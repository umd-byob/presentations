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

Prerequisites
--------------

The main prerequisite for this tutorial is that at least part of your analysis
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
documents: any text-editor will work. If you are familiar with [RStudio](http://www.rstudio.com),
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
some explanatory text.

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

### 3. Running code written in another language

Another useful feature of knitr is the ability to run [code written in other
languages besides R](http://yihui.name/knitr/demo/engines/).

For example, you can include a [Bash](http://en.wikipedia.org/wiki/Bash_(Unix_shell))
chunk to execute arbitrary shell commands, including other software and scripts.
Similar to above, all of the output of those commands will be appended to the
knitted report.

**Code**

    ```{r bash_example}
    bowtie2 --version
    ```

**Output**


```r
bowtie2 - -version
```

```
## Error: object 'bowtie2' not found
```


### 4. What else can knitr do?

...

Best Practices for Reproducible Research
----------------------------------------

Although there has already been [a lot](http://www.youtube.com/watch?v=7gYIs7uYbMo)
of [discussion](http://simplystatistics.org/2013/08/21/treading-a-new-path-for-reproducible-research-part-1/)
recently on [reproducible research](http://ivory.idyll.org/blog/research-software-reuse.html),
I thought I would put together a short list of "best practices".

### 1. Make your data and code available

This is a pretty obvious first step, but people are going to have a difficult
time reproducing your results if they are missing either the code or data.
Making both of these available in public repositories is already a big first
step towards making it easy for other scientists to reproduce your work.

If you are able to share the code used for the analysis openly, then [Github](github.com)
is an excellent free repository that can be used to host your code.  Moreover,
Github's built-in support for displaying Markdown makes it especially useful for
knitr-based workflows. The present tutorial, for example, is [hosted on Github](https://github.com/umd-byob/byob/blob/master/presentations/2013/0903-knitr_reproducible_research).

### 2. Make all steps of the analysis transparent

The second important factor to make research clear and reproducible is to
make all of the different steps of the analysis as transparent as possible.

At a minimum, provenance information should be included for any datasets used
in the analysis. Further, if possible, all steps used to prepare the data,
however mundane, should also be included directly in the workflow.

Finally, if certain steps in the middle of the analysis involve calling external
scripts that you wrote, consider including those scripts inline in a knitr 
block, or at the very least, include the code for those scripts with your final
document.

### 3. Describe the environment used to perform the analysis

In addition to describing any hardware used to collect data, where relevant,
the software environment used to perform the analysis should also be described
thoroughly.

Fortunately, knitr makes this especially easy since it can collect much of this
information for you.

See the `System Information` section below for an example of how this can be
performed.

System Information
------------------


```r
system("uname -a")
system("python --version")
sessionInfo()
```

```
## R version 3.0.1 (2013-05-16)
## Platform: x86_64-unknown-linux-gnu (64-bit)
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=C                 LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] ggplot2_0.9.3.1 knitr_1.4.1     colorout_1.0-0  vimcom_0.9-8   
## [5] setwidth_1.0-3 
## 
## loaded via a namespace (and not attached):
##  [1] colorspace_1.2-2   dichromat_2.0-0    digest_0.6.3      
##  [4] evaluate_0.4.7     formatR_0.9        grid_3.0.1        
##  [7] gtable_0.1.2       labeling_0.2       markdown_0.6.3    
## [10] MASS_7.3-26        munsell_0.4.2      plyr_1.8          
## [13] proto_0.3-10       RColorBrewer_1.0-5 reshape2_1.2.2    
## [16] scales_0.2.3       stringr_0.6.2      tools_3.0.1
```


References
==========

Aknowledgements
===============

