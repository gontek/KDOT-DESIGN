CREATE OR REPLACE FORCE VIEW pontis.randr_vw (strnum,invrte,hwysys,funcls,ftrint,faccar,locatn,distrc,county,counme,aadt,status,astric,sufrat,state_brdgs) AS
(
select   STRNUM ,
    INVENROUTE as INVRTE,
    highway_sys as HWYSYS ,
  func_class FUNCLS ,
  UPPER(ltrim(featint)) FTRINT ,
  Upper(ltrim(facility)) FACCAR ,
  UPPER(ltrim(location)) LOCATN ,
  hgwy_dist DISTRC,
  county_code COUNTY ,
  UPPER(COUNTY_NAME) as COUNME ,
  ADT AADT   ,
  SDFO STATUS ,
  suff_astrsk ASTRIC ,
  to_char(SUFfrate,'099.9') as SUFRAT ,
  CASE
    WHEN nvl(BRKEY,'-1') <> '-1' THEN 'Y'
    ELSE 'N'
   END AS STATE_BRDGS
from pontis.randr)
;