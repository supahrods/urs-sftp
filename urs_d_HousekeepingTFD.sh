#!/bin/bash
DAT_DIR=/MYBSS/EP_FILES/USAGE_WLN/DAT
FIN_DIR=/MYBSS/EP_FILES/USAGE_WLN/FIN
USAGE_DIR=/MYBSS/EP_FILES/BACKUP/USAGE_WLN/
LOG_DIR=/tmp/urs_logs
TSTAMP_DIR=/home/urpadm/job3-4/tstamp

##Housekeeping job3
for i in $(ls $DAT_DIR | grep .*"\.dat"$); do           ## check every .dat in dat dir
        touch -m $DAT_DIR/$i                            ## update modify timestamp
        if [ $(stat -c %Y $DAT_DIR/$i) -ge $(cat $TSTAMP_DIR/timestamp3.txt | grep $i$ | cut -f2 -d" ") ]; then ## if current timestamp is greater than equal to listed timestamp then delete the file
                echo "$DAT_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/job3-4.log;
                sed -i "/$i$/d" $TSTAMP_DIR/timestamp3.txt; ## remove entry in timestamp file
                rm $DAT_DIR/$i;
        fi;
done
for i in $(ls $FIN_DIR | grep .*"\.dat\.FIN"$); do      ## check every .dat.FIN in fin dir
        touch -m $FIN_DIR/$i                            ## update modify timestamp
        if [ $(stat -c %Y $FIN_DIR/$i) -ge $(cat $TSTAMP_DIR/timestamp3.txt | grep $i$ | cut -f2 -d" ") ]; then ## if current timestamp is greater than equal to listed timestamp then delete the file
                echo "$FIN_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/job3-4.log;
                sed -i "/$i$/d" $TSTAMP_DIR/timestamp3.txt; ## remove entry in timestamp file
                rm $FIN_DIR/$i;
        fi;
done
for i in $(ls $USAGE_DIR | grep .*"\.dat".*$); do       ## check every .dat and .dat.FIN in usage dir
        touch -m $USAGE_DIR/$i                          ## update modify timestamp
        if [ $(stat -c %Y $USAGE_DIR/$i) -ge $(cat $TSTAMP_DIR/timestamp3.txt | grep $i$ | cut -f2 -d" ") ]; then ## if current timestamp is greater than equal to listed timestamp then delete the file
                echo "$USAGE_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/job3-4.log;
                sed -i "/$i$/d" $TSTAMP_DIR/timestamp3.txt; ## remove entry in timestamp file
                rm $USAGE_DIR/$i;
        fi;
done

## Housekeeping job4
for i in $(ls $USAGE_DIR | grep .*"\.t3xt"$); do        ## check every .t3xt in usage dir
        touch -m $USAGE_DIR/$i                          ## update modify timestamp
        if [ $(stat -c %Y $USAGE_DIR/$i) -ge $(cat $TSTAMP_DIR/timestamp4.txt | grep $i$ | cut -f2 -d" ") ]; then       ## if current timestamp is greater than equal to listed timestamp then delete the file
                echo "$USAGE_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/job3-4.log;
                sed -i "/$i$/d" $TSTAMP_DIR/timestamp4.txt; ## remove entry in timestamp file
                rm $USAGE_DIR/$i;
        fi;
done
for i in $(ls $USAGE_DIR | grep .*"\.txt"$); do         ## check every .txt in usage dir
        touch -m $USAGE_DIR/$i                          ## update modify timestamp
        if [ $(stat -c %Y $USAGE_DIR/$i) -ge $(cat $TSTAMP_DIR/timestamp4.txt | grep $i$ | cut -f2 -d" ") ]; then       ## if current timestamp is greater than equal to listed timestamp then delete the file
                echo "$USAGE_DIR/$i exceeded its lifetime and is now being deleted" >> $LOG_DIR/job3-4.log;
                sed -i "/$i$/d" $TSTAMP_DIR/timestamp4.txt; ## remove entry in timestamp file
                rm $USAGE_DIR/$i;
        fi;
done
