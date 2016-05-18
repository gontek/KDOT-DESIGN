CREATE OR REPLACE FORCE VIEW pontis.v_awar_rpt (brkey,strtype,avg_hi,route_class,deck_area_eng,roadway_name,detour_length_eng,truckpct) AS
(
select  b.brkey
        , f_get_paramtrs_equiv_long('USERSTRUNIT','UNIT_MATERIAL',us.unit_material)||
         f_get_paramtrs_equiv_long('USERSTRUNIT','UNIT_TYPE',us.unit_type)||
        f_get_paramtrs_equiv_long('USERSTRUNIT','SUPER_DESIGN_TY',us.super_design_ty) as strtype
        ,ub.avg_hi avg_hi
        ,br.route_class
        ,b.deck_area / .09290304 as deck_area_eng
        ,roadway_name
        ,bypasslen / 1.609344 as detour_length_eng
        ,truckpct
 from  bridge b,
 roadway ur,
 tbl_route_class br,
 userbrdg ub,
  userstrunit us,
 structure_unit s
 where ub.brkey = b.brkey and
       ur.brkey = b.brkey and
      ur.on_under = '1' and
      us.brkey = b.brkey and
      s.brkey = b.brkey and
      us.strunitkey = s.strunitkey and
      s.strunittype = '1' and
      --br.brkey = b.brkey and
      substr(b.brkey,4,1) <> '5' and
      ub.avg_hi is not null and
      b.yearbuilt <> '1000' and
      b.brkey not in ('022028','022029','046314','105067','105151','105166') and
      ub.kta_insp not in ('0','1') and
      b.district <> '9' and
      br.brkey = b.brkey(+)
UNION ALL
select  b.brkey
        , f_get_paramtrs_equiv_long('USERSTRUNIT','UNIT_MATERIAL',us.unit_material)||
         f_get_paramtrs_equiv_long('USERSTRUNIT','UNIT_TYPE',us.unit_type)||
        f_get_paramtrs_equiv_long('USERSTRUNIT','SUPER_DESIGN_TY',us.super_design_ty) as strtype
        ,ub.avg_hi avg_hi
        ,'N/A' as route_class
        ,b.deck_area / .09290304 as deck_area_eng
        ,roadway_name
        ,bypasslen / 1.609344 as detour_length_eng
        ,truckpct
 from  bridge b,
 roadway ur,
-- tbl_route_class br,
 userbrdg ub,
 userstrunit us,
 structure_unit s
where ub.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = '1' and
      us.brkey = b.brkey and
      s.brkey = b.brkey and
      us.strunitkey = s.strunitkey and
      s.strunittype = '1' and
 --     br.brkey = b.brkey and
      substr(b.brkey,4,1) <> '5' and
      b.yearbuilt <> '1000' and
      ub.avg_hi is not null and
      b.district <> '9' and
      b.brkey not in ('022028','022029','046314','105067','105151','105166')
      and ub.kta_insp not in ('0','1')
      and b.brkey not in (select brkey from tbl_route_class br1
where br1.brkey = b.brkey))
;