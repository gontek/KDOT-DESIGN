CREATE OR REPLACE FORCE VIEW ksbms_robot.v_distinct_transfer_key_map (transfer_key_map_id) AS
SELECT DISTINCT TRANSFER_KEY_MAP_ID FROM DS_TRANSFER_KEY_MAP

 ;