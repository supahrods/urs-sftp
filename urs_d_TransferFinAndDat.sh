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
DAT_DIR=/MYBSS/EP_FILES/USAGE_WLN/DAT
FIN_DIR=/MYBSS/EP_FILES/USAGE_WLN/FIN
USAGE_DIR=/MYBSS/EP_FILES/USAGE_WLN
LOG_DIR=/logs/urs_logs
NAMING_CONVENTION=urs_d_TransferFinAndDat_$(date +%F)

## Process files then move to dat dir and fin dir
for i in $(ls $USAGE_DIR | grep .*"\.dat"$); do ## check every .dat file
        if [ -f $USAGE_DIR/$i.FIN ]; then               ## if there is a corresponding .dat.FIN
                echo $(date +%F)": $USAGE_DIR/$i.FIN exists for $USAGE_DIR/$i" >> $LOG_DIR/$NAMING_CONVENTION.log; ## log successful find
                touch $USAGE_DIR/$i && touch $USAGE_DIR/$i.FIN;
                mv $USAGE_DIR/$i $DAT_DIR && mv $USAGE_DIR/$i.FIN $FIN_DIR;     ## move .dat to dat dir and .dat.FIN to fin dir
        else
                echo $(date +%F)": $PROCESS_DIR/$i does not have any $PROCESS_DIR/$i.FIN" >> $LOG_DIR/$NAMING_CONVENTION.log; ## else, log unsuccessful
        fi;
done

## Process .dat.FIN files that do not have any .dat
## Another case when there is a .dat.FIN file while no .dat (however unlikely according to discussion)
for i in $(ls $USAGE_DIR | grep .*"\.dat\.FIN"$); do  ## check every .dat.FIN file in process dir
        if [ -f $USAGE_DIR/${i%.*} ]; then
                echo $(date +%F)": $USAGE_DIR/${i%.*} exists for $USAGE_DIR/$i" >> $LOG_DIR/$NAMING_CONVENTION.log;
                touch $USAGE_DIR/${i%.*} && touch $USAGE_DIR/$i;
                mv $USAGE_DIR/${i%.*} $DAT_DIR && mv $USAGE_DIR/$i $FIN_DIR;
        else
                echo $(date +%F)": $USAGE_DIR/$i does not have any .dat file" >> $LOG_DIR/$NAMING_CONVENTION.log; ## logging
        fi;
done

