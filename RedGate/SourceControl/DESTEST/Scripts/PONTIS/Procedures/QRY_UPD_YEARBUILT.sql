CREATE OR REPLACE procedure pontis.QRY_UPD_YEARBUILT is


/* CREATED TO TAKE CANSYS PROJECT DATA TO UPDATE BRIDGE.YEARBUILT (NBI 27) FIELD
   AUTOMAGICALLY AFTER THE MATERIALIZED VIEW V_BIF_CAPITAL_PRJ HAS BEEN REFRESHED
   created 5/19/2009 by dk
   
*/


begin

update bridge
set yearbuilt = (select actvtyyear from v_bif_capital_prj p
where p.brkey = bridge.brkey and
      p.actvtyid = '40') 
where district <> '9';
      
commit;
  
end;

 
/