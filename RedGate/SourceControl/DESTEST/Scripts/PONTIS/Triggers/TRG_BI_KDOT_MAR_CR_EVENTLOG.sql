CREATE OR REPLACE TRIGGER pontis.Trg_Bi_Kdot_Mar_Cr_Eventlog
  BEFORE INSERT ON pontis.Kdot_Mar_Cr_Eventlog
  FOR EACH ROW
DISABLE DECLARE
  -- local variables here
  Newkey VARCHAR(32) := Sys_Guid();
BEGIN
  IF (:New.Mar_Cr_Key IS NULL) THEN
    :New.Mar_Cr_Key := Newkey;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END Trg_Bi_Kdot_Mar_Cr_Eventlog;
/