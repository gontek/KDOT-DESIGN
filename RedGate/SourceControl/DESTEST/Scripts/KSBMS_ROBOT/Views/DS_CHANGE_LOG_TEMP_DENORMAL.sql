CREATE OR REPLACE FORCE VIEW ksbms_robot.ds_change_log_temp_denormal (entry_id,matchkey) AS
select entry_id, f_Gen_compare_keys(entry_id) matchkey FROM ds_change_log_temp

 ;