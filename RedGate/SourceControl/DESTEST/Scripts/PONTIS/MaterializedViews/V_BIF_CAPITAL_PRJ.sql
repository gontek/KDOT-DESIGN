CREATE MATERIALIZED VIEW pontis.v_bif_capital_prj (brkey,prjctid,actvtyid,actvtydscr,actvtydate,actvtyyear,micro_no,micro_frame,actvdate,bif_micro)
REFRESH COMPLETE START WITH TO_DATE('2016-5-22 3:0:0', 'yyyy-mm-dd hh24:mi:ss') NEXT NEXT_DAY(TRUNC(SYSDATE),'SUNDAY')+3/24 
AS select substr(a.str_name,2,3)||substr(a.str_name,8,3) brkey,
       substr(nvl(b.TA04,' '),1,20) PRJCTID,
       b.TA01 ACTVTYID,
       decode(substr(b.TA01_DESCR,1,(instrb(b.TA01_DESCR,'-')-2)),'CONSTRUCTION','YR_BLT',
       substr(b.TA01_DESCR,1,(instrb(b.TA01_DESCR,'-')-2))) ACTVTYDSCR,
    b.TA02 as actvtydate,
    to_number(to_char(b.TA02,'YYYY') )as actvtyyear,
    b.TA09 as Micro_No,
    B.TA10 as Micro_Frame
    ,to_number(extract(year from b.TA02)) actvdate
 ,decode(b.TA09,'','','Micro/File:  '||b.TA09||'/'||b.TA10)  bif_micro
 from can_v_str_brid@newcant.world a,can_v_str_actv@newcant.world b
    where 1=1
    and b.str_top_id = a.str_id
   and a.str_end_date is null
   and b.str_end_date is null
    and substr(a.str_name,2,3)||substr(a.str_name,8,3) <> '054038';