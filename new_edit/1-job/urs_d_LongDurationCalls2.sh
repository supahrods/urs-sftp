#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 7, 2019
# Version  : 1.4
#
# Description : Processing of file entries according to cases
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
# Version: 1.5
# Author: John Rodel Villa
# Date: April 26, 2019
# Description: Change wording of logs during merging process
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
source /appl/urpadm/conf/urs_d_LDC.conf;

# Logging start of LDC processing
echo "$(date "+%F %H:%M"): Processing of LDC files will start..." >> $LOG_DIR/$NAMING_CONVENTION2.log;

# Process Case1 (File entries with missing last aCR 'true,1,false')
echo "$(date "+%F %H:%M"): Case1 processing has started..." >> $LOG_DIR/$NAMING_CONVENTION2.log; # Logging for processing of Case1 files
for i in $(ls $CASE1_DIR/ | grep .*.ftr$); do # Check each file in CASE1_DIR that has a file extension of .ftr
	touch -m $CASE1_DIR/$i; # Update file timestamp
	CALL_IDENTIFIER=$(head -n1 $CASE1_DIR/$i 2> /dev/null | cut -f31 -d,); # Save the call identifier in a variable
	if [ $(stat -c %Y $CASE1_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then # Check if file has reached aging time
		# If aging is not yet reached, the block below will check if call has complete file entries and move every file to the SUCCESS_DIR
		if grep -qr $CALL_IDENTIFIER $POSSIBLE_SUCCESS; then
			if grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f28-30 -d, | grep -q "true,1,false"; then
				for a in $(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
                                        mv $a $SUCCESS_DIR;
				done;
				sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
				mv $CASE1_DIR/$i $SUCCESS_DIR;
			fi;
		fi;
	elif [ $(stat -c %Y $CASE1_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then # Check if file has reached aging time
		# If aging has been reached, the block below will try to consolidated entries for the same identifier, sort them, 
		# and do the editing for Case1. Move the edited file to SUCCESS_DIR
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS $CASE1_DIR | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs cat 2> /dev/null | awk NF >> $CASE1_DIR/placeholder_$CALL_IDENTIFIER;
		sort -t, -k25 -V $CASE1_DIR/placeholder_$CALL_IDENTIFIER > $CASE1_DIR/$i;
		rm $CASE1_DIR/placeholder_$CALL_IDENTIFIER 2> /dev/null;
		sed -i "$ s/true,1,true,$(tail -n1 $CASE1_DIR/$i | cut -f31 -d,)/true,1,false,$(tail -n1 $CASE1_DIR/$i | cut -f31 -d,)/" $CASE1_DIR/$i;
		for a in $(nl $CASE1_DIR/$i | cut -c6); do
                        sed -i "$a s/$(sed -n ${a}p $CASE1_DIR/$i | cut -f25-31 -d,)/$a,$(sed -n ${a}p $CASE1_DIR/$i | cut -f26-31 -d,)/" $CASE1_DIR/$i;
		done;
		sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
		mv $CASE1_DIR/$i $SUCCESS_DIR;
		echo "-------------------------------------------------------------------------------" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
		echo "The following files' contents have been merged to $SUCCESS_DIR/$i" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs echo >> $LOG_DIR/${NAMING_CONVENTION2}.log;
		echo "Total number of records: $(cat $SUCCESS_DIR/$i 2> /dev/null | wc -l)" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
		echo "$(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | wc -l) file/s merged to $SUCCESS_DIR/$i" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
		echo "-------------------------------------------------------------------------------" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs -I {} mv {} $MERGE_DIR 2> /dev/null;
	fi;
done;
echo "$(date "+%F %H:%M"): Case1 processing has finished" >> $LOG_DIR/$NAMING_CONVENTION2.log; # Logging for processing of Case1 files

# Process Case2 (File entries with missing initial aCR 'false,2,true')
echo "$(date "+%F %H:%M"): Case2 processing has started..." >> $LOG_DIR/$NAMING_CONVENTION2.log; # Logging for processing of Case2 files
for i in $(ls $CASE2_DIR/ | grep .*.ftr$); do # Check each file in CASE2_DIR that has a file extension of .ftr
        touch -m $CASE2_DIR/$i; # Update file timestamp
	CALL_IDENTIFIER=$(head -n1 $CASE2_DIR/$i 2> /dev/null | cut -f31 -d,); # Save the call identifier in a variable
        if [ $(stat -c %Y $CASE2_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then # Check if file has reached aging time
                # If aging is not yet reached, the block below will check if call has complete file entries and move every file to the SUCCESS_DIR
                if grep -qr $CALL_IDENTIFIER $POSSIBLE_SUCCESS; then
                        if grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f28-30 -d, | grep -q "false,2,true"; then
                                for a in $(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
                                        mv $a $SUCCESS_DIR;
                                done;
                                sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                                mv $CASE2_DIR/$i $SUCCESS_DIR;
                        fi;
                fi;
        elif [ $(stat -c %Y $CASE2_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then # Check if file has reached aging time
		# If aging has been reached, the block below will try to consolidated entries for the same identifier, sort them, 
		# and do the editing for Case2. Move the edited file to SUCCESS_DIR
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS $CASE2_DIR | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs cat 2> /dev/null | awk NF >> $CASE2_DIR/placeholder_$CALL_IDENTIFIER;
		sort -t, -k25 -V $CASE2_DIR/placeholder_$CALL_IDENTIFIER > $CASE2_DIR/$i;
		rm $CASE2_DIR/placeholder_$CALL_IDENTIFIER 2> /dev/null;
                sed -i "1 s/true,1,true,$(head -n1 $CASE2_DIR/$i | cut -f31 -d,)/false,2,true,$(head -n1 $CASE2_DIR/$i | cut -f31 -d,)/" $CASE2_DIR/$i;
                for a in $(nl $CASE2_DIR/$i | cut -c6); do
                        sed -i "$a s/$(sed -n ${a}p $CASE2_DIR/$i | cut -f25-31 -d,)/$a,$(sed -n ${a}p $CASE2_DIR/$i | cut -f26-31 -d,)/" $CASE2_DIR/$i;
                done
                sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                mv $CASE2_DIR/$i $SUCCESS_DIR;
		echo "-------------------------------------------------------------------------------" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "The following files' contents have been merged to $SUCCESS_DIR/$i" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs echo >> $LOG_DIR/${NAMING_CONVENTION2}.log;
		echo "Total number of records: $(cat $SUCCESS_DIR/$i 2> /dev/null | wc -l)" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "$(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | wc -l) file/s merged to $SUCCESS_DIR/$i" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "-------------------------------------------------------------------------------" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs -I {} mv {} $MERGE_DIR 2> /dev/null;
        fi;
done;
echo "$(date "+%F %H:%M"): Case2 processing has finished" >> $LOG_DIR/$NAMING_CONVENTION2.log; # Logging for processing of Case2 files

# Process Case3 (File entries with missing middle aCR 'true,1,true')
echo "$(date "+%F %H:%M"): Case3 processing has started..." >> $LOG_DIR/$NAMING_CONVENTION2.log; # Logging for processing of Case3 files
for i in $(ls $CASE3_DIR/ | grep .*.ftr$); do # Check each file in CASE3_DIR that has a file extension of .ftr
        touch -m $CASE3_DIR/$i; # Update file timestamp
	CALL_IDENTIFIER=$(head -n1 $CASE3_DIR/$i 2> /dev/null | cut -f31 -d,); # Save the call identifier in a variable
        M_NUM=$(head -n1 $CASE3_DIR/$i | cut -f25 -d,); # Save the first sequence number of the call
        L_NUM=$(tail -n1 $CASE3_DIR/$i | cut -f25 -d,); # Save the last sequence number of the call
        BETWEEN_SEQUENCE=$(eval "t=({$(($M_NUM+1))..$(($L_NUM-1))})"; echo ${t[*]}); # The supposed entries in between the first and last entries
        if [ $(stat -c %Y $CASE3_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then # Check if file has reached aging time
                # If aging is not yet reached, the block below will check if call has complete file entries and move every file to the SUCCESS_DIR
                if grep -qr $CALL_IDENTIFIER $POSSIBLE_SUCCESS; then
			grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS $CASE3_DIR | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs cat 2> /dev/null | awk NF | sort -t, -k25 -V >> $BETWEEN_DIR/urs_d_LongDurationCalls_placeholder_$CALL_IDENTIFIER;
			sed -i '1 d' $BETWEEN_DIR/urs_d_LongDurationCalls_placeholder_$CALL_IDENTIFIER;
			sed -i '$ d' $BETWEEN_DIR/urs_d_LongDurationCalls_placeholder_$CALL_IDENTIFIER;
                        for a in $BETWEEN_SEQUENCE; do
                                if cat $BETWEEN_DIR/urs_d_LongDurationCalls_placeholder_$CALL_IDENTIFIER | cut -f25 -d, | grep -q $a; then
                                        CHECK_COUNTER=$(($CHECK_COUNTER+1));
                                fi;
			done;
                        rm $BETWEEN_DIR/urs_d_LongDurationCalls_placeholder_$CALL_IDENTIFIER 2> /dev/null;
			if [ $CHECK_COUNTER == $(echo $BETWEEN_SEQUENCE | tr " " "\n" | wc -l) ]; then
				for b in $(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
					mv $b $SUCCESS_DIR;
				done;
				sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
				mv $CASE3_DIR/$i $SUCCESS_DIR;
			fi;
			CHECK_COUNTER=0;
                fi;
        elif [ $(stat -c %Y $CASE3_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then # Check if file has reached aging time
		# If aging has been reached, the block below will try to consolidated entries for the same identifier, sort them, 
		# and do the editing for Case3. Move the edited file to SUCCESS_DIR
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS $CASE3_DIR | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs cat 2> /dev/null | awk NF >> $CASE3_DIR/placeholder_$CALL_IDENTIFIER;
		sort -t, -k25 -V $CASE3_DIR/placeholder_$CALL_IDENTIFIER > $CASE3_DIR/$i;
		rm $CASE3_DIR/placeholder_$CALL_IDENTIFIER 2> /dev/null;
		for a in $(nl $CASE3_DIR/$i | cut -c6); do
			sed -i "$a s/$(sed -n ${a}p $CASE3_DIR/$i | cut -f25-31 -d,)/$a,$(sed -n ${a}p $CASE3_DIR/$i | cut -f26-31 -d,)/" $CASE3_DIR/$i;
		done
                sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                mv $CASE3_DIR/$i $SUCCESS_DIR;
		echo "-------------------------------------------------------------------------------" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "The following files' contents have been merged to $SUCCESS_DIR/$i" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs echo >> $LOG_DIR/${NAMING_CONVENTION2}.log;
		echo "Total number of records: $(cat $SUCCESS_DIR/$i 2> /dev/null | wc -l)" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "$(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | wc -l) file/s merged to $SUCCESS_DIR/$i" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "-------------------------------------------------------------------------------" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs -I {} mv {} $MERGE_DIR 2> /dev/null;
        fi;
done;
echo "$(date "+%F %H:%M"): Case3 processing has finished" >> $LOG_DIR/$NAMING_CONVENTION2.log; # Logging for processing of Case3 files

# Process Case4 (File entries with a one line initial aCR only)
echo "$(date "+%F %H:%M"): Case4 processing has started..." >> $LOG_DIR/$NAMING_CONVENTION2.log; # Logging for processing of Case4 files
for i in $(ls $CASE4_DIR/ | grep .*.ftr$); do # Check each file in CASE4_DIR that has a file extension of .ftr
        touch -m $CASE4_DIR/$i; # Update file timestamp
	CALL_IDENTIFIER=$(head -n1 $CASE4_DIR/$i 2> /dev/null | cut -f31 -d,); # Save the call identifier in a variable
        if [ $(stat -c %Y $CASE4_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then # Check if file has reached aging time
                # If aging is not yet reached, the block below will check if call has complete file entries and move every file to the SUCCESS_DIR
                if grep -qr $(head -n1 $CASE4_DIR/$i | cut -f31 -d,) $POSSIBLE_SUCCESS; then
                        if grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f28-30 -d, | grep -q "true,1,false"; then
                                for a in $(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
                                        mv $a $SUCCESS_DIR;
                                done;
                                sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                                mv $CASE4_DIR/$i $SUCCESS_DIR;
                        fi;
                fi;
        elif [ $(stat -c %Y $CASE4_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then # Check if file has reached aging time
		# If aging has been reached, the block below will try to consolidated entries for the same identifier, sort them,
		# and do the editing for Case4. Move the edited file to SUCCESS_DIR
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS $CASE4_DIR | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs cat 2> /dev/null | awk NF >> $CASE4_DIR/placeholder_$CALL_IDENTIFIER;
		sort -t, -k25 -V $CASE4_DIR/placeholder_$CALL_IDENTIFIER > $CASE4_DIR/$i;
		rm $CASE4_DIR/placeholder_$CALL_IDENTIFIER 2> /dev/null;
		if [ $(cat $CASE4_DIR/$i 2> /dev/null | wc -l) == 1 ]; then
	                sed -i "$ s/false,2,true,$(tail -n1 $CASE4_DIR/$i | cut -f31 -d,)/false,0,false,$(tail -n1 $CASE4_DIR/$i | cut -f31 -d,)/" $CASE4_DIR/$i;
			sed -i "$ s/$(tail -n1 $CASE4_DIR/$i | cut -f25-31 -d,)/,$(tail -n1 $CASE4_DIR/$i | cut -f26-31 -d,)/" $CASE4_DIR/$i;
        	        sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
			mv $CASE4_DIR/$i $SUCCESS_DIR;
		else
			sed -i "$ s/true,1,true,$(tail -n1 $CASE4_DIR/$i | cut -f31 -d,)/true,1,false,$(tail -n1 $CASE4_DIR/$i | cut -f31 -d,)/" $CASE4_DIR/$i;
			for a in $(nl $CASE4_DIR/$i | cut -c6); do
				sed -i "$a s/$(sed -n ${a}p $CASE4_DIR/$i | cut -f25-31 -d,)/$a,$(sed -n ${a}p $CASE4_DIR/$i | cut -f26-31 -d,)/" $CASE4_DIR/$i;
			done;
			sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
			mv $CASE4_DIR/$i $SUCCESS_DIR;
		fi;
		echo "-------------------------------------------------------------------------------" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "The following files' contents have been merged to $SUCCESS_DIR/$i" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs echo >> $LOG_DIR/${NAMING_CONVENTION2}.log;
		echo "Total number of records: $(cat $SUCCESS_DIR/$i 2> /dev/null | wc -l)" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "$(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | wc -l) file/s merged to $SUCCESS_DIR/$i" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "-------------------------------------------------------------------------------" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs -I {} mv {} $MERGE_DIR 2> /dev/null;
        fi;
done;
echo "$(date "+%F %H:%M"): Case4 processing has finished" >> $LOG_DIR/$NAMING_CONVENTION2.log; # Logging for processing of Case4 files

# Process Case5 (File entries with a one line middle aCR only)
echo "$(date "+%F %H:%M"): Case5 processing has started..." >> $LOG_DIR/$NAMING_CONVENTION2.log; # Logging for processing of Case5 files
for i in $(ls $CASE5_DIR/ | grep .*.ftr$); do # Check each file in CASE5_DIR that has a file extension of .ftr
        touch -m $CASE5_DIR/$i; # Update file timestamp
	CALL_IDENTIFIER=$(head -n1 $CASE5_DIR/$i 2> /dev/null | cut -f31 -d,); # Save the call identifier in a variable
        if [ $(stat -c %Y $CASE5_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then # Check if file has reached aging time
                # If aging is not yet reached, the block below will check if call has complete file entries and move every file to the SUCCESS_DIR
                if grep -qr $CALL_IDENTIFIER $POSSIBLE_SUCCESS; then
                        if grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f28-30 -d, | grep -q "true,1,false"; then
				if grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f28-30 -d, | grep -q "false,2,true"; then
                                	for a in $(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
                                        	mv $a $SUCCESS_DIR;
                                	done;
                                	sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                                	mv $CASE5_DIR/$i $SUCCESS_DIR;
                        	fi;
			fi;
                fi;
        elif [ $(stat -c %Y $CASE5_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then # Check if file has reached aging time
		# If aging has been reached, the block below will try to consolidated entries for the same identifier, sort them,
		# and do the editing for Case5. Move the edited file to SUCCESS_DIR
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS $CASE5_DIR | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs cat 2> /dev/null | awk NF >> $CASE5_DIR/placeholder_$CALL_IDENTIFIER;
		sort -t, -k25 -V $CASE5_DIR/placeholder_$CALL_IDENTIFIER > $CASE5_DIR/$i;
		rm $CASE5_DIR/placeholder_$CALL_IDENTIFIER 2> /dev/null;
		if [ $(cat $CASE5_DIR/$i 2> /dev/null | wc -l) == 1 ]; then
                	sed -i "$ s/true,1,true,$(tail -n1 $CASE5_DIR/$i | cut -f31 -d,)/false,0,false,$(tail -n1 $CASE5_DIR/$i | cut -f31 -d,)/" $CASE5_DIR/$i;
                        sed -i "$ s/$(tail -n1 $CASE5_DIR/$i | cut -f25-31 -d,)/,$(tail -n1 $CASE5_DIR/$i | cut -f26-31 -d,)/" $CASE5_DIR/$i;
                	sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                	mv $CASE5_DIR/$i $SUCCESS_DIR;
		else
			sed -i "1 s/true,1,true,$(head -n1 $CASE5_DIR/$i | cut -f31 -d,)/false,2,true,$(head -n1 $CASE5_DIR/$i | cut -f31 -d,)/" $CASE5_DIR/$i;
			for a in $(nl $CASE5_DIR/$i | cut -c6); do
				sed -i "$a s/$(sed -n ${a}p $CASE5_DIR/$i | cut -f25-31 -d,)/$a,$(sed -n ${a}p $CASE5_DIR/$i | cut -f26-31 -d,)/" $CASE5_DIR/$i;
			done
			sed -i "$ s/true,1,true,$(head -n1 $CASE5_DIR/$i | cut -f31 -d,)/true,1,false,$(head -n1 $CASE5_DIR/$i | cut -f31 -d,)/" $CASE5_DIR/$i;
			sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
			mv $CASE5_DIR/$i $SUCCESS_DIR;
		fi;
		echo "-------------------------------------------------------------------------------" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "The following files' contents have been merged to $SUCCESS_DIR/$i" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs echo >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "Total number of records: $(cat $SUCCESS_DIR/$i 2> /dev/null | wc -l)" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "$(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | wc -l) file/s merged to $SUCCESS_DIR/$i" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "-------------------------------------------------------------------------------" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs -I {} mv {} $MERGE_DIR 2> /dev/null;
        fi;
done;
echo "$(date "+%F %H:%M"): Case5 processing has finished" >> $LOG_DIR/$NAMING_CONVENTION2.log; # Logging for processing of Case5 files

# Process Case6 (File entries with a one line last aCR only)
echo "$(date "+%F %H:%M"): Case6 processing has started..." >> $LOG_DIR/$NAMING_CONVENTION2.log; # Logging for processing of Case6 files
for i in $(ls $CASE6_DIR/ | grep .*.ftr$); do # Check each file in CASE6_DIR that has a file extension of .ftr
        touch -m $CASE6_DIR/$i; # Update file timestamp
	CALL_IDENTIFIER=$(head -n1 $CASE6_DIR/$i 2> /dev/null | cut -f31 -d,); # Save the call identifier in a variable
        if [ $(stat -c %Y $CASE6_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then # Check if file has reached aging time
                # If aging is not yet reached, the block below will check if call has complete file entries and move every file to the SUCCESS_DIR
                if grep -qr $CALL_IDENTIFIER $POSSIBLE_SUCCESS; then
                        if grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f28-30 -d, | grep -q "false,2,true"; then
                                for a in $(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
                                        mv $a $SUCCESS_DIR;
                                done;
                                sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                                mv $CASE6_DIR/$i $SUCCESS_DIR;
                        fi;
                fi;
        elif [ $(stat -c %Y $CASE6_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then # Check if file has reached aging time
		# If aging has been reached, the block below will try to consolidated entries for the same identifier, sort them, 
		# and do the editing for Case6. Move the edited file to SUCCESS_DIR
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS $CASE6_DIR | cut -f1 -d: | xargs readlink -f 2> /dev/null | xargs cat 2> /dev/null | awk NF >> $CASE6_DIR/placeholder_$CALL_IDENTIFIER;
		sort -t, -k25 -V $CASE6_DIR/placeholder_$CALL_IDENTIFIER > $CASE6_DIR/$i;
		rm $CASE6_DIR/placeholder_$CALL_IDENTIFIER 2> /dev/null;
		if [ $(cat $CASE6_DIR/$i 2> /dev/null | wc -l) == 1 ]; then
                	sed -i "$ s/true,1,false,$(tail -n1 $CASE6_DIR/$i | cut -f31 -d,)/false,0,false,$(tail -n1 $CASE6_DIR/$i | cut -f31 -d,)/" $CASE6_DIR/$i;
                        sed -i "$ s/$(tail -n1 $CASE6_DIR/$i | cut -f25-31 -d,)/,$(tail -n1 $CASE6_DIR/$i | cut -f26-31 -d,)/" $CASE6_DIR/$i;
                	sed -i "/$(head -n1 $CASE6_DIR/$i | cut -f31 -d,)/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                	mv $CASE6_DIR/$i $SUCCESS_DIR;
		else
			sed -i "1 s/true,1,true,$CALL_IDENTIFIER/false,2,true,$CALL_IDENTIFIER/" $CASE6_DIR/$i;
			for a in $(nl $CASE6_DIR/$i | cut -c6); do
				sed -i "$a s/$(sed -n ${a}p $CASE6_DIR/$i | cut -f25-31 -d,)/$a,$(sed -n ${a}p $CASE6_DIR/$i | cut -f26-31 -d,)/" $CASE6_DIR/$i;
			done
			sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
			mv $CASE6_DIR/$i $SUCCESS_DIR;
		fi;
		echo "-------------------------------------------------------------------------------" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "The following files' contents have been merged to $SUCCESS_DIR/$i" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs echo >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "Total number of records: $(cat $SUCCESS_DIR/$i 2> /dev/null | wc -l)" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "$(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | wc -l) file/s merged to $SUCCESS_DIR/$i" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "-------------------------------------------------------------------------------" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs -I {} mv {} $MERGE_DIR 2> /dev/null;
        fi;
done;
echo "$(date "+%F %H:%M"): Case6 processing has finished" >> $LOG_DIR/$NAMING_CONVENTION2.log; # Logging for processing of Case6 files

# Process Case9 (File entries with missing initial (false,2,true) and last (true,1,false) aCR)
echo "$(date "+%F %H:%M"): Case9 processing has started..." >> $LOG_DIR/$NAMING_CONVENTION2.log; # Logging for processing of Case9 files
for i in $(ls $CASE9_DIR/ | grep .*.ftr$); do # Check each file in CASE9_DIR that has a file extension of .ftr
        touch -m $CASE9_DIR/$i; # Update file timestamp
        CALL_IDENTIFIER=$(head -n1 $CASE9_DIR/$i 2> /dev/null | cut -f31 -d,); # Save the call identifier in a variable
	if [ $(stat -c %Y $CASE9_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then # Check if file has reached aging time
                # If aging is not yet reached, the block below will check if call has complete file entries and move every file to the SUCCESS_DIR
                if grep -qr $CALL_IDENTIFIER $POSSIBLE_SUCCESS; then
                        if grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f28-30 -d, | grep -q "true,1,false"; then
                                if grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f28-30 -d, | grep -q "false,2,true"; then
                                        for a in $(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
                                                mv $a $SUCCESS_DIR;
                                        done;
                                        sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                                        mv $CASE9_DIR/$i $SUCCESS_DIR;
                                fi;
                        fi;
                fi;
	elif [ $(stat -c %Y $CASE9_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then 
		# If aging has been reached, the block below will try to consolidated entries for the same identifier, sort them,
                # and do the editing for Case9. Move the edited file to SUCCESS_DIR
                grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS $CASE9_DIR | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs cat 2> /dev/null | awk NF >> $CASE9_DIR/placeholder_$CALL_IDENTIFIER;
                sort -t, -k25 -V $CASE9_DIR/placeholder_$CALL_IDENTIFIER > $CASE9_DIR/$i;
                rm $CASE9_DIR/placeholder_$CALL_IDENTIFIER 2> /dev/null;
                sed -i "1 s/true,1,true,$(head -n1 $CASE9_DIR/$i | cut -f31 -d,)/false,2,true,$(head -n1 $CASE9_DIR/$i | cut -f31 -d,)/" $CASE9_DIR/$i;
                for a in $(nl $CASE9_DIR/$i | cut -c6); do
                        sed -i "$a s/$(sed -n ${a}p $CASE9_DIR/$i | cut -f25-31 -d,)/$a,$(sed -n ${a}p $CASE9_DIR/$i | cut -f26-31 -d,)/" $CASE9_DIR/$i;
                done
                sed -i "$ s/true,1,true,$(head -n1 $CASE9_DIR/$i | cut -f31 -d,)/true,1,false,$(head -n1 $CASE9_DIR/$i | cut -f31 -d,)/" $CASE9_DIR/$i;
                sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                mv $CASE9_DIR/$i $SUCCESS_DIR;
                echo "-------------------------------------------------------------------------------" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "The following files' contents have been merged to $SUCCESS_DIR/$i" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs echo >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "Total number of records: $(cat $SUCCESS_DIR/$i 2> /dev/null | wc -l)" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "$(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | wc -l) file/s merged to $SUCCESS_DIR/$i" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                echo "-------------------------------------------------------------------------------" >> $LOG_DIR/${NAMING_CONVENTION2}.log;
                grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs -I {} mv {} $MERGE_DIR 2> /dev/null;
        fi;
done;
echo "$(date "+%F %H:%M"): Case9 processing has finished" >> $LOG_DIR/$NAMING_CONVENTION2.log; # Logging for processing of Case9 files

# Logging end of LDC processing
echo "$(date "+%F %H:%M"): Processing of LDC files has finished" >> $LOG_DIR/$NAMING_CONVENTION2.log;

# EOF
