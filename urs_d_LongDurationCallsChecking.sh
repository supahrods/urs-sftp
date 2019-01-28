#!/bin/bash
TSTAMP_DIR=/home/urpadm/job1-2/tstamp
CASE1_DIR=/home/urpadm/job1-2/cases/case1
CASE2_DIR=/home/urpadm/job1-2/cases/case2
CASE3_DIR=/home/urpadm/job1-2/cases/case3
CASE4_DIR=/home/urpadm/job1-2/cases/case4
CASE5_DIR=/home/urpadm/job1-2/cases/case5
CASE6_DIR=/home/urpadm/job1-2/cases/case6
BETWEEN_DIR=/home/urpadm/job1-2/betweens
POSSIBLE_SUCCESS=/home/urpadm/job1-2/possible_success
SUCCESS_DIR=/MYBSS/ISG/ADHOC/WLN_INC_LD/OUTPUT
F_LIFETIME=604800
CHECK_COUNTER=0

##PROCESS CASE1
for i in $(ls $CASE1_DIR/ | grep .*.ftr$); do  ## for every file in case1 dir
	touch -m $CASE1_DIR/$i;
	CALL_IDENTIFIER=$(head -n1 $CASE1_DIR/$i 2> /dev/null | cut -f31 -d,);
	if [ $(stat -c %Y $CASE1_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then
		## Check for success
		if grep -qr $CALL_IDENTIFIER $POSSIBLE_SUCCESS; then
			if grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f28-30 -d, | grep -q "true,1,false"; then
				for a in $(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
					echo "$a $(stat -c %Y $a) $(($(stat -c %Y $a)+$F_LIFETIME)) $(head -n1 $a | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt
                                        mv $a $SUCCESS_DIR;
				done;
				sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
				mv $CASE1_DIR/$i $SUCCESS_DIR;
				echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
			fi;
		fi;
	elif [ $(stat -c %Y $CASE1_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS $CASE1_DIR | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs cat 2> /dev/null | awk NF >> $CASE1_DIR/placeholder_$CALL_IDENTIFIER;
		sort -t, -k25 -V $CASE1_DIR/placeholder_$CALL_IDENTIFIER > $CASE1_DIR/$i;
		rm $CASE1_DIR/placeholder_$CALL_IDENTIFIER 2> /dev/null;
		sed -i "$ s/true,1,true,$(tail -n1 $CASE1_DIR/$i | cut -f31 -d,)/true,1,false,$(tail -n1 $CASE1_DIR/$i | cut -f31 -d,)/" $CASE1_DIR/$i;
		sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
		mv $CASE1_DIR/$i $SUCCESS_DIR;
		echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs rm 2> /dev/null;
	fi;
done;

##PROCESS CASE2
for i in $(ls $CASE2_DIR/ | grep .*.ftr$); do  ## for every file in case2 dir
        touch -m $CASE2_DIR/$i;
	CALL_IDENTIFIER=$(head -n1 $CASE2_DIR/$i 2> /dev/null | cut -f31 -d,);
        if [ $(stat -c %Y $CASE2_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then
                ## Check for success
                if grep -qr $CALL_IDENTIFIER $POSSIBLE_SUCCESS; then
                        if grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f28-30 -d, | grep -q "false,2,true"; then
                                for a in $(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
					echo "$a $(stat -c %Y $a) $(($(stat -c %Y $a)+$F_LIFETIME)) $(head -n1 $a | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
                                        mv $a $SUCCESS_DIR;
                                done;
                                sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                                mv $CASE2_DIR/$i $SUCCESS_DIR;
				echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
                        fi;
                fi;
        elif [ $(stat -c %Y $CASE2_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS $CASE2_DIR | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs cat 2> /dev/null | awk NF >> $CASE2_DIR/placeholder_$CALL_IDENTIFIER;
		sort -t, -k25 -V $CASE2_DIR/placeholder_$CALL_IDENTIFIER > $CASE2_DIR/$i;
		rm $CASE2_DIR/placeholder_$CALL_IDENTIFIER 2> /dev/null;
                sed -i "1 s/true,1,true,$(head -n1 $CASE2_DIR/$i | cut -f31 -d,)/false,2,true,$(head -n1 $CASE2_DIR/$i | cut -f31 -d,)/" $CASE2_DIR/$i;
                for a in $(nl $CASE2_DIR/$i | cut -c6); do
                        sed -i "$a s/$(sed -n ${a}p $CASE2_DIR/$i | cut -f25-31 -d,)/$a,$(sed -n ${a}p $CASE2_DIR/$i | cut -f26-31 -d,)/" $CASE2_DIR/$i;
                done
                sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                mv $CASE2_DIR/$i $SUCCESS_DIR;
		echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs rm 2> /dev/null;
        fi;
done;

##PROCESS CASE3
for i in $(ls $CASE3_DIR/ | grep .*.ftr$); do  ## for every file in case3 dir
        touch -m $CASE3_DIR/$i;
	CALL_IDENTIFIER=$(head -n1 $CASE3_DIR/$i 2> /dev/null | cut -f31 -d,);
        M_NUM=$(head -n1 $CASE3_DIR/$i | cut -f25 -d,);
        L_NUM=$(tail -n1 $CASE3_DIR/$i | cut -f25 -d,);
        BETWEEN_SEQUENCE=$(eval "t=({$(($M_NUM+1))..$(($L_NUM-1))})"; echo ${t[*]});
        if [ $(stat -c %Y $CASE3_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then
                ## Check for success
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
					echo "$b $(stat -c %Y $b) $(($(stat -c %Y $b)+$F_LIFETIME)) $(head -n1 $b | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
					mv $b $SUCCESS_DIR;
				done;
				sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
				mv $CASE3_DIR/$i $SUCCESS_DIR;
				echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
			fi;
			CHECK_COUNTER=0;
                fi;
        elif [ $(stat -c %Y $CASE3_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS $CASE3_DIR | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs cat 2> /dev/null | awk NF >> $CASE3_DIR/placeholder_$CALL_IDENTIFIER;
		sort -t, -k25 -V $CASE3_DIR/placeholder_$CALL_IDENTIFIER > $CASE3_DIR/$i;
		rm $CASE3_DIR/placeholder_$CALL_IDENTIFIER 2> /dev/null;
		for a in $(nl $CASE3_DIR/$i | cut -c6); do
			sed -i "$a s/$(sed -n ${a}p $CASE3_DIR/$i | cut -f25-31 -d,)/$a,$(sed -n ${a}p $CASE3_DIR/$i | cut -f26-31 -d,)/" $CASE3_DIR/$i;
		done
                sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                mv $CASE3_DIR/$i $SUCCESS_DIR;
		echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs rm 2> /dev/null;
        fi;
done;

##PROCESS CASE4
for i in $(ls $CASE4_DIR/ | grep .*.ftr$); do  ## for every file in case4 dir
        touch -m $CASE4_DIR/$i;
	CALL_IDENTIFIER=$(head -n1 $CASE4_DIR/$i 2> /dev/null | cut -f31 -d,);
        if [ $(stat -c %Y $CASE4_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then
                ## Check for success
                if grep -qr $(head -n1 $CASE4_DIR/$i | cut -f31 -d,) $POSSIBLE_SUCCESS; then
                        if grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f28-30 -d, | grep -q "true,1,false"; then
                                for a in $(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
					echo "$a $(stat -c %Y $a) $(($(stat -c %Y $a)+$F_LIFETIME)) $(head -n1 $a | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
                                        mv $a $SUCCESS_DIR;
                                done;
                                sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                                mv $CASE4_DIR/$i $SUCCESS_DIR;
				echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
                        fi;
                fi;
        elif [ $(stat -c %Y $CASE4_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS $CASE4_DIR | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs cat 2> /dev/null | awk NF >> $CASE4_DIR/placeholder_$CALL_IDENTIFIER;
		sort -t, -k25 -V $CASE4_DIR/placeholder_$CALL_IDENTIFIER > $CASE4_DIR/$i;
		rm $CASE4_DIR/placeholder_$CALL_IDENTIFIER 2> /dev/null;
		if [ $(cat $CASE4_DIR/$i 2> /dev/null | wc -l) == 1 ]; then
	                sed -i "$ s/false,2,true,$(tail -n1 $CASE4_DIR/$i | cut -f31 -d,)/false,0,false,$(tail -n1 $CASE4_DIR/$i | cut -f31 -d,)/" $CASE4_DIR/$i;
			sed -i "$ s/$(tail -n1 $CASE4_DIR/$i | cut -f25-31 -d,)/,$(tail -n1 $CASE4_DIR/$i | cut -f26-31 -d,)/" $CASE4_DIR/$i;
        	        sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
			mv $CASE4_DIR/$i $SUCCESS_DIR;
			echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
			grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs rm 2> /dev/null;
		else
			sed -i "$ s/true,1,true,$(tail -n1 $CASE4_DIR/$i | cut -f31 -d,)/true,1,false,$(tail -n1 $CASE4_DIR/$i | cut -f31 -d,)/" $CASE4_DIR/$i;
			sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
			mv $CASE4_DIR/$i $SUCCESS_DIR;
			echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
			grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs rm 2> /dev/null;
		fi;
        fi;
done;

##PROCESS CASE5
for i in $(ls $CASE5_DIR/ | grep .*.ftr$); do  ## for every file in case5 dir
        touch -m $CASE5_DIR/$i;
	CALL_IDENTIFIER=$(head -n1 $CASE5_DIR/$i 2> /dev/null | cut -f31 -d,);
        if [ $(stat -c %Y $CASE5_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then
                ## Check for success
                if grep -qr $CALL_IDENTIFIER $POSSIBLE_SUCCESS; then
                        if grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f28-30 -d, | grep -q "true,1,false"; then
				if grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f28-30 -d, | grep -q "false,2,true"; then
                                	for a in $(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
                                        	echo "$a $(stat -c %Y $a) $(($(stat -c %Y $a)+$F_LIFETIME)) $(head -n1 $a | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
                                        	mv $a $SUCCESS_DIR;
                                	done;
                                	sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                                	mv $CASE5_DIR/$i $SUCCESS_DIR;
                                	echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
                        	fi;
			fi;
                fi;
        elif [ $(stat -c %Y $CASE5_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS $CASE5_DIR | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs cat 2> /dev/null | awk NF >> $CASE5_DIR/placeholder_$CALL_IDENTIFIER;
		sort -t, -k25 -V $CASE5_DIR/placeholder_$CALL_IDENTIFIER > $CASE5_DIR/$i;
		rm $CASE5_DIR/placeholder_$CALL_IDENTIFIER 2> /dev/null;
		if [ $(cat $CASE5_DIR/$i 2> /dev/null | wc -l) == 1 ]; then
                	sed -i "$ s/true,1,true,$(tail -n1 $CASE5_DIR/$i | cut -f31 -d,)/false,0,false,$(tail -n1 $CASE5_DIR/$i | cut -f31 -d,)/" $CASE5_DIR/$i;
                        sed -i "$ s/$(tail -n1 $CASE5_DIR/$i | cut -f25-31 -d,)/,$(tail -n1 $CASE5_DIR/$i | cut -f26-31 -d,)/" $CASE5_DIR/$i;
                	sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                	mv $CASE5_DIR/$i $SUCCESS_DIR;
                	echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
			grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs rm 2> /dev/null;
		else
			sed -i "1 s/true,1,true,$(head -n1 $CASE5_DIR/$i | cut -f31 -d,)/false,2,true,$(head -n1 $CASE5_DIR/$i | cut -f31 -d,)/" $CASE5_DIR/$i;
			for a in $(nl $CASE5_DIR/$i | cut -c6); do
				sed -i "$a s/$(sed -n ${a}p $CASE5_DIR/$i | cut -f25-31 -d,)/$a,$(sed -n ${a}p $CASE5_DIR/$i | cut -f26-31 -d,)/" $CASE5_DIR/$i;
			done
			sed -i "$ s/true,1,true,$(head -n1 $CASE5_DIR/$i | cut -f31 -d,)/true,1,false,$(head -n1 $CASE5_DIR/$i | cut -f31 -d,)/" $CASE5_DIR/$i;
			sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
			mv $CASE5_DIR/$i $SUCCESS_DIR;
			echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
			grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs rm 2> /dev/null;
		fi;
        fi;
done;

##PROCESS CASE6
for i in $(ls $CASE6_DIR/ | grep .*.ftr$); do  ## for every file in case6 dir
        touch -m $CASE6_DIR/$i;
	CALL_IDENTIFIER=$(head -n1 $CASE6_DIR/$i 2> /dev/null | cut -f31 -d,);
        if [ $(stat -c %Y $CASE6_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then
                ## Check for success
                if grep -qr $CALL_IDENTIFIER $POSSIBLE_SUCCESS; then
                        if grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f28-30 -d, | grep -q "false,2,true"; then
                                for a in $(grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
                                        echo "$a $(stat -c %Y $a) $(($(stat -c %Y $a)+$F_LIFETIME)) $(head -n1 $a | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
                                        mv $a $SUCCESS_DIR;
                                done;
                                sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                                mv $CASE6_DIR/$i $SUCCESS_DIR;
                                echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
                        fi;
                fi;
        elif [ $(stat -c %Y $CASE6_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then
		grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS $CASE6_DIR | cut -f1 -d: | xargs readlink -f 2> /dev/null | xargs cat 2> /dev/null | awk NF >> $CASE6_DIR/placeholder_$CALL_IDENTIFIER;
		sort -t, -k25 -V $CASE6_DIR/placeholder_$CALL_IDENTIFIER > $CASE6_DIR/$i;
		rm $CASE6_DIR/placeholder_$CALL_IDENTIFIER 2> /dev/null;
		if [ $(cat $CASE6_DIR/$i 2> /dev/null | wc -l) == 1 ]; then
                	sed -i "$ s/true,1,false,$(tail -n1 $CASE6_DIR/$i | cut -f31 -d,)/false,0,false,$(tail -n1 $CASE6_DIR/$i | cut -f31 -d,)/" $CASE6_DIR/$i;
                        sed -i "$ s/$(tail -n1 $CASE6_DIR/$i | cut -f25-31 -d,)/,$(tail -n1 $CASE6_DIR/$i | cut -f26-31 -d,)/" $CASE6_DIR/$i;
                	sed -i "/$(head -n1 $CASE6_DIR/$i | cut -f31 -d,)/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
                	mv $CASE6_DIR/$i $SUCCESS_DIR;
                	echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
			grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs rm 2> /dev/null;
		else
			sed -i "1 s/true,1,true,$CALL_IDENTIFIER/false,2,true,$CALL_IDENTIFIER/" $CASE6_DIR/$i;
			for a in $(nl $CASE6_DIR/$i | cut -c6); do
				sed -i "$a s/$(sed -n ${a}p $CASE6_DIR/$i | cut -f25-31 -d,)/$a,$(sed -n ${a}p $CASE6_DIR/$i | cut -f26-31 -d,)/" $CASE6_DIR/$i;
			done
			sed -i "/$CALL_IDENTIFIER/d" $TSTAMP_DIR/urs_d_LongDurationCalls_call_aging_tstamp.txt;
			mv $CASE6_DIR/$i $SUCCESS_DIR;
			echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt;
			grep -r $CALL_IDENTIFIER $POSSIBLE_SUCCESS | cut -f1 -d: | uniq | xargs readlink -f 2> /dev/null | xargs rm 2> /dev/null;
		fi;
        fi;
done;
