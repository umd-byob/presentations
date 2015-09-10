---
title: Adding LaTeX to improve flexibility 
author: Keith Hughitt
date: 2015/09/10
header-includes:
   - \usepackage{wrapfig}
   - \usepackage{framed}
---

Overview
========

In this example, we provide some simple examples of how the strengths of
Markdown and LaTeX can be used together to provide a higher level of control
over manuscript formatting.

The focus for this example is image positioning, and text flow. The default
method Pandoc uses to render images is to center them on the page, possibly
placing the image on a new page below when sufficient space is not available.
Often this results in the image appear *after* the location they are included
in, making it difficult to precisely where they appear in the document flow.

Further, the basic version of Markdown used by Pandoc does not support any
syntax for scaling images, so the images need to be pre-scaled before being
included in the document.

There are several possible work-around to this problem including HTML-based and
LaTeX-based approaches. The method I will describe below is one possible
LaTeX-based solution.

LaTeX figure rendering
======================

To improve our control over figure placement in Markdown documents, we will
make use of two LaTeX packages:

- [wrapfig](https://www.ctan.org/pkg/wrapfig?lang=en)
- [framed](https://www.ctan.org/pkg/framed?lang=en)

First, we will need to modify the YAML header at the top of our markdown
document to indicate that these packages should be included.

To do this, we can use the `header-includes` option (see
[here](http://tex.stackexchange.com/questions/139139/adding-headers-and-footers-using-pandoc)
for more examples).

```yaml
---
header-includes:
   - \usepackage{wrapfig}
   - \usepackage{framed}
---
```

### Positioning images with wrapfig

First, let's see how we can use `wrapfig` to align images to either side of a
document and have text flow around them.

The basic syntax for using wrapfig is:

```
\begin{wrapfigure}{r}{0.5\textwidth}
  \begin{center}
    \includegraphics[width=0.5\textwidth]{filename}
  \end{center}
  \caption{figure caption}
\end{wrapfigure}
```

If you were to use only the above syntax for all of your figures, however, you
would likely run into a problem when attempting to compile a PDF:

```
! Undefined control sequence.
l.156     \includegraphics

pandoc: Error producing PDF from TeX source
 ```

