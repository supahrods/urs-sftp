#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 7, 2019
# Version  : 1.4
#
# Description : Housekeeping for long duration call files
#
#----------------------------------------------------------
# Revision History:
#
# Version: 1.4
# Author: John Rodel Villa
# Date: March 7, 2019
# Description: Updated script to reflect URS phase 2 changes
#
# Version: 1.3
# Author: Joussyd M. Calupig
# Date: February 4, 2019
# Description: Updated path/directories and Headers
#----------------------------------------------------------

# Source configuration file for variables
source /appl/urpadm/conf/urs_d_LDC.conf;

# Logging start of LDC housekeeping process
echo "$(date "+%F %H:%M"): Housekeeping for LDC files will start..." >> $LOG_DIR/$NAMING_CONVENTION.log;

# Housekeeping for FILE_ERROR_DIR
# NOTE: Timestamp is reliant on ctime, do not change attributes of the file e.g. name, owner, permission, location, and content.
# If file is not deleted within specified date, it is a good indication that the file is tampered. Check attributes.
find $FILE_ERROR_DIR -type f -ctime $FILE_ERROR_DIR_AGING_DAYS -delete; # Delete files in FILE_ERROR_DIR after 180 days

# Housekeeping for ARCHIVE_DIR
# NOTE: Timestamp is reliant on ctime, do not change attributes of the file e.g. name, owner, permission, location, and content.
# If file is not deleted within specified date, it is a good indication that the file is tampered. Check attributes.
find $ARCHIVE_DIR -type f -ctime $ARCHIVE_DIR_AGING_DAYS -delete; # Delete files in ARCHIVE_DIR after 180 days

# Housekeeping for MERGE_DIR
# NOTE: Timestamp is reliant on ctime, do not change attributes of the file e.g. name, owner, permission, location, and content.
# If file is not deleted within specified date, it is a good indication that the file is tampered. Check attributes.
find $MERGE_DIR -type f -ctime $MERGE_DIR_AGING_DAYS -delete; # Delete files in MERGE_DIR after 7 days

# Logging end of LDC housekeeping process
echo "$(date "+%F %H:%M"): Housekeeping for LDC files has finished" >> $LOG_DIR/$NAMING_CONVENTION.log;
