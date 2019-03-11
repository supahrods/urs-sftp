#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 7, 2019
# Version  : 1.0
#
# Description : Housekeping of URS log files
#
#----------------------------------------------------------

# Source configuration file for variables
source /appl/urpadm/job1-2/urs_d_logs.conf;

# Logging start of housekeeping process
echo "$(date "+%F %H:%M"): Housekeeping for URS log files will start..." >> $LOG_DIR/$NAMING_CONVENTION.log;

# Housekeeping for LOG_DIR
# NOTE: Timestamp is reliant on ctime, do not change attributes of the file e.g. name, owner, permission, location, and content.
# If file is not deleted within specified date, it is a good indication that the file is tampered. Check attributes.
find $LOG_DIR -type f -ctime $LOG_DIR_AGING_DAYS -delete; # Delete files in LOG_DIR after 60 days

# Logging end of housekeeping process
echo "$(date "+%F %H:%M"): End of housekeeping for URS log files" >> $LOG_DIR/$NAMING_CONVENTION.log;

# EOF
