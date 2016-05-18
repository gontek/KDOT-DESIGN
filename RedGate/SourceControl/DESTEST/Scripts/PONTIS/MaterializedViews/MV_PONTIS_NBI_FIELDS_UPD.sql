CREATE MATERIALIZED VIEW pontis.mv_pontis_nbi_fields_upd (brkey,nbi_5a,nbi38,nbi28b,nbi42a,nbi42b,nbi43a,nbi43b,nbi44a,nbi44b,nbi_45,nbi_46,nbi47_on,nbi48,nbi54a,nbi54b,nbi55a,nbi55b,nbi56,nbi75a,nbi75b,nbi76,nbi94,nbi95,nbi96,nbi97)
REFRESH START WITH TO_DATE('2016-5-18 12:25:42', 'yyyy-mm-dd hh24:mi:ss') NEXT sysdate + 6/24 
AS select b.brkey,
'1' as nbi_5a,
 nbip.f_check_nbi_38(b.brkey)as NBI38,
 nbip.f_check_nbi_28b_on(b.brkey)  nbi28B,
 case
   when b.brkey = '096108' then '4'
     else
       nbip.f_check_nbi_42a(b.brkey)
  end as nbi42a,
nbip.f_check_nbi_42b(b.brkey) nbi42b,
substr(nbip.f_check_nbi_43(b.brkey),1,1) nbi43a,
ltrim(substr(nbip.f_check_nbi_43(b.brkey),-2),'0') nbi43b,
substr(nbip.f_check_nbi_44(b.brkey),1,1) as nbi44a,
NVL(LTRIM(SUBSTR(NBIP.F_CHECK_NBI_44(b.brkey),-2),'0'),'00')nbi44b,
to_number(nbip.f_check_nbi_45(b.brkey)) nbi_45,
to_number(nbip.f_check_nbi_46(b.brkey)) nbi_46,
nbip.f_check_nbi_47_on(b.brkey) nbi47_on,
nbip.f_check_nbi_48(b.brkey) nbi48,
nbip.f_check_nbi_54a(b.brkey)  nbi54a,
nbip.f_check_nbi_54b(b.brkey)  nbi54b,
nbip.f_check_nbi_55a(b.brkey)  nbi55a,
nbip.f_check_nbi_55b(b.brkey)  nbi55b,
nbip.f_check_nbi_56(b.brkey)  nbi56,
substr(nbip.f_check_nbi_75a_b(b.brkey),1,2)  nbi75a,
substr(nbip.f_check_nbi_75a_b(b.brkey),3,1)  nbi75b,
nbip.f_check_nbi_76(b.brkey) as nbi76,
to_number(ltrim(substr(nbip.f_check_nbi_94_95_96_97(b.brkey),0,6),'0'))*1000  nbi94,
to_number(ltrim(substr(nbip.f_check_nbi_94_95_96_97(b.brkey),7,6),'0'))*1000  nbi95,
to_number(ltrim(substr(nbip.f_check_nbi_94_95_96_97(b.brkey),13,6),'0'))*1000  nbi96,
substr(nbip.f_check_nbi_94_95_96_97(b.brkey),-4)  nbi97
from bridge b

union all

select b.brkey,
on_under nbi5a,
 nbip.f_check_nbi_38(b.brkey)as NBI38,
 nbip.f_check_nbi_28b_on(b.brkey)  nbi28B,
 case
   when b.brkey = '096108' then '4'
     else
       nbip.f_check_nbi_42a(b.brkey)
  end as nbi42a,
nbip.f_check_nbi_42b(b.brkey) nbi42b,
substr(nbip.f_check_nbi_43(b.brkey),1,1) nbi43a,
ltrim(substr(nbip.f_check_nbi_43(b.brkey),-2),'0') nbi43b,
substr(nbip.f_check_nbi_44(b.brkey),1,1) as nbi44a,
NVL(LTRIM(SUBSTR(NBIP.F_CHECK_NBI_44(b.brkey),-2),'0'),'00')nbi44b,
to_number(nbip.f_check_nbi_45(b.brkey)) nbi_45,
to_number(nbip.f_check_nbi_46(b.brkey)) nbi_46,
nbip.f_check_nbi_47_undr(b.brkey,b.on_under) nbi47_undr,
nbip.f_check_nbi_48(b.brkey) nbi48,
nbip.f_check_nbi_54a(b.brkey)  nbi54a,
nbip.f_check_nbi_54b(b.brkey)  nbi54b,
nbip.f_check_nbi_55a(b.brkey)  nbi55a,
nbip.f_check_nbi_55b(b.brkey)  nbi55b,
nbip.f_check_nbi_56(b.brkey)  nbi56,
substr(nbip.f_check_nbi_75a_b(b.brkey),1,2)  nbi75a,
substr(nbip.f_check_nbi_75a_b(b.brkey),3,1)  nbi75b,
nbip.f_check_nbi_76(b.brkey) as nbi76,
to_number(ltrim(substr(nbip.f_check_nbi_94_95_96_97(b.brkey),0,6),'0'))*1000  nbi94,
to_number(ltrim(substr(nbip.f_check_nbi_94_95_96_97(b.brkey),7,6),'0'))*1000  nbi95,
to_number(ltrim(substr(nbip.f_check_nbi_94_95_96_97(b.brkey),13,6),'0'))*1000  nbi96,
substr(nbip.f_check_nbi_94_95_96_97(b.brkey),-4)  nbi97

from userrway b
where b.feat_cross_type in ('10','30','50','51');