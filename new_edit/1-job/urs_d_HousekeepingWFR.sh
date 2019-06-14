#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 6, 2019
# Version  : 1.1
#
# Description : Housekeping of Wilter filter reports
#
#----------------------------------------------------------
# Revision History
#
# Version: 1.1
# Author: John Rodel Villa
# Date: June 14, 2019
# Description: Changed ctime to mtime

# Source configuration file for variables
source /appl/urpadm/conf/urs_d_WFR.conf;

# Logging start of housekeeping process
echo "$(date "+%F %H:%M"): Housekeeping for Wireline filter reports will start..." >> $LOG_DIR/$NAMING_CONVENTION.log;

# Housekeeping for WLNFILTER_DIR
find $WLNFILTER_DIR -type f -mtime $WLNFILTER_DIR_AGING_DAYS -delete; # Delete files in REPORT_DIR after 30 days

# Logging end of housekeeping process
echo "$(date "+%F %H:%M"): End of housekeeping for Wireline filter reports" >> $LOG_DIR/$NAMING_CONVENTION.log;

# EOF
