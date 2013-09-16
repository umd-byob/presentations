De novo assembly for short-read mRNA-Seq
========================================
--------------------------------

# Getting Started with a new system
Most modern operating systems, even Linux, do not come with prepackaged with comprehensive development environments.  This saves both bandwidth and space for the vast majority of users who will never use any part of their computer that can't be navigated by mouse clicks alone.  For the rest of us, this means that we have to do a bit of tinkering before we can really get started using a new system.

### Mac OS X
1. Open the App Store App
2. Install Xcode
3. Open Xcode
4. Navigate to Preferences (click the Apple in the upper left corner)
5. Select the "Downloads" tab
6. Click the button to install "Command Line Tools"

### Windows
I would strongly recommend using Cygwin, Wubi, or gaining access to a *nix-based system if you intend to develop or use open source software on a regular basis.

### Ubuntu (Linux)
I will use Ubuntu 12.04 LTS for the rest of this demo.

1. Open a terminal
2. Type the following commands to install various things from the Apt repository:

```
sudo apt-get update
sudo apt-get install build-essential
sudo apt-get install linux-headers-$(uname -r)
```

### Downloading software from the command line
Clicking web links to download files is very convenient as long as you're using the same local computer for everything.  Downloading files to a local computer, only to immediate have to copy them to a remote server can quickly become tedious however, so I recommend learning to use `wget`.  This allows files to be downloaded directly to any machine, without having to stage it on some intermediate work station.

I find it helpful to create a single directory to hold all of the software I download.  I tend to use `/usr/local/bin`, but this requires root access and can sometimes create other complications, so I will use the placeholder `/local/source/code/repository/` for the rest of this demo.

```
ssh user@server
cd /local/source/code/repository/
wget <link>
```

It is worth noting that links copied from browsers will frequently have the form `http://some.website.com/filename.tgz/download`.  If this is passed to wget, then wget will save the file as "download".  This is annoying because tar will then complain about the suffix.  An appropriate suffix can be added after the fact, but I find it easier to just remove the `/download` from the link.  I can't guarantee that this will always work, but I've never had problems doing it.

### Unpacking compressed directories
Many software packages are available as compressed directories.  This greatly reduces the amount of information that must be transmitted over the web.  The simplest way to unpack these "tarballs" is using the `tar` command, which can be found on most computers.

```
tar -xzvf <filename>.tgz
tar -xzvf <filename>.tar.gz
tar -xjvf <filename>.bz2
tar -xjvf <filename>.bzip2
```

All those flags tell `tar` to e***x***tract either a g***z***ipped or, uh, bzipped (denoted ***j*** for some reason) ***f***ile and provide ***v***erbose output as it works.  The original compressed files can then be deleted with the `rm` command.

### Compiling and installing software
Once the directories have been unpacked, they will likely contain some combination of source code and/or prebuilt binaries.  If they contain binaries, and you were careful to download the correct version for your system, then installation may be as simple as copying them to a directory in your path.  The most common place to install custom software is `/usr/local/bin`, which requires root access.

```
cd /local/source/code/repository/<software>/
sudo cp <binary_name> /usr/local/bin/
```

It is common for binaries to located in a subdirectory called `bin`, although this is far from universally practiced.

If the directory contains source code that must first be built, the most common method is using the `make` command.  First, change into the source code directory, then look for files called `configure`, `config`, `make`, or `Makefile`.  If you see some combination of these, then try the following set of commands, knowing that the first and third may fail.

```
./configure
make
sudo make install
```

If you get a message saying that the `./configure` command wasn't found, then don't worry about it.  Same with `sudo make install`.  As long as `make` completes successfully, then you should have created binaries somewhere in that directory.  The "install" often just copies them into `/usr/local/bin/`, which you now know how to do yourself  :)

--------------------------------------

# Installation Summary (for Ubuntu 12.04)

### Install Java and some additional libraries
```
sudo apt-get install default-jre
sudo apt-get install zlib1g-dev
sudo apt-get install libncurses5-dev
sudo apt-get install texlive-full
```

### Install samtools
```
cd /local/source/code/repository/
wget http://sourceforge.net/projects/samtools/files/samtools/0.1.19/samtools-0.1.19.tar.bz2
tar -xjvf samtools-0.1.19.tar.bz2
cd samtools-0.1.19
make
sudo cp samtools /usr/local/bin/
```

### Install Bowtie
```
cd /local/source/code/repository/
wget http://sourceforge.net/projects/bowtie-bio/files/bowtie/1.0.0/bowtie-1.0.0-linux-x86_64.zip
unzip bowtie-1.0.0-linux-x86_64.zip
cd bowtie-1.0.0
sudo cp bowtie /usr/local/bin/
sudo cp bowtie-build /usr/local/bin/
sudo cp bowtie-inspect /usr/local/bin/
sudo chmod +x /usr/local/bin/*
```

