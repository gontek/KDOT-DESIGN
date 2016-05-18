CREATE OR REPLACE FORCE VIEW pontis.v_field_check_form (brkey,strucname,unit,strtype,spans,brdg_lgth,rdwy_width,skew,design_method,design_load,adttotal,adtyear,truckpct,posted_restricted,dk_prot,handrail_type,apprpvmt,util,suff_rate,priority_opt,deck,super,sub,culv,avg_hi,history) AS
select b.brkey,
b.strucname,
u.strunitkey as UNIT,
f_structuretype(u.brkey, u.strunitkey)||', '||
f_get_paramtrs_equiv('userstrunit','unit_material',u.unit_material)||f_get_paramtrs_equiv('userstrunit','unit_type',u.unit_type)||
decode(u.super_design_ty,'0','',f_get_paramtrs_equiv('userstrunit','super_design_ty',u.super_design_ty) ) strtype,
u.num_spans_grp_1||' @ '||round(len_span_grp_1/0.3048)
||decode(u.num_spans_grp_2,null,'',', '||u.num_spans_grp_2||' @ '||round(len_span_grp_2/0.3048))
||decode(u.num_spans_grp_3,null,'',', '||u.num_spans_grp_3||' @ '||round(len_span_grp_3/0.3048))
||decode(u.num_spans_grp_4,null,'',', '||u.num_spans_grp_4||' @ '||round(len_span_grp_4/0.3048))
||decode(u.num_spans_grp_5,null,'',', '||u.num_spans_grp_5||' @ '||round(len_span_grp_5/0.3048))
||decode(u.num_spans_grp_6,null,'',', '||u.num_spans_grp_6||' @ '||round(len_span_grp_6/0.3048))
||decode(u.num_spans_grp_7,null,'',', '||u.num_spans_grp_7||' @ '||round(len_span_grp_7/0.3048))
||decode(u.num_spans_grp_8,null,'',', '||u.num_spans_grp_8||' @ '||round(len_span_grp_8/0.3048))
||decode(u.num_spans_grp_9,null,'',', '||u.num_spans_grp_9||' @ '||round(len_span_grp_9/0.3048))
||decode(u.num_spans_grp_10,null,'',', '||u.num_spans_grp_10||' @ '||round(len_span_grp_10/0.3048)) as spans,
round(b.length/.3048) brdg_lgth,
round(r.roadwidth/.3048) rdwy_width,
nvl(b.skew,0) as skew,
f_get_paramtrs_equiv_long('userbrdg','designload_type',ub.designload_type) design_method,
round(nvl(designload_kdot,0)/0.90718474) as design_load,
r.adttotal,
adtyear,
r.truckpct,
decode(bif.f_get_bif_inspecdata(b.brkey,'userinsp','oppostcl_kdot'),'7','P','8','R','None')posted_restricted,
f_get_paramtrs_equiv('userstrunit','dksurftype',u.dksurftype) dk_prot,
f_get_paramtrs_equiv('userstrunit','rail_type',u.rail_type) handrail_type,
f_field_check_apprs(b.brkey) as ApprPvmt,
case
  when ((nvl(attach_type_1,'_') not in ('_','0')) or
       (nvl(attach_type_2,'_') not in ('_','0')) or
       (nvl(attach_type_3,'_') not in ('_','0')))then
       'True'
       else
        'False'
        end as util,
bif.f_get_bif_inspecdata(b.brkey,'inspevnt','suff_rate')suff_rate,
bif.f_get_bif_inspecdata(b.brkey,'userinsp','priority_opt') priority_opt,
bif.f_get_bif_inspecdata(b.brkey,'inspevnt','dkrating') deck,
bif.f_get_bif_inspecdata(b.brkey,'inspevnt','suprating') super,
bif.f_get_bif_inspecdata(b.brkey,'inspevnt','subrating') sub,
bif.f_get_bif_inspecdata(b.brkey,'inspevnt','culvrating') culv,
ub.avg_hi,
f_field_check_projs(b.brkey) history
from bridge b, userstrunit u, roadway r, userbrdg ub
where u.brkey = b.brkey and
ub.brkey = b.brkey and
r.brkey = b.brkey and
r.on_under = '1' and
 district <> '9'
;