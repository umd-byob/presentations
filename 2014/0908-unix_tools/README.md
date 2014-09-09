Unix command line tools: survival guide
=======

Getting started
-------

### tmux - an alternative to screen

* Split your terminal into multiple windows/panes.
* Keep programs running after you disconnect.
* http://www.ocf.berkeley.edu/~ckuehl/tmux/


#### Shortcuts & cheatsheet
Taken from: https://gist.github.com/MohamedAlaa/2961058

start new:

    tmux

start new with session name:

    tmux new -s myname

attach:

    tmux a  #  (or at, or attach)

attach to named:

    tmux a -t myname

list sessions:

    tmux ls

kill session:

    tmux kill-session -t myname

### ctrl + r - recursive backward search

Search back through your BASH history for previous commands (instead of pressing the up and down arrows).

### tab - autocomplete

Start typing a command or path and then press **TAB** to autocomplete.


### How to extract *.tar/*.tar.gz/*.gz?
Use the **man** tool (or Google):

    $ man tar

    EXAMPLES
       tar -xvf foo.tar
              verbosely extract foo.tar

       tar -xzf foo.tar.gz
              extract gzipped foo.tar.gz

       tar -cjf foo.tar.bz2 bar/
              create bzipped tar archive of the directory bar called foo.tar.bz2

       tar -xjf foo.tar.bz2 -C bar/
              extract bzipped foo.tar.bz2 after changing directory to bar

       tar -xzf foo.tar.gz blah.txt
              extract the file blah.txt from foo.tar.gz


### Jump to previous directory

    $ cd -

### How much space is my directory taking up?

    $ du -sh /cbcb/project-scratch/cmhill/metalap/
    
    318G    /cbcb/project-scratch/cmhill/metalap/

### Editing remote files... locally

