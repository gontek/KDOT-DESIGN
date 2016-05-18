CREATE OR REPLACE FORCE VIEW pontis.v_expan_dev (brkey,adminarea,maint_rte_num,design_ref_post,"LOCATION",featint,dksurface,deckmatrl,strtype,expdev_type,expan_dev_sort) AS
(
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','1') as expdev_type,
       '1' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '1') or
      (u.expan_dev_near = '1')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','2') as expdev_type,
       '2' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '2') or
      (u.expan_dev_near = '2')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','3') as expdev_type,
       '3' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '3') or
      (u.expan_dev_near = '3')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','4') as expdev_type,
       '4' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '4') or
      (u.expan_dev_near = '4')))
      union all
  select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','5') as expdev_type,
       '5' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '5') or
      (u.expan_dev_near = '5')))
      union all
 select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','6') as expdev_type,
       '6' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '6') or
      (u.expan_dev_near = '6')))
      union all
  select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','7') as expdev_type,
       '7' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '7') or
      (u.expan_dev_near = '7')))
         union all
 select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','8') as expdev_type,
       '8' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '8') or
      (u.expan_dev_near = '8')))
      union all
 select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','9') as expdev_type,
       '9' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '9') or
      (u.expan_dev_near = '9')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','10') as expdev_type,
       '10' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '10') or
      (u.expan_dev_near = '10')))
      union all
 select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','11') as expdev_type,
       '11' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '11') or
      (u.expan_dev_near = '11')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','12') as expdev_type,
       '12' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '12') or
      (u.expan_dev_near = '12')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','15') as expdev_type,
       '15' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '15') or
      (u.expan_dev_near = '15')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','16') as expdev_type,
       '16' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '16') or
      (u.expan_dev_near = '16')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','17') as expdev_type,
       '17' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '17') or
      (u.expan_dev_near = '17')))
      union all
 select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','18') as expdev_type,
       '18' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '18') or
      (u.expan_dev_near = '18')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','19') as expdev_type,
       '19' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '19') or
      (u.expan_dev_near = '19')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','20') as expdev_type,
       '20' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '20') or
      (u.expan_dev_near = '20')))
      UNION ALL
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','21') as expdev_type,
       '21' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '21') or
      (u.expan_dev_near = '21')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','22') as expdev_type,
       '22' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '22') or
      (u.expan_dev_near = '22')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','23') as expdev_type,
       '23' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '23') or
      (u.expan_dev_near = '23')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','24') as expdev_type,
       '24' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '24') or
      (u.expan_dev_near = '24')))
      union all
  select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','25') as expdev_type,
       '25' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '25') or
      (u.expan_dev_near = '25')))
      union all
 select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','26') as expdev_type,
       '26' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '26') or
      (u.expan_dev_near = '26')))
      union all
  select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','27') as expdev_type,
       '27' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '27') or
      (u.expan_dev_near = '27')))
         union all
 select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','28') as expdev_type,
       '28' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '28') or
      (u.expan_dev_near = '28')))
      union all
 select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','29') as expdev_type,
       '29' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '29') or
      (u.expan_dev_near = '29')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','30') as expdev_type,
       '30' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '30') or
      (u.expan_dev_near = '30')))
      union all
 select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','31') as expdev_type,
       '31' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '31') or
      (u.expan_dev_near = '31')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','32') as expdev_type,
       '32' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '32') or
      (u.expan_dev_near = '32')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','33') as expdev_type,
       '33' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '33') or
      (u.expan_dev_near = '33')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','34') as expdev_type,
       '34' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '34') or
      (u.expan_dev_near = '34')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','35') as expdev_type,
       '35' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '35') or
      (u.expan_dev_near = '35')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','36') as expdev_type,
       '36' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '36') or
      (u.expan_dev_near = '36')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','37') as expdev_type,
       '37' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '37') or
      (u.expan_dev_near = '37')))
      union all
 select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','38') as expdev_type,
       '38' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '38') or
      (u.expan_dev_near = '38')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','39') as expdev_type,
       '39' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '39') or
      (u.expan_dev_near = '39')))
      union all
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','40') as expdev_type,
       '40' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '40') or
      (u.expan_dev_near = '40')))
      UNION ALL
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','41') as expdev_type,
       '41' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '41') or
      (u.expan_dev_near = '41')))
       UNION ALL
select b.brkey,
       b.adminarea,
        ur.maint_rte_num,
         ub.design_ref_post,
         b.location,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','dksurftype',u.dksurftype) as dksurface,
       f_get_paramtrs_equiv_long('userstrunit','deck_matrl',u.deck_matrl) as deckmatrl,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',u.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',u.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',u.super_design_ty) as strtype,
       f_get_paramtrs_equiv('userstrunit','expan_dev','42') as expdev_type,
       '42' as expan_dev_sort
from bridge b, userstrunit u, structure_unit s, userrway ur, userbrdg ub
where u.brkey = b.brkey and
      b.district <> '9' and
      s.brkey = b.brkey and
      ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey)and
      ub.brkey = b.brkey and
      u.strunitkey = s.strunitkey and
      s.strunittype = '1' and
   b.brkey in (select distinct brkey from userstrunit u
       where u.brkey = b.brkey and
      ((u.expan_dev_far = '42') or
      (u.expan_dev_near = '42'))) )

 ;