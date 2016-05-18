CREATE OR REPLACE FORCE VIEW pontis.v_priority_opt_check (brkey,priority_opt,po_date) AS
(
select BRKEY, PRIORITY_OPT, PO_DATE
from mv_priority_opt t
where t.brkey in
(select u.brkey from userinsp u, mv_latest_inspection mv
where mv.brkey = t.brkey and
      u.brkey = t.brkey and
      u.inspkey = mv.inspkey and
      u.priority_opt <> t.priority_opt))

 ;