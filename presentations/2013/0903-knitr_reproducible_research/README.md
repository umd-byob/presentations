% Reproducible Research Using Knitr/R
% [Keith Hughitt](mailto:khughitt@umd.edu)
% 2013/09/03

Reproducible Research Using Knitr/R
===================================

Overview
--------

This brief tutorial will describe some best practices for using [R](http://www.r-project.org/),
knitr, and a couple other related tools for reproducible research.

### Why knitr?
[Knitr](http://yihui.name/knitr/) is a package for R which allows you to write
documents that combine R code with text written in another language such as
[LaTeX](http://www.latex-project.org/) or [Markdown](http://daringfireball.net/projects/markdown/).
Knitr then processes the document, running the R code portions and embedding
the results in the document, making it easy to generate elegant looking reports
in a variety of formats such as Markdown, HTML, and PDF. Unlike the traditional
approach where figures are generated separately from the rest of a manuscript,
knitr makes it easy to combine all of these elements in such a way so that
another scientist can easily reconstruct the entire manuscript from scratch.

Pre-requisities
---------------

The main pre-requisite for this tutorial is that at least part of your analysis
is being performed in R. Some excellent tools exist to achieve a similar effect
in other programming languages (e.g. [IPython Notebook](http://www.youtube.com/watch?v=F4rFuIb1Ie4)),
and some of the general practices discussed are relevant regardless of what
programming language you are working with, but parts of the tutorial assume
that you are working with R.

To get started, let's load up an R console and install and load a few useful
packages:


```r
install.packages(c("devtools", "knitr", "ggplot2"), dependencies = TRUE)
library(devtools)
library(knitr)

install_github("knitcitations", "cboettig")
library(knitcitations)
```

Although knitr has support for embedding R code in a number of popular
languages, this tutorial focuses on one particular markup language, Markdown,
which has a clear and simple syntax, and is supported by many other useful
tools such as Github.

Development Environment
-----------------------
No special development environment is actually needed to work create knitr
documents: any text-editor will work. If you are famililar with [RStudio](http://www.rstudio.com),
however, there is [built-in support](http://www.rstudio.com/ide/docs/authoring/using_markdown)
or compiling RMarkdown documents written using the knitr syntax.

The Basics
----------

The basic structure of an RMarkdown knitr document is to have block of R code,
surrounded by Markdown text.

### 1. A simple example

**Code**

    Here is some *text* written in [Markdown](http://daringfireball.net/projects/markdown/)
    followed by a short block of R code.
    
    ```{r}
    print("Hello World")
    ```
    
    Some more text can then follow the code block.

**Output**

Here is some *text* written in [Markdown](http://daringfireball.net/projects/markdown/)
followed by a short block of R code.


```r
print("Hello World")
```

```
## [1] "Hello World"
```


Some more text can then follow the code block.

As you can see, the Markdown formatting in the first sentence has been applied,
and the R code, in this case a simple print statement, has been evaluated, and
the results appending in a quote block following the command.

Although the example is trivial, you can already start to image how this could
be useful by including the output of more complex calculations along-side of
some explantory text.

Things get much more interesting, however, when we start to look at how
plotting is handled by Knitr.

### 2. A plotting example

Using the same syntax as above, you can also embed plots directly in the output.

For example:

**Code**

    ```{r, plot_example, fig.width=8, fig.height=8, fig.dpi=96}
    library(ggplot2)
    set.seed(1)
    x = seq(1, 100)
    y = x + rnorm(100, sd=5)

    qplot(x, y) + geom_smooth(aes(x, y))
    ```
**Output**


```r
library(ggplot2)
set.seed(1)
x = seq(1, 100)
y = x + rnorm(100, sd = 5)

qplot(x, y) + geom_smooth(aes(x, y))
```

```
## geom_smooth: method="auto" and size of largest group is <1000, so using
## loess. Use 'method = x' to change the smoothing method.
```

![plot of chunk plot_example](figure/plot_example.png) 


For the above example, the figure is generated and saved as a PNG in the
`figure` directory. The plot is then referenced in the resulting Markdown, etc.
output file so that the image appears directly after the code used to generate
the image.

[Chunk options](http://yihui.name/knitr/options#chunk_options) allow you to
control various aspects of the code block. In the above example we specified
a desired figure width, height, and DPI; other options provide a way to control
the verbosity of the code output, skip blocks, etc.'

Notice also in the above example the 'plot_example' string that was added to
opening line of the R code block. This is simply an identifier that we can
give to that particular block or "chunk" of R code. It is not necessary to
give a code chunk an identifier, but it can be helpful for identifying problems
down the road, and also results in more descriptive filenames for the plot
images.

Finally, whenever parts of your analysis include a random component, such as
drawing from the Normal distribution above, it is a good practice to set a
known seed: otherwise it is very unlikely that someone else running your code
will arrive at the same results.



