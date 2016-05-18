CREATE OR REPLACE FORCE VIEW pontis.v_tblcansys (county,"SERIAL",brdg_culv,prefix,route,suffix,routeunique_id,route_id,ref_pt,fctyp,sftyp,brorient,direct,directionid,deck,super,sub,culv,bci,destrk,deswt,vclt,vcrt,uclt,ucrt,yrbuilt,yrrpr,supermat,supertyp,superdes,ng,fill,"SIGN",dist,area,aadt,spc1,spc2,"OWNER",roadway,"FUNCTION",feature,locdesc,suffrate,inspint,projnum,projwork,letdate,painttons,painttype,paintyear,paintcond,lastinsp,ponum,fedfundelig,brkey,lastupdated) AS
(
--save rows as tblbridgedata.txt
select substr(b.brkey,1,3) as county,
       substr(b.brkey,4,5) as serial,
       substr(b.bridge_id,6,1) as brdg_culv,
       ur.maint_rte_prefix prefix,
       ur.maint_rte_num route,
       ur.maint_rte_suffix suffix,
       ur.maint_rte_id routeunique_id,
       f_abcdlist_routeid(b.brkey) as route_id,
       ub.design_ref_post ref_pt,
       '-1' as fctyp,
       '-1' as sftyp,
       ub.orientation brorient,
       '-1' as direct,
       '-1' as directionid,
       i.dkrating deck,
       i.suprating super,
       i.subrating sub,
       i.culvrating as culv,
       ub.avg_hi BCI,
       '-1' as destrk,
       '-1' as deswt,
       '-1' as vclt,
       '-1' as vcrt,
       '-1' as uclt,
       '-1' as ucrt,
       b.yearbuilt as yrbuilt,
       b.yearrecon as yrrpr,
       us.unit_material supermat,
       us.unit_type supertyp,
       nvl(us.super_design_ty,0) superdes,
       f_num_girders(ub.brkey) NG,
      round(nvl(ub.culv_fill_depth / .3048,0),2) as fill,
       ub.posted_sign_type as sign,
       b.district as dist,
       ub.maint_area as area,
       r.adttotal as aadt,
       '-1' as spc1,
       '-1' as spc2,
       b.owner,
       round(roadwidth/ .3048) as roadway,
       b.facility function,
       b.featint feature,
       b.location as locdesc,
       i.suff_rate as suffrate,
       ui.brinspfreq_kdot as inspint,
       f_broms_proj(b.brkey) as projnum,
       f_broms_worktype(b.brkey) as projwork,
       bif.f_get_bif_bromsprjs(b.brkey,'progyear') as letdate,
       nvl(round(ub.suprstruct_tos / .9072),0) as PaintTons,
       nvl(ub.super_paint_sys,0) as painttype,
       nvl(extract(year from last_paint_supe),0) as PaintYear,
       ui.paint_cond as paintcond,
       i.inspdate as lastinsp,
       ui.priority_opt * 10000 as ponum,
       case
         when suff_rate between 0 and 50 and nbi_rating in ('1','2')
           then 'BR'
         when suff_rate > 50 and nbi_rating in ('1','2') then
           'BH'
       else 'NE'
       End as FedFundElig,
       b.brkey,
       sysdate as lastupdated
from bridge b, userbrdg ub,userrway ur, inspevnt i, userinsp ui, userstrunit us, structure_unit s,
     roadway r, mv_latest_inspection mv
where          ub.brkey = b.brkey and
               r.brkey = b.brkey and
               ur.on_under = r.on_under and
               r.on_under = '1'  and
               ur.brkey = b.brkey and
               i.brkey = b.brkey and
               ui.brkey = b.brkey and
               us.brkey = b.brkey and
               s.brkey = b.brkey and
               us.strunitkey = s.strunitkey and
               s.strunittype = '1' and
               mv.brkey = b.brkey and
               i.inspkey = mv.inspkey and
               ui.inspkey = mv.inspkey
       )
;