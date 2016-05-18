CREATE OR REPLACE TRIGGER pontis.TAUR_USERBRDG_DESIGNLOAD

	AFTER UPDATE OF DESIGNLOAD_KDOT, DESIGNLOAD_TYPE ON pontis.USERBRDG
	FOR EACH ROW
	



DECLARE v_designload BRIDGE.DESIGNLOAD%TYPE;
BEGIN

If (:NEW.DESIGNLOAD_KDOT < 13.5) then
    V_DESIGNLOAD := '1';
end if;

If (:NEW.DESIGNLOAD_TYPE in ('1','2','4')) and (:NEW.DESIGNLOAD_KDOT >= 13.5 and :NEW.DESIGNLOAD_KDOT < 18) then
    V_DESIGNLOAD := '2';
end if;

If (:NEW.DESIGNLOAD_TYPE in ('3','5')) and (:NEW.DESIGNLOAD_KDOT >=13.5 and :NEW.DESIGNLOAD_KDOT < 18) then 
    V_DESIGNLOAD := '3';
end if;

If (:NEW.DESIGNLOAD_TYPE in ('1','2','4')) and (:NEW.DESIGNLOAD_KDOT >= 18) then
    V_DESIGNLOAD := '4';
end if;

If (:NEW.DESIGNLOAD_TYPE = '3') and (:NEW.DESIGNLOAD_KDOT >= 18 and :NEW.DESIGNLOAD_KDOT < 22.5) then
    V_DESIGNLOAD := '5';
end if;

If (:NEW.DESIGNLOAD_TYPE = '5') and (:NEW.DESIGNLOAD_KDOT >= 18 and :NEW.DESIGNLOAD_KDOT< 22.5) then
    V_DESIGNLOAD := '6';
end if;

If :NEW.DESIGNLOAD_TYPE = '7' then
    V_DESIGNLOAD := '7';
end if;

If :NEW.DESIGNLOAD_TYPE = '6' then
    V_DESIGNLOAD := '8';
end if;

If (:NEW.DESIGNLOAD_TYPE in ('3','5')) and (:NEW.DESIGNLOAD_KDOT >= 22.5) then
    V_DESIGNLOAD := '9';
end if;

IF (:NEW.DESIGNLOAD_TYPE IN ('8') ) THEN
    V_DESIGNLOAD :='A';
END IF;

if(:NEW.DESIGNLOAD_TYPE IN ('_','0')) THEN
    V_DESIGNLOAD :='0';
end if;
-- If  :NEW.DESIGNLOAD_KDOT is less than 13.5 set this item to 1;
-- If  :NEW.DESIGNLOAD_TYPE is 1 or 2 or 4 and :NEW.DESIGNLOAD_KDOT is  >= 13.5 and < 18, set this item to 2;
-- If  :NEW.DESIGNLOAD_TYPE is 3 or 5 and :NEW.DESIGNLOAD_KDOT is >=13.5 and < 18, set this item to 3;
-- If :NEW.DESIGNLOAD_TYPE is 1, 2 or 4 and :NEW.DESIGNLOAD_KDOT  is >= 18, set this item to 4;
-- If :NEW.DESIGNLOAD_TYPE is 3 and :NEW.DESIGNLOAD_KDOT is  >= 18 and < 22.5, set this item to 5;
-- If :NEW.DESIGNLOAD_TYPE is 5 and :NEW.DESIGNLOAD_KDOT is >= 18 and < 22.5, set this item to 6;
-- If :NEW.DESIGNLOAD_TYPE is equal to 7, set this item to 7;
-- If :NEW.DESIGNLOAD_TYPE is equal to 6, set this item to 8;
-- If :NEW.DESIGNLOAD_TYPE  is 3 or 5 and :NEW.DESIGNLOAD_KDOT is >= 22.5, set this item to 9;
-- IF :new.designload_type is 8 or 0, set this item to 0;

UPDATE BRIDGE
	SET DESIGNLOAD = V_DESIGNLOAD
	WHERE
	BRIDGE.BRKEY = :OLD.BRKEY;

END;
/