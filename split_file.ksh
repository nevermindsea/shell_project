#!/bin/ksh
# SCRIPT : CSMETL01:/users/gpetlcrm/scripts/routine/cee_lib/split2.ksh
# AUTHOR : Naruchitwate Suksomboonsiri
# DATE : 2016-02-12
# REV : 1.0
# PLATFORM : UNIX, AIX
# PURPOSE: split file by fix no. of line. due to split (std lib) lacking some fn. 
# CHANGE LOG:
# 2016-03-17 add logging fn.
# 2016-03-17 add alphabetic generating fn.
# 2016-05-09 change round up logic implemnted by SED
#====Include ======


#split.ksh  [SIZE_PER_FILE] [FILE_NAME/FQN_FILE_NAME] [EXTENSION] [OPTION{1,2}]
#OPTION=1>NUMERIC_SIGN;OPTION=2>ALPHABETIC_SIGN as aa..zz


###SCRIPT
PATH_SCRIPT="/users/gpetlcrm/scripts/routine/cee_lib" 
PATH_CONFIG="/users/gpetlcrm/scripts"




#===Run Time =====
PROCESS_START=`date`
RUN_TIME=`date +'%Y%m%d_%H%M%S'`;
RUN_TIMEC=`date +'%H%M%S'`;
PRT_DATE=`TZ=GMT-31 date +'%Y%m%d'`

START_CAP_TIME=$(date -u +"%s")
END_CAP_TIME=""
TOTAL_CAP_TIME=""
CUR_DATE=`date '+%Y%m%d'`
EXECUTE_DATE=`date +'%Y-%m-%d %H:%M:%S'`
N_RUN_TIME=`date +'%Y%m%d_%H%M%S'`;
P_RUN_DATE=`date +'%Y%m%d'`;




###LOG
PATH_LOG="${PATH_SCRIPT}/log"
START_CAP_TIME=$(date -u +"%s")




FILE_NAME="SPLIT2"
FILE_LOG_LOC="${PATH_LOG}/${FILE_NAME}_${RUN_TIME}.log"
PATH_OUTPUT="${PATH_SCRIPT}/out"



get_alp_in_series(){
init_i=1
input_l=$1
text=''

for i in {a..z}
do
for j in {a..z}
do
       if [[ $init_i -gt $input_l ]]; then
        break
        else
            if [[ -z ${text} ]]; then
                text=${i}${j}
                else
                text=$text" "${i}${j}
            fi
    fi
init_i=$(($init_i+1))
done
done

echo $text
}

get_a(){
    echo 'AAAA'

}


start_log(){


if [[ !  -e  $PATH_LOG ]]; then
        mkdir -p $PATH_LOG
fi
echo "################################################################################################" 2>&1 | tee -a  ${FILE_LOG_LOC}
echo "${FILE_LOG_LOC}"
echo "********* Start ********* "`date`  >> ${FILE_LOG_LOC}
echo "Process ID : "`echo $$` >> ${FILE_LOG_LOC}
echo "Process Date : ${RUN_TIME}" >> ${FILE_LOG_LOC}
echo "" >> ${FILE_LOG_LOC}
echo "################################################################################################" 2>&1 | tee -a  ${FILE_LOG_LOC}
}

end_log(){
#TO CAP START TIME, END  TIME and PROCESS TIME THEN LOG.

        END_CAP_TIME=`date`
        TOTAL_CAP_TIME=$(($(date -u +"%s")-$START_CAP_TIME))
        echo "################################################################################################" 2>&1 | tee -a  ${FILE_LOG_LOC}
        echo "#Running Time: $(($TOTAL_CAP_TIME / 60)) minutes and $(($TOTAL_CAP_TIME % 60)) seconds elapsed.#" 2>&1 | tee -a  ${FILE_LOG_LOC}
        echo "#START TIME: ${PROCESS_START}                                             #" 2>&1 | tee -a ${FILE_LOG_LOC}
        echo "#END TIME  : ${END_CAP_TIME}                                   #" 2>&1 | tee -a  ${FILE_LOG_LOC}
        echo "################################################################################################" 2>&1 | tee -a  ${FILE_LOG_LOC}
}






#============[MAIN]======================

INPUT_FILE=$1
NUMLINE_PER_FILE=$2
EXTENSION_NAME=$3
LABEL_OPTION=$4


start_log

name_splited_extension=`echo "$INPUT_FILE" | sed "s/$EXTENSION_NAME//g"`

if [[ -z $EXTENSION_NAME  ]]; then
        name_splited_extension=$INPUT_FILE
        echo "EXTENSION_NAME not found, splited file name will be ${INPUT_FILE}  follow by ordering number."
fi
echo $name_splited_extension


l_total_src_file_line=`wc -l ${1}|awk '{print $1}'`
echo "${l_total_src_file_line}"
if [[ -z  $NUMLINE_PER_FILE ]]; then
    echo 'File $INPUT_FILE will be input by default; 2000 LINES PER FILE.'
    NUMLINE_PER_FILE=2000
fi

 
if [[ $l_total_src_file_line -gt $NUMLINE_PER_FILE ]]; then
    l_max_no_file=$((${l_total_src_file_line}./${NUMLINE_PER_FILE}.+0.5))
    r_no_file=`awk -v xx="$l_max_no_file" 'BEGIN { rounded = sprintf("%.0f", xx) ; print rounded }'`
if [[ $l_max_no_file -gt $r_no_file && $(($l_max_no_file%$r_no_file)) -ne 0 ]]; then
    r_no_file=$(($r_no_file+1))
else
    r_no_file=$r_no_file
fi
else
    r_no_file=1
fi

echo ${l_max_no_file}
alp_series=`get_alp_in_series $r_no_file`
echo "$alp_series $r_no_file"



next_min_line=1
next_max_line=$NUMLINE_PER_FILE


echo "${INPUT_FILE} containing  ${l_total_src_file_line} lines  will be splited to  ${r_no_file} files."


echo "LABLE OPTION IS ${LABEL_OPTION}"
case  ${LABEL_OPTION} in
    1) 
for i in  $(seq $r_no_file)
do
sed -n -e ${next_min_line},${next_max_line}p $INPUT_FILE > ${name_splited_extension}_${i}${EXTENSION_NAME}
wc -l  ${name_splited_extension}_${i}${EXTENSION_NAME}
next_min_line=$(($next_min_line+$NUMLINE_PER_FILE))
next_max_line=$(($next_max_line+$NUMLINE_PER_FILE))
done;;

    2)
for i in  $alp_series
do
sed -n -e ${next_min_line},${next_max_line}p $INPUT_FILE > ${name_splited_extension}_${i}${EXTENSION_NAME}
wc -l  ${name_splited_extension}_${i}${EXTENSION_NAME}
next_min_line=$(($next_min_line+$NUMLINE_PER_FILE))
next_max_line=$(($next_max_line+$NUMLINE_PER_FILE))
done;;

    *) echo 'INVALID LABEL TYPE';;

esac
end_log  2>&1 | tee -a  ${FILE_LOG_LOC}
---------------------------------

#!/bin/ksh

alphabet=( {A..Z} )

convertToString(){

    dividend="$1"
    dividend=$((dividend+26))
    if(( $dividend  <= 26)); then
        echo "AA"
        exit 0
    fi
    colName=""
    while(( dividend > 0 ))
    do
        mod=$(( (dividend-1)%26 ))
        colName="${alphabet[$mod]}$colName"
        dividend=$(( (dividend-mod)/26 ))
    done
    echo "$colName"

   
}



convertToString "$1"