#!/cbcb/lab/nelsayed/local/bin/bash
source /cbcb/lab/nelsayed/scripts/dotbashrc
MYHIST=$HOME/.readline_inputs
history -r $MYHIST
history -a $MYHIST
history -n $MYHIST
echo "Please provide an accepted_hits_sorted.sam file:"
read -e -i ${WD}
#export INPUT=$REPLY
## I think this will remove tailing spaces
#export INPUT={INPUT%%*( )}
export INPUT=${REPLY%%*( )}
history -s ${INPUT}
echo "Please provide a fasta.gff file:"
read -e -i ${REF}
#export ANN=$REPLY
export ANN=${REPLY%%*( )}
history -s ${ANN}
echo "Please provide the output file:"
read -e -i ${WD}
#export OUTPUT=$REPLY
export OUTPUT=${REPLY%%*( )}
history -s ${OUTPUT}

if [ -r "$INPUT" ]; then
    echo "Input: $INPUT is readable."
else
    echo "Input: $INPUT is not readable, check the path."
    exit 1
fi
if [ -r "$ANN" ]; then
    echo "Annotations: $ANN is readable."
else
    echo "Annotations: $ANN is not readable, check the path."
    exit 1
fi
if [ -z "$OUTPUT" ]; then
    echo "No output was provided."
    exit 1
fi

history -w

#echo "HTSEQ options:"
#read -e -i "htseq-count -q --stranded=no -t gene -i ID - "
#export HTSEQ=$REPLY
#export MYHTSEQ=${HTSEQ-"htseq-count -q --stranded=no -t gene -i ID - "}
#export HTSEQCMD="samtools view ${INPUT}  | ${MYHTSEQ} ${ANN} > ${OUTPUT}"


#export PBS_ARGS=${PBS_ARGS-"-V -S ${LAB}/local/bin/bash -q workstation -l walltime=12:00:00 "}
#export PBS_LOG=${PBS_LOG-" -j eo -e ibissub00.umiacs.umd.edu:${WD}/CountTable.out -m n"}

#echo "Please double-check the PBS arguments:"
#read -e -i "${PBS_ARGS}"
#export PBS_ARGS=$REPLY
#echo "And the logging arguments:"
#read -e -i "${PBS_LOG}"
#export PBS_LOG=$REPLY
#QSUB_ARGS=" $PBS_ARGS $PBS_LOG -"
#cat <<"EOF" | qsub $QSUB_ARGS
## If you wish to have changeable qsub arguments, look above.
cat <<"EOF" | qsub -
#!/usr/bin/bash
#PBS -V 
#PBS -S /bin/bash
#PBS -l mem=24GB,walltime=72:00:00
#PBS -q large
#PBS -N Comb_One_144_Count
#PBS -j eo -e ${WD}/ErrorOutput.Count

source ${LAB}/scripts/dotbashrc
start_log ${WD}/CountTable.log

CMD="samtools view ${INPUT}  | htseq-count -q --stranded=no -t gene -i ID - ${ANN} > ${OUTPUT}"
eval $CMD

end_log

EOF
