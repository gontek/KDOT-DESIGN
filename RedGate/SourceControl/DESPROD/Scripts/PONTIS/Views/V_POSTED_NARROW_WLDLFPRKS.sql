CREATE OR REPLACE FORCE VIEW pontis.v_posted_narrow_wldlfprks (cou,ser,"LOCATION",orientation,route,milepost,feature_crossed,yearbuilt,structure_type,type_3,type_3s2,type_33,approach_width,structure_width,rpt) AS
select substr(b.brkey,1,3) as cou
,substr(b.brkey,4,3) as ser
,b.location
,f_get_paramtrs_equiv_long('userbrdg','orientation',ub.orientation) as orientation
,DECODE(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_prefix')||
 lpad(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_num'),5,'0')||
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_suffix')||
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_id'),'K0090000','KDWP',
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_prefix')||
 lpad(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_num'),5,'0')||
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_suffix')||
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_id') ) route
,ub.design_county_ref milepost
,b.featint FEATURE_CROSSED
,b.yearbuilt
,f_get_paramtrs_equiv_long('bridge','designmain',b.designmain) as structure_type
,round(ub.posted_load_a/0.907185,0) as type_3
,round(ub.posted_load_b/0.907185,0) as type_3s2
,round(ub.posted_load_c/0.907185,0) as type_33
,round(bif.f_get_bif_rdwydata(b.brkey,'1','roadway','aroadwidth')*3.2808399,0) approach_width
, round(bif.f_get_bif_rdwydata(b.brkey,'1','roadway','roadwidth')*3.2808399,0) structure_width,
'A' as rpt
from userbrdg ub,
     bridge b
where ub.brkey = b.brkey and
b.yearbuilt <> '1000'
and b.district <>'9'
and bif.f_get_bif_inspecdata(b.brkey,'userinsp','oppostcl_kdot') = '7' -- use this for posted structures
and b.brkey not in (select brkey from userrway us1
where us1.brkey = b.brkey and
      us1.on_under <> '1' and
      us1.feat_cross_type in ('97','98')) --buried or structural slabs underneath the bridge...don't want these
union all
select substr(b.brkey,1,3) as cou
,substr(b.brkey,4,3) as ser
,b.location
,f_get_paramtrs_equiv_long('userbrdg','orientation',ub.orientation) as orientation
,DECODE(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_prefix')||
 lpad(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_num'),5,'0')||
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_suffix')||
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_id'),'K0090000','KDWP',
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_prefix')||
 lpad(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_num'),5,'0')||
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_suffix')||
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_id') ) route
,ub.design_county_ref milepost
,b.featint FEATURE_CROSSED
,b.yearbuilt
,f_get_paramtrs_equiv_long('bridge','designmain',b.designmain) as structure_type
,round(ub.posted_load_a/0.907185,0) as type_3
,round(ub.posted_load_b/0.907185,0) as type_3s2
,round(ub.posted_load_c/0.907185,0) as type_33
,round(bif.f_get_bif_rdwydata(b.brkey,'1','roadway','aroadwidth')*3.2808399,0) approach_width
, round(bif.f_get_bif_rdwydata(b.brkey,'1','roadway','roadwidth')*3.2808399,0) structure_width,
'B' as rpt
from userbrdg ub,
     bridge b
where ub.brkey = b.brkey and
b.yearbuilt <> '1000'
and b.district <>'9'
and ub.orientation = '1'
and round(bif.f_get_bif_rdwydata(b.brkey,'1','roadway','roadwidth')*3.2808399,1) < 24.0 -- use this for narrow structures
and b.brkey not in (select brkey from userrway us1
where us1.brkey = b.brkey and
      us1.on_under <> '1' and
      us1.feat_cross_type in ('97','98')) --buried or structural slabs underneath the bridge...don't want these
UNION ALL
select substr(b.brkey,1,3) as cou
,substr(b.brkey,4,3) as ser
,b.location
,f_get_paramtrs_equiv_long('userbrdg','orientation',ub.orientation) as orientation
,DECODE(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_prefix')||
 lpad(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_num'),5,'0')||
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_suffix')||
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_id'),'K0090000','KDWP',
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_prefix')||
 lpad(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_num'),5,'0')||
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_suffix')||
 bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_id') ) route
,ub.design_county_ref milepost
,b.featint FEATURE_CROSSED
,b.yearbuilt
,f_get_paramtrs_equiv_long('bridge','designmain',b.designmain) as structure_type
,round(ub.posted_load_a/0.907185,0) as type_3
,round(ub.posted_load_b/0.907185,0) as type_3s2
,round(ub.posted_load_c/0.907185,0) as type_33
,round(bif.f_get_bif_rdwydata(b.brkey,'1','roadway','aroadwidth')*3.2808399,0) approach_width
, round(bif.f_get_bif_rdwydata(b.brkey,'1','roadway','roadwidth')*3.2808399,0) structure_width,
'C' as rpt
from userbrdg ub,
     bridge b
where ub.brkey = b.brkey and
b.yearbuilt <> '1000'
and b.district <>'9'
and ub.orientation = '1'
and ub.owner_kdot = '14' -- use this for KDWP structures
and b.brkey not in (select brkey from userrway us1
where us1.brkey = b.brkey and
      us1.on_under <> '1' and
      us1.feat_cross_type in ('97','98')) --buried or structural slabs underneath the bridge...don't want these
;