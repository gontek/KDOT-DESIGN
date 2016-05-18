CREATE MATERIALIZED VIEW pontis.mv_bobs_letting_list (proj_id,strucname,dist,area,old_ser,new_ser,bif_new_ser,work_type,let_act_date)
REFRESH START WITH TO_DATE('2016-5-18 12:17:44', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE+(DECODE(TO_CHAR(SYSDATE,'D'),6,3,7,2,1)) 
AS select BR.Rte_Num || '-' ||br.co_num || '-' ||br.proj_num AS PROJ_ID,
      --B.STRUCNAME,
      br.rte_num||'-'||br.co_num||'-'||br.state_milepost||'('||lpad(to_char(br.serial_num),3,'0')||')' AS STRUCNAME,
       br.dist,
       br.area,
       LPAD(TO_CHAR(BR.REPL_1_SERIAL),3,'0') AS OLD_SER,
       lpad(to_char(br.serial_num),3,'0') as new_ser,
       case
         when LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0')<> lpad(to_char(br.repl_1_serial),3,'0')
           then lpad(to_char(br.serial_num),3,'0')
             else ''
               end AS bif_new_ser,
       --BR.PROG_CAT,
       --BR.IN_DEPTH_RPRT_IND,
       --NVL(BR.IN_DEPTH_COMPLETED_IND,'N') as IN_DEPTH_COMPLETED_IND,
       BR.WORK_TYPE,
       BR.LET_ACT_DATE

from BROMS_QUERY BR, pontis.BRIDGE B
WHERE ((LPAD(TO_CHAR(BR.CO_NUM),3,'0')||LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0') = b.BRKEY) or
 (LPAD(TO_CHAR(BR.CO_NUM),3,'0')||LPAD(TO_CHAR(BR.REPL_1_SERIAL),3,'0') = b.BRKEY)) AND
  (BR.SERIAL_NUM > 0) and
  (BR.BRDG_ID > 0) and
  (BR.UNIT_NUM = 1) AND
  (BR.FISCAL_YEAR >  EXTRACT(YEAR FROM SYSDATE)-5 ) AND
  (b.district <> '9') and
 -- (BR.WORK_TYPE NOT in ('GF','NO WORK','SCOUR','NEW_LOCAL')) AND
    ((BR.STATUS in ('ACTIV') AND BR.LET_ACT_DATE IS NOT NULL  ) OR
     (BR.STATUS IN ('ACTIV') AND BR.PLAN_COMPL_TAR_DATE IS NOT NULL) OR
      (BR.STATUS IN ('COMPL') and BR.IN_DEPTH_RPRT_IND = 'Y') OR
      (BR.STATUS IN ('CLOSE') and BR.IN_DEPTH_RPRT_IND = 'Y') )and
      (NVL(BR.IN_DEPTH_COMPLETED_IND,'N')<> 'Y')and
      (((LPAD(TO_CHAR(BR.REPL_1_SERIAL),3,'0')<> LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0') and substr(b.brkey,4,3) <> LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0'))) or
       (LPAD(TO_CHAR(BR.REPL_1_SERIAL),3,'0')= LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0') and substr(b.brkey,4,3) = LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0')));