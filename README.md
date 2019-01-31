TCOE Overview Document


## Unified Repository Server have 4 main features:

1. Processing of Long Duration Calls
2. Housekeeping of Wireline Filter Reports
3. Housekeeping and Transfering of .dat and .dat.FIN files into its designated directories
4. Bashing of received .dat files with the End of Day Summary reports

## These features can be perfomed by running the following scripts:
- urs_d_TransferFinAndDat.sh
- urs_d_Bashing.sh
- urs_d_LongDurationCalls.sh
- urs_d_LongDurationCallsChecking.sh
- urs_d_HousekeepingLDC.sh
- urs_d_HousekeepingTFD.sh
- urs_d_HousekeepingLogs.sh

# ------------------------
### urs_d_TransferFinAndDat.sh


![d6def3923fbdd6ffefd95d0c6bcb76de.png](:/0df45d2be2e5490782581b61d603c1cc)
The image above shows the required variables by the script
**RECEIVE_DIR** - This is where upstreams will transfer .dat and .fin files
**PROCESS_DIR** - This is where the processing of files happen 
**OUTPUT_DIR** - This is the directory where the output of the processed files are located
**DAT_DIR** - This is where all the .dat files will be transferred
**FIN_DIR** - This is where all the .FIN files will be transferred
**USAGE_DIR** - This is where invalidated .dat/.dat.FIN files will be transferred  
**LOG_DIR** - This is where the logs will be located
**TSTAMP_DIR** - This is where the timestamp/aging of every file will be located 
**F_LIFETIME** - This is where you will set the file lifespan. (in EPOCH format. ex: 604800)

This script will receive all files at RECEIVE_DIR then move them to PROCESS_DIR, after processing, move files to OUTPUT_DIR

***Psuedo Code***

1. Check if file is still uploading, if not, then move the file from receiving to processing.
2. Check every .dat file in process_dir, if there is a corresponding .dat.FIN, log successful find, if none, log unsuccessful find
3. Move .dat to dat_dir and .dat.FIN to fin_dir
4. Move .dat with no .dat.FIN file to wlg_usage
5. Process .dat.FIN files that do not have any .dat (while unlikely, this is a scenario catch).
6. If found .dat for a respective .dat.FIN then move to dat_dir and fin_dir and if not log unsuccessful and move .dat.FIN to wlg_usage


# ------------------------
### urs_d_Bashing.sh



![e134b62c01b73f12b5a4a0b73feeac48.png](:/25f03e5200c44abc8634174c7f83471c)
The image above shows the required variables by the script

**DATE_FILENAME** - Name convention for the output report file
**RECEIVE_DIR** - This is where upstreams will transfer .dat and .fin files
**PROCESS_DIR** - This is where the processing of files happen 
**OUTPUT_DIR** - This is the directory where the output of the processed files are located
**DAT_DIR** - This is where all the .dat files will be transferred
**FIN_DIR** - This is where all the .FIN files will be transferred
**USAGE_DIR** - This is where the report wil be transferred
**LOG_DIR** - This is where the logs will be located
**TSTAMP_DIR** - This is where the timestamp/aging of every file will be located 
**F_LIFETIME** - This is where you will set the aging of a file. (in EPOCH format. ex: 604800)
**VALIDATED_FILES* - A counter for the number of validated files
**MISSING_FIX** - A counter for the number of missing fixes i.e. missing .dat.FIN for a .dat and vice versa
**MISSING_FILES** - A counter for the number of missing files i.e. not seen in either dat_dir or fin_dir

***Psuedo Code***

1. Check if file is still uploading, if not, then move the file from receiving to processing.
2. For every entry in EOD file, check in dat_dir then check in fin_dir if to validate the success
3. Else, check in wlg_usage and log a missing fix. Else, file is missing.
3. Write the output in the results file
4. Move file output report to wlg_usage directory


# ------------------------
### urs_d_LongDurationCalls.sh


![3d7772fc549d30d05360771913f24271.png](:/e83d04cdc9724f30be5513284c63e678)

The image above shows the required variables by the script

