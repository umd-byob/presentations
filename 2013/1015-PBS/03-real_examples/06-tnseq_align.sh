#!/bin/env bash
. /cbcb/lab/nelsayed/scripts/dotbashrc
. ~abelew/.bash_aliases

export BASELIB_DIR=~abelew/project_scratch/libraries
export MYWD=$(pwd)

function Submit_Bowtie1 {
    export QUERY=$1
    export LIB=$2
    export OUTDIR=$3

    export INNAME=$(basename $QUERY .fasta.gz)
    ## Note that I am setting default alignment parameters to a single match which is _not_ randomly placed
    ## and no mismatches
    export BT_ARGS=${BTARGS-" -m 1 -k 1 -n 0 "}
    export SAMFILE="${INNAME}.sam"
    export OPTIONS="$BT_ARGS -f -S ${OUTDIR}/${SAMFILE}"

    export BT_LIB="$BASELIB_DIR/$LIB/$LIB"
    if [ ! -e "${BT_LIB}.1.ebwt" ]; then
	echo "The reference library: $BASELIB_DIR/$LIB/$LIB does not exist."
	return 1
    fi
    export BT_CMD="bowtie $OPTIONS $BT_LIB -1 $QUERY"
    export MYTEST=1

    if [ "$MYTEST" = "1" ]; then
	echo "Would run $BT_CMD"
    else
    cat <<"EOF" | qsub $QSUB_ARGS
## Body of the script to run bowtie goes here.
source ${LAB}/scripts/dotbashrc
echo "Changing directory to: ${MYWD}"
cd ${MYWD}

CORES=" -p $(cpus) "

CMD="bowtie

cd ${REFDIR} && ${BINDIR}/bowtie2 -x ${RNA_LIB} ${FILETYPE} -U ${MYWD}/${IN}.${NODE} -S ${MYWD}/${IN}.sam.${NODE} ${SEEDARGS} ${TRIM3p} ${MULTALIGN} ${REPORTARGS} ${CORES} 2>${MYWD}/${IN}.stderr.${NODE} 1>${MYWD}/${IN}.stdout.${NODE}"
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

fi

}

for lib in $(/bin/ls *.fasta.gz); do
    for condition in random1_nomismatch random1_1mismatch unique_nomismatch unique_1mismatch; do
	Submit_Bowtie1 $lib gas "$MYWD/$condition"
    done
done
