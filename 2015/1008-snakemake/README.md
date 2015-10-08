# Reproducible bioinformatics workflows with Snakemake

##Setup
Follow [these
instructions](https://htmlpreview.github.io/?https://bitbucket.org/johanneskoester/snakemake/raw/master/snakemake-tutorial.html) to set up your environment.

Alternatively, if you're on Mac or Linux and already have `conda` installed,
run `prepare-environment.sh` to download and unpack example data and create
a new conda environment.

The conda environment has snakemake, samtools, and bwa installed, and in order to use the environment, use:

```bash
source activate snakemake-tutorial
```

which prepends directories to your `$PATH` environmental variable.

##Slides
The content for the slides is in `source.markdown`. They can be rendered using [remark](https://github.com/gnab/remark/wiki) by running

```bash
./serve-slides.sh
```

and pointing your browser to localhost:8000.

