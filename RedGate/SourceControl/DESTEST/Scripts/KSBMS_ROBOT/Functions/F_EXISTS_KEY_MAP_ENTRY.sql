CREATE OR REPLACE function ksbms_robot.f_exists_key_map_entry(p_transfer_key_map_id DS_TRANSFER_KEY_MAP.TRANSFER_KEY_MAP_ID%TYPE ) return PLS_INTEGER is
  ls_dummy DS_TRANSFER_KEY_MAP.TRANSFER_KEY_MAP_ID%TYPE;
  Result pls_integer :=1;
begin
  SELECT DISTINCT TRANSFER_KEY_MAP_ID INTO ls_dummy
  FROM DS_TRANSFER_KEY_MAP WHERE
  DS_TRANSFER_KEY_MAP.TRANSFER_KEY_MAP_ID = p_transfer_key_map_id;
         RETURN 1;
  EXCEPTION                                    
  WHEN NO_DATA_FOUND THEN
       BEGIN
       RETURN 0;
       END;
       
  WHEN OTHERS THEN
       BEGIN
       RAISE;
       RETURN 0;
       END;
end f_exists_key_map_entry;

 
/