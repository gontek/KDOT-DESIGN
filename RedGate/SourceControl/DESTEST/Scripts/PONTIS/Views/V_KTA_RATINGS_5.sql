CREATE OR REPLACE FORCE VIEW pontis.v_kta_ratings_5 ("IDENTIFIER",brkey,brg_name,bridgeno,prefix,routeno,func,ftcr,route,insp_date,deck,super,sub,channel,culv,strc,dgeo,uncl,watr,algn,fclastdate,uwlastdate,northsouth) AS
(select '5' as identifier,
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
  UWLASTDATE ,
  NORTHSOUTH
  FROM KTAREPORT
  WHERE  insp_date = (select max(insp_date) from ktareport k
  where k.brkey = ktareport.brkey and
        k.insp_date not in (select max(insp_date) from v_kta_ratings_1 k1
        where k1.brkey = k.brkey ) and
        k.insp_date not in (select max(insp_date) from v_kta_ratings_2 k2
        where k2.brkey = k.brkey)  and
        k.insp_date not in (select max(insp_date) from v_kta_ratings_3 k3
        where k3.brkey = k.brkey) and
        k.insp_date not in (select max(insp_date) from v_kta_ratings_4 k4
        where k4.brkey = k.brkey)))

 ;