#!/bin/ksh
# SCRIPT_NAME:fs_mon_AIX_MBFREE.ksh

#set -x



# DEFINE VAR

MIN_MB_FREE="50MB"

WORK_FILE="/home/admincee/scripts/ksh/tmp/df.work"
>$WORK_FILE
OUT_FILE="/home/admincee/scripts/ksh/tmp/df.outfile"
>$OUT_FILE

THISHOST=`hostname`

EXCEPTIONS="/usr/local/bin/exceptions"
DATA_EXCEPTIONS="/tmp/dfdata.out"


# DEFINE FUNCTION 

function check_exception
{
	while read FSNAME FSLIMIT
	do	
		# Do NFS Sanity check
	done





}
# MAIN
# Get the data by scripting out /dev/cd #
# /proc rows  and keep column 1, 4 and 7
df -k | tail -n +2 | egrep -v '/dev/cd[0-9]| /proc' | awk '{print $1,$4,$6}' >$WORK_FILE

# Format Variable 
(( MIN_MB_FREE=$(echo $MIN_MB_FREE|sed s/MB//g)*1024))


 

while  read FSDEVICE FSMB_FREE FSMOUNT 
do
	FSMB_FREE=$(echo $FSMB_FREE | sed s/MB//g)
	if [[ $FSMB_FREE -lt $MIN_MB_FREE ]]; 	then  
		((FS_FREE_OUT=$FSMB_FREE/1000))
 		echo "$FSDEVICE mount on $FSMOUNT only has ${FS_FREE_OUT}MB Free" >> $OUT_FILE
	fi

done<$WORK_FILE

if [[ -s $OUT_FILE ]]; then 
		echo -e "\nFull FileSystem(s) on  $THISHOST\n" 
		cat $OUT_FILE
		print
		
fi 

