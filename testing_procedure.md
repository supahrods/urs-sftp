Transfer of Fin and Dat Testing(Job #3)

Create file using the following parameters:

touch -d 20190213 <filename format>.dat
touch -d 20190213 <filename format>.dat
touch -d 20190213 <filename format>.dat
touch -d 20190213 <filename format>.dat.FIN
touch -d 20190213 <filename format>.dat.FIN

move the files to /MYBSS/EP_FILES/BACKUP/USAGE_WLN/
Then execute urs_d_TransferFinAndDat.sh script

.dat with corresponding .FIN files should be trasfered /MYBSS/EP_FILES/USAGE_WLN/DAT
.FIN files should be tranfered /MYBSS/EP_FILES/USAGE_WLN/FIN

.dat file without corresponding .fin should be transfered in backup directory and will candidate for housekeeping since the file's created date is behind for more than 3 days


Bashing Testing(Job #4)

Create the EOD Summary file in txt format, with the filename of the .dat files. wrap in "StartOfFile" and "EndOfFile"

example:
StartOfFile
filename.dat
filename.dat
filename.dat
EndOfFile

Then execute job4 script

The generated report should show:
Number of validated files
Number of files without fin/dat
Number of missing files
Total Tally 
List of filenames(validated,without fin/dat,missing)

Testing of Job 1

Since weve done several testings, we should first clean up the file timestamp records and files.

To cleanup run the commands below:

> /appl/urpadm/job1-2/tstamp/timestamp1.txt
> /appl/urpadm/job1-2/tstamp/timestamp_wln_ftr.txt
> /appl/urpadm/job1-2/tstamp/urs_d_ErrorFile_Handling_tstamp.txt
> /appl/urpadm/job1-2/tstamp/urs_d_LongDurationCalls_call_aging_tstamp.txt
> /appl/urpadm/job1-2/tstamp/urs_d_LongDurationCalls_housekeeping_tstamp.txt

delete all files in cases dir
rm -rf /appl/urpadm/job1-2/cases/case1/*
rm -rf /appl/urpadm/job1-2/cases/case2/*
rm -rf /appl/urpadm/job1-2/cases/case3/*
rm -rf /appl/urpadm/job1-2/cases/case4/*
rm -rf /appl/urpadm/job1-2/cases/case5/*
rm -rf /appl/urpadm/job1-2/cases/case6/*

delete files with errr
rm -rf /appl/urpadm/job1-2/file_error_handling/*
delete success files
rm -rf /appl/urpadm/job1-2/success/*

After cleanup, we can now transfer the DTR's to its respective landing directory, to do this, run the command below:

cp /home/urpadm/urs-sftp/ldc-backup/* /MYBSS/ISG/ADHOC/WLN_INC_LD/INPUT/

Then run the first script of job1

CDR's should be segregated to cases 1-6
Open a file in each cases to check whether the segregation is done correctly. Below are the definition of each cases

case1 - Missing end value (true,1,false)
case2 - Missing first value (false,2,true)
case3 - Missing middle value (true,1,true)
case4 - Single first value entry (only false,2,true present)
case5 - Single middle value entry (only true,1,true present)
case6 - Single end value entry (only true,1,true present)

If the segregation is successful, we can now run the job1-checking script







