---
title: Using BibTeX to add a bibliography
author: Keith Hughitt
date: 2015/09/10
bibliography: references.bib
---

Overview
========

In this example, the use of BibTeX for incorporating references into a Markdown
manuscript is described.

[BibTeX](http://www.bibtex.org/Format/) is a file format used for describing
references and is commonly used in conjunction with LaTeX documents. A `.bib`
file contains one or more reference entries, each of which contains all of the
necessary information to describe a single bibliography entry.

An example entry might look like:

```tex
@article{Yizhak2015,
author = {Yizhak, Keren and Chaneton, Barbara and Gottlieb, Eyal and Ruppin, Eytan},
keywords = {11,15252,20145307,2015,817,accepted 26 may 2015,cancer metabolism,doi 10,genome-scale simulations,metabolic modeling,mol syst biol,msb,received 22 october 2014,revised 4 april},
pages = {1--17},
title = {{Modeling cancer metabolism on a genome scale}},
year = {2015}
}

Additional fields for including an abstract, isbn, etc. may also be included.
```

Notice in particular the string just after the opening bracket on the first
line: `Yizhak2015`. This will be the reference key you use to cite the artcile
in your document text (more on this later.)

Most popular reference managers are capable of generating .bib files for a
collection of references. For example, in Mendeley, you can use the "export"
option on a selected set of references to generate a BibTeX file. An easy way to
organize your references then is to simply have a separate folder for each
manuscript in Mendeley. Indeed there is even an option to have Mendeley
automatically generate a .bib file for each folder you create, such that
whenever a new reference is added to that folder, the corresponding .bib file
is automatically updated.

Adding a BibTeX bibliography
============================

After generating a BibTeX bibliography, you need to tell Pandoc where to find
it. To do this, edit the YAML block at the top of your Markdown document, and
add a `bibliography` entry:

```
---
title: Using BibTeX to add a bibliography
author: Keith Hughitt
date: 2015/09/10
bibliography: references.bib
---
```

To cite an article in your bibliography, you simply add an entry of the
following form:

```
[@Ref1; @Ref2; etc.]
```

For example, here we cite the first two entries from our bibliography
[@Shuman2013; @Yan2015], and a few more [@Yao2015; @Clarke2008; @Yin2015;
@Yizhak2015].

To have a references section automaticaly generated and appended to the bottom
of the file, we can then use the excellent [pandoc citeproc
extension](https://github.com/jgm/pandoc-citeproc):

```
pandoc --filter pandoc-citeproc input.md -o output.pdf
```

Specifying the citation style to use
====================================

To specify which citation and bibliography style should be used for the output
PDF, you can use the `--csl` citeproc parameter to choose from one of [over 7500
possible citation styles](https://github.com/citation-style-language/styles).

Simply download the citation style (.csl) file for the format you wish to use
and modify your pandoc command to include it, e.g.:

```
pandoc --filter pandoc-citeproc input.md --csl nucleic-acids-research.csl -o output.pdf
```

Some additional examples of how to include citations in Markdown are described
in the [RMarkdown documentation](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html).


References
==========