### Install Trinity
```
cd /local/source/code/repository/
wget http://sourceforge.net/projects/trinityrnaseq/files/trinityrnaseq_r2013_08_14.tgz
tar -xzvf trinityrnaseq_r2013_08_14.tgz
cd trinityrnaseq_r2013_08_14
make
sudo ln -s Trinity.pl /usr/local/bin/
```

Software installed by Trinity:

* JellyFish
* Inchworm
* Chrysalis
* QuantifyGraph
* GraphFromFasta
* ReadsToTranscripts
* fastool
* parafly
* slclust
* collectl

### Install Velvet
```
cd /local/source/code/repository/
wget http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz
tar -xzvf velvet_1.2.10.tgz
cd velvet_1.2.10
make 'CATEGORIES=1' 'MAXKMERLENGTH=64' 'OPENMP=1’
sudo cp velvet[gh] /usr/local/bin/
```

### Install Oases
```
cd /local/source/code/repository/
wget http://www.ebi.ac.uk/~zerbino/oases/oases_0.2.08.tgz
tar -xzvf oases_0.2.08.tgz
cd oases_0.2.08
make 'VELVET_DIR=/usr/local/src/velvet/1.2.10' 'CATEGORIES=1' 'MAXKMERLENGTH=64' 'OPENMP=1'
sudo cp oases /usr/local/bin/
sudo cp scripts/oases_pipeline.py /usr/local/bin/
```

--------------------------------------

# Sample Data
Many software packages come with small test data sets that can be used by end users verify that they have the software installed and running properly.  Trinity and Oases both come with test data sets, but the Oases reads are stored in an interleaved FASTA file, which pretty much only Velvet uses.  I'm therefore going to focus on the Trinity practice reads for this demo.  

Interestingly, the most recent version of Trinity lacks support for compressed read files, even though the practice reads still come gzipped, so we first have to uncompress them.

```
gunzip -c /local/source/code/repository/trinityrnaseq_r2013_08_14/sample_data/test_Trinity_Assembly/reads.left.fq.gz > ~/Desktop/BYOB_2013-09-10/reads.left.fq
gunzip -c /local/source/code/repository/trinityrnaseq_r2013_08_14/sample_data/test_Trinity_Assembly/reads.right.fq.gz > ~/Desktop/BYOB_2013-09-10/reads.right.fq
```

--------------------------------------

# Running Trinity
Trinity is relatively simple to run, for an assembler.  If the `Trinity.pl` script has been linked to the user's `$PATH`, and the user is in the directory containing the reads file `reads.left.fq` and `reads.right.fq`, then Trinity can be run as follows:

```
Trinity.pl --seqType fq --JM 1G --left reads.left.fq --right reads.right.fq
```

Arguably, a better way to run it is to be more specific about the paths and the parameters:

```
/usr/local/src/trinityrnaseq/r2013_02_25/Trinity.pl --seqType fq --JM 1G --left ~/Desktop/BYOB_2013-09-10/reads.left.fq --right ~/Desktop/BYOS_2013-09-10/reads.right.fq --output byob_trinity_r2013_02_25_demo --CPU 2
```

This is pretty difficult to read though, so a nicer way to run Trinity is to create `run.sh` script that lays out the commands in a way that makes it easier to read, and therefor to catch potential errors.

```
#!/bin/bash

left=~/Desktop/BYOB_2013-09-10/reads.left.fq
right=~/Desktop/BYOS_2013-09-10/reads.right.fq

time nice /usr/local/src/trinityrnaseq/r2013_02_25/Trinity.pl \
--seqType fq \
--JM 1G \
--left $left \
--right $right \
--output byob_trinity_r2013_02_25_demo \
--CPU 2 \
| tee byob_trinity_r2013_02_25_demo.log
```

To run a different version of Trinity, just link to the corresponding `Trinity.pl` script.

--------------------------------------

# Running Oases
Oases also contains a wrapper script called `oases_pipeline.py`, which I also prefer to call from a `run.sh` shell script within each working directory:

```
#!/bin/bash

reads1=~/Desktop/BYOB_2013-09-10/reads.left.fq
reads2=~/Desktop/BYOB_2013-09-10/reads.right.fq

kmin=15
kmax=63
step=2
merge=25
insLen=300

time nice oases_pipeline.py \
-m $kmin \
-M $kmax \
-s $step \
-g $merge \
-o byob_oases_demo \
-d " -shortPaired -separate -fastq $reads1 $reads2 " \
-p " -ins_length $insLen "
```

Unlike trinity, Oases does not provide verbose output as it works, so I use the following command to monitor it's progress:

```
while true; do ls -lhd */; sleep 5; done
```

After this completes, the merged assembly can be tweaked by using the `-r` command with the `oases_pipeline.py` script:

