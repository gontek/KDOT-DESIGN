CREATE MATERIALIZED VIEW pontis.mv_broms_query (brkey,work_type,proj_num,progyear,proj_status,old_ser,new_ser,bif_new_ser,prog_cat,in_depth_rprt_ind,in_depth_completed_ind,let_tar_date,plan_compl_act_date,plan_compl_tar_date)
REFRESH START WITH TO_DATE('2016-5-18 13:34:41', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE + (DECODE(TO_CHAR(SYSDATE,'D'),6,3,7,2,1)) 
AS select B.BRKEY,
       BR.WORK_TYPE,
       BR.PROJ_NUM,
       BR.FISCAL_YEAR AS PROGYEAR,
       BR.STATUS AS PROJ_STATUS,
       LPAD(TO_CHAR(BR.REPL_1_SERIAL),3,'0') AS OLD_SER,
       lpad(to_char(br.serial_num),3,'0') as new_ser,
       case
         when LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0')<> lpad(to_char(br.repl_1_serial),3,'0')
           then lpad(to_char(br.serial_num),3,'0')
             else ''
               end AS bif_new_ser,
       BR.PROG_CAT,
       BR.IN_DEPTH_RPRT_IND,
       NVL(BR.IN_DEPTH_COMPLETED_IND,'N') as IN_DEPTH_COMPLETED_IND,
       BR.LET_TAR_DATE,
       BR.PLAN_COMPL_ACT_DATE,
      BR.plan_compl_tar_date

from BROMS_QUERY BR, pontis.BRIDGE B
WHERE ((LPAD(TO_CHAR(BR.CO_NUM),3,'0')||LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0') = b.BRKEY) or
 (LPAD(TO_CHAR(BR.CO_NUM),3,'0')||LPAD(TO_CHAR(BR.REPL_1_SERIAL),3,'0') = b.BRKEY)) AND
  (BR.SERIAL_NUM > 0) and
  (BR.BRDG_ID > 0) and
  (BR.UNIT_NUM = 1) AND
  (BR.FISCAL_YEAR >  EXTRACT(YEAR FROM SYSDATE)-5 ) AND
  (b.district <> '9') and
  (BR.WORK_TYPE NOT in ('GF','NO WORK','SCOUR','NEW_LOCAL')) AND
    ((BR.STATUS in ('ACTIV') AND BR.LET_TAR_DATE IS NOT NULL  ) OR
     (BR.STATUS IN ('ACTIV') AND BR.PLAN_COMPL_TAR_DATE IS NOT NULL) OR
      (BR.STATUS IN ('COMPL') and BR.IN_DEPTH_RPRT_IND = 'Y') OR
      (BR.STATUS IN ('CLOSE') and BR.IN_DEPTH_RPRT_IND = 'Y') )and
      (NVL(BR.IN_DEPTH_COMPLETED_IND,'N')<> 'Y')and
      (((LPAD(TO_CHAR(BR.REPL_1_SERIAL),3,'0')<> LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0') and substr(b.brkey,4,3) <> LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0'))) or
       (LPAD(TO_CHAR(BR.REPL_1_SERIAL),3,'0')= LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0') and substr(b.brkey,4,3) = LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0')));