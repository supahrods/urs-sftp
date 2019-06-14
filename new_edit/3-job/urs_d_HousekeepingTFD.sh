#!/bin/bash
#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : March 5, 2019
# Version  : 1.5
#
# Description : Housekeeping of .dat and .FIN files
#
#----------------------------------------------------------
# Revision History:
#
# Version: 1.5
# Author: John Rodel Villa
# Date: June 14, 2019
# Description: Changed ctime to mtime
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
source /appl/urpadm/conf/urs_d_TFD.conf;

# Logging start of housekeeping process
echo "$(date "+%F %H:%M"): Housekeeping for TFD will start..." >> $LOG_DIR/$NAMING_CONVENTION.log;

# Housekeeping for DAT_DIR
find $DAT_DIR -type f -mtime $DAT_DIR_AGING_DAYS | xargs -I {} mv {} $BACKUP_DIR 2> /dev/null; # Move files from DAT_DIR to BACKUP_DIR after 3 days

# Housekeeping for fin directory
find $FIN_DIR -type f -mtime $FIN_DIR_AGING_DAYS | xargs -I {} mv {} $BACKUP_DIR 2> /dev/null; # Move files from FIN_DIR to BACKUP_DIR after 3 days

# Housekeeping for BACKUP_DIR
find $BACKUP_DIR -type f -mtime $BACKUP_DIR_AGING_DAYS -delete; # Delete files in BACKUP_DIR after 4 days

# Logging end of housekeeping process
echo "$(date "+%F %H:%M"): End of housekeeping for TFD" >> $LOG_DIR/$NAMING_CONVENTION.log;

# EOF
