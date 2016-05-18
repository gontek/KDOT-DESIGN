CREATE OR REPLACE FORCE VIEW pontis.v_ks_latest_ratings ("IDENTIFIER",brkey,adminarea,inspkey,inspdate,dkrating,suprating,subrating,culvrating,chanrating,nbi_rating,scourcrit,strrating,deckgeom,underclr,suff_rate,deck_hi,structure_hi,oppostcl,fhwa_status,uwater_insp_typ,super_comp_hi,wateradeq,fclastinsp,uwlastinsp) AS
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
       u.deck_hi,
       u.structure_hi,
       i.oppostcl,
       u.fhwa_status,
       u.uwater_insp_typ,
       u.super_comp_hi,
       i.wateradeq,
       i.fclastinsp,
       i.uwlastinsp
from bridge b, userinsp u,inspevnt i, mv_latest_inspection m
where i.brkey = b.brkey and
      m.brkey = b.brkey and
      u.brkey = b.brkey and
      u.inspkey = m.inspkey and
      i.inspkey = m.inspkey and
      u.brinspfreq_kdot <> '0' and
      b.district <> '9'
      and u.oppostcl_kdot <> '5'
order by b.brkey

 ;