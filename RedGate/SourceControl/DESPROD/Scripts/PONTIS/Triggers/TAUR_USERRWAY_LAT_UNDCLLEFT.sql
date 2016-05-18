CREATE OR REPLACE TRIGGER pontis.TAUR_USERRWAY_LAT_UNDCLLEFT
	AFTER UPDATE OF HCLRULT_E, HCLRULT_W, HCLRULT_N, HCLRULT_S ON pontis.USERRWAY
	FOR EACH ROW
	



 WHEN (NEW.FEAT_CROSS_TYPE IN ('4','10','30','50','51','70','30')) DECLARE V_HCLRULT_NBI BRIDGE.HCLRULT%TYPE;
		V_REFHUC BRIDGE.REFHUC%TYPE;
		TEMPHCLRULT_N BRIDGE.HCLRULT%TYPE;
		TEMPHCLRULT_E BRIDGE.HCLRULT%TYPE;
		TEMPHCLRULT_S BRIDGE.HCLRULT%TYPE;
		TEMPHCLRULT_W BRIDGE.HCLRULT%TYPE;
BEGIN

  If (:NEW.HCLRULT_N IS NULL OR :NEW.HCLRULT_N <= 0 ) then
	TEMPHCLRULT_N := 99.9;
  else
    	TEMPHCLRULT_N := :NEW.HCLRULT_N;
  end if;

  If (:NEW.HCLRULT_E IS NULL OR :NEW.HCLRULT_E <= 0 ) then
  	TEMPHCLRULT_E := 99.9;
  else
      	TEMPHCLRULT_E := :NEW.HCLRULT_E;
  end if;

  If (:NEW.HCLRULT_S IS NULL OR :NEW.HCLRULT_S <= 0 ) then
  	TEMPHCLRULT_S := 99.9;
  else
      	TEMPHCLRULT_S := :NEW.HCLRULT_S;
  end if;

  If (:NEW.HCLRULT_W IS NULL OR :NEW.HCLRULT_W <= 0 ) then
 	TEMPHCLRULT_W := 99.9;
  else
    	TEMPHCLRULT_W := :NEW.HCLRULT_W;
  end if;

  V_HCLRULT_NBI := round(least ( TEMPHCLRULT_N, TEMPHCLRULT_E, TEMPHCLRULT_S, TEMPHCLRULT_W),3);

  If V_HCLRULT_NBI in (99.9,0) then
     V_HCLRULT_NBI := 0;
  end if;

-- Based on the NBI coding guide, page35, if the restriction is >= 30 m
-- it will be coded as 99.9

  If V_HCLRULT_NBI >= 30 THEN
     V_HCLRULT_NBI := 99.9;
  end if;

---  Check if Highway or Railroad under the bridge;
-- Based on the NBI coding guide, page35, if the under record feature is not
-- highway or a railroad, code 0000

SELECT REFHUC INTO V_REFHUC FROM BRIDGE
 WHERE
  BRIDGE.BRKEY = :OLD.BRKEY;

if V_REFHUC = 'N' then
	V_HCLRULT_NBI := 0;
end if;

-- Now, Put This Lateral Clearance left into the Pontis BRIDGE Table;
UPDATE bridge
	SET HCLRULT = V_HCLRULT_NBI
	WHERE
	BRIDGE.BRKEY = :OLD.BRKEY;
  --      AND (:OLD.ON_UNDER = '2' OR :OLD.ON_UNDER = 'A');
END TAUR_USERRWAY_LAT_UNDCLLEFT;
/