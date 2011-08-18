#!/usr/bin/env python
import os
import os.path
import sys
import subprocess

force = True if '-f' in sys.argv else False

ignores = ['.git', 'README', 'install.py', 'vim_shortcuts.txt']
dir_list = os.listdir(".")
print dir_list
for file in dir_list:

    if not file in ignores:
        original = os.path.abspath(file)
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

print "Installing Janus"
subprocess.call(["git", "submodule", "init"])
subprocess.call(["git", "submodule", "update"])
subprocess.call(["rake"], cwd=".vim")
