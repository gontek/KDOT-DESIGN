CREATE OR REPLACE function pontis.f_broms_proj(v_brkey pontis.bridge.brkey%type)
return varchar2 is
  retval varchar2(10);
  v_brdg_id number;
  v_date number;
begin

v_date := extract(year from sysdate)-6;

select  distinct max(brdg_id)
into v_brdg_id
from BROMS_QUERY BR, pontis.BRIDGE B
WHERE ((LPAD(TO_CHAR(BR.CO_NUM),3,'0')||LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0') = v_brkey) or
 (LPAD(TO_CHAR(BR.CO_NUM),3,'0')||LPAD(TO_CHAR(BR.REPL_1_SERIAL),3,'0') = v_brkey)) AND
  (BR.SERIAL_NUM > 0) and
  (BR.BRDG_ID > 0) and
  (BR.UNIT_NUM = 1) AND
  (BR.FISCAL_YEAR >  v_date ) AND
  (BR.WORK_TYPE NOT in ('GF','NO WORK','SCOUR','NEW_LOCAL')) AND
    ((BR.STATUS in ('ACTIV') AND BR.LET_TAR_DATE IS NOT NULL  ) OR
     (BR.STATUS IN ('COMPL') and BR.IN_DEPTH_RPRT_IND = 'Y') OR
      (BR.STATUS IN ('CLOSE') and BR.IN_DEPTH_RPRT_IND = 'Y') );
  
SELECT distinct br.proj_num
into retval
from Broms_query br
WHERE  brdg_id = v_brdg_id;

        
return retval;
end f_broms_proj;

 
/