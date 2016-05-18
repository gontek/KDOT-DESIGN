CREATE OR REPLACE FORCE VIEW pontis.kaws_nextserial (reason_exists,county,strtype,co_ser,ref_point,countyname,str_desc) AS
select 'View for Sign and Lighting KAWS_LIST Rpt' REASON_EXISTS,SUBSTR(CO_SER,1,3) AS COUNTY, SUBSTR(CO_SER,4,1) AS STRTYPE, co_ser, REF_POINT,
F_GET_PARAMTRS_EQUIV('bridge','county',county_fipps) as countyname,
case
  when substr(co_ser,4,1) = 'L'
    then 'Lighttower'
      when substr(co_ser,4,1) = 'S'
        then 'Sign'
          else 'Other'
            end as str_desc
from kaws_structures
order by co_ser
;