CREATE OR REPLACE FORCE VIEW pontis.v_scour_findings (brkey,inspkey,scour_find_date,scour_find_comp,scour_comments) AS
select u.brkey,
       u.inspkey,
       u.scour_find_date,
       u.scour_find_comp,
       u.scour_comments
from userinsp u, mv_latest_inspection m
where u.brkey = m.brkey and
      u.inspkey = m.inspkey and
    ((u.scour_find_date <> '01/jan/1901' and
      u.scour_find_comp is null) or
      (u.scour_find_date <> '01/jan/1901' and
      u.scour_find_comp = '01/jan/1901'))
      order by u.brkey

 ;