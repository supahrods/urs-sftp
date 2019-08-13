#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 5, 2019
# Version  : 1.1
#
# Description : Housekeping of bashing reports and EOD files
#
#----------------------------------------------------------
# Revision History:
#
# Version: 1.1
# Author: John Rodel Villa
# Date: June 14, 2019
# Description: Changed ctime to mtime

# Source configuration file for variables
source /appl/urpadm/conf/urs_d_Bashing.conf;

# Logging start of housekeeping process
echo "$(date "+%F %H:%M"): Housekeeping for bash reports and EOD files will start..." >> $LOG_DIR/$LOG_NAMING_CONV.log;

# Housekeeping for REPORT_DIR
find $REPORT_DIR -type f -mtime $REPORT_DIR_AGING_DAYS -delete; # Delete files in REPORT_DIR after 30 days

# Housekeeping in USAGE_DIR for EOD files
# NOTE: Deletion is dependent on file name, if the pattern below is not anymore applicable, the files will not be deleted.
find $USAGE_DIR -type f -name "*SUMMARY*" -mtime $USAGE_DIR_AGING_DAYS -delete; # Delete files in USAGE_DIR with the file name pattern *SUMMARY* after 7 days

# Logging end of housekeeping process
echo "$(date "+%F %H:%M"): End of housekeeping for bash reports and EOD files" >> $LOG_DIR/$LOG_NAMING_CONV.log;

# EOF
