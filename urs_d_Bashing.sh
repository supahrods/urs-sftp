#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : January 22, 2019
# Version  : 1.3
#
# Description : Bashing of received .dat and .FIN files from EOD summary
#
#----------------------------------------------------------
# Revision History:
# Author: Joussyd M. Calupig
# Date: February 4, 2019
# Description: Updated path/directories and Headers
#----------------------------------------------------------

#!/bin/bash
DATE_FILENAME=$(date +%F_%H-%M-%S)_results.t3xt
DAT_DIR=/MYBSS/EP_FILES/USAGE_WLN/DAT
FIN_DIR=/MYBSS/EP_FILES/USAGE_WLN/FIN
USAGE_DIR=/MYBSS/EP_FILES/USAGE_WLN
REPORT_DIR=/MYBSS/EP_FILES/USAGE_WLN/REPORT
TSTAMP_DIR=/appl/urpadm/job3-4/tstamp
F_LIFETIME=604800
VALIDATED_FILES=$((0))
MISSING_FIX=$((0))
MISSING_FILES=$((0))
LOG_DIR=/logs/urs_logs
NAMING_CONVENTION=urs_d_Bashing__$(date +%F)

echo $(date +%F)": Starting Report Generation" >> $LOG_DIR/$NAMING_CONVENTION.log
## Process eod
for i in $(cat $USAGE_DIR/*.txt 2> /dev/null | grep .*\.dat); do
	if ls $DAT_DIR | grep -q $i; then
		if ls $FIN_DIR | grep -q $i; then
			VALIDATED_FILES=$(($VALIDATED_FILES+1));
			LIST_VALIDATED="$LIST_VALIDATED $i";
 		fi;
	elif ls $USAGE_DIR | grep -q $i; then
		MISSING_FIX=$(($MISSING_FIX+1));
		LIST_WOFIN="$LIST_WOFIN $i";
	else
		MISSING_FILES=$(($MISSING_FILES+1));
		LIST_MISSING="$LIST_MISSING $i";
	fi;
done

## Output to results file
echo -e "------------------------- Detailed Summary Report ----------------------------------------------------------------" >> $USAGE_DIR/$DATE_FILENAME;
echo -e "Date of Report Generation:		$(date)" >> $REPORT_DIR/$DATE_FILENAME;
echo -e "Number of Validated File(s):		$VALIDATED_FILES" >> $REPORT_DIR/$DATE_FILENAME;
echo -e "Number of File(s) without FIN/DAT:	$MISSING_FIX" >> $REPORT_DIR/$DATE_FILENAME;
echo -e "Number of Missing File(s):		$MISSING_FILES" >> $REPORT_DIR/$DATE_FILENAME;
echo -e "Total Tally:				$(($VALIDATED_FILES+$MISSING_FIX+$MISSING_FILES))\n" >> $REPORT_DIR/$DATE_FILENAME;
echo -e "--------- List of Validated File(s) ----------------------------------" >> $REPORT_DIR/$DATE_FILENAME;
echo $LIST_VALIDATED | tr " " "\n" >> $REPORT_DIR/$DATE_FILENAME;
echo -e "\n--------- List of File(s) Without FIN/DAT ----------------------------" >> $REPORT_DIR/$DATE_FILENAME;
echo $LIST_WOFIN | tr " " "\n" >> $REPORT_DIR/$DATE_FILENAME;
echo -e "\n--------- List of Missing File(s) ------------------------------------" >> $REPORT_DIR/$DATE_FILENAME;
echo $LIST_MISSING | tr " " "\n" >> $REPORT_DIR/$DATE_FILENAME;
echo -e "\n------------------------- End of Summary Report ------------------------------------------------------------------" >> $REPORT_DIR/$DATE_FILENAME;

## Move file output report to wlg usage dir
#rename 's/.txt/.txt.done/' $USAGE_DIR/*.txt 2> /dev/null;
echo "$(stat -c %Y $REPORT_DIR/$DATE_FILENAME) $(($(stat -c %Y $REPORT_DIR/$DATE_FILENAME)+$F_LIFETIME)) $REPORT_DIR/$DATE_FILENAME" >> $TSTAMP_DIR/urs_d_eod_report_tstamp.txt; ## record filename, timestamp today, timestamp 7 days after
echo $(date +%F)" : End of Report Generation" >> $LOG_DIR/$NAMING_CONVENTION.log
