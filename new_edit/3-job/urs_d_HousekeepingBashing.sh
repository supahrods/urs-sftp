#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 5, 2019
# Version  : 1.0
#
# Description : Housekeping of bashing reports and EOD files
#
#----------------------------------------------------------

# Source configuration file for variables
source /appl/urpadm/job3-4/urs_d_Bashing.conf;

# Logging start of housekeeping process
echo "$(date "+%F %H:%M"): Housekeeping for bash reports and EOD files will start..." >> $LOG_DIR/$NAMING_CONVENTION.log;

# Housekeeping for REPORT_DIR
# NOTE: Timestamp is reliant on ctime, do not change attributes of the file e.g. name, owner, permission, location, and content.
# If file is not deleted within specified date, it is a good indication that the file is tampered. Check attributes.
find $REPORT_DIR -type f -ctime $REPORT_DIR_AGING_DAYS -delete; # Delete files in REPORT_DIR after 30 days

# Housekeeping in USAGE_DIR for EOD files
# NOTE: Timestamp is reliant on ctime, do not change attributes of the file e.g. name, owner, permission, location, and content.
# If file is not deleted within specified date, it is a good indication that the file is tampered. Check attributes.
# Deletion is dependent on file name, if the pattern below is not anymore applicable, the files will not be deleted.
find $USAGE_DIR -type f -name "*SUMMARY*" -ctime $USAGE_DIR_AGING_DAYS -delete; # Delete files in USAGE_DIR with the file name pattern *SUMMARY* after 7 days

# Logging end of housekeeping process
echo "$(date "+%F %H:%M"): End of housekeeping for bash reports and EOD files" >> $LOG_DIR/$NAMING_CONVENTION.log;

# EOF
