CREATE OR REPLACE TRIGGER pontis.taur_userbrdg_maint_area
     AFTER INSERT OR UPDATE OF maint_area
     ON pontis.userbrdg
     FOR EACH ROW


DECLARE
  --local variables here
  ls_district BRIDGE.DISTRICT%TYPE;
  
BEGIN

-- Allen Marshall, CS - 2002-12-30 - unsupported
-- for the new MAINT_AREA, bind with BRIDGE.DISTRICT to create ADMIN_AREA!!!!
-- only if the new MAINT_AREA is valid (well, really, not MISSING or NULL)
IF inserting THEN
  -- use incoming new brkey
   SELECT NVL( district,'_') INTO ls_district FROM bridge WHERE brkey = :new.brkey;
ELSE -- updating, gotta be because of declaration of the trigger
  -- use existing brkey
   SELECT  NVL( district,'_')  INTO ls_district FROM bridge WHERE brkey = :old.brkey;
END IF;

-- only update bridge if the district is not missing and the maint_area is valid.
-- practically, this usually means only when updating unless we set a valid default for MAINT_AREA
  
     IF NOT (  :NEW.maint_area IS NULL OR  ksbms_pontis.f_is_pontis_missing_value ( :NEW.maint_area )  
     OR ksbms_pontis.f_is_pontis_missing_value ( ls_district ) )
     THEN
          UPDATE bridge
             SET bridge.adminarea = TRIM (bridge.district) || :NEW.maint_area
           WHERE bridge.brkey = :OLD.brkey;
     END IF;
     
END taur_userbrdg_maint_area;
/