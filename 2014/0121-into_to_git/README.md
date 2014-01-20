Introduction to Git and Github
==============================
[Keith Hughitt](khughitt@umd.edu)
2014/01/19

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

The goal of this tutorial is to familiarize the user with the basics of [Git](http://git-scm.com/)
and [Github](https://github.com/).

Of course, there are already numerous tutorials which do this and do a much
better job than I could ever do, e.g.:

- http://git-scm.com/docs/gittutorial
- http://try.github.io/levels/1/challenges/1
- https://help.github.com/articles/set-up-git
- http://readwrite.com/2013/09/30/understanding-github-a-journey-for-beginners-part-1

I would encourage people to check these out as well.

Here I am just going to try and cover enough to get people started and 
hopefully interested enough to try it out and learn more.

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
$
```

## 2. Checking a repo's status (git status)

It's always a good idea before making a commit to check the status of a repo
before making any changes using `git status`:

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
$
```

## 3. Saving changes (git commit)

Once you have done something interesting, `commit` it!

```bash
$ git commit -m 'Important change #1'
[master (root-commit) 9c5205a] Important change #1
 1 file changed, 1 insertion(+)
 create mode 100644 newfile
$ 

Only the changes that you have stages (using `git add`) will be included in
the commit. To include all changes made to files in the repo, you can use
`git commit -am`.
```

## 4. Pushing your changes to a remote repo (git push)

Once you have commited some changes, you may want to sync them with a remo
repo such as Github. This is done using the `git push` command.

```bash
$ git push -u origin master
Counting objects: 3, done.
Writing objects: 100% (3/3), 232 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To git@github.com:khughitt/test-repo.git
 * [new branch]      master -> master
Branch master set up to track remote branch master from origin.
$
```

Note that for this to work, you must first create a remote repo and add a
reference to it. We will come back to this part later...

## Pull changes made to a remote repo

Once you start to collaborate with other people, you will need a way to sync
your repo when other people have made changes to the shared repo.

This is done using the `git pull` command.

```bash
$ git pull
remote: Counting objects: 4, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (3/3), done.
From github.com:khughitt/test-repo
   9c5205a..1336440  master     -> origin/master
Updating 9c5205a..1336440
Fast-forward
 README.md | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 README.md
$ 

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
