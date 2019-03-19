#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 6, 2019
# Version  : 1.0
#
# Description : Housekeping of Wilter filter reports
#
#----------------------------------------------------------

# Source configuration file for variables
source /appl/urpadm/conf/urs_d_WFR.conf;

# Logging start of housekeeping process
echo "$(date "+%F %H:%M"): Housekeeping for Wireline filter reports will start..." >> $LOG_DIR/$NAMING_CONVENTION.log;

# Housekeeping for WLNFILTER_DIR
# NOTE: Timestamp is reliant on ctime, do not change attributes of the file e.g. name, owner, permission, location, and content.
# If file is not deleted within specified date, it is a good indication that the file is tampered. Check attributes.
find $WLNFILTER_DIR -type f -ctime $WLNFILTER_DIR_AGING_DAYS -delete; # Delete files in REPORT_DIR after 30 days

# Logging end of housekeeping process
echo "$(date "+%F %H:%M"): End of housekeeping for Wireline filter reports" >> $LOG_DIR/$NAMING_CONVENTION.log;

# EOF
