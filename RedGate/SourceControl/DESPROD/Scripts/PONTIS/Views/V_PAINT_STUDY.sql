CREATE OR REPLACE FORCE VIEW pontis.v_paint_study (brkey,prfx,route,featint,strtype,paint_type,paint_year,paint_cond,yearbuilt,brdglength,suprstruct_tos_eng,inspec_notes,future_prj,compl_prjs) AS
select b.brkey,
       bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_prefix') Prfx,
       bif.f_get_bif_route(b.brkey) route,
       b.featint,
       f_structuretype_main(b.brkey) as strtype,
        f_get_paramtrs_equiv('userbrdg','super_paint_sys',ub.super_paint_sys) as paint_type,
         extract(year from ub.last_paint_supe) as paint_year,
                bif.f_get_bif_inspecdata(b.brkey,'userinsp','paint_cond') as paint_cond,
         b.yearbuilt,
          round(b.length/.3048) brdglength,
          round(ub.suprstruct_tos / .9072) as suprstruct_tos_eng,
       bif.f_get_bif_inspecdata(b.brkey,'inspevnt','notes') as inspec_notes,
       case
         when f_broms_worktype(b.brkey) like '%Paint%' then f_broms_proj(b.brkey)||' '||f_broms_worktype(b.brkey)||
           ' '||'FY  '||bif.f_get_bif_bromsprjs(b.brkey,'progyear')
           else ''
             end as future_prj,
       case
          when f_cansys_proj_actvtyid(b.brkey,'42') = '42' then
       'Paint Proj  '||'FY '||f_cansys_proj_date(b.brkey,'42')||'  '||f_cansys_proj(b.brkey,'42')
       else
         ''
         end as compl_prjs
from bridge b, userbrdg ub
where ub.brkey = b.brkey and
substr(b.brkey,4,1) <> '5' and
nvl(ub.suprstruct_tos,-1) > 0.0 and
kta_insp not in ('0','1') and
b.district <> '9'
order by    bif.f_get_bif_route(b.brkey), b.brkey
;