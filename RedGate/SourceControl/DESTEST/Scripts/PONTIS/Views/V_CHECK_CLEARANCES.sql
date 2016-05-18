CREATE OR REPLACE FORCE VIEW pontis.v_check_clearances (brkey,kdot_latitude,kdot_longitude,comparekey,vclrinv_n,vclrinv_s,vclrinv_e,vclrinv_w) AS
(select ub.brkey, kdot_latitude, kdot_longitude,kdot_latitude||kdot_longitude as comparekey,
vclrinv_n,vclrinv_s,vclrinv_e,vclrinv_w
from userrway us, userbrdg ub, bridge b
where ub.brkey = b.brkey and
      us.brkey = b.brkey and
      us.on_under = '1' and
      b.district <> '9' and
      b.yearbuilt <> '1000' and
      substr(b.brkey,4,1) <> '5' and
     (( nvl(vclrinv_n,30.45) < 30.44 ) or
     ( nvl(vclrinv_s,30.45) < 30.44 ) or
    (  nvl(vclrinv_e,30.45) < 30.44 ) or
    (  nvl(vclrinv_w,30.45) < 30.44)))

 ;