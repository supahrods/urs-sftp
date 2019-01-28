#!/bin/bash

touch -d "last week" /tmp/urs_logs/date_check;
find /tmp/urs_logs -type f ! -newer /tmp/urs_logs/date_check | xargs rm -rf 2> /dev/null;
