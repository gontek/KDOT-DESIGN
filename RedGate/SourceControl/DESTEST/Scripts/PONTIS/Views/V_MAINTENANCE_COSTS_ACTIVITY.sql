CREATE OR REPLACE FORCE VIEW pontis.v_maintenance_costs_activity (brkey,acct_date,task_id,totalpertask) AS
(

select mv.brkey, acct_date,TASK_ID,
sum(amount)AS TOTALPERTASK from mv_maintenance_costs mv
GROUP BY BRKEY, ACCT_DATE, TASK_ID)
ORDER BY BRKEY, ACCT_DATE DESC

 ;