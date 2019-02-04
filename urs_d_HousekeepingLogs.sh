#----------------------------------------------------------
# Author   : John Rodel Villa
# Date     : January 22, 2019
# Version  : 1.3
#
# Description : Housekeeping of logs
#
#----------------------------------------------------------
# Revision History:
# Author: Joussyd M. Calupig
# Date: February 4, 2019
# Description: Updated path/directories and Headers
#----------------------------------------------------------

#!/bin/bash
LOG_DIR=/logs/urs_logs

touch -d "2 month ago" ${LOG_DIR}/date_check;
find $LOG_DIR -type f ! -newer ${LOG_DIR}/date_check | xargs rm -rf 2> /dev/null;
