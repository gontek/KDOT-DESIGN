CREATE OR REPLACE FORCE VIEW pontis.v_structurelog (brkey,district,county,on_under,cou,design_ref_post,county_ref,area,sub_area,"SERIAL","LOCATION",route_prefix,route,recordtype,feature_carried,feature_crossed,under_construction,sortorder,sumlanes,trans_lanes,approachwidth,unit_1,unit_2,unit_3,unit_4,unit_5,unit_6,unit_7,unit_8,unit_9,unit_10,unit_11,unit_12,unit_13,unit_14,unit_15,unit_16,unit_17,unit_18,unit_19,unit_20,unit_21,unit_22,unit_23,unit_24,unit_25,unit_26,unit_27,unit_28,unit_29,unit_30,unit_31,unit_32,unit_33,unit_34,unit_35,unit_36,unit_37,unit_38,designloadtype,invrating,oprrating,dkrating,suprating,subrating,culvrating,scourcrit,wateradeq,prjctid,actvtyyear,microfile) AS
select b.brkey
       ,b.district
       ,b.county
       ,r.on_under
       ,substr(b.brkey,0,3) as cou
       ,ub.design_ref_post
       ,ub.design_county_ref as county_ref
       ,trim(ub.maint_area) as area
       ,trim(ub.sub_area) as sub_area
       ,substr(b.brkey,4,3) as serial
       ,b.location

       ,case
       when ur.route_prefix in ('U','K','I')  then
         ur.route_prefix
         when ur.route_prefix in ('X') then
           ur.maint_rte_prefix
           else
           ur.maint_rte_prefix
          end as route_prefix
        ,case
         when ur.route_prefix in ('U','K','I') then
           to_number(ur.route_num)
           else
             to_number(ur.maint_rte_num)
         end as route
/*
         ,ur.route_prefix
         ,to_number(ur.route_num) as route
*/
     ,case when orientation = '3' and ur.on_under = '1' then 'ADJACENT'
       when ur.on_under <> '1' then 'UNDER'
         else 'ON'
           end as recordtype
       ,b.facility as feature_carried
       ,b.featint as feature_crossed
       ,case when b.yearbuilt = '1000' then
       'Y'
       else 'N'
         end as under_construction
       ,case
         when ur.route_prefix in ('X','I') then 1
         when ur.route_prefix = 'U' then 2
         when ur.route_prefix = 'K' then 3
           else 4
         end as sortorder
        ,b.sumlanes
        ,ur.trans_lanes
        ,round(r.aroadwidth/.3048) as approachwidth
  ,V.UNIT_1,
  V.UNIT_2,
  V.UNIT_3,
  V.UNIT_4,
  V.UNIT_5,
  V.UNIT_6,
  V.UNIT_7,
  V.UNIT_8,
  V.UNIT_9,
  V.UNIT_10,
  V.UNIT_11,
  V.UNIT_12,
  V.UNIT_13,
  V.UNIT_14,
  V.UNIT_15,
  V.UNIT_16,
  V.UNIT_17,
  V.UNIT_18,
  V.UNIT_19,
  V.UNIT_20,
  V.UNIT_21,
  V.UNIT_22,
  V.UNIT_23,
  V.UNIT_24,
  V.UNIT_25,
  V.UNIT_26,
  V.UNIT_27,
  V.UNIT_28,
  V.UNIT_29,
  V.UNIT_30,
  V.UNIT_31,
  V.UNIT_32,
  V.UNIT_33,
  V.UNIT_34,
  V.UNIT_35,
  V.UNIT_36,
  V.UNIT_37,
  V.UNIT_38,
  F_GET_PARAMTRS_EQUIV_LONG('userbrdg','designload_type',ub.designload_type) as designloadtype,
  round(metrictons_to_tons(b.irload)) as INVRATING,
  round(metrictons_to_tons(b.orload)) as OPRRating,
  i.dkrating,
  i.suprating,
  i.subrating,
  i.culvrating,
  i.scourcrit,
  i.wateradeq,
  p.prjctid,
  p.actvtyyear,
  p.micro_no||'/'||p.micro_frame as microfile
from bridge b,
userbrdg ub,
userrway ur,
roadway r,
tbl_placecode t,
V_STRUCTURELOG_UNITS V,
inspevnt i,
mv_latest_inspection mv,
v_bif_capital_prj p
where ub.brkey = b.brkey and
      ur.brkey = b.brkey and
      r.brkey = b.brkey and
      r.on_under = ur.on_under
    and ( (ub.function_type in ('10','30','50','51','70') and r.on_under = '1')or
        (r.on_under <> '1' and feat_cross_type in ('10','30','50','51')))
    and t.brkey = b.brkey
      and v.brkey = b.brkey
      and mv.brkey = b.brkey
      and i.brkey = b.brkey
      and i.inspkey = mv.inspkey
      and p.brkey = b.brkey and
      p.actvtyid = '40'
   --   and b.yearbuilt <> '1000'

    -- and b.district = '1' and
    -- county = '005'
     order by b.district, b.county,sortorder,to_number(design_ref_post)

 ;