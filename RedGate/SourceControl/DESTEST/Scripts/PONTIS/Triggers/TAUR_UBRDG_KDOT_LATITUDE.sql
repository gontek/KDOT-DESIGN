CREATE OR REPLACE trigger pontis.TAUR_UBRDG_KDOT_LATITUDE
  after update of kdot_latitude on pontis.userbrdg  
  for each row
  
  /*-------------------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------------
  -- Trigger:  taur_userbrdg_kdot_LATITUDE
  -- To autocalculate LATITUDE for the bridge table from userbrdg.kdot_LATITUDE..to
  -- deg..min..seconds.
  
  -- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
  ---------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------
--Revision History:
2003-08-21         - KDOT Pontis Deb - calculation trigger to populate bridge.LATITUDE
-------------------from userbrdg_kdot_LATITUDE (if it works...yeah!)
*/



declare
v_kdot_LATITUDE bridge.LATITUDE%TYPE;

begin
--take the kdot_LATITUDE value and tweek it to the bridge.LATITUDE format

v_kdot_LATITUDE := abs(f_latlong_to_minutes(:new.kdot_latitude)/100); 

-- if this works,put it into the bridge table

update bridge
   set LATITUDE = v_kdot_LATITUDE
   where bridge.brkey = :old.brkey;


end TAUR_UBRDG_KDOT_LATITUDE;
/