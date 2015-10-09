if [ ! -e snakemake-tutorial-data.tar.gz ]; then
    wget https://bitbucket.org/johanneskoester/snakemake/downloads/snakemake-tutorial-data.tar.gz
else
    echo "tarball exists; skipping download"
fi
if [ ! -e data/genome.fa ]; then
    tar -xf snakemake-tutorial-data.tar.gz
else
    echo "tarball appears to already be extracted; skipping"
fi

if [ ! $(conda env list | grep "snakemake-tutorial" | wc -l) -ne 0 ]; then
    conda create -n snakemake-tutorial -c bioconda --file requirements.txt python=3
else
    echo "conda environment 'snakemake-tutorial' already exists"
fi
