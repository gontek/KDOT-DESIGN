CREATE OR REPLACE TRIGGER pontis.TAUR_NBI_28A_LANESON
	AFTER UPDATE OF TOTLANES ON pontis.USERRWAY
  FOR EACH ROW
  

--THIS UPDATES LANES (NBI 28A) FROM ON_UNDER = '1' (or Cansys FUNC )ITEMS ONLY

  WHEN (new.on_under = '1' ) DECLARE v_functype USERBRDG.FUNCTION_TYPE%TYPE;
        V_LANES ROADWAY.LANES%TYPE;
        temp_lanes roadway.lanes%type;
        
BEGIN
select function_Type into v_functype
from userbrdg
where userbrdg.brkey = :old.brkey;

IF v_functype in ('10','30','50','51','70') then
   IF (:NEW.TOTLANES IS NULL ) THEN
    TEMP_LANES := 0;
   ELSE
    TEMP_LANES := :NEW.TOTLANES;
 END IF;
END IF;
 
-- Now, create the new total value for lanes...
  V_LANES := TEMP_LANES;
  

UPDATE ROADWAY
  SET LANES = V_LANES
  WHERE
  ROADWAY.BRKEY = :OLD.BRKEY ;

END TAUR_NBI_28A_LANESON;
/