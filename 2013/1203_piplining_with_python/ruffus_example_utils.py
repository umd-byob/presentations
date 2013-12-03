import sys
from os.path import exists

touch = lambda fname: open(fname, 'w')

def printInfo(task_name, inputs, outputs):
    print 'Running %s with:'%task_name
    print '\tinputs: %s'%str(inputs)
    print '\toutputs: %s'%str(outputs)

def createFiles(filelist):
    if isinstance(filelist, (list, tuple)):
        for f in filelist:
            touch(f)
    elif isinstance(filelist, str):
        touch(filelist)
    else:
        raise TypeError('fileList is not list, tuple or str') 