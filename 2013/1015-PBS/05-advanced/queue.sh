#!/bin/bash
. ~/.bashrc
cd $PRFDB_HOME
./prf_daemon --make_jobs
QSTAT=/usr/local/torque/bin/qstat
USERID=`id | awk -F'(' '{print $2}' | awk -F ')' '{print $1}'`
PARTIAL=`grep pbs_partialname prfdb.conf | awk -F= '{print $2}' | sed 's/'\''//g'`
DAEMONS=`grep pbs_num_daemons prfdb.conf | awk -F= '{print $2}'`
for arch in lin
  do
for num in $(eval echo {01..`echo -n $DAEMONS`})
    do
    num=`echo $num | awk '{printf "%02d", $num}'`
    EXIST=`$QSTAT | grep $USERID | grep $PARTIAL | awk '{print $2}' | grep $arch | awk -F'_' '{print $3}' | grep $num`
    if [ "$EXIST" = "" ]; then
	if [ $arch = "lin" ]; then
          /usr/local/bin/qsub -j eo -e outputs/qsub.err -m n jobs/linux/$num 2>/dev/null 1>&2 
        elif [ $arch = "aix" ]; then
          /usr/local/bin/qsub -j eo -e outputs/qsub.err -m n jobs/aix/$num 2>/dev/null 1>&2 
        elif [ $arch = "iri" ]; then
          /usr/local/bin/qsub -j eo -e outputs/qsub.err -m n jobs/irix/$num 2>/dev/null 1>&2
        fi
     fi 
     done
  done
at "now + 4 hours" < queue.sh 2>/dev/null 1>&2
