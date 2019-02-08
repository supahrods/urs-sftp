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
USAGE_DIR=/MYBSS/EP_FILES/USAGE_WLN/REPORT
BACKUP_DIR=/MYBSS/EP_FILES/BACKUP/USAGE_WLN/
LOG_DIR=/logs/urs_logs
TSTAMP_DIR=/appl/urpadm/job3-4/tstamp
NAMING_CONVENTION=urs_d_HousekeepingTFD_$(date +%F)

echo $(date +%F)": Housekeeping will start..." >> $LOG_DIR/$NAMING_CONVENTION.log;
## Housekeeping for dat directory
find $DAT_DIR -type f -ctime +3 | xargs -I {} mv {} $BACKUP_DIR 2> /dev/null;

## Housekeeping for fin directory
find $FIN_DIR -type f -ctime +3 | xargs -I {} mv {} $BACKUP_DIR 2> /dev/null;

## Housekeeping for backup directory
find $BACKUP_DIR -type f -ctime +7 -delete

## Housekeeping job4 - eod generated report
for i in $(ls $USAGE_DIR | grep .*"\.t3xt"$); do        ## check every .t3xt in usage dir
        touch -m $USAGE_DIR/$i                          ## update modify timestamp
        if [ $(stat -c %Y $USAGE_DIR/$i) -ge $(cat $TSTAMP_DIR/urs_d_eod_report_tstamp.txt | grep $i$ | cut -f2 -d" ") ]; then       ## if current timestamp is greater than equal to listed timestamp then delete the file
                echo "$USAGE_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/$NAMING_CONVENTION.log;
                sed -i "/$i$/d" $TSTAMP_DIR/urs_d_eod_report_tstamp.txt; ## remove entry in timestamp file
                rm $USAGE_DIR/$i;
        fi;
done

echo $(date +%F)": End of Housekeeping" >> $LOG_DIR/$NAMING_CONVENTION.log;
