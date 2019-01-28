#!/bin/bash
DATE_FILENAME=$(date +%F_%H-%M-%S)_results.t3xt
RECEIVE_DIR=/home/urpadm/job3-4/receiving
PROCESS_DIR=/home/urpadm/job3-4/processingeod
OUTPUT_DIR=/home/urpadm/job3-4/output/eod_results
DAT_DIR=/MYBSS/EP_FILES/USAGE_WLN/DAT
FIN_DIR=/MYBSS/EP_FILES/USAGE_WLN/FIN
USAGE_DIR=/MYBSS/EP_FILES/BACKUP/USAGE_WLN
TSTAMP_DIR=/home/urpadm/job3-4/tstamp
F_LIFETIME=604800
VALIDATED_FILES=$((0))
MISSING_FIX=$((0))
MISSING_FILES=$((0))

## Check if uploading then move from receiving to processing
for i in $(ls $RECEIVE_DIR | grep .*"\.txt"$); do
	if ! lsof | grep $RECEIVE_DIR/$i; then
		echo "$(stat -c %Y $RECEIVE_DIR/$i) $(($(stat -c %Y $RECEIVE_DIR/$i)+$F_LIFETIME)) $i" >> $TSTAMP_DIR/timestamp4.txt; ## record filename, timestamp today, timestamp 7 days after
  		mv $RECEIVE_DIR/$i $PROCESS_DIR;
 	fi;
done

## Process eod
for i in $(cat $PROCESS_DIR/*.txt 2> /dev/null | grep .*\.dat); do
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
echo -e "------------------------- Detailed Summary Report ----------------------------------------------------------------" >> $OUTPUT_DIR/$DATE_FILENAME;
echo -e "Date of Report Generation:		$(date)" >> $OUTPUT_DIR/$DATE_FILENAME;
echo -e "Number of Validated File(s):		$VALIDATED_FILES" >> $OUTPUT_DIR/$DATE_FILENAME;
echo -e "Number of File(s) without FIN/DAT:	$MISSING_FIX" >> $OUTPUT_DIR/$DATE_FILENAME;
echo -e "Number of Missing File(s):		$MISSING_FILES" >> $OUTPUT_DIR/$DATE_FILENAME;
echo -e "Total Tally:				$(($VALIDATED_FILES+$MISSING_FIX+$MISSING_FILES))\n" >> $OUTPUT_DIR/$DATE_FILENAME;
echo -e "--------- List of Validated File(s) ----------------------------------" >> $OUTPUT_DIR/$DATE_FILENAME;
echo $LIST_VALIDATED | tr " " "\n" >> $OUTPUT_DIR/$DATE_FILENAME;
echo -e "\n--------- List of File(s) Without FIN/DAT ----------------------------" >> $OUTPUT_DIR/$DATE_FILENAME;
echo $LIST_WOFIN | tr " " "\n" >> $OUTPUT_DIR/$DATE_FILENAME;
echo -e "\n--------- List of Missing File(s) ------------------------------------" >> $OUTPUT_DIR/$DATE_FILENAME;
echo $LIST_MISSING | tr " " "\n" >> $OUTPUT_DIR/$DATE_FILENAME;
echo -e "\n------------------------- End of Summary Report ------------------------------------------------------------------" >> $OUTPUT_DIR/$DATE_FILENAME;

## Move file output report to wlg usage dir
mv $PROCESS_DIR/*.txt $USAGE_DIR 2> /dev/null;
mv $OUTPUT_DIR/$DATE_FILENAME $USAGE_DIR 2> /dev/null;
echo "$(stat -c %Y $USAGE_DIR/$DATE_FILENAME) $(($(stat -c %Y $USAGE_DIR/$DATE_FILENAME)+$F_LIFETIME)) $USAGE_DIR/$DATE_FILENAME" >> $TSTAMP_DIR/timestamp4.txt; ## record filename, timestamp today, timestamp 7 days after
