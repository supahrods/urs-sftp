#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 5, 2019
# Version  : 1.5
#
# Description : Transfers .dat and .FIN files into its respective directory
#
#----------------------------------------------------------
# Revision History:
#
# Version: 1.5
# Author: John Rodel Villa
# Date: March 5, 2019
# Description: Updated script to reflect URS phase 2 changes
#
# Version: 1.4
# Author: Joussyd M. Calupig
# Date: February 4, 2019
# Description: Updated path/directories and headers
#----------------------------------------------------------

# Source configuration file for variables
source /appl/urpadm/conf/urs_d_TFD.conf;

# Run through each file and check a .dat.FIN for each .dat file then move to respective folders
echo "$(date "+%F %H:%M") Processing each .dat file, checking if a corresponding .dat.FIN is present." >> $LOG_DIR/$NAMING_CONVENTION.log; # Logging the process
for i in $(ls $USAGE_DIR | grep .*"\.dat"$); do	# Check each .dat file
	if [ -f $USAGE_DIR/$i.FIN ]; then # If there is a corresponding .dat.FIN
		echo "$USAGE_DIR/$i.FIN exists for $USAGE_DIR/$i" >> $LOG_DIR/$NAMING_CONVENTION.log; # Logging a successful find
		touch $USAGE_DIR/$i && touch $USAGE_DIR/$i.FIN; # Reinitialize new timestamp for storage
		mv $USAGE_DIR/$i $DAT_DIR && mv $USAGE_DIR/$i.FIN $FIN_DIR; # Move .dat to DAT_DIR and .dat.FIN to FIN_DIR
	else
		echo "$PROCESS_DIR/$i does not have any $PROCESS_DIR/$i.FIN" >> $LOG_DIR/$NAMING_CONVENTION.log; # Logging an unsuccessful find
	fi;
	FILE_COUNTER=$(($FILE_COUNTER + 1)); # Incrementing number of files processed
done
echo "$(date "+%F %H:%M") $FILE_COUNTER file/s has been processed at run time." >> $LOG_DIR/$NAMING_CONVENTION.log; # Logging number of files processed

# Reinitialize FILE_COUNTER variable
FILE_COUNTER=0;

# Run through each file and check a .dat for each .dat.FIN file then move to respective folders
# NOTE: This case is unlikely, it is put here in case it happens
echo "$(date "+%F %H:%M") Processing each .dat.FIN file, checking if a corresponding .dat is present." >> $LOG_DIR/$NAMING_CONVENTION.log; # Logging the process
for i in $(ls $USAGE_DIR | grep .*"\.dat\.FIN"$); do # Check each .dat.FIN file
        if [ -f $USAGE_DIR/${i%.*} ]; then # If there is a corresponding .dat
		echo "$USAGE_DIR/${i%.*} exists for $USAGE_DIR/$i" >> $LOG_DIR/$NAMING_CONVENTION.log; # Logging a successful find
		touch $USAGE_DIR/${i%.*} && touch $USAGE_DIR/$i; # Reinitialize new timestamp for storage
		mv $USAGE_DIR/${i%.*} $DAT_DIR && mv $USAGE_DIR/$i $FIN_DIR; # Move .dat.FIN to FIN_DIR and .dat to DAT_DIR
	else
                echo "$USAGE_DIR/$i does not have any .dat file" >> $LOG_DIR/$NAMING_CONVENTION.log; # Logging an unsuccessful find
        fi;
	FILE_COUNTER=$(($FILE_COUNTER + 1)); # Incrementing number of files processed
done
echo "$(date "+%F %H:%M") $FILE_COUNTER file/s has been processed at run time." >> $LOG_DIR/$NAMING_CONVENTION.log; # Logging number of files processed

# EOF
