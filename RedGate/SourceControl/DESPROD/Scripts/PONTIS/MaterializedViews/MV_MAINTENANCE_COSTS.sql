CREATE MATERIALIZED VIEW pontis.mv_maintenance_costs (brkey,acct_date,activity_num,task_id,project_num,status,quantity,amount)
REFRESH START WITH TO_DATE('2016-3-18 20:26:18', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE + (DECODE(TO_CHAR(SYSDATE,'D'),6,3,7,2,1)) 
AS select  substr(TRNS_ITEM_NUM,1,6)  "BRKEY",
        extract(year from TRNS_INCURRED_DATE )     "ACCT_DATE",
        TRNS_ACTIVITY_NUM   "ACTIVITY_NUM",
        case
          when to_number(trns_task)<10
           then '099'
            else        TRNS_TASK
         end "TASK_ID",
        TRNS_PROJECT_NUM     "PROJECT_NUM",
        TRNS_STATUS "STATUS",
           TRNS_QUANTITY "QUANTITY",
        TRNS_AMOUNT "AMOUNT"
    from dtcpmspd.t_ccfb_trans@db2prod.us.oracle.com T ,
     bridge b
    where  b.brkey = substr(trns_item_num,1,6)
  --  AND EXTRACT(YEAR FROM TRNS_incurred_DATE) = '2011'
    and TRNS_ITEM_TYPE = 'BM'
    and TRNS_STATUS    = 'READY'
    and TRNS_ACTIVITY_NUM = '481';