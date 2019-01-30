#!/bin/bash
LOG_DIR=/tmp/urs_logs

touch -d "2 month ago" ${LOG_DIR}/date_check;
find $LOG_DIR -type f ! -newer ${LOG_DIR}/date_check | xargs rm -rf 2> /dev/null;
