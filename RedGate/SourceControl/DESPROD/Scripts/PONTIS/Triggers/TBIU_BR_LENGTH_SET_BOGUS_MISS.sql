CREATE OR REPLACE TRIGGER pontis.TBIU_BR_LENGTH_SET_BOGUS_MISS
  BEFORE insert or update OF length on pontis.bridge
  for each row

-- More than one column can be referenced here e.g.
-- BEFORE INSERT OR UPDATE OF a,b,c,d,e,f,g ON BRIDGE
-- and code below would have to show how to handle each column...

declare
  -- local variables here
  -- none
  
BEGIN
  IF UPDATING THEN
  
  -- if it was null and is now becoming null or zero, make it -1
    BEGIN
      -- check old value -if null, set to a Pontis missing value
      IF :old.length is null AND
        -- see if the new value is equal  to 0
        (  :new.length = 0 OR :new.length IS NULL ) THEN
        -- make new value the old value, since this is a bogus conversion
        :new.length := '-1.0';
      END IF;
    
    END;
  
  ELSE
    -- inserting
  
    BEGIN

    -- if it is being inserted as a null or zero, make it -1
      IF :new.length = 0 or :new.length IS NULL then
        :new.length := '-1.0';
      end if;
    
    END;
  
  END IF;

end TBIU_BR_LENGTH_SET_BOGUS_MISS;
/