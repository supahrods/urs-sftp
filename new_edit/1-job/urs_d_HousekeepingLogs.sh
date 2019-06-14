#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 7, 2019
# Version  : 1.1
#
# Description : Housekeping of URS log files
#
#----------------------------------------------------------
# Revision History
#
# Version: 1.1
# Author: John Rodel Villa
# Date: June 14, 2019
# Description: Changed ctime to mtime

# Source configuration file for variables
source /appl/urpadm/conf/urs_d_logs.conf;

# Logging start of housekeeping process
echo "$(date "+%F %H:%M"): Housekeeping for URS log files will start..." >> $LOG_DIR/$NAMING_CONVENTION.log;

# Housekeeping for LOG_DIR
find $LOG_DIR -type f -mtime $LOG_DIR_AGING_DAYS -delete; # Delete files in LOG_DIR after 60 days

# Logging end of housekeeping process
echo "$(date "+%F %H:%M"): End of housekeeping for URS log files" >> $LOG_DIR/$NAMING_CONVENTION.log;

# EOF
