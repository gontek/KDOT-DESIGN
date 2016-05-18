CREATE OR REPLACE FORCE VIEW pontis.v_kta_ratings_1 ("IDENTIFIER",brkey,brg_name,bridgeno,prefix,routeno,func,ftcr,route,insp_date,deck,super,sub,channel,culv,strc,dgeo,uncl,watr,algn,fclastdate,uwlastdate,northsouth) AS
(select '1' as identifier,
        BRKEY      ,
  BRG_NAME   ,
  BRIDGENO,
  SUBSTR(ROUTE,4,1) AS PREFIX,
  LTRIM(SUBSTR(ROUTE,7,3),'0') AS ROUTENO,
  FUNC       ,
  FTCR       ,
  ROUTE      ,
  INSP_DATE  ,
  DECK       ,
  SUPER      ,
  SUB        ,
  CHANNEL    ,
  CULV       ,
  STRC       ,
  DGEO       ,
  UNCL       ,
  WATR       ,
  ALGN       ,
  FCLASTDATE ,
  UWLASTDATE,
  NORTHSOUTH
  FROM KTAREPORT
  WHERE EXTRACT (YEAR FROM INSP_DATE) = (select max(extract(year from insp_date))
  from ktareport k
  where k.brkey = ktareport.brkey
  group by k.brkey))

 ;