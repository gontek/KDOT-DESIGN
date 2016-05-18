CREATE OR REPLACE FORCE VIEW pontis.v_strlog_posted (cou,ser,"LOCATION",orientation,route,milepost,feature_crossed,year_built,structure_type,type_3,type_3s2,type_33,approach_width,struct_width) AS
select substr(b.brkey,0,3) as cou,
       substr(b.brkey,4,3) as ser,
       b.location,
       f_get_paramtrs_equiv('userbrdg','orientation',u.orientation) orientation,
       bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_prefix')||lpad(bif.f_get_bif_rdwydata(b.brkey,'1',
       'userrway','maint_rte_num'),5,'0')||'00' ROUTE,
       u.design_county_ref MILEPOST,
       b.featint FEATURE_CROSSED,
       b.yearbuilt YEAR_BUILT,
       f_get_paramtrs_equiv_long('bridge','designmain',b.designmain) as structure_type,
       round(u.posted_load_a/0.90718,0) TYPE_3,
       round(u.posted_load_b/0.90718,0) TYPE_3S2,
       round(u.posted_load_c/0.90718,0) TYPE_33,
       ROUND(nvl(bif.f_get_BIF_rdwydata(b.brkey,'1','userrway','aroadwidth_near')*3.2808399,9.9)) APPROACH_WIDTH,
       ROUND(NVL(bif.f_get_bif_rdwydata(b.brkey,'1','roadway','roadwidth')*3.2808399,9.9)) STRUCT_WIDTH


from userbrdg u, bridge b
where u.brkey = b.brkey
and substr(b.brkey,4,1) <> '5'
and   b.yearbuilt <> '1000'
and b.district <> '9'
and u.posted_load_a > 0

order by b.brkey

 ;