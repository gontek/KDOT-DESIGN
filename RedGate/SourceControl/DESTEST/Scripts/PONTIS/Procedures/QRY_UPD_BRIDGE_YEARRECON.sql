CREATE OR REPLACE procedure pontis.QRY_UPD_BRIDGE_YEARRECON is

begin

/* CREATED TO TAKE CANSYS PROJECT DATA TO UPDATE BRIDGE.YEARRECON (NBI 106) FIELD
   AFTER THE MATERIALIZED VIEW V_BIF-CAPITAL_PRJ HAS BEEN REFRESHED
   created 10/6/2009 by dk
   
*/




update bridge
set yearrecon = (select
       max(to_char(actvtydate,'YYYY'))
from v_bif_capital_prj v
where v.brkey = bridge.brkey and
v.actvtyid in ('13','14','15','17','18','19') );


commit;
  
end;

 
/