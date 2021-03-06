#!/bin/bash
TSTAMP_DIR=/home/ubuntu/job1-2/tstamp
LOG_DIR=/tmp/urs_logs
SUCCESS_DIR=/home/ubuntu/job1-2/success
WLNFILTER_SUCCESS=/home/ubuntu/job1-2/wln_ftr_success

##Housekeeping job1
for i in $(ls $SUCCESS_DIR); do          		 ## check every .dat in dat dir
        touch -m $SUCCESS_DIR/$i                            ## update modify timestamp
        if [ $(stat -c %Y $SUCCESS_DIR/$i) -ge $(cat $TSTAMP_DIR/housekeeping_tstamp1.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then ## if current timestamp is greater than equal to listed timestamp then delete the file
                echo "$SUCCESS_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/job1.log;
                sed -i "/$i/d" $TSTAMP_DIR/housekeeping_tstamp1.txt; ## remove entry in timestamp file
                rm $SUCCESS_DIR/$i 2> /dev/null;
        fi;
done

##Housekeeping job2
for i in $(ls $WLNFILTER_SUCCESS); do                          ## check every .dat in dat dir
        touch -m $WLNFILTER_SUCCESS/$i                            ## update modify timestamp
        if [ $(stat -c %Y $WLNFILTER_SUCCESS/$i) -ge $(cat $TSTAMP_DIR/timestamp_wln_ftr.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then ## if current timestamp is greater than equal to listed timestamp then delete the file
                echo "$WLNFILTER_SUCCESS/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/job1.log;
                sed -i "/$i/d" $TSTAMP_DIR/timestamp_wln_ftr.txt; ## remove entry in timestamp file
                rm $WLNFILTER_SUCCESS/$i 2> /dev/null;
        fi;
done
