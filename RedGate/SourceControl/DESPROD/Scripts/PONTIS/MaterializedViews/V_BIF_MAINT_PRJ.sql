CREATE MATERIALIZED VIEW pontis.v_bif_maint_prj (brkey,acct_date,activity_num,task_id,project_num,status,acti_description)
REFRESH COMPLETE START WITH TO_DATE('2016-5-22 2:0:0', 'yyyy-mm-dd hh24:mi:ss') NEXT NEXT_DAY(TRUNC(sysdate),'SUN') + 2/24 
AS select distinct substr(TRNS_ITEM_NUM,1,6)  "BRKEY",
        TRNS_ACCT_DATE      "ACCT_DATE",
        TRNS_ACTIVITY_NUM   "ACTIVITY_NUM",
        TRNS_TASK "TASK_ID",
        TRNS_PROJECT_NUM     "PROJECT_NUM",
        TRNS_STATUS "STATUS",
        ACTI_DESCRIPTION
    from dtcpmspd.t_ccfb_trans@db2prod.us.oracle.com,  dtcpmspd.t_activity@db2prod.us.oracle.com , bridge b
    where b.brkey = substr(trns_item_num,1,6)
    and TRNS_ITEM_TYPE = 'BM'
    and TRNS_STATUS    = 'READY'
    and TRNS_ACTIVITY_NUM = ACTI_ACTIVITY_NUM
    and TRNS_ACTIVITY_NUM = 481
    and trns_task > '010';