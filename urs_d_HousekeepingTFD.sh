#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : January 22, 2019
# Version  : 1.3
#
# Description : Housekeeping of .dat and .FIN files
#
#----------------------------------------------------------
# Revision History:
# Author: Joussyd M. Calupig
# Date: February 4, 2019
# Description: Updated path/directories and Headers
#----------------------------------------------------------

#!/bin/bash
DAT_DIR=/MYBSS/EP_FILES/USAGE_WLN/DAT
FIN_DIR=/MYBSS/EP_FILES/USAGE_WLN/FIN
USAGE_DIR=/MYBSS/EP_FILES/BACKUP/USAGE_WLN/
BACKUP_DIR=/appl/urpadm/job3-4/output/backup
LOG_DIR=/logs/urs_logs
TSTAMP_DIR=/appl/urpadm/job3-4/tstamp
NAMING_CONVENTION=urs_d_findat_eod_report_$(date +%F)

##Housekeeping job3
for i in $(ls $DAT_DIR | grep .*"\.dat"$); do           ## check every .dat in dat dir
        touch -m $DAT_DIR/$i                            ## update modify timestamp
        if [ $(stat -c %Y $DAT_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_findat_tstamp.txt | grep $i$ | cut -f2 -d" ") ]; then ## if current timestamp is greater than equal to listed timestamp then delete the file
                echo "$DAT_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/$NAMING_CONVENTION.log;
                sed -i "/$i$/d" $TSTAMP_DIR/urs_d_findat_tstamp.txt; ## remove entry in timestamp file
                rm $DAT_DIR/$i;
        fi;
done

for i in $(ls $FIN_DIR | grep .*"\.dat\.FIN"$); do      ## check every .dat.FIN in fin dir
        touch -m $FIN_DIR/$i                            ## update modify timestamp
        if [ $(stat -c %Y $FIN_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_findat_tstamp.txt | grep $i$ | cut -f2 -d" ") ]; then ## if current timestamp is greater than equal to listed timestamp then delete the file
                echo "$FIN_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/$NAMING_CONVENTION.log;
                sed -i "/$i$/d" $TSTAMP_DIR/urs_d_findat_tstamp.txt; ## remove entry in timestamp file
                rm $FIN_DIR/$i;
        fi;
done

## Housekeeping for backup dir
touch -d "last week" $BACKUP_DIR/date_check;
find $BACKUP_DIR -type f ! -newer $BACKUP_DIR/date_check | xargs rm -rf 2> /dev/null;

## Housekeeping job4
for i in $(ls $USAGE_DIR | grep .*"\.t3xt"$); do        ## check every .t3xt in usage dir
        touch -m $USAGE_DIR/$i                          ## update modify timestamp
        if [ $(stat -c %Y $USAGE_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_eod_report_tstamp.txt | grep $i$ | cut -f2 -d" ") ]; then       ## if current timestamp is greater than equal to listed timestamp then delete the file
                echo "$USAGE_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/$NAMING_CONVENTION.log;
                sed -i "/$i$/d" $TSTAMP_DIR/urs_d_eod_report_tstamp.txt; ## remove entry in timestamp file
                rm $USAGE_DIR/$i;
        fi;
done
for i in $(ls $USAGE_DIR | grep .*"\.txt"$); do         ## check every .txt in usage dir
        touch -m $USAGE_DIR/$i                          ## update modify timestamp
        if [ $(stat -c %Y $USAGE_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_eod_report_tstamp.txt | grep $i$ | cut -f2 -d" ") ]; then       ## if current timestamp is greater than equal to listed timestamp then delete the file
                echo "$USAGE_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/$NAMING_CONVENTION.log;
                sed -i "/$i$/d" $TSTAMP_DIR/urs_d_eod_report_tstamp.txt; ## remove entry in timestamp file
                rm $USAGE_DIR/$i;
        fi;
done
