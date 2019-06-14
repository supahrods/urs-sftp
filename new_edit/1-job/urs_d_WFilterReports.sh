#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 13, 2019
# Version  : 1.1
#
# Description : Counting Wilter filter reports
#
#----------------------------------------------------------
# Revision History:
#
# Version: 1.1
# Author: John Rodel Villa
# Date: June 14, 2019
# Description: Changed ctime to mtime

# Source configuration file for variables
source /appl/urpadm/conf/urs_d_WFR.conf;

# Logging start of counting process
echo "$(date "+%F %H:%M"): Showing filter reports for the last 3 days..." >> $LOG_DIR/$NAMING_CONVENTION.log;

# Logging number of files for the last 3 days
echo "$(date -d "2 days ago" +%F): $(find $WLNFILTER_DIR -type f -daystart -mtime 2 | wc -l) file/s" >> $LOG_DIR/$NAMING_CONVENTION.log;
echo "$(date -d "1 day ago" +%F): $(find $WLNFILTER_DIR -type f -daystart -mtime 1 | wc -l) file/s" >> $LOG_DIR/$NAMING_CONVENTION.log;
echo "$(date -d "today" +%F): $(find $WLNFILTER_DIR -type f -daystart -mtime 0 | wc -l) file/s" >> $LOG_DIR/$NAMING_CONVENTION.log;

# Logging end of counting process
echo "$(date "+%F %H:%M"): End of counting for Wireline filter reports" >> $LOG_DIR/$NAMING_CONVENTION.log;

# EOF
