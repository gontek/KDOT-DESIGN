CREATE OR REPLACE TRIGGER pontis.TAUR_USERRWAY_LAT_UNDCLright
	AFTER UPDATE OF HCLRURT_E, HCLRURT_W, HCLRURT_N, HCLRURT_S ON pontis.USERRWAY
	FOR EACH ROW
	





  WHEN (NEW.FEAT_CROSS_TYPE IN ('4','10','30','50','51','70','30')) DECLARE V_HCLRURT_NBI BRIDGE.HCLRURT%TYPE;
		V_REFHUC BRIDGE.REFHUC%TYPE;
		TEMPHCLRURT_N BRIDGE.HCLRURT%TYPE;
		TEMPHCLRURT_E BRIDGE.HCLRURT%TYPE;
		TEMPHCLRURT_S BRIDGE.HCLRURT%TYPE;
		TEMPHCLRURT_W BRIDGE.HCLRURT%TYPE;
BEGIN
  

  If (:NEW.HCLRURT_N IS NULL OR :NEW.HCLRURT_N <= 0 ) then
	TEMPHCLRURT_N := 99.9;
  else
    	TEMPHCLRURT_N := :NEW.HCLRURT_N;
  end if;

  If (:NEW.HCLRURT_E IS NULL OR :NEW.HCLRURT_E <= 0 ) then
  	TEMPHCLRURT_E := 99.9;
  else
      	TEMPHCLRURT_E := :NEW.HCLRURT_E;
  end if;

  If (:NEW.HCLRURT_S IS NULL OR :NEW.HCLRURT_S <= 0 ) then
  	TEMPHCLRURT_S := 99.9;
  else
      	TEMPHCLRURT_S := :NEW.HCLRURT_S;
  end if;

  If (:NEW.HCLRURT_W IS NULL OR :NEW.HCLRURT_W <= 0 ) then
 	TEMPHCLRURT_W := 99.9;
  else
    	TEMPHCLRURT_W := :NEW.HCLRURT_W;
  end if;

  V_HCLRURT_NBI := round(least( TEMPHCLRURT_N, TEMPHCLRURT_E, TEMPHCLRURT_S, TEMPHCLRURT_W),3);

  If V_HCLRURT_NBI in (99.9,0) then
     V_HCLRURT_NBI := 0; 
  end if;

-- Based on the NBI coding guide, page35, if the restriction is >= 30 m
-- it will be coded as 99.9

  If V_HCLRURT_NBI >= 30 THEN
     V_HCLRURT_NBI := 99.9;
  end if;

---  Check if Highway or Railroad under the bridge;
-- Based on the NBI coding guide, page35, if the under record feature is not
-- highway or a railroad, code 0000

SELECT REFHUC INTO V_REFHUC FROM BRIDGE
 WHERE
  BRIDGE.BRKEY = :OLD.BRKEY;

if V_REFHUC = 'N' then
	V_HCLRURT_NBI := 0;
end if;

-- Now, Put This Lateral Clearance Right into the Pontis BRIDGE Table;
UPDATE bridge
	SET HCLRURT = V_HCLRURT_NBI
	WHERE
	BRIDGE.BRKEY = :OLD.BRKEY;

END TAUR_USERRWAY_LAT_UNDCLright;
/