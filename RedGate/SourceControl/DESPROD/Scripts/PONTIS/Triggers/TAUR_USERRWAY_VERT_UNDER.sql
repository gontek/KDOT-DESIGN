CREATE OR REPLACE TRIGGER pontis.TAUR_USERRWAY_VERT_UNDER
	AFTER UPDATE OF VCLR_E, VCLR_W, VCLR_N, VCLR_S ON pontis.USERRWAY
	FOR EACH ROW
	




DECLARE V_VCLR_NBI BRIDGE.VCLRUNDER%TYPE;
	        V_REFVUC   BRIDGE.REFVUC%TYPE;
		TEMPVCLR_N BRIDGE.VCLRUNDER%TYPE;
		TEMPVCLR_E BRIDGE.VCLRUNDER%TYPE;
		TEMPVCLR_S BRIDGE.VCLRUNDER%TYPE;
		TEMPVCLR_W BRIDGE.VCLRUNDER%TYPE;
BEGIN

  If (:NEW.VCLR_N IS NULL OR :NEW.VCLR_N <= 0 ) then
	TEMPVCLR_N := 99999;
  else
    	TEMPVCLR_N := :NEW.VCLR_N;
  end if;

  If (:NEW.VCLR_E IS NULL OR :NEW.VCLR_E <= 0 ) then
  	TEMPVCLR_E := 99999;
  else
      	TEMPVCLR_E := :NEW.VCLR_E;
  end if;

  If (:NEW.VCLR_S IS NULL OR :NEW.VCLR_S <= 0 ) then
  	TEMPVCLR_S := 99999;
  else
      	TEMPVCLR_S := :NEW.VCLR_S;
  end if;

  If (:NEW.VCLR_W IS NULL OR :NEW.VCLR_W <= 0 ) then
 	TEMPVCLR_W := 99999;
  else
    	TEMPVCLR_W := :NEW.VCLR_W;
  end if;

  V_VCLR_NBI := least ( TEMPVCLR_N, TEMPVCLR_E, TEMPVCLR_S, TEMPVCLR_W);


  If V_VCLR_NBI = 99999 then
     V_VCLR_NBI := 0;
  end if;

-- Based on the NBI coding guide, page34, if the restriction is >= 30 m
-- it will be coded as 99.99

  If V_VCLR_NBI >= 30 THEN
     V_VCLR_NBI := 99.99;
  end if;

-- Based on the NBI coding guide, page34, if the under record feature is not
-- highway or a railroad, code 0000

SELECT REFVUC INTO V_REFVUC FROM BRIDGE
 WHERE
  BRIDGE.BRKEY = :OLD.BRKEY;

if V_REFVUC = 'N' then
	V_VCLR_NBI := 0;
end if;

-- Now, Put This Vertical Clearance Over into the Pontis BRIDGE Table;
UPDATE bridge
	SET VCLRUNDER = V_VCLR_NBI
	WHERE
	BRIDGE.BRKEY = :OLD.BRKEY
        AND (:OLD.ON_UNDER = '2' OR :OLD.ON_UNDER = 'A');
END TAUR_USERRWAY_VERT_UNDER;
/