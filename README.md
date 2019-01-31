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
**DAT_DIR** - This is where all the .dat files will be transfered
**FIN_DIR** - This is where all the .FIN files will be transfered
**USAGE_DIR** -
**LOG_DIR** - This is where the logs will be located
**TSTAMP_DIR** - This is where the timestamp/aging of every file will be located 
**F_LIFETIME** - This is where you will set the file lifespan. (in EPOCH format. ex: 604800)

This script will receive all files at RECEIVE_DIR then move them to PROCESS_DIR, after processing, move files to OUTPUT_DIR

***Psuedo Code***

1. Check if file is still uploading, if no, then move the file from receiving to processing.
2. Process files then move to output directory
3. Check every .dat file in process dir, if there is a corresponding .da.FIN, log successful find
4. Move .dat to dat dir and .dat.FIN to fin dir, or else log unsuccessful
5. Move .dat file to wlg_usage
6. Process .dat.FIN files that do not have any .dat
7. Another case when there is a .dat.FIN file while no .dat (however unlikely according to discussion)
8. check every .dat.FIN file in process dir, since only .dat.FIN w/o .dat files are present, log it
9. Move .dat.FIN to wlg_usage


# ------------------------
### urs_d_Bashing.sh



![e134b62c01b73f12b5a4a0b73feeac48.png](:/25f03e5200c44abc8634174c7f83471c)
The image above shows the required variables by the script

**DATE_FILENAME** - 
**RECEIVE_DIR** - This is where upstreams will transfer .dat and .fin files
**PROCESS_DIR** - This is where the processing of files happen 
**OUTPUT_DIR** - This is the directory where the output of the processed files are located
**DAT_DIR** - This is where all the .dat files will be transfered
**FIN_DIR** - This is where all the .FIN files will be transfered
**USAGE_DIR** -
**LOG_DIR** - This is where the logs will be located
**TSTAMP_DIR** - This is where the timestamp/aging of every file will be located 
**F_LIFETIME** - This is where you will set the aging of a file. (in EPOCH format. ex: 604800)
**VALIDATED_FILES* - 
**MISSING_FIX** - 
**MISSING_FILES** - 

***Psuedo Code***

1. Check if uploading then move from receiving to processing
2. Process End Of Day Summary
3. Write the output in the results file
4. Move file output report to wlg usage dir


# ------------------------
### urs_d_LongDurationCalls.sh


![3d7772fc549d30d05360771913f24271.png](:/e83d04cdc9724f30be5513284c63e678)

The image above shows the required variables by the script

**TSTAMP_DIR** - This is where the timestamp/aging of every file will be located 
**RECEIVE_DIR** - This is where upstreams will transfer .dat and .fin files
**WLNFILTER_DIR** - 
**WLNFILTER_ARCHIVE_DIR** - 
**FILE_ERROR_DIR** - 
**CASE1_DIR** -
**CASE2_DIR** -
**CASE3_DIR** - 
**CASE4_DIR** - 
**CASE5_DIR** - 
**CASE6_DIR** - 
**LOG_DIR** - This is where the logs will be located
**F_LIFETIME** - This is where you will set the aging of a file. (in EPOCH format. ex: 604800)
**POSSIBLE_SUCCESS** - 
**SUCCESS_DIR** - 
**NAMING_CONVENTION** - 
 

***Psuedo Code***

1. Segregate and generate timestamp/file life span for long duration calls
2. Wireline filter timestamp creation
3. Wireline archive timestamp creation


# ------------------------
### urs_d_LongDurationCallsChecking.sh
![58e9a68a6a7a97cddbbd62caca77ed0d.png](:/ee905b9c353f4a1d804f09fffb95a99d)

The image above shows the required variables by the script

**TSTAMP_DIR** - This is where the timestamp/aging of every file will be located 
**CASE1_DIR** -
**CASE2_DIR** -
**CASE3_DIR** - 
**CASE4_DIR** - 
**CASE5_DIR** - 
**CASE6_DIR** - 
**BETWEEN_DIR** - 
**POSSIBLE_SUCCESS** - 
**SUCCESS_DIR** -
**F_LIFETIME** - This is where you will set the aging of a file. (in EPOCH format. ex: 604800) 
**CHECK_COUNTER** - 
 

***Psuedo Code***

1. 



The scripts above are scheduled to run as stated below in recurring manner:

urs_d_TransferFinAndDat.sh : At every 5th minute
urs_d_Bashing.sh           : At 06:00
urs_d_HousekeepingTFD.sh   : At every 5th minute
urs_d_HousekeepingLDC.sh   : At every 5th minute
#*/10 * * * * urs_d_LongDurationCalls.sh         #Job1-2
#30 * * * *   urs_d_LongDurationCallsChecking.sh #Job1-checking
#*/11 * * * * urs_d_LongDurationCallsChecking.sh #Job1-checking




