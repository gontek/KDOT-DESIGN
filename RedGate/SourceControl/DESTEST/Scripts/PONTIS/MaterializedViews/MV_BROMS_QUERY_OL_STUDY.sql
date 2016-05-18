CREATE MATERIALIZED VIEW pontis.mv_broms_query_ol_study (brkey,work_type,proj_num,progyear,proj_status,old_ser,new_ser,bif_new_ser,prog_cat,fiscal_year,letdate,acceptdate)
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
       BR.FISCAL_YEAR,
       br.let_act_date letdate,
       br.notice_accept_act_date acceptdate

from BROMS_QUERY BR, pontis.BRIDGE B
WHERE ((LPAD(TO_CHAR(BR.CO_NUM),3,'0')||LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0') = b.BRKEY) or
 (LPAD(TO_CHAR(BR.CO_NUM),3,'0')||LPAD(TO_CHAR(BR.REPL_1_SERIAL),3,'0') = b.BRKEY)) AND
  (BR.SERIAL_NUM > 0) and
  (BR.BRDG_ID > 0) and
  (BR.UNIT_NUM = 1) AND
  (b.district <> '9') and
  BR.WORK_TYPE like '%OL%';