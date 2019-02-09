#!/bin/bash
> /appl/urpadm/job1-2/tstamp/timestamp1.txt
> /appl/urpadm/job1-2/tstamp/timestamp_wln_ftr.txt
> /appl/urpadm/job1-2/tstamp/urs_d_ErrorFile_Handling_tstamp.txt
> /appl/urpadm/job1-2/tstamp/urs_d_LongDurationCalls_call_aging_tstamp.txt
> /appl/urpadm/job1-2/tstamp/urs_d_WireLine_Ftr_Archive_tstamp.txt
> /appl/urpadm/job1-2/tstamp/urs_d_WireLine_Ftr_Report_tstamp.txt
> /appl/urpadm/job1-2/tstamp/urs_d_LongDurationCalls_housekeeping_tstamp.txt
> /appl/urpadm/job3-4/tstamp/urs_d_dat_backup_tstamp.txt
> /appl/urpadm/job3-4/tstamp/urs_d_eod_report_tstamp.txt
> /appl/urpadm/job3-4/tstamp/urs_d_findat_tstamp.txt
> /appl/urpadm/job3-4/tstamp/timstamp3.txt
> /appl/urpadm/job3-4/tstamp/timstamp4.txt



#Cleaning Job1 procesing directories
rm -rf /appl/urpadm/job1-2/cases/case1/*
rm -rf /appl/urpadm/job1-2/cases/case2/*
rm -rf /appl/urpadm/job1-2/cases/case3/*
rm -rf /appl/urpadm/job1-2/cases/case4/*
rm -rf  /appl/urpadm/job1-2/cases/case5/*
rm -rf  /appl/urpadm/job1-2/cases/case6/*
rm -rf  /appl/urpadm/job1-2/file_error_handling/*
rm -rf  /appl/urpadm/job1-2/success/*
rm -rf  /appl/urpadm/job1-2/betweens/*
rm -rf  /appl/urpadm/job1-2/merged/*
rm -rf  /appl/urpadm/job1-2/possible_success/*
rm -rf  /appl/urpadm/job1-2/wln_ftr_archive/*

#Cleaning Job3-4 processing directories
rm -rf /appl/urpadm/job3-4/output/backup/*
rm -rf /appl/urpadm/job3-4/output/eod_results/*
rm -rf /appl/urpadm/job3-4/processing/*
rm -rf /appl/urpadm/job3-4/processingeod/*
rm -rf /appl/urpadm/job3-4/receiving/*

#/MYBSS cleanup
rm -rf /MYBSS/EP_FILES/USAGE_WLN/*.t3xt
rm -rf /MYBSS/EP_FILES/USAGE_WLN/*.txt
rm -rf /MYBSS/EP_FILES/USAGE_WLN/*.done
rm -rf /MYBSS/EP_FILES/USAGE_WLN/DAT/*
rm -rf /MYBSS/EP_FILES/USAGE_WLN/FIN/*
rm -rf /MYBSS/EP_FILES/USAGE_WLN/REPORT/*
rm -rf /MYBSS/EP_FILES/USAGE_WLN/DAT/*
rm -rf /MYBSS/EP_FILES/BACKUP/USAGE_WLN/*
rm -rf /MYBSS/ISG/DAILY/WLN_FILTER/*
rm -rf /MYBSS/ISG/ADHOC/WLN_INC_LD/PROCESSING/*
rm -rf /MYBSS/ISG/ADHOC/WLN_INC_LD/INPUT/*
rm -rf /MYBSS/ISG/ADHOC/WLN_INC_LD/OUTPUT/*
rm -rf /MYBSS/ISG/ADHOC/WLN_INC_LD/ERROR/*
rm -rf /MYBSS/ISG/ADHOC/WLN_INC_LD/ARC/*

