CREATE OR REPLACE FORCE VIEW pontis.v_compare_ratings_test ("IDENTIFIER",brkey,adminarea,inspkey,inspdate,dkrating,suprating,subrating,culvrating,chanrating,nbi_rating,scourcrit,strrating,deckgeom,underclr,suff_rate,deck_comp_hi,super_comp_hi,sub_comp_hi,culv_comp_hi,oppostcl,fhwa_status) AS
select '1' as identifier,
       b.brkey,
       b.adminarea,
       i.inspkey,
       i.inspdate,
       i.dkrating,
       i.suprating,
       i.subrating,
       i.culvrating,
       i.chanrating,
       i.nbi_rating,
       i.scourcrit,
       i.strrating,
       i.deckgeom,
       i.underclr,
       i.suff_rate,
       u.deck_comp_hi,
       u.super_comp_hi,
       u.sub_comp_hi,
       u.culv_comp_hi,
       i.oppostcl,
       u.fhwa_status
from bridge b, userinsp u,inspevnt i, mv_latest_inspection m
where i.brkey = b.brkey and
      m.brkey = b.brkey and
      u.brkey = b.brkey and
      u.inspkey = m.inspkey and
      i.inspkey = m.inspkey and
      u.brinspfreq_kdot <> '0' and
      b.district <> '9'

union all
select  '2'as identifier,
        b.brkey,
       b.adminarea,
       i.inspkey,
       i.inspdate,
       i.dkrating,
       i.suprating,
       i.subrating,
       i.culvrating,
       i.chanrating,
       i.nbi_rating,
       i.scourcrit,
       i.strrating,
       i.deckgeom,
       i.underclr,
       i.suff_rate,
       u.deck_comp_hi,
       u.super_comp_hi,
       u.sub_comp_hi,
       u.culv_comp_hi,
       i.oppostcl,
       u.fhwa_status
from bridge b, userinsp u,inspevnt i, mv_latest_inspection m
where i.brkey = b.brkey and
      m.brkey = b.brkey and
      u.brkey = b.brkey and
      u.inspkey = i.inspkey  and
      i.inspkey = (select max(inspkey) from inspevnt j
      where j.brkey = b.brkey and
       j.inspdate = (select max(inspdate) from inspevnt k
           where k.brkey = b.brkey and
          k.inspkey not in (select inspkey from mv_latest_inspection m1
           where m1.brkey = b.brkey) )) and
       u.brinspfreq_kdot <> '0' and
       b.district <> '9'

 ;