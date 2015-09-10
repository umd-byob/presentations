---
title: Adding LaTeX to improve flexibility 
author: Keith Hughitt
date: 2015/09/10
header-includes:
   - \usepackage{wrapfig}
   - \usepackage{framed}
---

<!-- eliminate white-space above figures
 http://tex.stackexchange.com/questions/27695/strange-space-left-above-wrapfig-figures
-->
\setlength\intextsep{0pt}

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

Positioning images with wrapfig
-------------------------------

First, let's see how we can use `wrapfig` to align images to either side of a
document and have text flow around them.

The basic syntax for using wrapfig is:

```tex
\begin{wrapfigure}{r}{0.5\textwidth}
  \begin{center}
    \includegraphics[width=0.5\textwidth]{filename}
  \end{center}
  \caption{figure caption}
\end{wrapfigure}
```

If you were to use only the above syntax for all of your figures, however, you
would likely run into a problem when attempting to compile a PDF:

> ! Undefined control sequence.
> 
> l.156     \\includegraphics
>
> pandoc: Error producing PDF from TeX source

Pandoc appears to have trouble with `includegraphics` calls in documents for
which there are no figures included using normal markdown syntax.

A work-around for this is to include a small (1x1px) transparent image using
Markdown, and set its display to `none` using CSS:

```html
<div style='display:none;'>
![](images/placeholder.png)
</div>
```

The image itself is still included, but is small enough to be missed (there is
probably a pretty straight-forward way to hide it completely.) The CSS is
needed to prevent an empty figure caption from being included and disrupting
the ordering of figure numbers in the text.

<div style='display:none;'>
![](images/placeholder.png)
</div>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

\begin{wrapfigure}{r}{0.5\textwidth}
  \begin{center}
    \includegraphics[width=0.5\textwidth]{images/ponyo}
  \end{center}
  \caption{\textbf{Cat} Ponyo prefers to be on the right-side of the document.}
\end{wrapfigure}

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.


Adding a border using framed
----------------------------

### Basic framed usage

We may also wish to include a border around our images. To do this, we can used
the LaTeX `framed` package.

\pagebreak

For this, we simply wrap our `\includegraphics` call with:

```tex
\begin{framed}
...
\end{framed}
```

The resulting code to include our figure becomes:

```tex
\begin{wrapfigure}[28]{l}{0.5\textwidth}
\begin{framed}
  \begin{center}
    \includegraphics{images/ponyo}
  \end{center}
  \caption{\textbf{Cat} For now, she will settle for being on the left... 
  }
\end{framed}
\end{wrapfigure}
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

\begin{wrapfigure}{l}{0.5\textwidth}
\begin{framed}
  \begin{center}
    \includegraphics{images/ponyo}
  \end{center}
  \caption{\textbf{Cat} For now, she will settle for being on the left... 
  }
\end{framed}
\end{wrapfigure}

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua.

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

### Getting rid of extra spacing

To reduce some of the wasted space above and below the figure, we can use the
`\vspace` command:

```tex
\begin{wrapfigure}{l}{0.5\textwidth}
\begin{framed}
  \vspace{-18pt}
  \begin{center}
    \includegraphics{images/ponyo}
  \end{center}
  \vspace{-20pt}
  \caption{\textbf{Cat} Still hanging out on the left, but enjoying the more
  snug box.
  }
  \vspace{-8pt}
\end{framed}
\end{wrapfigure}
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

\begin{wrapfigure}{l}{0.5\textwidth}
\begin{framed}
  \vspace{-18pt}
  \begin{center}
    \includegraphics{images/ponyo}
  \end{center}
  \vspace{-20pt}
  \caption{\textbf{Cat} For now, she will settle for being on the left... 
  }
  \vspace{-8pt}
\end{framed}
\end{wrapfigure}

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua.

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

Additional tips on working with images
--------------------------------------

Finally, here are a couple more tricks that I've found useful for improving the
image handling in Markdown.

### Reduce wasted space with \\intextsep

Add this to the top of your document to cut back on some of the wasted space
above and below your figures:

```tex
\setlength\intextsep{0pt}
```

Source: [http://tex.stackexchange.com/questions/27695/strange-space-left-above-wrapfig-figures]( http://tex.stackexchange.com/questions/27695/strange-space-left-above-wrapfig-figures)

### Use \\pagebreak to start a new page

Sometimes it is also useful to push some content down to the start of a new
page. This can be useful, for example, if a block of code is rendering at the
bottom of a page and is being split across two pages.

```tex
\pagebreak
```

Further Reading
===============

1. [Overleaf Package Example: wrapfig](https://www.overleaf.com/latex/examples/package-example-wrapfig/hmdrphhbxmjp#.VfGcNmzoJhE)
2. [ShareLaTeX - wrapfig](https://www.sharelatex.com/learn/Wrapping_text_around_figures)
3. [LaTeX Stack Exchange - Handling of wrapfig pictures in LaTeX](http://tex.stackexchange.com/questions/56176/handling-of-wrapfig-pictures-in-latex)
4. [LaTeX/Boxes - Wikibooks](https://en.wikibooks.org/wiki/LaTeX/Boxes)
