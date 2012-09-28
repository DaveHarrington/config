#!/usr/bin/env python
import os
import os.path
import sys

force = True if '-f' in sys.argv else False

whitelist= ['vim', '.vimrc',
	'.ackrc', '.bash_profile', '.bashrc', '.gitconfig',
	'.inputrc', '.tmux.conf']

for file in whitelist:

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
