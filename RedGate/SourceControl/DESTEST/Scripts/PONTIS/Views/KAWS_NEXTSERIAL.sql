CREATE OR REPLACE FORCE VIEW pontis.kaws_nextserial (county,strtype,co_ser,ref_point,countyname) AS
select SUBSTR(CO_SER,1,3) AS COUNTY, SUBSTR(CO_SER,4,1) AS STRTYPE, co_ser, REF_POINT,
F_GET_PARAMTRS_EQUIV('bridge','county',county_fipps) as countyname
from kaws_structures
order by co_ser
;