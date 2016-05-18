CREATE MATERIALIZED VIEW pontis.mv_priority_opt (brkey,priority_opt,po_date)
AS SELECT SUBSTR(d.str_name,2,3)||substr(d.str_name,8,3) as brkey,
       e.EP02 as priority_opt,
       e.EP01 as po_date
from can_v_str_EPFS@canp e,
     can_v_str_brid@canp d
where 1=1
and e.str_top_id = d.str_id
and e.str_end_date is null
and d.str_end_date is null;