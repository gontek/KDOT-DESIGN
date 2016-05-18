CREATE OR REPLACE FORCE VIEW pontis.randr_vw (strnum,invrte,hwysys,funcls,ftrint,faccar,locatn,distrc,county,counme,aadt,status,astric,sufrat,state_brdgs) AS
(
select   STRNUM ,
    INVRTE,
    HWYSYS ,
  FUNCLS ,
  FTRINT ,
  FACCAR ,
  LOCATN ,
  DISTRC,
  COUNTY ,
  UPPER(COUNME) as COUNME ,
  AADT   ,
  STATUS ,
  ASTRIC ,
  to_char(SUFRAT,'099.9') as SUFRAT ,
  CASE
    WHEN nvl(BRKEY,'-1') <> '-1' THEN 'Y'
    ELSE 'N'
   END AS STATE_BRDGS
from pontis.randr  )

 ;