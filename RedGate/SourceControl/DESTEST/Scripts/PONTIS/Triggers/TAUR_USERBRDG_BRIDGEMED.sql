CREATE OR REPLACE TRIGGER pontis.TAUR_USERBRDG_BRIDGEMED
	AFTER UPDATE OF BRIDGEMED_KDOT ON pontis.USERBRDG
	FOR EACH ROW
	



DECLARE	v_nbi_result_code BRIDGE.BRIDGEMED%TYPE;
BEGIN

-- Look up the NBI code for the KDOT field 
v_nbi_result_code := get_nbicode_from_NBILookup( 'USERBRDG', 'BRIDGEMED_KDOT', :new.BRIDGEMED_KDOT );

UPDATE BRIDGE
	SET BRIDGEMED = V_NBI_RESULT_CODE
	WHERE
	BRIDGE.BRKEY = :OLD.BRKEY;

END;
/