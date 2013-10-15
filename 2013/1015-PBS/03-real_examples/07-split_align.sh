#!/bin/bash
source ${LAB}/scripts/dotbashrc

## Option argument handling as per example at:
## http://stackoverflow.com/questions/402377/using-getopts-in-bash-shell-script-to-get-long-and-short-command-line-options/7680682#7680682
## options may be followed by one colon to indicate they have a required argument
## Options used by this script:
# -i|--input : input fastq -- required
# -r|--reference : reference library without the .bwt1 etc --required
# -j|--jnput : second read input fastq -- not required
# -n|--nodes : how many nodes to request
# -h|--help  : print some usage information
# -t|--test  : don't actually do anything on the compute nodes, just print what would be done.
MYOPTIONS=$(/usr/bin/getopt -o a:hi:j:n:r:t --long aligner:,help,input:,jnput:,nodes:,reference:,test -- "$@")
if [ $? != 0 ]; then
    echo "Options processing failed." >&2
    exit 1
fi

eval set -- "$MYOPTIONS"
while [ $# > 0 ]; do
    case "$1" in
    -a|--aligner)
	    echo "Setting the aligner to: $2"
	    export ALIGNER=${2-"bowtie2"}
	    shift
	    ;;
    -t|--test)
	    echo "Going to print the commands I _would_ run."
	    export MYTEST=1
	    ;;
    -h|--help)
	    echo "This script attempts to split an input fastq into files"
	    echo "appropriate for aligning over n nodes."
	    echo "For example:"
	    echo "split_align -n 12 -i /some/path/to/input.fastq -r /some/path/to/tcruzi_combined"
	    echo ""
	    echo "The above command will request 12 nodes"
	    echo "align input.fastq, and use the tcruzi_combined reference"
	    echo "note that the tcruzi_combined doesn't have .bwt"
	    exit 0
	    ;;
    # for options with required arguments, an additional shift is required
    -i|--input)
	    IN="$2"
	    shift
	    ;;
    -j|--jnput)
	    IN2="$2"
	    shift
	    ;;
    -n|--nodes)
	    start="$2"
	    shift
	    ;;
    -r|--reference)
	    export RNA_LIB=$2
	    shift
	    ;;
    (--)
            shift
	    break
	    ;;
    (-*)
            echo "$0: error - unrecognized option $1" 1>&2
	    exit 1
	    ;;
    (*)
            break
	    ;;
    esac
    shift
done

export NODES=${start-10}
export MYTEST=${MYTEST-0}
export ALIGNER=${ALIGNER-"bowtie2"}
## Check that the reference library exists.
export RNALIB=${RNALIB-"${REF}/tcruzi/tcruzi_clbrener/genome_tcruzi_clbrener/tc_combined/TcruziComplete_Genomic_TritrypDB-4.1.1.bt2"}
export BINDIR="/cbcb/lab/nelsayed/programs/bin"
export BUILD="$BINDIR/bowtie2-build"
export REFDIR=$(/usr/bin/dirname $RNALIB)

function submit_test {
cat <<"EOF" | qsub $QSUB_ARGS

source ${LAB}/scripts/dotbashrc
start_log ${MYWD}/${PBS_JOBNAME}_dstat.txt
start_log

coproc dstat -t -c -d -n -g -m -y -p -r --fs --tcp --vm --proc-count --output=${MYWD}/${PBS_JOBNAME}.csv 2>>${MYWD}/${PBS_JOBNAME}_dstat.txt 1>&2
echo "Changing directory to ${MYWD}"
cd ${MYWD}

NODE=${PBS_ARRAYID}
ls -al
sleep 30
ls -al

if [[ "$?" = "0" ]]; then
   echo "$NODE success $? in ${SECONDS}" >> ${MYWD}/status.txt
else
   echo "$NODE fail $? in ${SECONDS}" >> ${MYWD}/status.txt
fi

end_log

EOF
}

