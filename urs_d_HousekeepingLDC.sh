#!/bin/bash
TSTAMP_DIR=/home/urpadm/job1-2/tstamp
LOG_DIR=/tmp/urs_logs
SUCCESS_DIR=/MYBSS/ISG/ADHOC/WLN_INC_LD/OUTPUT
WLNFILTER_DIR=/MYBSS/ISG/DAILY/WLN_FILTER
WLNFILTER_ARCHIVE_DIR=/home/urpadm/job1-2/wln_ftr_archive
FILE_ERROR_DIR=/home/urpadm/job1-2/file_error_handling
NAMING_CONVENTION=urs_d_LongDurationCalls_$(date +%F)

##Housekeeping long duration call
for i in $(ls $SUCCESS_DIR); do          		 ## check every .dat in dat dir
        touch -m $SUCCESS_DIR/$i                            ## update modify timestamp
        if [ $(stat -c %Y $SUCCESS_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then ## if current timestamp is greater than equal to listed timestamp then delete the file
                echo "$SUCCESS_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/${NAMING_CONVENTION}.log;
                sed -i "/$i/d" $TSTAMP_DIR/urs_d_LongDurationCalls_housekeeping_tstamp.txt; ## remove entry in timestamp file
                rm $SUCCESS_DIR/$i 2> /dev/null;
        fi;
done

##Housekeeping wireline filter report
for i in $(ls $WLNFILTER_DIR); do
	if grep -q $i $TSTAMP_DIR/urs_d_WireLine_Ftr_Report_tstamp.txt; then
		touch -m $WLNFILTER_DIR/$i                            ## update modify timestamp
        	if [ $(stat -c %Y $WLNFILTER_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_WireLine_Ftr_Report_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then ## if current timestamp is greater than equal to listed timestamp then delete the file
                	echo "$WLNFILTER_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/${NAMING_CONVENTION}.log;
               		sed -i "/$i/d" $TSTAMP_DIR/urs_d_WireLine_Ftr_Report_tstamp.txt; ## remove entry in timestamp file
                	rm $WLNFILTER_DIR/$i 2> /dev/null;
        	fi;
	fi;
done

##Housekeeping error files
for i in $(ls $FILE_ERROR_DIR); do
        touch -m $FILE_ERROR_DIR/$i                            ## update modify timestamp
        if [ $(stat -c %Y $FILE_ERROR_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_ErrorFile_Handling_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then ## if current timestamp is greater than equal to listed timestamp then delete the file
                echo "$FILE_ERROR_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/${NAMING_CONVENTION}.log;
                sed -i "/$i/d" $TSTAMP_DIR/urs_d_ErrorFile_Handling_tstamp.txt; ## remove entry in timestamp file
                rm $FILE_ERROR_DIR/$i 2> /dev/null;
        fi;
done

##Housekeeping wireline filter archive
for i in $(ls $WLNFILTER_ARCHIVE_DIR); do
        if grep -q $i $TSTAMP_DIR/urs_d_WireLine_Ftr_Archive_tstamp.txt; then
                touch -m $WLNFILTER_ARCHIVE_DIR/$i                            ## update modify timestamp
                if [ $(stat -c %Y $WLNFILTER_ARCHIVE_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_WireLine_Ftr_Archive_tstamp.txt 2> /dev/null | grep $i | cut -f3 -d" ") ]; then ## if current timestamp is greater than equal to listed timestamp then delete the file
                        echo "$WLNFILTER_ARCHIVE_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/${NAMING_CONVENTION}.log;
                        sed -i "/$i/d" $TSTAMP_DIR/urs_d_WireLine_Ftr_Archive_tstamp.txt; ## remove entry in timestamp file
                        rm $WLNFILTER_ARCHIVE_DIR/$i 2> /dev/null;
                fi;
        fi;
done

