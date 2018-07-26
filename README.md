# Credit-card-management-system-Hadoop-Oozie-Incremental
This project use oozie &amp; sqoop incremental job to only import the updated data(updated/inserted) into HDFS and Hive


------
1. create only static external table, no dynamic table is created.


2. Sqoop job can only incrementally importing the updated data, E.X:
                      
                      sqoop job 
                      -Dorg.apache.sqoop.splitter.allow_text_splitter=true
                      --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop 
                      --create BranchJobAppend
                      -- import 
                      --m 1
                      --connect jdbc:mysql://localhost/JDBC
                      --driver com.mysql.jdbc.Driver 
                      --append
                      --query  
                      " SELECT BRANCH_CODE, BRANCH_NAME, BRANCH_STREET, BRANCH_CITY, BRANCH_STATE, BRANCH_ZIP, (select concat( '(',(select                          substring(BRANCH_PHONE, 1, 3)), ')', (select substring(BRANCH_PHONE, 4,3)), '-',(select substring(BRANCH_PHONE, 7, 3)))), LAST_UPDATED FROM CDW_SAPP_BRANCH WHERE \$CONDITIONS " 
                      --split-by BRANCH_CODE
                      --incremental lastmodified
                      --check-column LAST_UPDATED
                      --last-value '2017-04-18 15:51:47'
                      --target-dir /user/maria_dev/CREDIT_CARD_SYSTEM/CDW_SAPP_BRANCH_APPEND/
                      --fields-terminated-by ','
                      
3. As a result, the Hive table only contains the new data but not the old data.


4. The coordinator is the same with Project Credit-card-management-system-Hadoop-Oozie