function submit_bowtie {
cat <<"EOF" | qsub $QSUB_ARGS

## Body of the script to run bowtie goes here.

source ${LAB}/scripts/dotbashrc
start_log

coproc $VMSTAT
echo "Changing directory to: ${MYWD}"
cd ${MYWD}

NODE=${PBS_ARRAYID}
CORES=" -p $(cpus) "
MULTALIGN=${MULTIALIGN-" -k 1 "}
TRIM3p=${TRIM3p-" -3 0 "}
SEEDARGS=${SEEDARGS-" -D 5 -R 1 -N 0 -L 10 -i S,0,2.50 "}
FILETYPE=${FILETYPE-" -f "}
REPORTARGS=${REPORTARGS-"  --un-gz  ${MYWD}/${IN}-unaligned.txt.gz --al-gz ${MYWD}/${IN}-aligned.txt.gz --no-head --no-sq "}

CMD="cd ${REFDIR} && ${BINDIR}/bowtie2 -x ${RNA_LIB} ${FILETYPE} -U ${MYWD}/${IN}.${NODE} -S ${MYWD}/${IN}.sam.${NODE} ${SEEDARGS} ${TRIM3p} ${MULTALIGN} ${REPORTARGS} ${CORES} 2>${MYWD}/${IN}.stderr.${NODE} 1>${MYWD}/${IN}.stdout.${NODE}"
if [ -n "$MYTEST" ]; then
  echo "Would run:"
  echo "$CMD"
  echo "This can be modified by exporting following variables:"
  echo "MULTIALIGN, TRIM3p, SEEDARGS, FILETYPE, REPORTARGS"
else
  eval $CMD
fi

if [[ "$?" = "0" ]]; then
   echo "$NODE success $? in ${SECONDS}" >> ${MYWD}/status.txt
else
   echo "$NODE fail $? in ${SECONDS}" >> ${MYWD}/status.txt
fi
end_log

EOF

}

function submit_tophat {
cat <<"EOF" | qsub $QSUB_ARGS

## Body of the script to run bowtie goes here.

source ${LAB}/scripts/dotbashrc
coproc $VMSTAT

echo "Changing directory to: ${MYWD}"
cd ${MYWD}

NODE=${PBS_ARRAYID}
CORES=" -p $(cpus) "
MULTALIGN=${MULTIALIGN-" -k 1 "}
TRIM3p=${TRIM3p-" -3 0 "}
SEEDARGS=${SEEDARGS-" -D 5 -R 1 -N 0 -L 10 -i S,0,2.50 "}
FILETYPE=${FILETYPE-" -f "}
REPORTARGS=${REPORTARGS-"  --un-gz  ${MYWD}/${IN}-unaligned.txt.gz --al-gz ${MYWD}/${IN}-aligned.txt.gz --no-head --no-sq "}

CMD="cd ${REFDIR} && ${BINDIR}/bowtie2 -x ${RNA_LIB} ${FILETYPE} -U ${MYWD}/${IN}.${NODE} -S ${MYWD}/${IN}.sam.${NODE} ${SEEDARGS} ${TRIM3p} ${MULTALIGN} ${REPORTARGS} ${CORES} 2>${MYWD}/${IN}.stderr.${NODE} 1>${MYWD}/${IN}.stdout.${NODE}"
if [ -n "$MYTEST" ]; then
  echo "Would run:"
  echo "$CMD"
  echo "This can be modified by exporting following variables:"
  echo "MULTIALIGN, TRIM3p, SEEDARGS, FILETYPE, REPORTARGS"
else
  eval $CMD
fi

if [[ "$?" = "0" ]]; then
   echo "$NODE success $? in ${SECONDS}" >> ${MYWD}/status.txt
else
   echo "$NODE fail $? in ${SECONDS}" >> ${MYWD}/status.txt
fi

EOF

}


export MYWD=${PWD}
if [ -n $MYTEST ]; then
    echo "Would split files with fastq_count ${IN} | awk '{print \$2}'"
    echo "Artificially setting ENTRIES to 1000"
    ENTRIES=1000
else 
    ENTRIES=$(fastq_count ${IN} | awk '{print $2}')
fi
SEQUENCES_PER_NODE=$(( $ENTRIES / $NODES ))
LINES_PER_NODE=$(( $SEQUENCES_PER_NODE * 4 ))
echo "There are ${ENTRIES} sequences in ${IN}."
echo "Splitting it into ${SEQUENCES_PER_NODE} for ${NODES} computers."
SPLITCMD="split -d -l $LINES_PER_NODE $IN ${IN}."
if [ -n $MYTEST ]; then
    echo "$SPLITCMD"
else
    eval $SPLITCMD 2>split.out 1>&2
fi


