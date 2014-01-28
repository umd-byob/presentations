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
better job than I could hope to do, e.g.:

- [Git - gittutorial Documentation](http://git-scm.com/docs/gittutorial)
- [Try Git: Code School](http://try.github.io/levels/1/challenges/1)
- [Set Up Git · GitHub Help](https://help.github.com/articles/set-up-git)
- [GitHub For Beginners: Don't Get Scared, Get Started](http://readwrite.com/2013/09/30/understanding-github-a-journey-for-beginners-part-1)

I would encourage people to check these out as well.

Here I am just going to try and cover enough to get people started and 
hopefully interested enough to try it out and learn more.

## Intro to version control systems (VCS)

Version control systems (VCS) are software tools used to track changes to a
collection of files and directories and to aide in collaborative development.
VCS is most widely used in the context of software development for tracking
changes to code, but it can also be used to track changes to other types of
work such as manuscripts, data, etc.

Some popular examples include:

- Concurrent Versions System (CSV)
- Subversion (SVN)
- Git
- Bazaar
- Mercurial

Although the big picture is generally the same for each of these, and using
any of them is going to be better than using none, there are some differences
in the philosophy and function of each.

CSV and SVN were developed first, and are *centralized* version control
systems. This means that there is a master codebase, and client hosts which
"checkout" pieces of this code to make changes.

Newer VCS, including the later three listed above, follow a different approach
called *distributed* VCS (dVCS). In this model there is no central repository
-- all clients have an entire copy of the repository.

Both approaches have their advantages and disadvantages. The focus in this
tutorial, however, is on one of the dVCS: git.

## Why is VCS useful?

Some of the main uses for VCS include:

- Tracking changes (imagine not having an undo button in Word...)
- Backing up code (Mirroring on Github, etc.)
- Experimentation (branches)
- Collaboration

Git Basics
----------

## Installation

Download and install Git from
[git-scm.com](http://git-scm.com/book/en/Getting-Started-Installing-Git).

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

## 5. Pulling changes made to a remote repo

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

Github Basics
-------------

## Overview

[Github](https://github.com) is a free online mirroring service for git 
repositories. It hosts mostly open source code, although you can also pay to 
have "private" repositories.

## Why use Github?

- Backup your code
- Share your code
- Collaboration
- Online code viewing/editing
- Browsable [commit history](https://github.com/pydata/pandas/commits/master)
- Integrates with [other services](http://developer.github.com/v3/repos/hooks/)
- Renders [Markdown](http://daringfireball.net/projects/markdown/)
- Host websites (e.g. [umd-byob.github.io](umd-byob.github.io))
- Host R packages ([install_github](http://www.inside-r.org/packages/cran/devtools/docs/install_github))
- Host Python packages ([pip](http://www.pip-installer.org/en/latest/logic.html#vcs-support))
- Repo [statistics](https://github.com/pydata/pandas/graphs/contributors)


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
