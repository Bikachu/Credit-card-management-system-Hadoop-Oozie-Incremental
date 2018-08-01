SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

load data inpath "/user/maria_dev/CREDIT_CARD_SYSTEM/CDW_SAPP_CREDITCARD_APPEND/"
into table CDW_SAPP_D_CREDIT_CARD;

