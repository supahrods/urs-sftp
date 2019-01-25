#----------------------------------------------------------
# Author : John Rodel Villa
# Date : January 23, 2019
# Version : 1.1
#
# Description : Long Duration Call Case Segregation
#
#----------------------------------------------------------
# Revision History:
# Author: Joussyd M. Calupig
# Date: January 25, 2019
# Description: Updated Header
#----------------------------------------------------------

#!/bin/bash
TSTAMP_DIR=/home/urpadm/job1-2/tstamp
RECEIVE_DIR=/MYBSS/ISG/ADHOC/WLN_INC_LD/INPUT #input
WLNFILTER_LANDING=/home/ubuntu/job1-2/wln_ftr_receive #WLN_FILTER
WLNFILTER_SUCCESS=/home/ubuntu/job1-2/wln_ftr_success
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

## Segregation and generate timestamp for long distance calls
for i in $(ls $RECEIVE_DIR/ | grep .*.ftr$); do
	echo "$i $(stat -c %Y $RECEIVE_DIR/$i) $(($(stat -c %Y $RECEIVE_DIR/$i)+$F_LIFETIME)) $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/timestamp1.txt;
	if [ $(head -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "0,2,1" ]; then
		if [ $(cat $RECEIVE_DIR/$i 2> /dev/null | wc -l) == "1" ]; then
			if grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE2_DIR; then
				echo "file $i is a possible success for case2" >> $LOG_DIR/job1.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE5_DIR; then
				echo "file $i is a possible success for case5" >> $LOG_DIR/job1.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE6_DIR; then
				echo "file $i is a possible success for case6" >> $LOG_DIR/job1.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			else
				echo "file $i is case 4 (single scenario)" >> $LOG_DIR/job1.log;
				mv $RECEIVE_DIR/$i $CASE4_DIR;
			fi;
		elif [ $(tail -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "1,1,0" ]; then
			if grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE5_DIR; then
				echo "file $i is a possible success for case5" >> $LOG_DIR/job1.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			else
				echo "file $i is case 3 (no middle)" >> $LOG_DIR/job1.log;
				mv $RECEIVE_DIR/$i $CASE3_DIR;
			fi;
		elif [ $(tail -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "1,1,1" ]; then
			if grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE2_DIR; then
				echo "file $i is a possible success for case2" >> $LOG_DIR/job1.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE5_DIR; then
				echo "file $i is a possible success for case5" >> $LOG_DIR/job1.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE6_DIR; then
				echo "file $i is a possible success for case6" >> $LOG_DIR/job1.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			else
				echo "file $i is case 1 (no end)" >> $LOG_DIR/job1.log;
				mv $RECEIVE_DIR/$i $CASE1_DIR;
			fi;
		fi;
	elif [ $(head -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "1,1,1" ]; then
		if grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE1_DIR; then
			echo "file $i is a possible success for case1" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE2_DIR; then
			echo "file $i is a possible success for case2" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE3_DIR; then
			echo "file $i is a possible success for case3" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE4_DIR; then
			echo "file $i is a possible success for case4" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE5_DIR; then
			echo "file $i is a possible success for case5" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE6_DIR; then
			echo "file $i is a possible success for case6" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif [ $(cat $RECEIVE_DIR/$i 2> /dev/null | wc -l) == 1 ]; then
			echo "file $i is case 5 (1 liner middle entry)" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $CASE5_DIR;
		else
			echo "file $i is case 2 (no beginning)" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $CASE2_DIR;
		fi;
	elif [ $(head -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "1,1,0" ]; then
		if grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE1_DIR; then
			echo "file $i is a possible success for case1" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE2_DIR; then
			echo "file $i is a possible success for case2" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE3_DIR; then
			echo "file $i is a possible success for case3" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE4_DIR; then
			echo "file $i is a possible success for case4" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE5_DIR; then
			echo "file $i is a possible success for case5" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE6_DIR; then
			echo "file $i is a possible success for case6" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif [ $(cat $RECEIVE_DIR/$i 2> /dev/null | wc -l) == 1 ]; then
			echo "file $i is case 6 (1 liner last entry)" >> $LOG_DIR/job1.log;
			mv $RECEIVE_DIR/$i $CASE6_DIR;
                fi;
	fi;
done

## wireline filter timestamp creation
for i in $(ls $WLNFILTER_LANDING/); do
	echo "$i $(stat -c %Y $i) $(($(stat -c %Y $i)+$F_LIFETIME)) $(head -n1 $i | cut -f31 -d,)" >> $TSTAMP_DIR/timestamp_wln_ftr.txt;
	mv $WLNFILTER_LANDING/$i $WLNFILTER_SUCCESS;
done

