CREATE MATERIALIZED VIEW pontis.mv_cals_elements_new (brkey,elem_key,envkey,strunitkey,qty,cond1,cond2,cond3,cond4)
REFRESH START WITH TO_DATE('2016-5-18 12:25:50', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE + 6/24 
AS SELECT B.BRKEY,
         B.elem_key,
          B.ENVKEY,
         B.STRUNITKEY,
   --    b.elem_quantity,
   --    p.factor,
         case
           when B.elem_key in ('515','520','6000') then
             to_char(round(b.elem_quantity / .3048))
             when b.elem_key in ('510') then
               to_char(round(b.elem_quantity / .09290304))
               when b.elem_key in ('1130') then
                 '1'
                      else to_char(round(B.ELEM_QUANTITY / P.FACTOR))
               end as QTY,
          case
            when b.elem_key in ('515','520','6000') then
              to_char(round(b.elem_qtystate1 / .3048))
              when b.elem_key in ('510') then
                to_char(round(b.elem_qtystate1 / .09290304))
                when b.elem_key in ('1130') and b.elem_qtystate1 > 0
                  then '1'
              else to_char(round(B.ELEM_QTYSTATE1 / P.FACTOR))
                end as COND1,
           case
            when b.elem_key in ('515','520','6000') then
              to_char(round(b.elem_qtystate2 / .3048))
              when b.elem_key in ('510') then
                to_char(round(b.elem_qtystate2 / .09290304))
                 when b.elem_key in ('1130') and b.elem_qtystate1 > 0
                  then '1'
              else to_char(round(B.ELEM_QTYSTATE2 / P.FACTOR))
                end as COND2,
          case
            when b.elem_key in ('515','520','6000') then
              to_char(round(b.elem_qtystate3 / .3048))
              when b.elem_key in ('510') then
                to_char(round(b.elem_qtystate3 / .09290304))
                 when b.elem_key in ('1130') and b.elem_qtystate1 > 0
                  then '1'
              else to_char(round(B.ELEM_QTYSTATE3 / P.FACTOR))
                end as COND3,
          case
            when b.elem_key in ('515','520','6000') then
              to_char(round(b.elem_qtystate4 / .3048))
               when b.elem_key in ('510') then
                to_char(round(b.elem_qtystate4 / .09290304))
                 when b.elem_key in ('1130') and b.elem_qtystate1 > 0
                  then '1'
              else to_char(round(B.ELEM_QTYSTATE4 / P.FACTOR))
                end as COND4
    FROM pontis.PON_ELEM_INSP B,
         pontis.PON_ELEM_DEFS E,
         pontis.USERSTRUNIT US,
         pontis.METRIC_ENGLISH P,
         pontis.BRIDGE BR
   WHERE P.PAIRCODE = E.ELEM_PAIRCODE and
         E.ELEM_KEY = B.ELEM_KEY AND
         B.BRKEY = US.BRKEY AND
         B.STRUNITKEY = US.STRUNITKEY AND
         B.BRKEY = BR.BRKEY AND
         BR.DISTRICT <> '9' AND
         SUBSTR(B.BRKEY,4,1) <> '5' and
         B.INSPKEY = (SELECT MAX(I.INSPKEY) FROM INSPEVNT I
        WHERE I.BRKEY = B.BRKEY AND I.INSPDATE = (SELECT MAX(INSPDATE) FROM
      INSPEVNT G WHERE G.BRKEY = B.BRKEY AND G.ELINSPDONE = '1'));