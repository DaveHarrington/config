#!/usr/bin/env python
import os
import os.path
import sys

force = True if '-f' in sys.argv else False

ignores = ['.git', 'README', 'install.py', 'vim_shortcuts.txt',
	'ssh_config', 'vim_improvements.txt', 'git_hooks',
	'com.googlecode.iterm2.plist']
dir_list = os.listdir(".")
for file in dir_list:

    if not file in ignores:
        original = os.path.abspath(file)
        if not file[0] == '.':
            file = '.' + file
        new = os.path.join(os.environ['HOME'], file)

        if force or os.path.islink(new):
            print 'Removing old: ', new
            os.remove(new)

        print "Symlinking %s -> %s" % (original, new),
        try:
            os.symlink(original, new)
        except:
            print original, "FAIL"
        else:
            print "SUCCESS"
