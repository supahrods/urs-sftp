#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 7, 2019
# Version  : 1.4
#
# Description : Classification of file entries according to cases
# Case1 : File entries with missing last aCR 'true,1,false'
# Case2 : File entries with missing initial aCR 'false,2,true'
# Case3 : File entries with missing middle aCR 'true,1,true'
# Case4 : File entries with a one line initial aCR only
# Case5 : File entries with a one line middle aCR only
# Case6 : File entries with a one line last aCR only
# Case7/possible_success: The call identifier of the entry is already present in one of the above/below cases (not counting error case)
# Case8/error_case : File entries where aCR is not part of the defined business cases
# Case9 : File entries with missing initial (false,2,true) and last (true,1,false) aCR
#
#----------------------------------------------------------
# Revision History:
#
# Version: 1.4
# Author: John Rodel Villa
# Date: March 7, 2019
# Description: Updated script to reflect URS phase 2 changes
#
# Version: 1.3
# Author: Joussyd M. Calupig
# Date: February 4, 2019
# Description: Updated path/directories and Headers
#----------------------------------------------------------

# Source configuration file for variables
source /appl/urpadm/job1-2/urs_d_LDC.conf;

# Logging start of LDC segregation process
echo "$(date "+%F %H:%M"): Segregation of LDC files will start..." >> $LOG_DIR/$NAMING_CONVENTION.log;

# Logging no files have been processed if there are no files present in RECEIVE_DIR
if [ $(ls $RECEIVE_DIR | wc -w) == 0 ]; then
	echo "$(date "+%F %H:%M"): No files have been processed!" >> $LOG_DIR/$NAMING_CONVENTION.log
fi;

# Segregation and generate timestamp for long distance calls
for i in $(ls $RECEIVE_DIR/ | grep .*.ftr$); do # Check all files that has the file extension .ftr
	echo "$i $(stat -c %Y $RECEIVE_DIR/$i) $(($(stat -c %Y $RECEIVE_DIR/$i)+$F_LIFETIME)) $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt; # Log file name, current timestamp, aging, and call identifier
	if [ $(head -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "false,2,true" ]; then # Check if aCR of the first entry is false,2,true
		if [ $(cat $RECEIVE_DIR/$i 2> /dev/null | wc -l) == "1" ]; then # Check if file has single entry
			# Block below checks if identifier is already present in other cases, if not then it is a Case4
			if grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE2_DIR; then
				echo "file $i is a possible success for case2" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE5_DIR; then
				echo "file $i is a possible success for case5" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE6_DIR; then
				echo "file $i is a possible success for case6" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE9_DIR; then
                                echo "file $i is a possible success for case9" >> $LOG_DIR/${NAMING_CONVENTION}.log;
                                mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			else
				echo "file $i is case 4 (single scenario)" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $CASE4_DIR;
			fi;
		elif [ $(tail -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "true,1,false" ]; then # Check if last entry of the file is true,1,false
			# Block below checks if identifer is already present in other cases, if not then it is a Case3
			if grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE5_DIR; then
				echo "file $i is a possible success for case5" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE9_DIR; then
                                echo "file $i is a possible success for case9" >> $LOG_DIR/${NAMING_CONVENTION}.log;
                                mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			else
				echo "file $i is case 3 (no middle)" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $CASE3_DIR;
			fi;
		elif [ $(tail -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "true,1,true" ]; then # Check if last entry of the file is a true,1,true
			# Block below checks if identifier is already present in other cases, if not then it is a Case1
			if grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE2_DIR; then
				echo "file $i is a possible success for case2" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE5_DIR; then
				echo "file $i is a possible success for case5" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE6_DIR; then
				echo "file $i is a possible success for case6" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE9_DIR; then
                                echo "file $i is a possible success for case9" >> $LOG_DIR/${NAMING_CONVENTION}.log;
                                mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
			else
				echo "file $i is case 1 (no end)" >> $LOG_DIR/${NAMING_CONVENTION}.log;
				mv $RECEIVE_DIR/$i $CASE1_DIR;
			fi;
		fi;
	elif [ $(head -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "true,1,true" ]; then # Check if aCR of the first entry is true,1,true
		# Block below checks if identifer is already present in other cases, or if contains single entry only, or if it 
		# lacks both initial and last aCR, else it is a Case3
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
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE9_DIR; then
                        echo "file $i is a possible success for case9" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif [ $(cat $RECEIVE_DIR/$i 2> /dev/null | wc -l) == 1 ]; then
			echo "file $i is case 5 (1 liner middle entry)" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $CASE5_DIR;
		elif [ $(tail -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "true,1,true" -a $(cat $RECEIVE_DIR/$i 2> /dev/null | wc -l) != 1 ]; then
			echo "file $i is case 9 (no beginning and end)" >> $LOG_DIR/${NAMING_CONVENTION}.log;
                        mv $RECEIVE_DIR/$i $CASE9_DIR;
		else
			echo "file $i is case 2 (no beginning)" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $CASE2_DIR;
		fi;
	elif [ $(head -n1 $RECEIVE_DIR/$i | cut -f28-30 -d,) == "true,1,false" ]; then # Check if aCR of the first entry is true,1,true
		# Block below checks if identifer is already present in other cases, or if contains single entry only
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
		elif grep -rq $(head -n1 $RECEIVE_DIR/$i | cut -f31 -d,) $CASE9_DIR; then
			echo "file $i is a possible success for case9" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $POSSIBLE_SUCCESS;
		elif [ $(cat $RECEIVE_DIR/$i 2> /dev/null | wc -l) == 1 ]; then
			echo "file $i is case 6 (1 liner last entry)" >> $LOG_DIR/${NAMING_CONVENTION}.log;
			mv $RECEIVE_DIR/$i $CASE6_DIR;
                fi;
	else # Else, the file is not in current business scope so it is an error
		echo "file $i is out of current scope, moving to error handling directory" >> $LOG_DIR/${NAMING_CONVENTION}.log;
		sed -i "/$i/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
		mv $RECEIVE_DIR/$i $FILE_ERROR_DIR;
	fi;
done

# Logging end of LDC segregation process
echo "$(date "+%F %H:%M"): Segregation of LDC files finished" >> $LOG_DIR/$NAMING_CONVENTION.log;

# EOF
