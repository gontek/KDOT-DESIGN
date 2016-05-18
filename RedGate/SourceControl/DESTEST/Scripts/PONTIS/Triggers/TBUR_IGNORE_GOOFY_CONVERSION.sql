CREATE OR REPLACE TRIGGER pontis.TBUR_IGNORE_GOOFY_CONVERSION
  BEFORE update OF  lftbrnavcl on pontis.bridge  
  for each row




DISABLE declare
  -- local variables here
BEGIN
-- check old value
IF :old.lftbrnavcl = 99.9 AND
-- see if the new value is equal (use round to trim precision) 
round( :new.lftbrnavcl,2)  = round( 99.9 * 2.53,2)  THEN
-- make new value the old value, since this is a bogus conversion
:new.lftbrnavcl := :old.lftbrnavcl; END IF;
  
end TBUR_IGNORE_GOOFY_CONVERSION;
/