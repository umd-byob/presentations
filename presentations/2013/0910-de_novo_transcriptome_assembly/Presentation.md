De novo assembly for short-read mRNA-Seq
===========================================
--------------------------------
## Configuring a fresh system for development
Most modern operating systems, even Linux, do not come with prepackaged with comprehensive development environments.  This saves both bandwidth and space for the vast majority of users who will never use any part of their computer that can't be navigated by mouse clicks alone.  For the rest of us, this means that we have to do a bit of tinkering before we can really get started using a new system.

### Mac OS X
1. Open the App Store App
2. Install Xcode
3. Open Xcode
4. Navigate to Preferences (click the Apple in the upper left corner)
5. Select the "Downloads" tab
6. Click the button to install "Command Line Tools"

### Ubuntu
1. Open a terminal
2. Type the following commands to install various things from the Apt repository:

```
sudo apt-get update
sudo apt-get install build-essential
sudo apt-get install linux-headers-$(uname -r)
```

### Windows
I would strongly recommend using Cygwin, Wubi, or gaining access to a *nix-based system if you intend to develop or use open source software on a regular basis.

## Downloading assembly software
Clicking web links to download files is very convenient as long as you're using the same computer for everything.  Downloading files to a local computer, only to immediate have to copy them to a remote server can quickly become tedious however, so I recommend learning to use `wget`:

```
ssh user@server
cd working/directory/
wget <link>
```

This command line utility allows files to be downloaded directly to any machine, without having to stage it on some intermediate work station.

### Trinity
Links to downalod Trinity can be found on the project's SourceForge page.

Main website: <http://trinityrnaseq.sourceforge.net/>  
Download page: <http://sourceforge.net/projects/trinityrnaseq/files/>

Choose the desired version, right click the corresponding link, select "Copy Link Address" (or whatever equivalent option is offered by your-favorite-browser), and the use wget to download it.  Zum Beispiel:

```
wget http://sourceforge.net/projects/trinityrnaseq/files/trinityrnaseq_r2013_08_14.tgz/download
```

Now, this command will actually save Trinity in a file called "download", so I tend to manually delete the "/download" from the link address when I see it.  You can also just rename the file to "anything.tgz" once it's finished.  

### Oases
Similarly, Oases can be downloaded from its own project page:  
<http://www.ebi.ac.uk/~zerbino/oases/>  

```
wget http://www.ebi.ac.uk/~zerbino/oases/oases_0.2.08.tgz
```

or, as indicated on the main page, it can be checked out from Github:  
<https://github.com/dzerbino/oases/tree/master>

## Unpacking the compressed directories
Once we have downloaded the compressed tarballs, we need to unpack them.  The simplest way is using the `tar` command, which can be found on nearly any computer.

```
tar -xzvf trinityrnaseq_r2013_08_14.tgz
tar -xzvf oases_0.2.08.tgz
```

All those flags tell `tar` to e**x**tract a g**z**ipped **f**ile and provide **v**erbose output as it works.  This will create new directories called "trinityrnaseq_r2013_08_14" and "oases_0.2.0".  The original compressed files can now be deleted.

## Installing dependencies (for Ubuntu)

### Trinity
Trinity comes prepackaged with most of software it needs.  This has caused the package to bloat over 100MB, but greatly simplifies the installation process.  On Ubuntu, the only thing Trinity needs beyond the standard set of compilers and header files are the zlib headers, which can be easilly installed from the apt-repository.

```
sudo apt-get install zlib1g-dev
```

### Oases
Like Trinity, Oases requires one additional non-standard package (Latex) from the apt-repository, which it uses to compile the help pages.

```
sudo apt-get install texlive-full
```

Unlike Trinity however, Oases does not come packaged with the rest of the software packages upon which it's built.  We must therefore first download and install Velvet.

#### Installing Velvet
Unlike the other dependecies, Velvet can not be automagically installed from the apt repositories.  Instead, we must use a procedure very similar to what we're using for the other assemblers.  Thankfully, Velvet doesn't have any special dependencies for itself.  The only quirk is that Velvet and Oases must both be compiled with identical optional parameters.  Here I'm compiling Velvet to accept only a single read library, *k*mers up to 64 bases, and OpenMPI support (parallel version).

```
wget http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz
tar -xzvf velvet_1.2.10.tgz
cd velvet_1.2.10.tgz
make 'CATEGORIES=1' 'MAXKMERLENGTH=64' 'OPENMP=1’
```

Now that we've gone to the trouble to compile Velvet, we might as well install it:

```
sudo cp velvet[gh] /usr/local/bin/
```

## Installing the assemblers

### Trinity
Like most open source software packages, Trinity uses `make` to handle compilation.

```
cd trinityrnaseq_r2013_08_14
make
```

The Trinity binaries are rarely called directly however, and the Trinity.pl wrapper script uses relative paths to find them.  It is therefore not very helpful to copy anything from the Trinity build directory into your path.  Instead, I prefer to link the main wrapper script into `/usr/local/bin`:

```
sudo ln -s Trinity.pl /usr/local/bin/
```


### Oases
Oases is more typical, except that it requires the user to direct it towards the Velvet source directory, and also to indicate the options used to compile the Velvet binaries:

```
cd oases_0.2.08
make 'VELVET_DIR=/usr/local/src/velvet/1.2.10' 'CATEGORIES=1' 'MAXKMERLENGTH=64' 'OPENMP=1'
```

Once this has finished, we can simply copy the Oases binary into `/usr/local/bin`:

```
sudo cp oases /usr/local/bin/
```

# Installation Summary (for Ubuntu)
```
# Prepare system
sudo apt-get update
sudo apt-get install build-essential
sudo apt-get install linux-headers-$(uname -r)
sudo apt-get install zlib1g-dev
cd ~/working/directory/
# Install Trinity
wget http://sourceforge.net/projects/trinityrnaseq/files/trinityrnaseq_r2013_08_14.tgz
tar -xzvf trinityrnaseq_r2013_08_14.tgz
cd trinityrnaseq_r2013_08_14
make
sudo ln -s Trinity.pl /usr/local/bin/
cd ../
# Install Oases
sudo apt-get install texlive-full
wget http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz
tar -xzvf velvet_1.2.10.tgz
cd velvet_1.2.10
make 'CATEGORIES=1' 'MAXKMERLENGTH=64' 'OPENMP=1’
sudo cp velvet[gh] /usr/local/bin/
cd ../
wget http://www.ebi.ac.uk/~zerbino/oases/oases_0.2.08.tgz
tar -xzvf oases_0.2.08.tgz
cd oases_0.2.08
make 'VELVET_DIR=/usr/local/src/velvet/1.2.10' 'CATEGORIES=1' 'MAXKMERLENGTH=64' 'OPENMP=1'
sudo cp oases /usr/local/bin/
cd ../
```
