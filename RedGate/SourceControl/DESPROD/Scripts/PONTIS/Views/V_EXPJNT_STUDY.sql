CREATE OR REPLACE FORCE VIEW pontis.v_expjnt_study (brkey,yearbuilt,addt,adminarea,maint_rte_num,strtype,expdev_type,brdglength,qty,cond1_qty,cond2_qty,cond3_qty,notes,future_prj,compl_prjs) AS
select v.brkey,
       b.yearbuilt,
       bif.f_get_bif_rdwydata(b.brkey,'1','roadway','adttotal') as addt,
       v.adminarea,
        v.maint_rte_num,
       v.strtype,
       v.expdev_type,
       round(b.length/.3048) brdglength,
       (select sum(qty)
       from mv_cals_elements e
       where e.brkey = b.brkey and
       e.elemkey in ('300','301','302','303','304')
       group by brkey) qty,
      (select sum(cond1)
       from mv_cals_elements e
       where e.brkey = b.brkey and
       e.elemkey in ('300','301','302','303','304')
       group by brkey) cond1_qty,
       (select sum(cond2)
       from mv_cals_elements e
       where e.brkey = b.brkey and
       e.elemkey in ('300','301','302','303','304')
       group by brkey) cond2_qty,
       (select sum(cond3)
       from mv_cals_elements e
       where e.brkey = b.brkey and
       e.elemkey in ('300','301','302','303','304')
       group by brkey) cond3_qty,
       i.notes,
       case
         when f_broms_worktype(b.brkey) like '%EXP%' then f_broms_proj(b.brkey)||' '||f_broms_worktype(b.brkey)||
           ' '||'FY  '||bif.f_get_bif_bromsprjs(b.brkey,'progyear')
           else ''
             end as future_prj,
       case
          when f_cansys_proj_actvtyid(b.brkey,'7') = '7' then
       'Repl Exp Jnt  '||'FY '||f_cansys_proj_date(b.brkey,'7')||'  '||f_cansys_proj(b.brkey,'7')
       else
         ''
         end as compl_prjs
from v_expan_dev v, bridge b, mv_latest_inspection mv, inspevnt i
where v.brkey = b.brkey and
i.brkey = b.brkey and
mv.brkey = b.brkey and
i.inspkey = mv.inspkey and
b.servtypon <> '3' and
 expan_dev_sort in ('9','21','26','33','37')
;