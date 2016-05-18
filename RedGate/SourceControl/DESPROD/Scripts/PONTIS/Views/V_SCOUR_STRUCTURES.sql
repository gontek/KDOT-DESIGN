CREATE OR REPLACE FORCE VIEW pontis.v_scour_structures (brkey,on_under,roadway_name) AS
select bridge.brkey, on_under,roadway_name
from bridge, roadway, userinsp, mv_latest_inspection
where roadway.brkey = bridge.brkey and
      userinsp.brkey = bridge.brkey and
      mv_latest_inspection.brkey = bridge.brkey and
      userinsp.inspkey = mv_latest_inspection.inspkey and
      roadway.on_under = '22' and
      substr(bridge.brkey,4,1) <> '5' and
      userinsp.brinspfreq_kdot not in ('0')

 ;