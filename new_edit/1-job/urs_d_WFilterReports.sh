#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 13, 2019
# Version  : 1.0
#
# Description : Counting Wilter filter reports
#
#----------------------------------------------------------

# Source configuration file for variables
source /appl/urpadm/job1-2/urs_d_WFR.conf;

# Logging start of counting process
echo "$(date "+%F %H:%M"): Showing filter reports for the last 3 days..." >> $LOG_DIR/$NAMING_CONVENTION.log;

# Logging number of files for the last 3 days
echo "$(date -d "2 days ago" +%F): $(find $WLNFILTER_DIR -type f -daystart -ctime 2 | wc -l) file/s" >> $LOG_DIR/$NAMING_CONVENTION.log;
echo "$(date -d "1 day ago" +%F): $(find $WLNFILTER_DIR -type f -daystart -ctime 1 | wc -l) file/s" >> $LOG_DIR/$NAMING_CONVENTION.log;
echo "$(date -d "today" +%F): $(find $WLNFILTER_DIR -type f -daystart -ctime 0 | wc -l) file/s" >> $LOG_DIR/$NAMING_CONVENTION.log;

# Logging end of counting process
echo "$(date "+%F %H:%M"): End of counting for Wireline filter reports" >> $LOG_DIR/$NAMING_CONVENTION.log;

# EOF
