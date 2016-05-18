CREATE MATERIALIZED VIEW pontis.mv_priority_opt (brkey,priority_opt,po_date)
REFRESH START WITH TO_DATE('2016-5-18 13:38:32', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE + (DECODE(TO_CHAR(SYSDATE,'D'),6,3,7,2,1)) 
AS SELECT SUBSTR(d.str_name,2,3)||substr(d.str_name,8,3) as brkey,
       e.EP02 as priority_opt,
       e.EP01 as po_date
from can_v_str_EPFS@canp e,
     can_v_str_brid@canp d
where 1=1
and e.str_top_id = d.str_id
and e.str_end_date is null
and d.str_end_date is null;