A remote directory can be mounted locally using tools like [sshfs](http://fuse.sourceforge.net/sshfs.html) or [cyberduck](https://cyberduck.io/?l=en).

    sshfs cmhill@ibissub00.umiacs.umd.edu:/cbcb/path/to/dir/ ~/cbcb


### When recursively removing files, **NEVER** use ```rm -rf *```.

Common unix tools
-------

### less
Console text reader.
* -N = print line numbers 

### pipe
To skip the file-creation step, you can use the pipe character (|) to use the output of one command as the input for another command. It is incredibly powerful for linking long lists of commands to efficiently manage input and output[1].

    $ ls /etc/ | grep host

### sort
Sort the text input.
* -n = sort numbers (instead of alphabetical)
* -r = reverse
* -k2 = field

### cat
Output the file to standard out (or redirect via pipe "|" character)

### uniq
Print only unique lines.
* -c = prefix lines by the number of occurrences
* -d = only print duplicate lines

### grep
Searches the input files for lines containing the given pattern.  When it finds a match it outputs the line/
* -v = inverse match (print only lines *NOT* containing the pattern).
* -f [**FILE**] = use a list of patterns from [**FILE**]

### awk
A program language that you can use to select particular records in a file and perform operations upon them.  

Print out the first field of a tab delimited file

    $ awk '{print $1}' file

Change field separator ```-F ","```. 

[Common examples](http://www.catonmat.net/blog/ten-awk-tips-tricks-and-pitfalls/):
```
awk 'NR % 6'            # prints all lines except those divisible by 6
awk 'NR > 5'            # prints from line 6 onwards (like tail -n +6, or sed '1,5d')
awk '$2 == "foo"'       # prints lines where the second field is "foo"
awk 'NF >= 6'           # prints lines with 6 or more fields
awk '/foo/ && /bar/'    # prints lines that match /foo/ and /bar/, in any order
awk '/foo/ && !/bar/'   # prints lines that match /foo/ but not /bar/
awk '/foo/ || /bar/'    # prints lines that match /foo/ or /bar/ (like grep -e 'foo' -e 'bar')
awk '/foo/,/bar/'       # prints from line matching /foo/ to line matching /bar/, inclusive
awk 'NF'                # prints only nonempty lines (or: removes empty lines, where NF==0)
awk 'NF--'              # removes last field and prints the line
awk '$0 = NR" "$0'      # prepends line numbers (assignments are valid in conditions)
```

More detailed examples below.

### join
Join two files on a specified field.

### comm
Compare two sorted files line by line
* -1 suppress lines unique to FILE1
* -2 suppress lines unique to FILE2
* -3 suppress lines that appear in both files

Examples
-------
Alignment results are often stored in the Sequence Alignment/Map Format (SAM) specification. 

    $ cat test.sam


    @HD     VN:1.0  SO:unsorted
    @SQ     SN:NODE_2824_length_585_cov_1.69815_ID_5647     LN:585
    @SQ     SN:NODE_2806_length_588_cov_1.82689_ID_5611     LN:588
    @SQ     SN:NODE_500_length_2036_cov_3.02411_ID_999      LN:2036
    ...
    ERR260157.1.1   16      2910961 411     6       101M    *       0       0       ACATTCCGCTTCTGCGGTATCGGAATATGATTGCGTGATNNANGATTTTCTCACTCTTCCTGAAGGCACGGATACCAACGTTCCGTTTGTTGGCGAATCTT   4@8<@<BCA?@@9@>A5BDB?EEEECCCC?BDDDCA?,,##-#HJIIIJJIGHHCIHDJJJGGGGGGCIHDIGDIGIGJJIGIIIIJJHFHHDFFFDDC@C   AS:i:-3 XS:i:-7 XN:i:0  XM:i:3  XO:i:0  XG:i:0  NM:i:3  MD:Z:39G0G1A58  YT:Z:UU
    ERR260157.1.1   272     3081990 411     6       101M    *       0       0       *       *       AS:i:-7 XS:i:-7 XN:i:0  XM:i:4  XO:i:0  XG:i:0  NM:i:4  MD:Z:5T33G0G1A58        YT:Z:UU
    ERR260157.2.1   16      2165540 163     1       101M    *       0       0       GGAAAGGGGTGGCTTGGGTTTGCAGAAGATGCCGCAAAATGTNGTTTGCTGTTTCCGCTTCTGACGGGCGGGGAGCCGTTTCTGTACGAAGATTTTCAGGA   ############################################?;>66(3<B<AIF==)'(--(@D?)DEHBGGGGGHGEEGBA;IHFF?HHDDDBD@@@   AS:i:-7 XS:i:-7 XN:i:0  XM:i:4  XO:i:0  XG:i:0  NM:i:4  MD:Z:6A9A1A23G58        YT:Z:UU
    ERR260157.2.1   272     20646   16      1       101M    *       0       0       *       *       AS:i:-7 XS:i:-7 XN:i:0  XM:i:4  XO:i:0  XG:i:0  NM:i:4  MD:Z:6A9A1A23G58        YT:Z:UU
    ERR260157.4.1   0       3544273 374     6       101M    *       0       0       CACAATATATATCTGCTTTACTGATGATCGGCCCCATCCTGAAAAACGGATTGAGGTTGAATCTTACAGGAGAAATCATTTCCCGCCCTTACATTAATCTA   @@@DADDDBA:A?EHADB@HHG<HGHHIII6GD?D89?DDFHIGI9:DF;@AA3=;CD@37==77?EHHBDB9?AC:>>;B3>C8>=@6
    ...

#### Print only valid alignments (where the second field FLAG is *not* set to 0x4):

    $ awk '{if (and($2,0x4) == 0) {print $0}}' test.sam | less

#### Count the reference (third field) hits.
    
    $ grep -v "^@" test.sam | awk '{if (and($2,0x4) == 0) {print $3}}'  | sort | uniq -c | sort -nr | less


#### Make a histogram of reported insert sizes.
    $ grep -v "^@" test_insert.sam |  awk '{if ($9 > 0) print $9}' | sort -n | uniq -c | less


xargs - build and execute command lines from standard input
-------

Find out who is using up all the project-scratch disk space:

    $ cd /cbcb/project-scratch
    $ ls | xargs -I {} du -sh {} | less

    2.0M    assembly-eval-code
    5.6G    Atacama_Pop
    1.8T    chsiao
    ...


Additional links
-------
[1] http://www.ibm.com/developerworks/aix/tutorials/au-unixtips1/