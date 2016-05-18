CREATE OR REPLACE trigger pontis.TAUR_UBRDG_KDOT_LONGITUDE
  after update OF kdot_longitude on pontis.userbrdg  
  for each row
  
  /*-------------------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------------
  -- Trigger:  taur_userbrdg_kdot_LONGITUDE
  -- To autocalculate LONGITUDE for the bridge table from userbrdg.kdot_LONGITUDE..to
  -- deg..min..seconds.
  
  -- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
  ---------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------
--Revision History:
2003-08-21         - KDOT Pontis Deb - calculation trigger to populate bridge.LONGITUDE
-------------------from userbrdg_kdot_LONGITUDE (if it works...yeah!)
*/



declare
v_kdot_LONGITUDE bridge.LONGITUDE%TYPE;

begin
--take the kdot_LONGITUDE value and tweek it to the bridge.LONGITUDE format

--v_kdot_LONGITUDE := abs(trunc(:new.kdot_LONGITUDE)*10000 + trunc(mod(:new.kdot_LONGITUDE, 1)*60)*100 +
-- trunc(mod((mod(:new.kdot_LONGITUDE, 1)*60), 1)*60));
v_kdot_longitude := abs(f_latlong_to_minutes(:new.kdot_longitude)/100); 
 

-- if this works,put it into the bridge table

update bridge
   set LONGITUDE = v_kdot_LONGITUDE
   where bridge.brkey = :old.brkey;


end TAUR_UBRDG_KDOT_LONGITUDE;
/