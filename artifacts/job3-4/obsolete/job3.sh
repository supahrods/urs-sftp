#!/bin/bash
S3_DAT=s3://rods-sample/dat/
S3_FIN=s3://rods-sample/fin/
S3_WLG_USAGE=s3://rods-sample/wlg_usage/
S3_DAT_ITEMS=$(aws s3 ls $S3_DAT 2> /dev/null | tr -s " " | cut -f4 -d" " | awk NF)
S3_FIN_ITEMS=$(aws s3 ls $S3_FIN 2> /dev/null | tr -s " " | cut -f4 -d" " | awk NF)
S3_WLG_USAGE_ITEMS=$(aws s3 ls $S3_WLG_USAGE 2> /dev/null | tr -s " " | cut -f4 -d" " | awk NF)
LOG_DIR=/tmp/urs_logs

## Process files then move to fin and dat directories
## Irrelevent files will retain in wlg_usage
for i in $(echo $S3_WLG_USAGE_ITEMS | tr " " "\n" | grep .*"\.dat"$); do
	if echo $S3_WLG_USAGE_ITEMS | tr " " "\n" | grep -q $i.FIN; then
		echo "$(echo $S3_WLG_USAGE_ITEMS | tr " " "\n" | grep $i.FIN) exists for $(echo $S3_WLG_USAGE_ITEMS | tr " " "\n" | grep $i)" >> $LOG_DIR/job3.log;
		aws s3 mv --quiet $S3_WLG_USAGE$i $S3_DAT 2> /dev/null && aws s3 mv --quiet $S3_WLG_USAGE$i.FIN $S3_FIN 2> /dev/null;
	else
		echo "$(echo $S3_WLG_USAGE_ITEMS | tr " " "\n" | grep $i) does not have any $(echo $S3_WLG_USAGE_ITEMS | tr " " "\n" | grep $i).FIN" >> $LOG_DIR/job3.log;
	fi;
done

##Insert date in log
echo $(date) >> $LOG_DIR/job3.log
echo >> $LOG_DIR/job3.log
