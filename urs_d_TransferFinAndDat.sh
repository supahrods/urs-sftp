#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : January 22, 2019
# Version  : 1.3
#
# Description : Transfers .dat and .FIN files into its respective directory
#
#----------------------------------------------------------
# Revision History:
# Author: Joussyd M. Calupig
# Date: February 4, 2019
# Description: Updated path/directories and Headers
#----------------------------------------------------------

#!/bin/bash
RECEIVE_DIR=/appl/urpadm/job3-4/receiving
PROCESS_DIR=/appl/urpadm/job3-4/processing
DAT_DIR=/MYBSS/EP_FILES/USAGE_WLN/DAT
FIN_DIR=/MYBSS/EP_FILES/USAGE_WLN/FIN
USAGE_DIR=/MYBSS/EP_FILES/BACKUP/USAGE_WLN
BACKUP_DIR=/appl/urpadm/job3-4/output/backup
LOG_DIR=/logs/urs_logs
TSTAMP_DIR=/appl/urpadm/job3-4/tstamp
F_LIFETIME=604800
DAT_BACKUP_LIFETIME=259200
NAMING_CONVENTION=urs_d_findat_eod_report_$(date +%F)


## workflow: receive all files at RECEIVE_DIR then move them to PROCESS_DIR

## Check if uploading then move from receiving to processing
for i in $(ls $RECEIVE_DIR | grep .*"\.dat".*$); do	## check every .dat file
	if ! lsof | grep $RECEIVE_DIR/$i; then		## check if file is still uploading
		echo "$(stat -c %Y $RECEIVE_DIR/$i) $(($(stat -c %Y $RECEIVE_DIR/$i)+$F_LIFETIME)) $i" >> $TSTAMP_DIR/urs_d_findat_tstamp.txt; ## record filename, timestamp today, timestamp 7 days after
		mv $RECEIVE_DIR/$i $PROCESS_DIR;	## move to process dir if file finished upload
	fi;
done

## Process files then move to output directory
for i in $(ls $PROCESS_DIR | grep .*"\.dat"$); do	## check every .dat file in process dir
	if [ -f $PROCESS_DIR/$i.FIN ]; then		## if there is a corresponding .dat.FIN
		echo "$PROCESS_DIR/$i.FIN exists for $PROCESS_DIR/$i" >> $LOG_DIR/$NAMING_CONVENTION.log; ## log successful find
		mv $PROCESS_DIR/$i $DAT_DIR && mv $PROCESS_DIR/$i.FIN $FIN_DIR;	## move .dat to dat dir and .dat.FIN to fin dir
	else
		echo "$PROCESS_DIR/$i does not have any $PROCESS_DIR/$i.FIN" >> $LOG_DIR/$NAMING_CONVENTION.log; ## else, log unsuccessful
		sed -i "/$i$/d" $TSTAMP_DIR/urs_d_findat_tstamp.txt;
		echo "$(stat -c %Y $PROCESS_DIR/$i) $(($(stat -c %Y $PROCESS_DIR/$i)+$DAT_BACKUP_LIFETIME)) $i" >> $TSTAMP_DIR/urs_d_dat_backup_tstamp.txt;
		mv $PROCESS_DIR/$i $USAGE_DIR;	## move .dat file to wlg_usage
	fi;
done

## Process .dat.FIN files that do not have any .dat
## Another case when there is a .dat.FIN file while no .dat (however unlikely according to discussion)
for i in $(ls $PROCESS_DIR | grep .*"\.dat\.FIN"$); do  ## check every .dat.FIN file in process dir
        if [ -f $PROCESS_DIR/$i ]; then                 ## since only .dat.FIN w/o .dat files are present,
                echo "$PROCESS_DIR/$i does not have any .dat file" >> $LOG_DIR/$NAMING_CONVENTION.log; ## logging
		sed -i "/$i$/d" $TSTAMP_DIR/urs_d_findat_tstamp.txt;
		echo "$(stat -c %Y $PROCESS_DIR/$i) $(($(stat -c %Y $PROCESS_DIR/$i)+$DAT_BACKUP_LIFETIME)) $i" >> $TSTAMP_DIR/urs_d_dat_backup_tstamp.txt;
                mv $PROCESS_DIR/$i $USAGE_DIR;          ## move .dat.FIN to wlg_usage
        fi;
