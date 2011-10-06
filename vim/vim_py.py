import re
import vim
#http://vimdoc.sourceforge.net/htmldoc/if_pyth.html#python-vim

COMMENT = "#"

def set_breakpoint():
    line_no = int( vim.eval( 'line(".")'))
    line = vim.current.line
    indent = re.search( '^(\s*)', line).group(1)

    # Inserts:
    #
    # import pdb #FIXME: pdb import
    # pdb.set_trace() #FIXME: Breakpoint
    #
    pdb_str = [
              "",
              "%simport pdb #FIXME: pdb import" % indent,
              "%spdb.set_trace() #FIXME: Breakpoint" % indent,
              "",
              ]

    vim.current.buffer.append(pdb_str, line_no - 1)

def remove_breakpoints():
    current_line = int( vim.eval( 'line(".")'))

    lines_to_remove = []
    line_no = 1
    line_previous = "!"
    for line in vim.current.buffer:
        if line.lstrip()[:10] == "import pdb":
            if line_previous == "":
                lines_to_remove.append(line_no-1)
            lines_to_remove.append(line_no)
        elif line_previous.lstrip()[:15] == "pdb.set_trace()":
            lines_to_remove.append(line_no - 1)
            if line == "":
                lines_to_remove.append(line_no)
        line_no += 1
        line_previous = line

    lines_to_remove.reverse()

    for line_no in lines_to_remove:
        vim.command( "normal %dG" % line_no)
        vim.command( "normal dd")
        if line_no < current_line:
            current_line -= 1

def swap_args():
    curr_line = vim.current.line
    curr_line_no, cursor_pos = vim.current.window.cursor

    for start_pos in range(cursor_pos, 0, -1):
      if curr_line[start_pos] in ['[', '(', ' ']:
        start_pos += 1
        break

    end_pos = cursor_pos
    while True:
      try:
        if curr_line[end_pos] in [',']:
          break
      except IndexError:
        return
      end_pos += 1

    end_pos_2 = end_pos + 1
    while True:
      if curr_line[end_pos_2] in [',', ')', ']']:
        break
      end_pos_2 += 1

    before_cut = curr_line[:start_pos]
    after_cut = curr_line[end_pos_2:]
    cut_word_1 = curr_line[start_pos:end_pos]
    cut_word_2 = curr_line[end_pos + 2:end_pos_2]
    start_line = ''.join([before_cut, cut_word_2, ', '])
    new_line = ''.join([start_line, cut_word_1, after_cut])
    vim.current.line = new_line
    vim.current.window.cursor = (curr_line_no, len(start_line))

def toggle_comment():
    uncommented = False
    for line_no, line in enumerate(vim.current.range[:10]):
        if line.strip() != "" and line.lstrip()[0] != COMMENT:
            uncommented = True
            break

    if uncommented:
        comment()
    else:
        uncomment()

def comment():
    start, end = vim.current.range.start + 1, vim.current.range.end + 1
    vim.command("%(start)d, %(end)s yank c" % {'start': start, 'end':end})
    for line_no, line in enumerate(vim.current.range):
        vim.current.range[line_no] = COMMENT + line

def uncomment():
    for line_no, line in enumerate(vim.current.range):
        if line != "" and line[0] == COMMENT:
            vim.current.range[line_no] = line[1:]

def _get_indent_level(line):
    return len(line) - len(line.lstrip())

def _get_current_line():
    line_no, _ = vim.current.window.cursor
    return line_no, vim.current.line

def vim_print(*args):
    str_out = [str(arg_) for arg_ in args]
    vim.current.buffer.append(str_out)

_block_re = {'class': r"\s*class\s",
             'def': r"\s*def\s",
            }

def __start_block(block_type, find_top=True):
    start_line = vim.current.window.cursor[0] - 1

    # search forward for start of this indent level
    curr_indent = _get_indent_level(vim.current.line)
    for start_line_no in range(start_line, len(vim.current.buffer)):
        line = vim.current.buffer[start_line_no]
        if line.strip() != "" and _get_indent_level(line) != curr_indent:
            start_line_no -= 1
            break

    # search backwards for line containing block regex
    class_indent = -1
    for line_no in range(start_line_no, -1, -1):
        line = vim.current.buffer[line_no]
        if re.match(_block_re[block_type], line):
            class_indent = _get_indent_level(line)
            continue

        elif class_indent > -1:
            if line.strip() == "" or _get_indent_level(line) != class_indent:
                if line_no + 1 != start_line or not find_top:
                    break
                else:
                    # We were at the top
                    class_indent = -1

    return class_indent, line_no + 1

def _start_block(block_type):
    class_indent, line_no = __start_block(block_type)
    if class_indent > -1:
        vim.current.window.cursor = line_no + 1, class_indent

def _end_block(block_type):
    class_indent, start_line = __start_block(block_type , False)

    if class_indent == -1:
        return

    at_start = True
    for line_no in range(start_line, len(vim.current.buffer)):
        line = vim.current.buffer[line_no]
        if at_start and _get_indent_level(line) == class_indent:
            continue
        elif at_start:
            at_start = False

        if line.strip() != "" and _get_indent_level(line) <= class_indent:
            line_no -= 1
            break

    vim.current.window.cursor = line_no + 1, _get_indent_level(line)

def start_class():
    return _start_block('class')

def end_class():
    return _end_block('class')

def start_def():
    return _start_block('def')

def end_def():
    return _end_block('def')

def test_foo():
    vim.current.window.cursor = 3, 0

import os.path
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))

# `gf` jumps to the filename under the cursor.  Point at an import statement
# and jump to it!
import os
import sys
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))

#get rest of this block

#['__doc__', '__name__', '__package__', 'buffers', 'command', 'current', 'error', 'eval', 'windows']
#['buffer', 'line', 'range', 'window']
#['append', 'mark', 'name', 'number', 'range']
def print_dir():
    #dir_str = [dir(vim)]
    #dir_str.append(dir(vim.buffers))
    #dir_str.append(dir(vim.command))
    #dir_str.append(dir(vim.current))
    #dir_str.append(dir(vim.error))
    #dir_str.append(dir(vim.eval))
    #dir_str.append(dir(vim.windows))
    #dir_str.append("buffers")
    #dir_str.append("command")
    #dir_str.append("current")
    dir_str = []
    dir_str.append(dir(vim.current))
    dir_str.append(dir(vim.current.buffer))
    dir_str.append(vim.current.buffer.range)
    dir_str.append(dir(vim.current.line))
    dir_str.append("range: + " + dir(vim.current.range))
    dir_str.append(dir(vim.current.window))
    dir_str.append("--")
    dir_str.append(vim.current.window.cursor)
    dir_str.append(vim.current.window.height)
    dir_str.append(dir(vim.current.window.buffer))
    #dir_str.append("error")
    #dir_str.append(str(vim.error))
    #dir_str.append("eval")
    #dir_str.append(vim.current.buffer.name)
    #dir_str.append(vim.current.buffer.number)
    #dir_str.append(vim.current.buffer.range)
    
    dir_str = [str(dir_) for dir_ in dir_str]
    vim.current.buffer.append(dir_str)

    #for line in vim.current.buffer.range(1,10):
        #vim.current.buffer.append(line)
    #a = vim.current.buffer.range(1,10)
    #vim.current.buffer.append(str(a))
    #vim.current.buffer.append(help(vim))
    #vim.current.buffer.append(str(dir(vim.windows)))

#Add the virtualenv's site-packages to vim path

