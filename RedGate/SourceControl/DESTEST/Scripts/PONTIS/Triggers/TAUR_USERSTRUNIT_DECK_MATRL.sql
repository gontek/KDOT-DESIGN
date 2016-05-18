CREATE OR REPLACE TRIGGER pontis.TAUR_USERSTRUNIT_DECK_MATRL

	AFTER UPDATE OF DECK_MATRL ON pontis.USERSTRUNIT
	FOR EACH ROW
	




DISABLE DECLARE V_StrUnitType STRUCTURE_UNIT.STRUNITTYPE%TYPE;
		v_nbi_result_code BRIDGE.DKSTRUCTYP%TYPE;

BEGIN

SELECT STRUNITTYPE INTO V_StrUnitType FROM STRUCTURE_UNIT
 WHERE
  STRUCTURE_UNIT.BRKEY = :OLD.BRKEY
   AND STRUCTURE_UNIT.STRUNITKEY = :OLD.STRUNITKEY;

-- Check to See if this is the Main Unit :

If V_StrUnitType = '1' Then
-- If it IS the Main Structure Unit. Designate The Deck Material for this Unit
-- to be the Deck Material for the ENTIRE Structure (for NBI),LOOKUP the approriate NBI code:

-- Look up the NBI code for the KDOT field
v_nbi_result_code := ksbms_pontis.get_nbicode_from_NBILookup( 'USERSTRUNIT', 'DECK_MATRL', :new.DECK_MATRL );

UPDATE BRIDGE
	SET DKSTRUCTYP = V_NBI_RESULT_CODE
	WHERE
	BRIDGE.BRKEY = :OLD.BRKEY;
END IF;

-- Note : If this is NOT the Main Unit, then the Deck Material is not Assigned!

END TAUR_USERSTRUNIT_DECK_MATRL;
/