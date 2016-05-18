CREATE OR REPLACE FORCE VIEW pontis.v_health_index_by_dist (brkey,district,deck_hi,super_hi,sub_hi,culv_hi,avg_hi) AS
(      select b.brkey,
         b.district, 
         u.deck_comp_hi as deck_hi,
         u.super_comp_hi as super_hi,  
         u.sub_comp_hi as sub_hi,  
         u.culv_comp_hi as culv_hi,
          ur.avg_hi

  from bridge b, mv_latest_inspection i, userinsp u , userbrdg ur 
  where i.brkey = b.brkey and
        u.brkey = b.brkey and
        ur.brkey = b.brkey and 
        u.inspkey = i.inspkey and  ur.avg_hi is not null and  b.brkey not in ('011097','011098','011099'))

 ;