CREATE OR REPLACE FORCE VIEW ksbms_robot.ds_lookup_keyvals_c (entry_id,keyname,keyvalue,key_sequence_num,createdatetime,createuserid) AS
select "ENTRY_ID","KEYNAME","KEYVALUE","KEY_SEQUENCE_NUM",
    "CREATEDATETIME","CREATEUSERID"
    from kdot.ds_lookup_keyvals@NEWCANT.world;