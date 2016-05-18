CREATE OR REPLACE FORCE VIEW ksbms_robot.ds_change_log_c (entry_id,sequence_num,exchange_rule_id,exchange_type,old_value,new_value,exchange_status,precedence,createdatetime,createuserid,remarks) AS
select "ENTRY_ID","SEQUENCE_NUM","EXCHANGE_RULE_ID",
    "EXCHANGE_TYPE","OLD_VALUE","NEW_VALUE","EXCHANGE_STATUS",
    "PRECEDENCE","CREATEDATETIME","CREATEUSERID","REMARKS"
    from kdot.ds_change_log@NEWCANT.world;