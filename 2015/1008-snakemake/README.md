# Reproducible bioinformatics workflows with Snakemake
Author: Ryan Dale
License: Public domain

##Setup
Follow [these
instructions](https://htmlpreview.github.io/?https://bitbucket.org/johanneskoester/snakemake/raw/master/snakemake-tutorial.html) to set up your environment.

Alternatively, if you're on Mac or Linux and already have `conda` installed,
run `prepare-environment.sh` (in this directory) to download and unpack example data and create
a new conda environment.

The conda environment has snakemake, samtools, and bwa installed. To use the environment, use:

```bash
source activate snakemake-tutorial
```

which prepends directories to your `$PATH` environmental variable. When you're done, 

```bash
source deactivate
```

to restore your $PATH.

The contents of `Snakefile` are what was covered in the seminar.

##Slides
Download `slides2.html` and view the file locally.

The content for the slides is in `source.markdown`. They can be rendered using
[remark](https://github.com/gnab/remark/wiki) by running

```bash
./serve-slides.sh
```
and pointing your browser to localhost:8000.


