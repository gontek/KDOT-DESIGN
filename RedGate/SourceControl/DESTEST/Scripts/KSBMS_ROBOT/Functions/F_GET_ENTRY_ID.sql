CREATE OR REPLACE function ksbms_robot.f_get_entry_id return VARCHAR2 is
  Result varchar2(32);
begin
  SELECT sys_guid() 
    INTO Result
    FROM DUAL;
  return(Result);
  EXCEPTION 
  WHEN NO_DATA_FOUND
  THEN
    RAISE;
  WHEN OTHERS
  THEN
    RAISE;
    
end f_get_entry_id;


 
/