CREATE OR REPLACE FORCE VIEW pontis.v_asbesto (brkey,waterproof_memb,bituminous_surf,elastomeric_bearing,bitwearsurf,stripseal_compjnts,utility) AS
(
select b.brkey,
case when b.brkey in (select brkey from userstrunit u
  where u.brkey = b.brkey and
  u.dksurftype = '11') then
  'T'
  else 'F'
    end as waterproof_memb,
case when b.brkey in (select brkey from userstrunit u
  where u.brkey = b.brkey and
  u.dksurftype = '10') then
  'T'
  else 'F'
    end as bituminous_surf,
 case when b.brkey in (select brkey from userstrunit u
  where u.brkey = b.brkey and
  u.bearing_type = '5') then
  'T'
  else 'F'
    end as elastomeric_bearing,
    case when b.brkey in (select brkey from userstrunit u
  where u.brkey = b.brkey and
  u.dksurftype = '10') then
  'T'
  else 'F'
    end as bitwearsurf,
  case when b.brkey in (select p.brkey from pon_elem_insp p, mv_latest_inspection mv
    where p.brkey = b.brkey and
    mv.brkey = p.brkey and
    mv.inspkey = p.inspkey and
    p.elem_key in ('300','302') ) then
    'T'
    else 'F'
      end as StripSeal_CompJnts ,
 case when b.brkey in (select brkey from userbrdg ub
  where ub.brkey = b.brkey and
 (( nvl(ub.attach_type_1,'-1') not in ('-1','_','0')) or
  (nvl(ub.attach_type_2,'-1') not in ('-1','_','0')) or
  (nvl(ub.attach_type_3,'-1') not in ('-1','_','0'))))
  then
  'T'
  else 'F'
    end as utility
from bridge b, userbrdg ub
where ub.brkey = b.brkey and
 district <> '9' and yearbuilt <> '1000' and
substr(b.brkey,4,1) <> '5' and
nvl(ub.kta_insp,'-1') not in ('1','0'))
;