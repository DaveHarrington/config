import vim

COMMENT = "#"

def set_breakpoint():
    import re

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

#vim.command( "normal %dG" % nCurrentLine)
def _get_indent_level(line):
    return len(line) - len(line.lstrip())

def _get_current_line():
    line_no = int(vim.eval('line(".")'))
    line = vim.current.buffer(line_no)

    return line, line_no

#def _select_range(start_line, end_line):
    #pass

#def select_block():
    #curr_line, curr_line_no = _get_current_line()
    #current_indent = _get_indent_level(curr_line)

    #for line, end_line_no in all_buffer():
        #if _get_indent_level(line) < current_indent:
            #end_line_no -= 1
            #break

    #for line, start_line_no in buffer_[curr_line_no::-1]:
        #if _get_indent_level(line) < current_indent:
            #break

    #_select_range(start_line_no, end_line_no)

def toggle_comment():
    uncommented = False
    for line, _ in line_range():
        if line.lstrip()[0] != COMMENT or line.strip() == "":
            uncommented = True
            break

    if uncommented:
        comment()
    else:
        uncomment()

def comment():
    start, end = current_range()
    vim.command("%(start)d,%(end)d normal i%(comment)s" %
                {"start": start, "end": end, "comment": COMMENT})

def uncomment():
    for line, line_no in line_range():
        if len(line) and line[0] == COMMENT:
            uncommented_line = line[1:]
            delete_line(line_no)
            insert_line(line_no, uncommented_line)

def foo():
    #uncomment_range()
    insert_line(2, "foo")

def delete_line(line_no):
    vim.command( "normal %dG" % line_no)
    vim.command( "normal dd")

def insert_line(line_no, line):
    vim.command("%d normal O" % line_no)
    vim.command("%d normal i%s" % (line_no, line))

def vim_print(*args):
    str_out = [str(arg_) for arg_ in args]
    vim.current.buffer.append(str_out)

def line_range():
    start, _ = current_range()
    line_no = start
    for line in vim.current.range:
        yield line, line_no
        line_no += 1

def current_range():
    first, sec = str(vim.current.range).split(":")
    start = int(first.split("(")[1])
    end = int(sec.split(")")[0])
    return start, end

def all_buffer_range():
    line_no = 1
    for line in vim.current.buffer:
        yield line, line_no
        line_no += 1

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
    dir_str.append(dir(vim.current.line))
    dir_str.append(dir(vim.current.range))
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

