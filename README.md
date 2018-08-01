# Credit-card-management-system-Hadoop-Oozie-Incremental
This project use oozie &amp; sqoop incremental job to only import the updated data(updated/inserted) into HDFS and Hive


------

---------
How to test this project:

1. Open sqoopmetastore and create four jobs:
                                            
                                            BranchJobAppend
                                            CreditcardJobAppend
                                            CustomerJobAppend
                                            TimeJobAppend
 
 For the BranchJobAppend:
 
     -use incremental lastmodified
     -The check-column is LAST_UPDATED. It is a timestamp column
     
 For the CustomerJobAppend:
 
     -use incremental lastmodified
     -The check-column is LAST_UPDATED. It is a timestamp column
     
 For the CreditcardJobAppend:
 
     -use incremental append
     -The check-column is TRASANCTION_ID
     -So if you want to insert data into CDW_SAPP_D_CREDIT_CARD, The TRASACTION_ID must larger than 46694,
     
  EX:
  
                    insert into CDW_SAPP_CREDITCARD
                   (TRANSACTION_ID,DAY,MONTH,YEAR,BRANCH_CODE,TRANSACTION_TYPE, TRANSACTION_VALUE)
                    VALUES
                   (46695,31,7,2018,114,'BILLS','23.456');
     
  For the TimeJobAppend:
  
      -use incremental append
      -the check-column is 'TIMEID'
      -If you change the CREDITCARD table, it will shown changed in TIME table too 
     
     
2. create CREDIT_CARD_OOZIE_APPEND under maria_dev, 

   and  
   
                                    BRANCH_workflow
                                    BRANCH_coordinator
                                    CREDITCARD_workflow
                                    CREDITCARD_coordinator
                                    CUSTOMER_workflow
                                    CUSTOMER_coordinator
                                    TIME_workflow
                                    TIME_coordinator
    
  under CREDIT_CARD_OOZIE_APPEND.

3. Each workflow folder contains 3 files, take BRANCH as an example:


                  CDW_SAPP_D_BRANCH.HIVE
                  BRANCH_job.properties
                  BRANCH_workflow.xml
                  BRANCH_job.properties: 

 Execute Branch_job.properties:                  
 
                  oozie job -oozie http://localhost:11000/oozie -config BRANCH_job.properties -run
 
 After you execute the workflow, the oozie job will execute the BranchJobAppend for the first time, then build CDW_SAPP_D_BRANCH.
 This workflow has no coordinator so it only executes once.
 
 ------
 ----
 YOU must run BRANCH_job.properties first BEFORE you run BRANCH_job_append.properties!!!
 -----
 
 
  Each coordinator folder contains 4 files, take BRANCH as an example:
   
                  BRANCH_coordinator_append.xml
                  BRANCH_copydata_append.hql
                  BRANCH_job_append.properties
                  BRANCH_workflow_append.xml
   
  Execute BRANCH_job_append.properties:
            
                  oozie job -oozie http://localhost:11000/oozie -config BRANCH_workflow_job.properties -run
                
After execute the BRANCH_workflow, the sqoop job is alreay ran once, so when the sqoop job running the second time, it will only import the updated/inserted new file to HDFS, and then Hive will move that file to the CDW_SAPP_D_BRANCH's directory.
The BRANCH_workflow_append.xml will implement this requirement.


 
             
                  

