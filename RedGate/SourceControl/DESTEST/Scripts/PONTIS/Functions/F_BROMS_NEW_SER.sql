CREATE OR REPLACE function pontis.f_broms_new_ser(v_brkey pontis.bridge.brkey%type)
return varchar2 is
  retval varchar2(5);
  v_brdg_id number;
  v_date number;
begin

v_date := extract(year from sysdate)-6;

select  distinct max(brdg_id)
into v_brdg_id
from broms_query br
WHERE  ((LPAD(TO_CHAR(BR.CO_NUM),3,'0')||LPAD(TO_CHAR(BR.SERIAL_NUM),3,'0') = v_BRKEY) OR
 (LPAD(TO_CHAR(BR.CO_NUM),3,'0')||LPAD(TO_CHAR(BR.REPL_1_SERIAL),3,'0') = v_BRKEY)) AND
  (BR.SERIAL_NUM > 0) and
  (BR.BRDG_ID > 0) and
  (BR.UNIT_NUM = 1) AND
  (BR.FISCAL_YEAR > v_date ) AND
  (BR.WORK_TYPE NOT in ('GF','NO WORK','SCOUR','NEWR-LOCAL','NEW_LOCAL')) AND
    ((BR.STATUS in ('ACTIV') AND BR.LET_TAR_DATE IS NOT NULL  ) OR
      (BR.STATUS IN ('COMPL') and BR.IN_DEPTH_RPRT_IND = 'Y') OR
      (BR.STATUS IN ('CLOSE') and BR.IN_DEPTH_RPRT_IND = 'Y')
       );


SELECT distinct lpad(to_char(br.serial_num),3,'0')
into retval
from Broms_query br
WHERE  brdg_id = v_brdg_id;

retval := '('||retval||')';

return retval;
end f_broms_new_ser;

 
/