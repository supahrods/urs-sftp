#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 5, 2019
# Version  : 1.4
#
# Description : Housekeeping of .dat and .FIN files
#
#----------------------------------------------------------
# Revision History:
#
# Version: 1.4
# Author: John Rodel Villa
# Date: March 5, 2019
# Description: Updated script to reflect URS phase 2 changes
#
# Version: 1.3
# Author: Joussyd M. Calupig
# Date: February 4, 2019
# Description: Updated path/directories and Headers
#----------------------------------------------------------

# Source configuration file for variables
source /appl/urpadm/job3-4/urs_d_TFD.conf;

# Logging start of housekeeping process
echo "$(date "+%F %H:%M"): Housekeeping for TFD will start..." >> $LOG_DIR/$NAMING_CONVENTION.log;

# Housekeeping for DAT_DIR
# NOTE: Timestamp is reliant on ctime, do not change attributes of the file e.g. name, owner, permission, location, and content.
# If file is not moved within specified date, it is a good indication that the file is tampered. Check attributes.
find $DAT_DIR -type f -ctime +2 | xargs -I {} mv {} $BACKUP_DIR 2> /dev/null; # Move files from DAT_DIR to BACKUP_DIR after 3 days

# Housekeeping for fin directory
# NOTE: Timestamp is reliant on ctime, do not change attributes of the file e.g. name, owner, permission, location, and content.
# If file is not moved within specified date, it is a good indication that the file is tampered. Check attributes.
find $FIN_DIR -type f -ctime +2 | xargs -I {} mv {} $BACKUP_DIR 2> /dev/null; # Move files from FIN_DIR to BACKUP_DIR after 3 days

# Housekeeping for BACKUP_DIR
# NOTE: Timestamp is reliant on ctime, do not change attributes of the file e.g. name, owner, permission, location, and content.
# If file is not deleted within specified date, it is a good indication that the file is tampered. Check attributes.
find $BACKUP_DIR -type f -ctime +6 -delete; # Delete files in BACKUP_DIR after 7 days

# Logging end of housekeeping process
echo "$(date "+%F %H:%M"): End of housekeeping for TFD" >> $LOG_DIR/$NAMING_CONVENTION.log;

# EOF
