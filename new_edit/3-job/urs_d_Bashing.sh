#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 5, 2019
# Version  : 1.5
#
# Description : Bashing of received .dat and .FIN files from EOD summary
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
source /appl/urpadm/conf/urs_d_Bashing.conf;

# Logging start of bashing process
echo "$(date "+%F %H:%M"): Starting EOD bashing report generation..." >> $LOG_DIR/$NAMING_CONVENTION.log;

# Initialize file counter
FCOUNTER=0;

# Report generation process
if [ $(ls $USAGE_DIR | grep .*\.txt$ | wc -w) == 0 ]; then
        echo "$(date "+%F %H:%M"): No EOD report has been processed!" >> $LOG_DIR/$NAMING_CONVENTION.log
	touch $REPORT_DIR/${FCOUNTER}_${DATE_FILENAME};
else
	for b in $(ls $USAGE_DIR | grep .*\.txt$); do
		# Check every .dat inside the EOD report then count number of validated, missing fixes, and missing files
		for i in $(cat $USAGE_DIR/$b.txt 2> /dev/null | grep .*\.dat); do # Check every content of EOD file that ends with .dat
			if ls $DAT_DIR | grep -q $i; then # Check if content is found as a file inside DAT_DIR
				if ls $FIN_DIR | grep -q $i; then # Check if content is found as a file inside FIN_DIR (not including .FIN)
					VALIDATED_FILES=$(($VALIDATED_FILES+1)); # If found on both, increment number of validated files
	 			fi;
			elif ls $USAGE_DIR | grep -q $i; then # Check if content is found inside USAGE_DIR
				MISSING_FIX=$(($MISSING_FIX+1)); # If found, increment number of missing fixes
				LIST_WOFIN="$LIST_WOFIN $i"; # Add the file name to a missing fixes list
			else
				MISSING_FILES=$(($MISSING_FILES+1)); # Else, file did not reach URS and tagged as missing
				LIST_MISSING="$LIST_MISSING $i"; # Add the file name to a missing files list
			fi;
		done

		# Generate a report from tally of validated files, missing fixes, and missing files
		echo -e "------------------------- Detailed Summary Report ----------------------------------------------------------------" >> $REPORT_DIR/${FCOUNTER}_${DATE_FILENAME};
		echo -e "Date of Report Generation:		$(date)" >> $REPORT_DIR/${FCOUNTER}_${DATE_FILENAME};
		echo -e "Number of Validated File(s):		$VALIDATED_FILES" >> $REPORT_DIR/${FCOUNTER}_${DATE_FILENAME};
		echo -e "Number of File(s) without FIN/DAT:	$MISSING_FIX" >> $REPORT_DIR/${FCOUNTER}_${DATE_FILENAME};
		echo -e "Number of Missing File(s):		$MISSING_FILES" >> $REPORT_DIR/${FCOUNTER}_${DATE_FILENAME};
		echo -e "Total Tally:				$(($VALIDATED_FILES+$MISSING_FIX+$MISSING_FILES))\n" >> $REPORT_DIR/${FCOUNTER}_${DATE_FILENAME};
		echo -e "--------- List of File(s) Without FIN/DAT ----------------------------" >> $REPORT_DIR/${FCOUNTER}_${DATE_FILENAME};
		echo $LIST_WOFIN | tr " " "\n" >> $REPORT_DIR/${FCOUNTER}_${DATE_FILENAME};
		echo -e "\n--------- List of Missing File(s) ------------------------------------" >> $REPORT_DIR/${FCOUNTER}_${DATE_FILENAME};
		echo $LIST_MISSING | tr " " "\n" >> $REPORT_DIR/${FCOUNTER}_${DATE_FILENAME};
		echo -e "\n------------------------- End of Summary Report ------------------------------------------------------------------" >> $REPORT_DIR/${FCOUNTER}_${DATE_FILENAME};

		# Increase file counter value
		FCOUNTER=$(($FCOUNTER+1));
	done;

	# Rename EOD file to signify it has been processed
	# NOTE: This is important to happen. Without changing file extension, it will still be processed on the next run of the script
	rename 's/.txt/.txt.done/' $USAGE_DIR/*.txt 2> /dev/null;
fi;

# Logging end of bashing process
echo "$(date "+%F %H:%M"): End of EOD bashing report generation" >> $LOG_DIR/$NAMING_CONVENTION.log;

# EOF
