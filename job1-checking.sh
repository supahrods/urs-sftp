#!/bin/bash
TSTAMP_DIR=/home/ubuntu/job1-2/tstamp
RECEIVE_DIR=/home/ubuntu/job1-2/receiving
CASES_DIR=/home/ubuntu/job1-2/cases
CASE1_DIR=/home/ubuntu/job1-2/cases/case1
CASE2_DIR=/home/ubuntu/job1-2/cases/case2
CASE3_DIR=/home/ubuntu/job1-2/cases/case3
CASE4_DIR=/home/ubuntu/job1-2/cases/case4
BETWEEN_DIR=/home/ubuntu/job1-2/betweens
POSSIBLE_SUCCESS=/home/ubuntu/job1-2/possible_success
SUCCESS_DIR=/home/ubuntu/job1-2/success
F_LIFETIME=604800

##PROCESS CASE1
for i in $(ls $CASE1_DIR/ | grep .*.ftr$); do  ## for every file in case1 dir
	touch -m $CASE1_DIR/$i;
	if [ $(stat -c %Y $CASE1_DIR/$i) -lt $(cat $TSTAMP_DIR/timestamp1.txt | grep $i | cut -f3 -d" ") ]; then
		## Check for success
		if grep -qr $(head -n1 $CASE1_DIR/$i | cut -f31 -d,) $POSSIBLE_SUCCESS; then
			if grep -r $(head -n1 $CASE1_DIR/$i | cut -f31 -d,) $POSIBLE_SUCCESS | cut -f28-30 -d, | grep -q 1,1,0; then
				for a in $(grep -r $(head -n1 $CASE1_DIR/$i | cut -f31 -d,) $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
					echo "$a $(stat -c %Y $a) $(($(stat -c %Y $a)+$F_LIFETIME)) $(head -n1 $a | cut -f31 -d,)" >> $TSTAMP_DIR/housekeeping_tstamp1.txt
                                        mv $a $SUCCESS_DIR;

				done;
				sed -i "/$(head -n1 $CASE1_DIR/$i | cut -f31 -d,)/d" $TSTAMP_DIR/timestamp1.txt;
				mv $CASE1_DIR/$i $SUCCESS_DIR;
				echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/housekeeping_tstamp1.txt;
			fi;
		fi;
	elif [ $(stat -c %Y $CASE1_DIR/$i) -ge $(cat $TSTAMP_DIR/timestamp1.txt | grep $i | cut -f3 -d" ") ]; then
		sed -i "$ s/1,1,1,$(tail -n1 $CASE1_DIR/$i | cut -f31 -d,)/1,1,0,$(tail -n1 $CASE1_DIR/$i | cut -f31 -d,)/" $CASE1_DIR/$i;
		sed -i "/$(head -n1 $CASE1_DIR/$i | cut -f31 -d,)/d" $TSTAMP_DIR/timestamp1.txt;
		mv $CASE1_DIR/$i $SUCCESS_DIR;
		echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/housekeeping_tstamp1.txt;
	fi;
done

##PROCESS CASE2
for i in $(ls $CASE2_DIR/ | grep .*.ftr$); do  ## for every file in case2 dir
        touch -m $CASE2_DIR/$i;
        if [ $(stat -c %Y $CASE2_DIR/$i) -lt $(cat $TSTAMP_DIR/timestamp1.txt | grep $i | cut -f3 -d" ") ]; then
                ## Check for success
                if grep -qr $(head -n1 $CASE2_DIR/$i | cut -f31 -d,) $POSSIBLE_SUCCESS; then
                        if grep -r $(head -n1 $CASE2_DIR/$i | cut -f31 -d,) $POSIBLE_SUCCESS | cut -f28-30 -d, | grep -q 0,2,1; then
                                for a in $(grep -r $(head -n1 $CASE2_DIR/$i | cut -f31 -d,) $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
					echo "$a $(stat -c %Y $a) $(($(stat -c %Y $a)+$F_LIFETIME)) $(head -n1 $a | cut -f31 -d,)" >> $TSTAMP_DIR/housekeeping_tstamp1.txt;
                                        mv $a $SUCCESS_DIR;
                                done;
                                sed -i "/$(head -n1 $CASE2_DIR/$i | cut -f31 -d,)/d" $TSTAMP_DIR/timestamp1.txt;
                                mv $CASE2_DIR/$i $SUCCESS_DIR;
				echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/housekeeping_tstamp1.txt;
                        fi;
                fi;
        elif [ $(stat -c %Y $CASE2_DIR/$i) -ge $(cat $TSTAMP_DIR/timestamp1.txt | grep $i | cut -f3 -d" ") ]; then
                sed -i "1 s/1,1,1,$(head -n1 $CASE2_DIR/$i | cut -f31 -d,)/0,2,1,$(head -n1 $CASE2_DIR/$i | cut -f31 -d,)/" $CASE2_DIR/$i;
                for a in $(nl $CASE2_DIR/$i | cut -c6); do
                        sed -i "$a s/$(sed -n ${a}p $CASE2_DIR/$i | cut -f27-31 -d,)/$a,$(sed -n ${a}p $CASE2_DIR/$i | cut -f28-31 -d,)/" $CASE2_DIR/$i;
                done
                sed -i "/$(head -n1 $CASE2_DIR/$i | cut -f31 -d,)/d" $TSTAMP_DIR/timestamp1.txt;
                mv $CASE2_DIR/$i $SUCCESS_DIR;
		echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/housekeeping_tstamp1.txt;
        fi;
done

##PROCESS CASE3
for i in $(ls $CASE3_DIR/ | grep .*.ftr$); do  ## for every file in case3 dir
        touch -m $CASE3_DIR/$i;
        M_NUM=$(head -n1 $CASE3_DIR/$i | cut -f27 -d,);
        L_NUM=$(tail -n1 $CASE3_DIR/$i | cut -f27 -d,);
        eval "t=({$(($M_NUM+1))..$(($L_NUM-1))})"; echo ${t[*]/%/,1,1,1,$(head -n1 $CASE3_DIR/$i | cut -f31 -d,)} | tr " " "\n" >> $BETWEEN_DIR/$i;
        if [ $(stat -c %Y $CASE3_DIR/$i) -lt $(cat $TSTAMP_DIR/timestamp1.txt | grep $i | cut -f3 -d" ") ]; then
                ## Check for success
                if grep -qr $(head -n1 $CASE3_DIR/$i | cut -f31 -d,) $POSSIBLE_SUCCESS; then
                        for a in $(cat $BETWEEN_DIR/$i); do
                                if grep -qr $a $POSSIBLE_SUCCESS; then
                                        sed -i "/$a/d" $BETWEEN_DIR/$i;
                                fi;
                                if grep -qr $a $CASE3_DIR; then
                                        sed -i "/$a/d" $BETWEEN_DIR/$i;
                                fi;
                                if [ $(cat $BETWEEN_DIR/$i | wc -l) == 0 ]; then
					for b in $(grep -r $(head -n1 $CASE3_DIR/$i | cut -f31 -d,) $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
						echo "$b $(stat -c %Y $b) $(($(stat -c %Y $b)+$F_LIFETIME)) $(head -n1 $b | cut -f31 -d,)" >> $TSTAMP_DIR/housekeeping_tstamp1.txt;
                                                mv $b $SUCCESS_DIR;
					done;
                                        sed -i "/$(head -n1 $CASE3_DIR/$i | cut -f31 -d,)/d" $TSTAMP_DIR/timestamp1.txt;
                                        mv $CASE3_DIR/$i $SUCCESS_DIR;
					echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/housekeeping_tstamp1.txt;
                                fi;
                        done;
                fi;
        elif [ $(stat -c %Y $CASE3_DIR/$i) -ge $(cat $TSTAMP_DIR/timestamp1.txt | grep $i | cut -f3 -d" ") ]; then
                sed -i "$ s/$(tail -n1 $CASE3_DIR/$i | cut -f27-31 -d,)/$(cat $CASE3_DIR/$i | wc -l),$(tail -n1 $CASE3_DIR/$i | cut -f28-31 -d,)/" $CASE3_DIR/$i;
                sed -i "/$(head -n1 $CASE3_DIR/$i | cut -f31 -d,)/d" $TSTAMP_DIR/timestamp1.txt;
                mv $CASE3_DIR/$i $SUCCESS_DIR;
		echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/housekeeping_tstamp1.txt;
        fi;
        rm $BETWEEN_DIR/$i;
done

##PROCESS CASE4
for i in $(ls $CASE4_DIR/ | grep .*.ftr$); do  ## for every file in case4 dir
        touch -m $CASE4_DIR/$i;
        if [ $(stat -c %Y $CASE4_DIR/$i) -lt $(cat $TSTAMP_DIR/timestamp1.txt | grep $i | cut -f3 -d" ") ]; then
                ## Check for success
                if grep -qr $(head -n1 $CASE4_DIR/$i | cut -f31 -d,) $POSSIBLE_SUCCESS; then
                        if grep -r $(head -n1 $CASE4_DIR/$i | cut -f31 -d,) $POSIBLE_SUCCESS | cut -f28-30 -d, | grep -q 1,1,0; then
                                for a in $(grep -r $(head -n1 $CASE4_DIR/$i | cut -f31 -d,) $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
					echo "$a $(stat -c %Y $a) $(($(stat -c %Y $a)+$F_LIFETIME)) $(head -n1 $a | cut -f31 -d,)" >> $TSTAMP_DIR/housekeeping_tstamp1.txt;
                                        mv $a $SUCCESS_DIR;
                                done;
                                sed -i "/$(head -n1 $CASE4_DIR/$i | cut -f31 -d,)/d" $TSTAMP_DIR/timestamp1.txt;
                                mv $CASE4_DIR/$i $SUCCESS_DIR;
				echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/housekeeping_tstamp1.txt;
                        fi;
                fi;
        elif [ $(stat -c %Y $CASE4_DIR/$i) -ge $(cat $TSTAMP_DIR/timestamp1.txt | grep $i | cut -f3 -d" ") ]; then
                sed -i "$ s/0,2,1,$(tail -n1 $CASE4_DIR/$i | cut -f31 -d,)/0,0,0,$(tail -n1 $CASE4_DIR/$i | cut -f31 -d,)/" $CASE4_DIR/$i;
                sed -i "/$(head -n1 $CASE4_DIR/$i | cut -f31 -d,)/d" $TSTAMP_DIR/timestamp1.txt;
                mv $CASE4_DIR/$i $SUCCESS_DIR;
		echo "$i $(stat -c %Y $SUCCESS_DIR/$i) $(($(stat -c %Y $SUCCESS_DIR/$i)+$F_LIFETIME)) $(head -n1 $SUCCESS_DIR/$i | cut -f31 -d,)" >> $TSTAMP_DIR/housekeeping_tstamp1.txt;
        fi;
done
