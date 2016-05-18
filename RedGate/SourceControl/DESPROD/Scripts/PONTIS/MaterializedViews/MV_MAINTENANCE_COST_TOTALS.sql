CREATE MATERIALIZED VIEW pontis.mv_maintenance_cost_totals (brkey,acct_date,task,totalpertask)
REFRESH START WITH TO_DATE('2016-5-18 10:40:10', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE + 6/24 
AS select mv.brkey, acct_date,
f_get_paramtrs_equiv('bm_task','task_id',mv.TASK_ID) as task,
sum(amount)AS TOTALPERTASK from mv_maintenance_costs mv
GROUP BY BRKEY, ACCT_DATE, TASK_ID;