CREATE OR REPLACE TRIGGER pontis.TAUR_USERRWAY_VERT_SIGN
	AFTER UPDATE OF VCLR_N_SIGN, VCLR_S_SIGN, VCLR_E_SIGN,VCLR_W_SIGN ON pontis.USERRWAY
	FOR EACH ROW

	
 WHEN (new.on_under != '1') DECLARE V_UNDR_SIGN  USERBRDG.VERT_UNDR_SIGN%TYPE;
	  		TEMPSIGN_N   USERBRDG.VERT_UNDR_SIGN%TYPE;
		    TEMPSIGN_S   USERBRDG.VERT_UNDR_SIGN%TYPE;
        TEMPSIGN_E   USERBRDG.VERT_UNDR_SIGN%TYPE;
        TEMPSIGN_W   USERBRDG.VERT_UNDR_SIGN%TYPE;

BEGIN




If (:NEW.VCLR_N_SIGN IS NULL OR :NEW.VCLR_N_SIGN <= 0 )then
	TEMPSIGN_N := 'N';
  else
    	TEMPSIGN_N := 'Y';
end if;

If (:NEW.VCLR_S_SIGN IS NULL OR :NEW.VCLR_S_SIGN <= 0 )then
	TEMPSIGN_S := 'N';
else
 	TEMPSIGN_S := 'Y';
end if;
  
If (:NEW.VCLR_E_SIGN IS NULL OR :NEW.VCLR_E_SIGN <= 0 )then
	TEMPSIGN_E := 'N';
else
 	TEMPSIGN_E := 'Y';
end if; 
 
If (:NEW.VCLR_W_SIGN IS NULL OR :NEW.VCLR_W_SIGN <= 0 )then
	TEMPSIGN_W := 'N';
else
TEMPSIGN_W := 'Y';
end if;

  
---OKAY...IF ANY OF THESE IS 'Y', THEN VERT_UNDR_SIGN = 'Y', OTHERWISE, 'N'   
IF (TEMPSIGN_N = 'Y' OR
    TEMPSIGN_S = 'Y' OR
    TEMPSIGN_E = 'Y' OR
    TEMPSIGN_W = 'Y') Then
    V_UNDR_SIGN := 'Y';
 ELSE
    V_UNDR_SIGN := 'N';
    
    
END IF;
-- Now update userbrdg table...
UPDATE USERBRDG
	SET VERT_UNDR_SIGN = V_UNDR_SIGN
	WHERE
	USERBRDG.BRKEY = :OLD.BRKEY;

END TAUR_USERRWAY_VERT_SIGN;
/