Writing reproducible manuscripts with RMarkdown
===============================================

[Keith Hughitt](mailto:khughitt@umd.edu)

September 10, 2015

![Markdown document with corresponding PDF](images/markdown_pdf_example.png)

Overview
--------

In this tutorial, we will explore the use of
[Markdown](http://daringfireball.net/projects/markdown/) for writing scientific
manuscripts. After discussing some of the strengths and weaknesses of using
Markdown over other approaches such as [LaTeX](http://www.latex-project.org/)
or [Google Docs](https://www.google.com/docs/about/), the basic steps of
putting together a Markdown-based paper will be described. Next, examples will
be provided on various aspects of Markdown manuscript generation, including:

- Figures and tables
- PDF generation using [pandoc](http://pandoc.org/getting-started.html)
- Bibliography management using [BibTeX](http://www.bibtex.org/) and the 
  [Pandoc citeproc extension](https://github.com/jgm/pandoc-citeproc)
- Extending Markdown documents with LaTeX.

Finally, to tie things together, we will discuss the use of
[knitr](http://yihui.name/knitr/) and [RMarkdown](http://rmarkdown.rstudio.com/) 
to create fully-reproducible manuscripts containing figures and tables
generated in [R](https://www.r-project.org/).

Why Markdown?
-------------

Before we get to far, it is worth considering the merits (and drawbacks) of
using Markdown for writing scientific manuscripts in the first place. 

### Advantages

- Its _easy_
- Plain-text
    - Simple, light-weight syntax
    - Use any editor
    - Un-rendered markdown is nearly as readable as rendered
    - Can use version control to track history
- Markdown is becoming increasingly common (Github, Stack overflow, etc.)
- Easier to learn than LaTeX
- Supports embedded LaTeX and HTML
- Can be rendered to PDF, HTML, LaTeX, Word, etc.
- Easy bibliography management using BibTeX and Pandoc
- Can be readily combined with R to automatically generate plots and tables
  using R code.

### Disadvantages

- Collaborative writing not as straight-forward
    - For technically-savvy, using Git to provides a simple way to collaborate 
      on a document
    - [Markx](https://github.com/yoavram/markx) is another potentially interesting
      collaborative Markdown editor aimed at scientists.
    - Still, useful features like reviewer comments will are missing.
- Less flexible than LaTeX or Word
    - Because of the simplicity of the Markdown syntax, the formatting options
      available are fairly limited.
    - In particular, image handling is very basic in Markdown.
    - This can be overcome, however, by using bits of embedded LaTeX.

Converting Markdown to PDF
--------------------------

To render a plain Markdown document (as opposed to an RMarkdown document), you
can use the Pandoc command:

```sh
pandoc -i input.md output.pdf
```

Example 1: Basic Markdown document
----------------------------------

To begin, lets create a simply Markdown example to demonstrate how to include 
figures, tables, and formulas.

- [Example 1](examples/01-simple-markdown-document.md)


Example 2: Adding LaTeX to improve flexibility
----------------------------------------------

In the next example, we will see how adding a bit of LaTeX to our Markdown
documents can give us a much finer control of image placement and other
formatting issues.

- [Example 2](examples/02-markdown-and-latex.md)

Example 3: Using BibTeX to add a bibliography
---------------------------------------------

In the next example, we will see how BibTeX and the pandoc `citeproc` extension
can be used include references into a manuscript.

- [Example 3](examples/03-including-a-bibliography.md)

For RMarkdown documents, another approach would be to use the `knitcitations`
package by Carl Boettiger:

http://www.carlboettiger.info/2012/05/30/knitcitations.html

This allows you to simply include DOIs inline and have a bibliography
automatically generated for you.

Example 4: Reproducible manuscripts with RMarkdown
--------------------------------------------------

Finally, bringing it all together, we will look at an example RMarkdown
document which includes all of the above elements with figures and
tables generated on-the-fly using knitr.

- [Example 4](examples/04-rmarkdown-manuscript-example.Rmd)

Further reading
---------------

**Markdown-based manuscripts**

1. [Simple template for scientific manuscripts in R markdown](http://www.petrkeil.com/?p=2401)
2. [Writing academic papers in Markdown using Sublime Text and Pandoc](http://nikolasander.com/writing-in-markdown/)
3. [Writing Scientific Papers Using Markdown](https://danieljhocking.wordpress.com/2014/12/09/writing-scientific-papers-using-markdown/)
4. [Markdown-for-Manuscripts](https://github.com/djhocking/Markdown-for-Manuscripts)
5. [Opening Science (a book written in Markdown)](http://book.openingscience.org/)
6. [Library Data: R Markdown and Figures](http://www.rci.rutgers.edu/~ag978/litdata/figs/)

