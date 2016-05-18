CREATE OR REPLACE FORCE VIEW pontis.v_ks_nxtlatest_ratings ("IDENTIFIER",brkey,adminarea,inspkey,inspdate,dkrating,suprating,subrating,culvrating,chanrating,nbi_rating,scourcrit,strrating,deckgeom,underclr,suff_rate,deck_hi,structure_hi,oppostcl,fhwa_status,uwater_insp_typ,super_comp_hi,wateradeq,fclastinsp,uwlastinsp) AS
select  '2'as identifier,
        b.brkey,
        nvl(b.adminarea,'') as adminarea,
        nvl(i.inspkey,'NONE') as inspkey,
        nvl(i.inspdate,'') as inspdate,
        nvl(i.dkrating,'_') as dkrating,
        nvl(i.suprating,'_') as suprating,
        nvl(i.subrating,'_') as subrating,
        nvl(i.culvrating,'_') as culvrating,
        nvl(i.chanrating, '_') as chanrating,
        nvl(i.nbi_rating, '_') as nbi_rating,
        nvl(i.scourcrit, '_') as scourcrit,
        nvl(i.strrating, '_') as strrating,
        nvl(i.deckgeom, '_') as deckgeom,
        nvl(i.underclr, '_') as underclr,
        nvl(i.suff_rate,'-1') as suff_rate,
        nvl(u.deck_hi,'-1') as deck_hi,
        nvl(u.structure_hi,'-1') as structure_hi,
        nvl(i.oppostcl,'_') as oppostcl,
        nvl(u.fhwa_status,'_') as fhwa_status,
        nvl(u.uwater_insp_typ,'_') as uwater_insp_typ,
        nvl(u.super_comp_hi,-1) as super_comp_hi,
        nvl(i.wateradeq,'-1') as wateradeq,
        nvl(i.fclastinsp,'') as fclastinsp,
        nvl(i.uwlastinsp,'') as uwlastinsp
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
       b.district <> '9' and
       u.oppostcl_kdot <> '5'
 order by b.brkey

 ;