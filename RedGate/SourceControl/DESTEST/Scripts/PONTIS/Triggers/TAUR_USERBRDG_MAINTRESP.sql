CREATE OR REPLACE TRIGGER pontis.TAUR_USERBRDG_MAINTRESP
	AFTER UPDATE OF CUSTODIAN_KDOT ON pontis.USERBRDG
	FOR EACH ROW
	



DECLARE	v_nbi_result_code BRIDGE.CUSTODIAN%TYPE;
BEGIN

-- Look up the NBI code for the KDOT field 
v_nbi_result_code := get_nbicode_from_NBILookup( 'USERBRDG', 'CUSTODIAN_KDOT', :new.CUSTODIAN_KDOT );

UPDATE BRIDGE
	SET CUSTODIAN = V_NBI_RESULT_CODE
	WHERE
	BRIDGE.BRKEY = :OLD.BRKEY;

END;
/