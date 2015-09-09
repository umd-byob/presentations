Writing reproducible manuscripts with RMarkdown
===============================================

[Keith Hughitt](mailto:khughitt@umd.edu)

September 10, 2015

Overview
--------

In this tutorial, we will explore the use of
[Markdown](http://daringfireball.net/projects/markdown/) for writing scientific
manuscripts. After discussing some of the strengths and weaknesses of using
Markdown over other approaches such as [LaTeX](http://www.latex-project.org/)
or [Google Docs](https://www.google.com/docs/about/), the basic steps of
putting togehter a Markdown-based paper will be described. Next, examples will
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


