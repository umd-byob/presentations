PBS
===
Please Be Sane
--------------

# Overview
1.  What and Why PBS?
2.  Cluster resources on campus
3.  Setting up
4.  Simplest possible example
5.  Real examples
6.  Gotchas that mess up _everyone_
7.  More advanced shell usage with PBS

# What is PBS?  Why is it useful?
The portable batch system is a client-server model for submitting
and scheduling computationally intensive jobs.  The PBS specification
has been implemented a few times, leading to some peculiar
differences.
Happily, both clusters I have played with at the University of
Maryland use the open source torque implementation:
http://www.adaptivecomputing.com/products/open-source/torque/

It provides methods to schedule many jobs to avoid crashing the
servers as well as facilities to make many jobs run in parrallel.



# Cluster resources on campus
=============================
There are two main clusters on campus: (that I am aware of)
1.  deepthought.umd.edu
   a) Accessible through login.deepthought.umd.edu
   b) Provides free low-priority queues, paid high-priority
   c) Makes use of the university shared filesystem (AFS and NFS)
   d) Available to anyone on campus
   e) Maintained by the univeristy IT department
2.  www.umiacs.umd.edu
   a) Accessible through ibissub0[0-2].umiacs.umd.edu
   b) Requires some arrangement between a professor and umiacs
   c) Uses the umiacs file system (NFS)
   d) Maintained by the umiacs staff



# Setting up
============
1.  The shell environment
   a) .bashrc .bash_profile .bash_aliases
2.  Public/Private key exchange with SSH
   b) ssh-keygen
3.  Screen / VNC (optional)
   c) .screenrc vncserver
> scriptreplay -s ssh_keygen.log -t ssh_keygen.time


# First Submission
==================
1.  Submitting with parameters in the script
2.  Parameters on the command line
3.  Submission embedded in the script

## First submission version 1:
------------------------------
In order to view this, go into the 02-first_submission directory and run:
> scriptreplay -s 01-first_submission.log -t 01-first_submission.time
Note the following:
1.  The current working directory did not stay the same
2.  The shell's environment changed significantly
  a)  New variables were created including a bunch that start with 'PBS'
  b)  Two of those are of particular interest: PBS_O_WORKDIR PBS_O_PATH

## First submission version 2:
------------------------------
In order to see what happened this time, do:
> scriptreplay -s 02-first_submission.log -t 02-first_submission.time
Note the following:
1.  One is no longer allowed to bare-echo a "!", it will try to substitute my previous command now.
2.  The execution node 'beech' has gotten two jobs in a row from me.
3.  Options specified on the command line trump those included in a job file

## First submission version 3:
------------------------------
> scriptreplay -s 03-first_submission.log -t 03-first_submission.time
I made it a bit more complex this time:
1.  I have a file in $DONE which tells me when my script is finished
    running on the compute node.
2.  I have an environment variable $PBS_ARGS which I use for
    submitting jobs because I cannot remember arguments.
3.  I placed the entire text of my job inside my script
    This allows one to perform some fairly complex multi-stage jobs
4.  I added a stanza at the end which waits for the compute node to
    finish. 



# Some real examples!
=====================
Check out the 03-real_examples directory.
1. 01-wdarocha_bwa2.sh:  An initial bwa submission
2. 02-tophat.sh:  Submitting a quick tophat run.  Note that the long
arguments are split into separate lines.
3. 03-rRNA_filter.sh:  A simple job to filter ribosomal reads from
short sequencing reads.
4. 04-CountTable_qsub_WDR.sh:  A somewhat more complext job which may
be used to perform htseq-count on a lot of separate libraries by
reading from the command prompt with tab-completion and its own
history file.
5. 05-align_concat.sh:  Chaining together a few steps of an alignment
pipeline.
6. 06-tnseq_align.sh:  Given many read libraries, perform similar
alignments on all of them in semi-parrallel.
7. 07-split_align.sh:  A somewhat more difficult example using the -T
argument to PBS in order to split the large input into a bunch of
small pieces and run perform an operation on all of them concurrently.
8. 08-split_align-fasta.pl and 09-split_align-blast.pl:  Performing a
similar splitting process without -T but for blast/fasta alignments.

# Gotcha!
=========
1. The most common error:  relative paths!  (look at 01-bwa.sh above)
2. The second most common error:  STDOUT vs STDERR
3. File permissions!
4. Third: Finding the logs!



# Advanced usage
================
1.  queue.sh is actually not very advanced, but uses a couple of
tricks to make it an infinitely running job to saturate a cluster.
  It requires the scripts 01-nn depending on the number of jobs one
  wishes to use.  This was written before the -T option was available
  in torque.
2.  submit.sh is an example that shows one need not stick with bash
  This job renders movies in pymol by submitting separate frames to
  different compute nodes and having each frame ray-traced.  render.py
  does the actual work.  This job does however use -T.
05 through 07 above