```
time nice oases_pipeline.py -m 21 -M 41 -g 21 -r -o byob_oases_demo
```

--------------------------------------

### Install Bowtie2
```
cd /local/source/code/repository/
wget http://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.1.0/bowtie2-2.1.0-linux-x86_64.zip
unzip bowtie2-2.1.0-linux-x86_64.zip
cd bowtie2-2.1.0
sudo cp bowtie2* /usr/local/bin/
```

--------------------------------------

# Comparing the Assemblies

### Installing NCBI-BLAST+
```
cd /local/source/code/repository/
wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.2.28+-x64-linux.tar.gz
tar xzvf ncbi-blast-2.2.28+-x64-linux.tar.gz
cd ncbi-blast-2.2.28+
sudo cp bin/* /usr/local/bin/
```

### Downloading NCBI BLAST databases
There is a "proper" way to do this using wget options, but I don't know those options, and I *do* know how to use BASH for-loops, so I did this instead:
```
cd /local/database/repository/
for i in seq $(seq -f "%02g" 0 15); do wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.${i}.tar.gz; done
wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/est_mouse.tar.gz.md5
```

I'm pretty sure this next part doesn't require a loop, but I used one anyway.  Note that I dropped the dash (-) on the `tar` options.  This was not a typo.  The `tar` command will accept this, though it is good to be in a habit of using normal command line option syntax.

```
for file in *.tar.gz; do tar xzvf $file; done
```

### Installing HMMer3
```
cd /local/source/code/repository/
wget ftp://selab.janelia.org/pub/software/hmmer3/3.1b1/hmmer-3.1b1-linux-intel-x86_64.tar.gz
tar xzvf hmmer-3.1b1-linux-intel-x86_64.tar.gz
cd hmmer-3.1b1-linux-intel-x86_64
sudo cp binaries/* /usr/local/bin/
```

### Downloading Pfam-A
```
cd /local/database/repository/
wget ftp://ftp.sanger.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
gunzip Pfam-A.hmm.gz
```

Then prepare it for use with either `hmmsearch` or `hmmscan` by formatting it with `hmmpress`:

```
cd /local/database/repository/
hmmpress Pfam-A.hmm
```

### Installing Google sparehash
```
cd /local/source/code/repository/
wget https://sparsehash.googlecode.com/files/sparsehash-2.0.2.tar.gz
tar -xzvf sparsehash-2.0.2.tar.gz
cd sparsehash-2.0.2
./configure
make
sudo make install
```

### Installing the C++ Boost libraries
```
cd /local/source/code/repository/
wget http://downloads.sourceforge.net/project/boost/boost/1.50.0/boost_1_50_0.tar.bz2
tar xjvf boost_1_50_0.tar.bz2
cd boost_1_50_0
sudo ./boostrap.sh
sudo ./b2
```

### Installing ABySS
```
cd /local/source/code/repository/
wget http://www.bcgsc.ca/platform/bioinfo/software/abyss/releases/1.3.6/abyss-1.3.6.tar.gz
tar -xzvf abyss-1.3.6.tar.gz
cd abyss-1.3.6
ln -s /local/source/code/repository/boost_1_50_0/boost boost
./configure
make
sudo make install
```

### Installing R & Rstudio (and some useful packages)
I wanted R 3.0, which isn't currently available through the apt-repositories, so I had to do a bit of tinkering as per the instructions on this website: <http://cran.r-project.org/bin/linux/ubuntu/README.html>

First, open `/etc/apt/sources.list` as root using your-favorite-text-editor.  I like vim, though I don't recommend it.

```
sudo vim /etc/apt/sources.list
```

Add this line to the end (I normally use the [NCI mirror](http://watson.nci.nih.gov/cran_mirror/), but I wasn't able to reach it while I was making this tutorial, so I used the [CMU mirror](http://lib.stat.cmu.edu/R/CRAN/) instead):

```
deb http://lib.stat.cmu.edu/R/CRAN/bin/linux/ubuntu precise/
```

Then install R and some useful libraries (everything except `plyr`, `ggplot2`, and `knitr` are on this list because `R` complained about them being out of date).

```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update
sudo apt-get install r-base
sudo apt-get install r-base-dev
sudo R
install.packages("codetools", dependencies=True)
install.packages("plyr", dependencies=True)
install.packages("MASS", dependencies=True)
install.packages("lattice", dependencies=True)
install.packages("survival", dependencies=True)
install.packages("rpart", dependencies=True)
install.packages("foreign", dependencies=True)
install.packages("cluster", dependencies=True)
install.packages("ggplot2", dependencies=True)
install.packages("knitr", dependencies=True)
```
Press ctrl+d to close the R session, then [install Rstudio from the web](http://www.rstudio.com/) and enjoy the simple nostalgic pleasure of clicking buttons for a few minutes.
