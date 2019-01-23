#!/bin/bash
TSTAMP_DIR=/home/ubuntu/job1-2/tstamp
RECEIVE_DIR=/home/ubuntu/job1-2/receiving
CASES_DIR=/home/ubuntu/job1-2/cases
CASE1_DIR=/home/ubuntu/job1-2/cases/case1
CASE2_DIR=/home/ubuntu/job1-2/cases/case2
CASE3_DIR=/home/ubuntu/job1-2/cases/case3
CASE4_DIR=/home/ubuntu/job1-2/cases/case4
POSSIBLE_SUCCESS=/home/ubuntu/job1-2/possible_success
SUCCESS_DIR=/home/ubuntu/job1-2/success
LONG_CALL_HOLDER=0
LONG_CALL_DIR=/home/ubuntu/job1-2/long_calls

##PROCESS CASE4
for i in $(ls $CASE4_DIR/ | grep .*.ftr$); do  ## for every file in case4 dir
	touch -m $CASE4_DIR/$i;
	if [ $(stat -c %Y $CASE4_DIR/$i) -lt $(cat $TSTAMP_DIR/timestamps.txt | grep $i | cut -f3 -d" ") ]; then
		## Check for success
		if grep -qr $(head -n1 $CASE4_DIR/$i | cut -f31 -d,) $POSSIBLE_SUCCESS; then
			if grep -r $(head -n1 $CASE4_DIR/$i | cut -f31 -d,) $POSIBLE_SUCCESS | cut -f28-30 -d, | grep -q 1,1,0; then
				for a in $(grep -r $(head -n1 $CASE4_DIR/$i | cut -f31 -d,) $POSSIBLE_SUCCESS | cut -f1 -d: | uniq); do
					mv $a $SUCCESS_DIR;
				done;
				sed -i "/$(head -n1 $CASE4_DIR/$i | cut -f31 -d,)/d" $TSTAMP_DIR/timestamps.txt;
				mv $CASE4_DIR/$i $SUCCESS_DIR;
			fi;
		fi;
	elif [ $(stat -c %Y $CASE4_DIR/$i) -ge $(cat $TSTAMP_DIR/timestamps.txt | grep $i | cut -f3 -d" ") ]; then
		sed -i "$ s/0,2,1,$(tail -n1 $CASE4_DIR/$i | cut -f31 -d,)/0,0,0,$(tail -n1 $CASE4_DIR/$i | cut -f31 -d,)/" $CASE4_DIR/$i;
		sed -i "/$(head -n1 $CASE4_DIR/$i | cut -f31 -d,)/d" $TSTAMP_DIR/timestamps.txt;
		mv $CASE4_DIR/$i $SUCCESS_DIR;
	fi;
done
