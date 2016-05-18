CREATE OR REPLACE FORCE VIEW pontis.v_hi_by_category (brkey,avg_hi,inspkey,deck_comp_hi,super_comp_hi,sub_comp_hi,culv_comp_hi,"CATEGORY") AS
Select B1.brkey,
       ub.avg_hi,
       ui.inspkey,
       ui.deck_comp_hi,
       ui.super_comp_hi,
       ui.sub_comp_hi,
       ui.culv_comp_hi,
case
  when ub.avg_hi > 95 then 11
  when ub.avg_hi > 90 and ub.avg_hi <= 95 then 10
  when ub.avg_hi > 85 and ub.avg_hi <= 90 then 9
  when ub.avg_hi > 80 and ub.avg_hi <= 85 then 8
  when ub.avg_hi > 75 and ub.avg_hi <= 80 then 7
  when ub.avg_hi > 70 and ub.avg_hi <= 75 then 6
  when ub.avg_hi > 65 and ub.avg_hi <= 70 then 5
  when ub.avg_hi > 60 and ub.avg_hi <= 65 then 4
  when ub.avg_hi > 55 and ub.avg_hi <= 60 then 3
  when ub.avg_hi > 50 and ub.avg_hi <= 55 then 2
  when ub.avg_hi <= 50 then 1
  else 0
  end as Category

from bridge B1, userbrdg ub, userinsp ui, mv_latest_inspection mv
where
  ub.brkey = b1.brkey and
  ub.avg_hi is not null and
  B1.yearbuilt <> '1000'and
  ui.brkey = b1.brkey and
  mv.brkey = b1.brkey and
  ui.inspkey = mv.inspkey and
  B1.district <> '9' and
  B1.brkey not in ('022028','022029','046314','105067','105151','105166')

 ;