done

## Process .dat files in wlg_usage directory
for i in $(ls $USAGE_DIR | grep .*"\.dat"$); do
	touch -m $USAGE_DIR/$i;
	if [ $(stat -c %Y $USAGE_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_dat_backup_tstamp.txt 2> /dev/null | grep $i | cut -f2 -d" ") ]; then
        	if [ -f $USAGE_DIR/$i.FIN ]; then
                	sed -i "/$i$/d" $TSTAMP_DIR/urs_d_dat_backup_tstamp.txt;
                	echo "$USAGE_DIR/$i.FIN exists for $USAGE_DIR/$i" >> $LOG_DIR/$NAMING_CONVENTION.log;
			echo "$(stat -c %Y $USAGE_DIR/$i) $(($(stat -c %Y $USAGE_DIR/$i)+$F_LIFETIME)) $i" >> $TSTAMP_DIR/urs_d_findat_tstamp.txt;
			echo "$(stat -c %Y $USAGE_DIR/$i.FIN) $(($(stat -c %Y $USAGE_DIR/$i.FIN)+$F_LIFETIME)) $i.FIN" >> $TSTAMP_DIR/urs_d_findat_tstamp.txt;
                	mv $USAGE_DIR/$i $DAT_DIR && mv $USAGE_DIR/$i.FIN $FIN_DIR;
		fi;
        elif [ $(stat -c %Y $USAGE_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_dat_backup_tstamp.txt 2> /dev/null | grep $i | cut -f2 -d" ") ]; then
                echo "$USAGE_DIR/$i is being moved to backup directory" >> $LOG_DIR/$NAMING_CONVENTION.log;
		mv $USAGE_DIR/$i $BACKUP_DIR;
		sed -i "/$i$/d" $TSTAMP_DIR/urs_d_dat_backup_tstamp.txt;
        fi;
done

## Process .dat.FIN files in wlg_usage directory
for i in $(ls $USAGE_DIR | grep .*"\.dat\.FIN"$); do
	touch -m $USAGE_DIR/$i;
        if [ $(stat -c %Y $USAGE_DIR/$i) -lt $(cat $TSTAMP_DIR/urs_d_dat_backup_tstamp.txt 2> /dev/null | grep $i | cut -f2 -d" ") ]; then
                if [ -f $USAGE_DIR/${i%.*} ]; then
                        sed -i "/$i$/d" $TSTAMP_DIR/urs_d_dat_backup_tstamp.txt;
                        echo "$USAGE_DIR/$i exists for $USAGE_DIR/${i%.*}" >> $LOG_DIR/$NAMING_CONVENTION.log;
			echo "$(stat -c %Y $USAGE_DIR/${i%.*}) $(($(stat -c %Y $USAGE_DIR/${i%.*})+$F_LIFETIME)) ${i%.*}" >> $TSTAMP_DIR/urs_d_findat_tstamp.txt;
			echo "$(stat -c %Y $USAGE_DIR/$i) $(($(stat -c %Y $USAGE_DIR/$i)+$F_LIFETIME)) $i" >> $TSTAMP_DIR/urs_d_findat_tstamp.txt;
                        mv $USAGE_DIR/${i%.*} $DAT_DIR && mv $USAGE_DIR/$i $FIN_DIR;
                fi;
        elif [ $(stat -c %Y $USAGE_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_dat_backup_tstamp.txt 2> /dev/null | grep $i | cut -f2 -d" ") ]; then
                echo "$USAGE_DIR/$i is being moved to backup directory" >> $LOG_DIR/$NAMING_CONVENTION.log;
                mv $USAGE_DIR/$i $BACKUP_DIR;
                sed -i "/$i$/d" $TSTAMP_DIR/urs_d_dat_backup_tstamp.txt;
        fi;
done
