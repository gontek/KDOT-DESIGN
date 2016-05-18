CREATE MATERIALIZED VIEW pontis.mv_maintenance_cost_totals (brkey,acct_date,task,totalpertask)
AS select mv.brkey, acct_date,
f_get_paramtrs_equiv('bm_task','task_id',mv.TASK_ID) as task,
sum(amount)AS TOTALPERTASK from mv_maintenance_costs mv
GROUP BY BRKEY, ACCT_DATE, TASK_ID;