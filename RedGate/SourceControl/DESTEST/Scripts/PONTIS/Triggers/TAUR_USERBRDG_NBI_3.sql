CREATE OR REPLACE trigger pontis.taur_userbrdg_NBI_3
  after update or insert of brkey
  on pontis.userbrdg
  for each row



DECLARE
-- local variables here

ls_fippscounty bridge.county%type;

BEGIN

ls_fippscounty := f_get_county_fipps('BRIDGE','COUNTY',substr(:new.brkey,0,3));

UPDATE BRIDGE
SET COUNTY = ls_fippscounty
where
bridge.brkey = :new.brkey;

END;
/