RNALIB=$(basename $RNALIB .bt2)
RNALIB=$(basename $RNALIB .1 2>/dev/null)
## Check to see if the bowtie index exists
## Check if my chosen RNA library exists
if [ -r $REFDIR/${RNA_LIB} ]; then
    if [ -n $MYTEST ]; then
	echo "Checking for the existence of $REFDIR/${RNA_LIB}"
    fi
    INDEX_CMD="cd ${REFDIR} && ${BUILD} ${REFDIR}/${RNA_LIB} $RNA_LIB"
  ## Then check to see if the index exists
    if [ -r $REFDIR/${RNA_LIB} ]; then
	echo "The indexes already exist."
    elif [ -n $MYTEST ]; then

	echo "Creating indices with the command:"
	echo "$INDEX_CMD"
    else
	eval $INDEX_CMD
    fi
else
    echo "The RNA starting library does not exist.  Cannot continue."
#    exit
fi

## Set up the bowtie2 commandline.
## This will include a variable 'NODE' which will be PBS_ARRAYID
## I don't yet know if PBS_ARRAYID starts at 0 or 1, if the latter, decrement it by 1...

export ZINDEXED_NODES=$(( $NODES - 1 ))
export PBS_ARGS=${PBS_ARGS-"-V -S ${LAB}/local/bin/bash -q workstation -l walltime=12:00:00 "}
export PBS_LOG=${PBS_LOG-" -j eo -e ibissub00.umiacs.umd.edu:${MYWD}/split_align.out -m n"}
QSUB_ARGS=" -t 0-${ZINDEXED_NODES} $PBS_ARGS $PBS_LOG -"

if [ -n "$MYTEST" ]; then
    echo "The arguments used for qsub are:"
    echo "$QSUB_ARGS"
    echo "Logging is handled with the following arguments:"
    echo "$PBS_LOG"
    echo "These may be changed by exporting PBS_ARGS and PBS_LOGS"
fi

if [ -n "$MYTEST" ]; then
    echo "Creating a status file at ${MYWD}/status.txt"
fi
cat /dev/null > ${MYWD}/status.txt

if [ -n "$MYTEST" ]; then
    echo "Starting the qsub command now."
    echo "It will execute jobs on the compute nodes which only"
    echo "print what would be done."
fi

if [ "$ALIGNER" = "bowtie2" ]; then
    submit_bowtie
elif [ "$ALIGNER" = "tophat" ]; then
    submit_tophat
elif
    [ "$ALIGNER" = "test" ]; then
    submit_test
else
    echo "Received an unknown aligner: $ALIGNER"
    exit 1
fi


SNOOZE=${SNOOZE-60}
ITERATIONS=0
FINISHED=0
echo "Starting ${SNOOZE} second loop to wait for compute nodes to finish."
while [[ $FINISHED < 1 ]]; do
    sleep ${SNOOZE}
    NUM_DONE=0
    ITERATIONS=$(( $ITERATIONS + 1 ))
    for node in $(eval echo "{0..${ZINDEXED_NODES}}"); do
	## The uniq is necessary because I am running multiple attempts at once
	## And they are race conditioning each other.  I should make status.txt into
	## something rational like status_${PBS_JOBID}.txt
	STATE=$(grep "^$node" status.txt | uniq | awk '{print $2}')
	if [ -z "${STATE}" ]; then
	    echo "Waiting on ${node} to complete."
	elif [ "${STATE}" = "success" ]; then
	    echo "$node successfully completed."
	    NUM_DONE=$(( $NUM_DONE + 1 ))
	else
	    echo "$node had an error."
	fi
    done
    echo "Checked $ITERATIONS times for completion."
    echo ""
    
    if [[ "$NUM_DONE" = "${NODES}" ]]; then ## all the compute nodes returned successfully.
	echo "Job done."
	SAMOUT="${IN}.sam"
	touch $SAMOUT
	echo "Merging outputs into ${SAMOUT}."
	for node in $(eval echo "{0..${ZINDEXED_NODES}}"); do
	    if [ "$ALIGNER" = "bowtie2" ]; then
		CMD="cat ${IN}.sam.${node} >> $SAMOUT"
	    elif [ "$ALIGNER" = "tophat" ]; then
		CMD="bamtools ${IN}.bam.${node} >> $SAMOUT"
	    else
		CMD="echo \"I don't know what this command is.\""
	    fi

	    if [ -n "$MYTEST" ]; then
		echo "Merging the output files with:"
		echo "$CMD"
	    else
		eval $CMD
	    fi
	done
	echo "Files merged."
	FINISHED=1
    fi
done
echo "Finished."
