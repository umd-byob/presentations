#!/bin/env bash
echo "This is essentially the same submission script as last time."
echo "Except all those parameters will need to be specified on the command line."
echo "In addition, this time I will source my bashrc explicitly."

## Keep in mind the bashrc should never print _anything_ to screen
source ${HOME}/.bashrc

if [ -n "$PBS_O_WORKDIR" ]; then
    cd $PBS_O_WORKDIR
fi

echo "Find out the executing host:"
uname -a
echo "Find out the current working directory:"
pwd
echo "Find out if any PBS specific variables are set:"
env | grep "^PBS"
