# Git with Confidence


## References ##
 - [Pro Git](http://git-scm.com/book)
  - The book is on [GitHub](https://github.com/progit/progit)!
 - [Git from the bottom up](http://ftp.newartisans.com/pub/git.from.bottom.up.pdf) by John Wiegley
  - This link is broken as of 2/24, so I've included the [pdf](/2014/0225-git_with_confidence/references/git.from.bottom.up.pdf?raw=true) in the repository.

 - [Cool interactive cheat sheet](http://ndpsoftware.com/git-cheatsheet.html)
 - [Another cheat sheet](http://www.git-tower.com/blog/git-cheat-sheet-detail/)

 The images in this presentation are from Pro Git and from "Git from the bottom up", which are made available
 under the [Creative Commons Attribution Non Commercial Share Alike 3.0 license](http://creativecommons.org/licenses/by-nc-sa/3.0/).

## Review ##

![workflow](img/git_workflow.png)

Commands:

  - `git init`
  - `git add`
  - `git status`
  - `git commit`
  - `git push`
  - `git pull`
  - `git checkout <branch or commit>`


## Git terminology ##

- **repository**: A collection of **commits** which serves as an archive of 
                what the project's **working tree** looked like over time. It also stores additional data,
                like **branches**, **tags**, and **HEAD**.

- **commit**: A snapshop of your working tree at some point in time.

- **the index**: A staging area for registering changes which are to be commited.

- **working tree**: A directory of your filesystem which has a repository associated with it (
                  stored in the .git hidden directory). The working tree includes all directories
                  and subdirectories in the working tree directory.

- **blob**: A container for file content. Blobs are featureless and store only content, but no metadata - not 
even a filename.

- **branch**: A named reference to a commit. A branch can point to different commits over time.

- **tag**: A named reference to a commit. A tag always points to the same commit. 

- **HEAD**: A reference which specifies what is currently checked out. HEAD could
  refer to a branch or to a commit.


## Commits ##

Git stores data in **blobs**, **trees**, and **commits**. Git is a **content addressable filesystem**, meaning data
is stored in key-value pairs. The key is the SHA-1 hash of the object's contents, and the value is the
content itself.

- A file is stored as a **blob** object.
- A **tree** points to blobs and other trees (i.e. subdirectories) and provide a filename for each.
- A **commit** points to a tree, the commit (or commits) which immediately preceed it, and additional metadata (such as the commit message, author, author e-mail.)

This is what a tree looks like:

![tree](img/git_tree.png)

This is what an initial commit looks like:

![commit](img/git_commit.png)

This is what several commits look like. Note that each commit has a parent commit, except for the initial commit.

![commits](img/git_commit_parents.png)


You can explore blobs, trees, and commits using `git cat-file` (but this is never necessary in practice):

```
$ git cat-file -t 5eab59d5579379e7ac24ca8d0515e077bbd7bb9c

commit
```


```
$ git cat-file -p 5eab59d5579379e7ac24ca8d0515e077bbd7bb9c

tree cb8fef9d6f9b6c2b017358c346029ef1fe96d18e
parent 0227a74bfc5aa251023e5a411c6a9f49ce1f437f
author Keith Hughitt <keith.hughitt@gmail.com> 1392847696 -0500
committer Keith Hughitt <keith.hughitt@gmail.com> 1392847696 -0500

Added Steve Mount's RNA-Seq normalization presentation
```

```
$ git cat-file -p cb8fef9d6f9b6c2b017358c346029ef1fe96d18e

100644 blob 7870d377e7ec5614635ad12d8a27a259a158e702  .gitignore
100644 blob ccb3f02c1748511dd015ab81853b46fe24552893  .gitmodules
040000 tree 5589118a2783e8ff1e3c79559e0d7a02b6fc5ba2  2013
040000 tree e2c10734af096e4dda2c70774869dbdc405f58f3  2014
100644 blob bf96193bc23063b53acc1094b939def349b63c69  README.md
```

#### Viewing commit history

Use the `git log` command to see the commit history:

```
# Show the last 5 commits from HEAD
$ git log --oneline -n 5

5eab59d Added Steve Mount's RNA-Seq normalization presentation
0227a74 Merge branch 'master' of github.com:umd-byob/presentations
931eda5 Fixed a few typos in Git tutorial
a4f083c Update README.md
6df7073 Added Git tutorial links

# Show the commit history as a graph.
$ git log --oneline --abbrev-commit --graph --decorate --color

* 5eab59d (orig/master, orig/HEAD, fork/master, master) Added Steve Mount's RNA-
*   0227a74 Merge branch 'master' of github.com:umd-byob/presentations
|\
| * a4f083c Update README.md
* | 931eda5 Fixed a few typos in Git tutorial
|/
* 6df7073 Added Git tutorial links
```

I find the previous command useful, so I created an alias for it:

```
# Set the 'nicelog' alias
$ git config --global alias.nicelog "log --oneline --abbrev-commit --graph --decorate --color"

# Call git nicelog
$ git nicelog

* 5eab59d (orig/master, orig/HEAD, fork/master, master) Added Steve Mount's RNA-
*   0227a74 Merge branch 'master' of github.com:umd-byob/presentations
|\
| * a4f083c Update README.md
* | 931eda5 Fixed a few typos in Git tutorial
|/
* 6df7073 Added Git tutorial links
```

Use the `--all` option to see all commits reachable from any branch or from the stash.

## Git Branches ##

This is what a branch looks like:

![branch](img/git_branch.png)

- Branches are lightweight objects in git - they are nothing other than named references to particular commits.
  - They are stored as a 41 byte file on your filesystem (40 character hexademical value of the SHA-1 hash of the commit, plus a newline.)

- When you are working on a branch, the branch pointer moves as commits are made.

- Basic commands:

```
# List branches
git branch

# List all branches (including remote branches)
git branch -a 

# Create a new branch
git checkout -b my_new_branch

# Delete a branch
git branch -d my_new_branch
```

- Tip: Branches are disposable! Whenever working on a new feature, create a branch, and delete it when you've
merged it into your master branch.

- Must read:
  - [What a branch is](http://git-scm.com/book/en/Git-Branching-What-a-Branch-Is)
  - [Basic branching and merging](http://git-scm.com/book/en/Git-Branching-Basic-Branching-and-Merging)

### Merging ###

To merge changes from a branch into the current branch:

```
$ git merge <commit or branch>
```

Git will automatically merge selected commit into the current branch if there are no conflicts. This will create a new commit with the completed merge. If the current branch
is an ancestor of the commit being merged from, then the current branch pointer can simply be moved to that commit. This is known as a fast-forward merge.

#### Example of a fast forward merge

Before the merge:

![before_merge](img/git_before_ff_merge.png)

```
$ git checkout master
$ git merge hotfix
```

After the merge:

![after_merge](img/git_after_ff_merge.png)


#### Example of a recursive merge

![before_merge](img/git_before_recursive_merge.png)

```
$ git checkout master
$ git merge iss53
```

After the merge:

![after_merge](img/git_after_recursive_merge.png)

- See ProGit [Basic branching and merging](http://git-scm.com/book/en/Git-Branching-Basic-Branching-and-Merging) for more details.

### Rebase ###

Rebasing is an alternative to merging. Git rebase can be used to move commits from one branch to another branch,
which makes for a cleaner commit history. 

##### Example

Before rebase:

![commits](img/git_before_rebase.png)

```
# Rebase experiment onto master
$ git checkout experiment
$   git rebase master
```

After rebase:

![commits](img/git_after_rebase.png)

`git rebase` can be used to do *crazy* things, like re-order commits, remove commits, or squash multiple commits into a single commit.
For more information on how to use `git rebase` in this manner, see the chapter on [rewriting history in Pro Git](http://git-scm.com/book/en/Git-Tools-Rewriting-History).

**Note: Only use git rebase for modifying local changes that have not been shared publicly**. When you use `git rebase`,
you are effectively modifying the history of the repository. If those commits which you are "revising" with `git rebase` have already been made public, other people may have based their work off of that commit history. Then you'll have a mess on your hands.


## Other Utilities ##

### Stashing ###

Git stash gives you a way of storing a snapshot of your working tree and index (i.e. staging area) and resetting your working
tree to the last commit. This is really useful when:
 - you need to suddenly switch between branches but your working tree is in a "dirty" state.
 - when you want to create a commit to permanently hold on to your changes, but don't want the commit to be part of a branch's history.

```
# Stash your changes
$ git stash save my_stash

# List stashes
$ git stash list

# Apply stashed changes
$ git stash apply
```

### Reset ###


Use `git reset` to move the branch head to a particular commit. This can potentially change the working tree and the index
depending on the mode which is used:

 - `git reset --soft <commit>` will move the branch to the specified commit, but will not modify the working tree or the index.
 - `git reset --mixed <commit>` will move the branch to the specified commit and will reset the index, but not the working tree.
 - `git reset --hard <commit>` will move the branch to the specified commit and will reset the index and will reset the working tree. ** This is potentially dangerous because any uncommitted changes in your working tree will be lost forever **.

 It's best to do `git reset` on a temporary experimental branch before moving your `master` branch. It's also good practice to do a `git stash` before performing a `git reset --hard`, in case you need to recover.


### Reflog ###

Git keeps a log of the commits that HEAD has pointed to over the last 30 days. You can see these commits with `git reflog`.
This can be used to help you access "orphaned" commits which are no longer reachable from a branch.


### GUI Clients ###

Gitk is a git repository browser that ships with git. Other GUI's are listed [here](http://git-scm.com/downloads/guis).
