CREATE OR REPLACE TRIGGER pontis.TAUR_USERRWAY_VERT_OVER
	AFTER UPDATE OF VCLRINV_E, VCLRINV_W, VCLRINV_N, VCLRINV_S ON pontis.USERRWAY
	FOR EACH ROW
	




DECLARE V_VCLRINV_NBI BRIDGE.VCLROVER%TYPE;
		TEMPVCLRINV_N BRIDGE.VCLROVER%TYPE;
		TEMPVCLRINV_E BRIDGE.VCLROVER%TYPE;
		TEMPVCLRINV_S BRIDGE.VCLROVER%TYPE;
		TEMPVCLRINV_W BRIDGE.VCLROVER%TYPE;
BEGIN

  If (:NEW.VCLRINV_N IS NULL OR :NEW.VCLRINV_N <= 0 ) then
	TEMPVCLRINV_N := 99999;
  else
    	TEMPVCLRINV_N := :NEW.VCLRINV_N;
  end if;

  If (:NEW.VCLRINV_E IS NULL OR :NEW.VCLRINV_E <= 0 ) then
  	TEMPVCLRINV_E := 99999;
  else
      	TEMPVCLRINV_E := :NEW.VCLRINV_E;
  end if;

  If (:NEW.VCLRINV_S IS NULL OR :NEW.VCLRINV_S <= 0 ) then
  	TEMPVCLRINV_S := 99999;
  else
      	TEMPVCLRINV_S := :NEW.VCLRINV_S;
  end if;

  If (:NEW.VCLRINV_W IS NULL OR :NEW.VCLRINV_W <= 0 ) then
 	TEMPVCLRINV_W := 99999;
  else
    	TEMPVCLRINV_W := :NEW.VCLRINV_W;
  end if;

  V_VCLRINV_NBI := least ( TEMPVCLRINV_N, TEMPVCLRINV_E, TEMPVCLRINV_S, TEMPVCLRINV_W);

-- Based on the NBI coding guide, page33, if NO restriction exists over the bridge
-- it will be coded as 99.99

  If V_VCLRINV_NBI = 99999 then
     V_VCLRINV_NBI := 99.99;
  end if;

-- Based on the NBI coding guide, page33, if the restriction is >= 30 m
-- it will be coded as 99.99

  If V_VCLRINV_NBI >= 30 THEN
     V_VCLRINV_NBI := 99.99;
  end if;


-- Now, Put This Vertical Clearance Over into the Pontis BRIDGE Table;
UPDATE bridge
	SET VCLROVER = V_VCLRINV_NBI
	WHERE
	BRIDGE.BRKEY = :OLD.BRKEY
        AND (:OLD.ON_UNDER = '1');
END TAUR_USERRWAY_VERT_OVER;
/