**TSTAMP_DIR** - This is where the timestamp/aging of every file will be located 
**RECEIVE_DIR** - This is where upstreams will transfer .dat and .fin files
**WLNFILTER_DIR** - This is wireline filter reports will be transferred
**WLNFILTER_ARCHIVE_DIR** - This is where amdocs mediation will transfer archived files
**FILE_ERROR_DIR** - This is the directory where entries not bound by the cases will be transferred
**CASE1_DIR** - Landing area for case1 entries (see below)
**CASE2_DIR** - Landing area for case2 entries (see below)
**CASE3_DIR** - Landing area for case3 entries (see below)
**CASE4_DIR** - Landing area for case4 entries (see below)
**CASE5_DIR** - Landing area for case5 entries (see below)
**CASE6_DIR** - Landing area for case6 entries (see below)
**LOG_DIR** - This is where the logs will be located
**F_LIFETIME** - This is where you will set the aging of a file. (in EPOCH format. ex: 604800)
**POSSIBLE_SUCCESS** - A directory for entries that has subsequent entry in the case folder e.g. case1_dir, case2_dir, etc...
**SUCCESS_DIR** - This is where successfull entries will be transferred i.e. successful by calls being complete or by being edited
**NAMING_CONVENTION** - Naming convention for log files
 

***Psuedo Code***

1. Segregate entries according to acr values. 
There are 6 cases:
case1 - Missing end value (true,1,false)
case2 - Missing first value (false,2,true)
case3 - Missing middle value (true,1,true)
case4 - Single first value entry (only false,2,true present)
case5 - Single middle value entry (only true,1,true present)
case6 - Single end value entry (only true,1,true present)
2. Move entries to their respective cases
3. Issue their current timestamp, and issue retention timestamp (7 days)


# ------------------------
### urs_d_LongDurationCallsChecking.sh
![58e9a68a6a7a97cddbbd62caca77ed0d.png](:/ee905b9c353f4a1d804f09fffb95a99d)

The image above shows the required variables by the script

**TSTAMP_DIR** - This is where the timestamp/aging of every file will be located 
**CASE1_DIR** - Landing area for case1 entries (see below)
**CASE2_DIR** - Landing area for case2 entries (see below)
**CASE3_DIR** - Landing area for case3 entries (see below)
**CASE4_DIR** - Landing area for case4 entries (see below)
**CASE5_DIR** - Landing area for case5 entries (see below)
**CASE6_DIR** - Landing area for case6 entries (see below)
**BETWEEN_DIR** - Temporary saving directory for case3 wherein middle entries (true,1,true) are saved
**POSSIBLE_SUCCESS** - A directory for entries that has subsequent entry in the case folder e.g. case1_dir, case2_dir, etc...
**SUCCESS_DIR** - This is where successfull entries will be transferred i.e. successful by calls being complete or by being edited
**F_LIFETIME** - This is where you will set the aging of a file. (in EPOCH format. ex: 604800) 
**CHECK_COUNTER** - A counter for checking file content integrity
 

***Psuedo Code***

1. Processed on a per case basis in a serial manner.
case1 - Missing end value (true,1,false)
- update file timestamp. check if timestamp has not yet reached 7 days.
- if not, check for call identifer in possible_success. this is a chance to complete the file
- if 7 days has been reached, concatenate all files with the same call identifier into single file (first file) then edit according to rule
case2 - Missing first value (false,2,true)
- update file timestamp. check if timestamp has not yet reached 7 days.
- if not, check for call identifer in possible_success. this is a chance to complete the file
- if 7 days has been reached, concatenate all files with the same call identifier into single file (first file) then edit according to rule
case3 - Missing middle value (true,1,true)
- update file timestamp. check if timestamp has not yet reached 7 days.
- if not, check for call identifer in possible_success. this is a chance to complete the file
- if 7 days has been reached, concatenate all files with the same call identifier into single file (first file) then edit according to rule
case4 - Single first value entry (only false,2,true present)
- update file timestamp. check if timestamp has not yet reached 7 days.
- if not, check for call identifer in possible_success. this is a chance to complete the file
- if 7 days has been reached, concatenate all files with the same call identifier into single file (first file) then edit according to rule
case5 - Single middle value entry (only true,1,true present)
- update file timestamp. check if timestamp has not yet reached 7 days.
- if not, check for call identifer in possible_success. this is a chance to complete the file
- if 7 days has been reached, concatenate all files with the same call identifier into single file (first file) then edit according to rule
case6 - Single end value entry (only true,1,true present)
- update file timestamp. check if timestamp has not yet reached 7 days.
- if not, check for call identifer in possible_success. this is a chance to complete the file
- if 7 days has been reached, concatenate all files with the same call identifier into single file (first file) then edit according to rule




The scripts above are scheduled to run as stated below in recurring manner:

urs_d_TransferFinAndDat.sh : At every 5th minute
urs_d_Bashing.sh           : At 06:00
urs_d_HousekeepingTFD.sh   : At every 5th minute
urs_d_HousekeepingLDC.sh   : At every 5th minute
#*/10 * * * * urs_d_LongDurationCalls.sh         #Job1-2
#30 * * * *   urs_d_LongDurationCallsChecking.sh #Job1-checking
#*/11 * * * * urs_d_LongDurationCallsChecking.sh #Job1-checking




