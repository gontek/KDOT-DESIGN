CREATE OR REPLACE FORCE VIEW pontis.v_active_structure_count (brkey,strtype,kdot_latitude,kdot_longitude,rte_prefx,route,route_ref,brdg_culv) AS
select b.brkey
       ,f_structuretype_main(B.BRKEY) STRTYPE
       ,UB.kdot_latitude
       ,UB.kdot_longitude
      , bif.f_get_bif_rdwydata(B.brkey,'1','userrway','maint_rte_prefix') rte_prefx
      , bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_num') as route
       ,ub.design_ref_post route_ref,
      case
        when substr(b.brkey,4,1) = '5'
          then 'C'
            else 'B'
              end as brdg_culv
from bridge B, userbrdg UB,roadway r
where B.brkey = UB.brkey and
      r.brkey = b.brkey and
      r.on_under = '1'
  --    and avg_hi is not null and
   --   substr(B.brkey,4,1) <> '5'
   and   B.yearbuilt <> '1000' and
    B.district <> '9' and
     function_type <> '90'
;