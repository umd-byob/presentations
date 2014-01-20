Introduction to Git and Github
==============================
[Keith Hughitt](khughitt@umd.edu)
2014/01/19

or "Scientific collaboration using Git and Github"?

Outline (TODO)
--------------

- What is VCS?
- Why is VCS useful?
    - Tracking changes (imagine not having an undo button in Word...)
    - Backing up code (Mirroring on Github, etc.)
    - Experimentation (branches)
    - Collaboration
- What is Git?
    - Brief history of VCS
    - Distributed vs. centralized
    - Why git? Free, simple to get started with, widely used (huge community),
      very powerful platform for working with Git repos (Github!)
- Intro to Github
    - features
        - backing up code
        - commit history
        - view code and diffs
        - makes it easy to share code!
        - Markdown support! :)
        - Free for OSS; private repos available as well.
- Single user workflow with Git and Github

Overview
--------

Git Basics
----------

## Five most useful git commands to know

This is 99% of what you need to know to use Git:

1. git init
2. git status
3. git commit
4. git push
5. git pull

## 1. Creating a new repo (git init)

To create a new git repository, simply enter the root directory which you want
to make a repo and run `git init`:

```bash
$ mkdir test
$ cd test 
$ git init
Initialized empty Git repository in /home/username/test/.git/
```

## 2. Checking a repo's status (git status)

It's always a good idea before making a commit to check the status of a repo
before making any changes:

```bash
$ touch newfile
$ echo 'Hello World' > newfile 
$ git status
On branch master

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

    newfile

nothing added to commit but untracked files present (use "git add" to track)
$ git add .
$ git status
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

    new file:   newfile
```




Single-user Workflow
--------------------


Multi-user Workflow
-------------------


Beyond code
-----------

- Markdown
    - notes
    - knitr output
- Websites
    - BYOB
    - Slidify
- LaTeX
    - Maybe...

References
----------
- https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
- https://help.github.com/articles/github-flavored-markdown
