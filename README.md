Bring Your Own Bioinformatics: Presentations
=============================================
University of Maryland, College Park bioinformatics and computational biology
interest group.

For more information about the club and upcoming meetings, check out the [BYOB
website](http://umd-byob.github.io/) and [Google Group](https://groups.google.com/forum/#!forum/umd-byob).

Instructions for uploading a presentation
=========================================
If you are planning to give a presentation at BYOB, and have related materials
that you are able to share, the below steps will describe how they can be added
to this repository.

What to include
---------------

### Overview

Ideally, everything needed to reproduce the results of the presentation, along
with the presentation itself should be included. "Presentation" is used loosely
here are may refer to any number of different formats such as a powerpoint
presentation, a well-commented script or code example, a Knitr source file, 
IPython notebook, Markdown notes, etc.

In cases where datasets have been used as part of the analysis, special care
must be taken. First, when possible, try and make use of datasets that are
publically available and do not require any special access. In cases where the 
datasets are very small (less than ~500Kb) then you can simply include them in 
the repository directly. When larger datasets are used in the analysis, 
instructions should be included on how to find and download the dataset, 
ideally from a permanent location. In both cases be sure to provide information
about the source of the dataset.

### List of things to include

1. **README.md** - A Brief description of the presentation including the title
   and author, along with descriptions of the material included, and how to
   use them.
2. **Presentation** - Powerpoint slides, Markdown, IPython notebooks, etc.
3. **Code** - Code examples, or shell script of commands used in presentation.
4. **Data** - Any datasets used in tutorial (see above for notes on how to 
   handle).
5. **Output** - If output is generated as part of the tutorial, and the
   resulting files are not too large, they may be included directly in the
   repo. Otherwise, the output should be described as best as possible so that
   users can judge whether they obtained the correct output.
6. **Other** - As long as you have the rights, and the filesizes are small, any
   additional files that are relevant to the presenation, and do not fit well
   in any of the above categories may be included.

When in doubt, look at examples of other presentations that have been uploaded
in the past to get an idea for what to include.

### A Note on using Knitr output

If you used [Knitr/RMarkdown](http://www.rstudio.com/ide/docs/authoring/using_markdown)
to generate all or part of your presntation, it may be more convenient to 
rename the generated .md file README.md and use it as your prensentation 
overview file described above. If you do this, please be sure to include your 
name and presentation title in the output as well.

Uploading to Github
-------------------

If this is your first time using Git or Github, it is advisable to first take
a little bit of time familiarising yourself with the basics of these tools.
Some tutorials have been included at the bottom of the page to help get you
started. Once you feel more comfortable with these tools, continue reading
below.

### 1. Create a fork of the BYOB repo
The first step is to [create a fork](https://help.github.com/articles/fork-a-repo)
of the [byob](https://github.com/umd-byob/byob) repo.

Once you have done this, [clone](http://git-scm.com/book/en/Git-Basics-Getting-a-Git-Repository)
your fork 

### 2. Create a new directory

Enter the 'presentations' directory, and then the directory for the current
year. Create a new directory with the format:

> mmdd-short_presentation_title

All of your materials will go inside this directory.

### 3. Add your materials

Begin adding your materials here. Feel free to make multiple [commits](http://gitref.org/basic/)
as you are working on your materials.

### 4. Add a README.md

Create a README.md as described above.

### 5. Commit changes

If you have not already commited all of your changes, do so now. E.g.:

    git add .
    git commit -am "Adding presentation xxx"
    git push

The last command will push the changes to your fork of the BYOB repository.

### 6. Submit a pull request

Once your materials are finished and ready to be added to the main BYOB repo,
submit a [pull request](https://help.github.com/articles/using-pull-requests)
with your changes:

From the github page for your fork, click on the "pull requests" button on the
right of the page, and then click "new pull request".

Follow the instructions to enter a description of the changes and submit
your request.

All done! Once your changes have been reviewed to make sure they look okay
they will be added to the main repo.

At this point you are finished. If you wish to make additional changes later
on, however, the same steps above may be followed to submit additional pull
requests.

More Information
================
1. http://net.tutsplus.com/tutorials/other/easy-version-control-with-git/
2. http://git-scm.com/docs/gittutorial
3. http://daringfireball.net/projects/markdown/

