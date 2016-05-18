CREATE MATERIALIZED VIEW pontis.mv_cals_elements (brkey,elemkey,envkey,strunitkey,qty,cond1,cond2,cond3,cond4,cond5)
REFRESH START WITH TO_DATE('2016-5-18 12:25:55', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE + 6/24 
AS SELECT B.BRKEY,
         B.elemkey,
         B.ENVKEY,
         B.STRUNITKEY,

         round(B.QUANTITY / P.FACTOR) AS QTY,
         round(B.QTYSTATE1 / P.FACTOR) COND1,
         round(B.QTYSTATE2 / P.FACTOR) COND2,
         round(B.QTYSTATE3 / P.FACTOR) COND3,
         round(B.QTYSTATE4 / P.FACTOR) COND4,
         round(B.QTYSTATE5 / P.FACTOR) COND5
     FROM pontis.ELEMINSP B,
         pontis.ELEMDEFS E,
         pontis.METRIC_ENGLISH P,
         pontis.BRIDGE BR
   WHERE B.BRKEY = BR.BRKEY
         AND BR.DISTRICT <> '9'
         AND P.PAIRCODE = E.PAIRCODE
         and pontis.E.ELEMKEY = B.ELEMKEY
         and B.INSPKEY = (SELECT MAX(I.INSPKEY) FROM INSPEVNT I
        WHERE I.BRKEY = B.BRKEY AND I.INSPDATE = (SELECT MAX(INSPDATE) FROM
      INSPEVNT G WHERE G.BRKEY = B.BRKEY AND G.ELINSPDONE = '1'));