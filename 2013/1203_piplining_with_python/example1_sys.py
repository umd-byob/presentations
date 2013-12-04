#!/usr/bin/env python
'''
example1_sys.py
Print 
Usage: 
    ./exampe1_sys.py FILE_PATH
    cat FILE_PATH | ./example1_sys.py
'''

from sys import stdout, stdin, stderr, argv

def count_words(file):
    '''
    Print the number of words per line in a file.
    '''
    for line_num, line in enumerate(file):
        num_words = len(line.split())
        stdout.write('%i: %i\n'%(line_num, num_words))

if __name__ == '__main__':

    # By default, read from standard input
    file = stdin
    filename = 'stdin'

    # If a filepath is provided, use the file instead of
    # standard input
    args = argv[1:]
    if args:
        filename = args[0]
        file = open(filename)

    # Run
    stderr.write('-'*50 + '\n')
    stderr.write('Filename: %s\n'%filename)    
    count_words(file)

