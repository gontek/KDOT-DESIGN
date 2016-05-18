CREATE OR REPLACE FORCE VIEW pontis.v_kta_ratings_test ("IDENTIFIER",brkey,brg_name,bridgeno,prefix,routeno,func,ftcr,route,inspdate_1,inspdate_2,inspdate_3,inspdate_4,inspdate_5,deck,super,sub,channel,culv,strc,dgeo,uncl,watr,algn,fclastdate,uwlastdate,northsouth) AS
(select identifier,
        BRKEY      ,
  BRG_NAME   ,
  BRIDGENO,
  SUBSTR(ROUTE,4,1) AS PREFIX,
  LTRIM(SUBSTR(ROUTE,7,3),'0') AS ROUTENO,
  FUNC       ,
  FTCR       ,
  ROUTE      ,
  case
    when identifier = '1' then
      INSP_DATE
      else to_date('01/jan/1901')
        end as inspdate_1,
  case
    when identifier = '2' then
      INSP_DATE
      else to_date('01/jan/1901')
        end as inspdate_2,
   case
    when identifier = '3' then
      INSP_DATE
      else to_date('01/jan/1901')
        end as inspdate_3,
     case
    when identifier = '4' then
      INSP_DATE
      else to_date('01/jan/1901')
        end as inspdate_4,
       case
    when identifier = '5' then
      INSP_DATE
      else to_date('01/jan/1901')
        end as inspdate_5,
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
  FROM KTAREPORT)

 ;