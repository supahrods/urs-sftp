#!/bin/bash
TSTAMP_DIR=/home/urpadm/job1-2/tstamp
RECEIVE_DIR=/MYBSS/ISG/ADHOC/WLN_INC_LD/INPUT
WLNFILTER_DIR=/MYBSS/ISG/DAILY/WLN_FILTER
WLNFILTER_ARCHIVE_DIR=/MYBSS/ISG/ADHOC/WLN_INC_LD/ARCHIVE
FILE_ERROR_DIR=/home/urpadm/job1-2/file_error_handling
CASE1_DIR=/home/urpadm/job1-2/cases/case1
CASE2_DIR=/home/urpadm/job1-2/cases/case2
CASE3_DIR=/home/urpadm/job1-2/cases/case3
CASE4_DIR=/home/urpadm/job1-2/cases/case4
CASE5_DIR=/home/urpadm/job1-2/cases/case5
CASE6_DIR=/home/urpadm/job1-2/cases/case6
LOG_DIR=/tmp/urs_logs
POSSIBLE_SUCCESS=/home/urpadm/job1-2/possible_success
SUCCESS_DIR=/MYBSS/ISG/ADHOC/WLN_INC_LD/OUTPUT
F_LIFETIME=604800
NAMING_CONVENTION=urs_d_LongDurationCalls_$(date +%F)

## Segregation and generate timestamp for long distance calls
for i in $(ls $RECEIVE_DIR/ | grep .*.ftr$); do
	echo "$i $(stat -c %Y $RECEIVE_DIR/$i) $(($(stat -c %Y $RECEIVE_DIR/$i)+$F_LIFETIME)) $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
	if [ $(head -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "false,2,true" ]; then
		if [ $(cat $RECEIVE_DIR/$i 2> /dev/null | wc -l) == "1" ]; then
			if grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE2_DIR; then
				echo "file $i is a possible success for case2" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE5_DIR; then
				echo "file $i is a possible success for case5" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE6_DIR; then
				echo "file $i is a possible success for case6" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			else
				echo "file $i is case 4 (single scenario)" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $CASE4_DIR;
			fi;
		elif [ $(tail -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "true,1,false" ]; then
			if grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE5_DIR; then
				echo "file $i is a possible success for case5" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			else
				echo "file $i is case 3 (no middle)" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $CASE3_DIR;
			fi;
		elif [ $(tail -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "true,1,true" ]; then
			if grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE2_DIR; then
				echo "file $i is a possible success for case2" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE5_DIR; then
				echo "file $i is a possible success for case5" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE6_DIR; then
				echo "file $i is a possible success for case6" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			else
				echo "file $i is case 1 (no end)" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $CASE1_DIR;
			fi;
		fi;
	elif [ $(head -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "true,1,true" ]; then
		if grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE1_DIR; then
			echo "file $i is a possible success for case1" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE2_DIR; then
			echo "file $i is a possible success for case2" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE3_DIR; then
			echo "file $i is a possible success for case3" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE4_DIR; then
			echo "file $i is a possible success for case4" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE5_DIR; then
			echo "file $i is a possible success for case5" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE6_DIR; then
			echo "file $i is a possible success for case6" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif [ $(cat $RECEIVE_DIR/$i 2> /dev/null | wc -l) == 1 ]; then
			echo "file $i is case 5 (1 liner middle entry)" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $CASE5_DIR;
		else
			echo "file $i is case 2 (no beginning)" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $CASE2_DIR;
		fi;
	elif [ $(head -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "true,1,false" ]; then
		if grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE1_DIR; then
			echo "file $i is a possible success for case1" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE2_DIR; then
			echo "file $i is a possible success for case2" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE3_DIR; then
			echo "file $i is a possible success for case3" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE4_DIR; then
			echo "file $i is a possible success for case4" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE5_DIR; then
			echo "file $i is a possible success for case5" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE6_DIR; then
			echo "file $i is a possible success for case6" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif [ $(cat $RECEIVE_DIR/$i 2> /dev/null | wc -l) == 1 ]; then
			echo "file $i is case 6 (1 liner last entry)" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $CASE6_DIR;
                fi;
	else
		echo "file $i is out of current scope, moving to error handling directory" >> $LOG_DIR/${NAMING_CONVENTION}.log;
		echo "$i $(stat -c %Y $RECEIVE_DIR/$i) $(($(stat -c %Y $RECEIVE_DIR/$i)+$F_LIFETIME)) $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_ErrorFile_Handling_tstamp.txt;
		sed -i "/$i/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
		mv $RECEIVE_DIR/$i $FILE_ERROR_DIR;
	fi;
done

## wireline filter timestamp creation
for i in $(ls $WLNFILTER_DIR/); do
	touch $TSTAMP_DIR/urs_d_WireLine_Ftr_Report_tstamp.txt;
	if ! grep -q $i $TSTAMP_DIR/urs_d_WireLine_Ftr_Report_tstamp.txt; then
		echo "$i $(stat -c %Y $WLNFILTER_DIR/$i) $(($(stat -c %Y $WLNFILTER_DIR/$i)+$F_LIFETIME)) $(head -n1 $WLNFILTER_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_WireLine_Ftr_Report_tstamp.txt;
	fi;
done

## wireline archive timestamp creation
for i in $(ls $WLNFILTER_ARCHIVE_DIR/); do
        touch $TSTAMP_DIR/urs_d_WireLine_Ftr_Archive_tstamp.txt;
        if ! grep -q $i $TSTAMP_DIR/urs_d_WireLine_Ftr_Archive_tstamp.txt; then
                echo "$i $(stat -c %Y $WLNFILTER_ARCHIVE_DIR/$i) $(($(stat -c %Y $WLNFILTER_ARCHIVE_DIR/$i)+$F_LIFETIME)) $(head -n1 $WLNFILTER_ARCHIVE_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_WireLine_Ftr_Archive_tstamp.txt;
        fi;
done
