CREATE MATERIALIZED VIEW pontis.mv_bif_data_elements (brkey,elem_key,elem_parent_key,envkey,strunitkey,qty,qty1,qty2,qty3,qty4,pct1,pct2,pct3,pct4,elem_shortname,englishunit,e_line,elemtype,culv_y_n)
REFRESH START WITH TO_DATE('2016-5-18 12:15:58', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE+(DECODE(TO_CHAR(SYSDATE,'D'),6,3,7,2,1)) 
AS SELECT B.BRKEY,
       B.elem_key,
       b.elem_parent_key,
       B.ENVKEY,
       B.STRUNITKEY,
       --    b.elem_quantity,
       --    p.factor,
       case
         when B.elem_key in ('515') then
          to_char(round(b.elem_quantity / .3048))
         when b.elem_key in ('510') then
          to_char(round(b.elem_quantity / .09290304))
         else
          to_char(round(B.ELEM_QUANTITY / P.FACTOR))
       end as QTY,
       case
         when b.elem_key in ('515') then
          to_char(round(b.elem_qtystate1 / .3048))
         when b.elem_key in ('510') then
          to_char(round(b.elem_qtystate1 / .09290304))
         else
          to_char(round(B.ELEM_QTYSTATE1 / P.FACTOR))
       end as qty1,
       case
         when b.elem_key in ('515') then
          to_char(round(b.elem_qtystate2 / .3048))
         when b.elem_key in ('510') then
          to_char(round(b.elem_qtystate2 / .09290304))
         else
          to_char(round(B.ELEM_QTYSTATE2 / P.FACTOR))
       end as qty2,
       case
         when b.elem_key in ('515') then
          to_char(round(b.elem_qtystate3 / .3048))
         when b.elem_key in ('510') then
          to_char(round(b.elem_qtystate3 / .09290304))
         else
          to_char(round(B.ELEM_QTYSTATE3 / P.FACTOR))
       end as qty3,
       case
         when b.elem_key in ('515') then
          to_char(round(b.elem_qtystate4 / .3048))
         when b.elem_key in ('510') then
          to_char(round(b.elem_qtystate4 / .09290304))
          else
          to_char(round(B.ELEM_QTYSTATE4 / P.FACTOR))
       end as qty4,
       to_char(round(elem_pctstate1)) pct1,
       to_char(round(elem_pctstate2)) pct2,
       to_char(round(elem_pctstate3)) pct3,
       to_char(round(elem_pctstate4)) pct4,
       E.ELEM_SHORTNAME,
       P.ENGLISHUNIT,
       '_____' e_line,
       f_get_kdot_element_type(us.brkey,us.strunitkey,b.elem_key) as elemtype,
       --replaced by function f_get_Kdot_Element_type--
       /*case
         when e.elem_KEY in (12,
                             13,
                             15,
                             16,
                             28,
                             29,
                             30,
                             31,
                             38,
                             54,
                             60,
                             65,
                             240,
                             241,
                             242,
                             243,
                             244,
                             245,
                             844,
                             300,
                             301,
                             302,
                             303,
                             304,
                             305,
                             306,
                             320,
                             321,
                             330,
                             331,
                             332,
                             333,
                             334,
                             510,
                             1130) AND
              LENGTH(F_STRUCTURETYPE(US.BRKEY, US.STRUNITKEY)) <> 3 then
          '1'
         when e.elem_KEY in (12,
                             13,
                             15,
                             16,
                             28,
                             29,
                             30,
                             31,
                             38,
                             54,
                             60,
                             65,
                             240,
                             241,
                             242,
                             243,
                             244,
                             245,
                             844,
                             300,
                             301,
                             302,
                             303,
                             304,
                             305,
                             306,
                             320,
                             321,
                             330,
                             331,
                             332,
                             333,
                             334,
                             510,
                             1130,
                             6000) AND
              LENGTH(F_STRUCTURETYPE(US.BRKEY, US.STRUNITKEY)) = 3 then
          '4'
         when e.elem_KEY in (102,
                             104,
                             105,
                             106,
                             107,
                             109,
                             110,
                             111,
                             112,
                             113,
                             115,
                             116,
                             117,
                             118,
                             120,
                             135,
                             136,
                             141,
                             142,
                             143,
                             144,
                             145,
                             146,
                             147,
                             148,
                             149,
                             152,
                             154,
                             155,
                             156,
                             157,
                             161,
                             162,
                             310,
                             311,
                             312,
                             313,
                             314,
                             315,
                             316,
                             845,
                             846) AND
              LENGTH(F_STRUCTURETYPE(US.BRKEY, US.STRUNITKEY)) <> 3 then
          '2'
         when e.elem_KEY in (102,
                             104,
                             105,
                             106,
                             107,
                             109,
                             110,
                             111,
                             112,
                             113,
                             115,
                             116,
                             117,
                             118,
                             120,
                             135,
                             136,
                             141,
                             142,
                             143,
                             144,
                             145,
                             146,
                             147,
                             148,
                             149,
                             152,
                             154,
                             155,
                             156,
                             157,
                             161,
                             162,
                             310,
                             311,
                             312,
                             313,
                             314,
                             315,
                             316,
                             845,
                             846,
                             6000) AND
              LENGTH(F_STRUCTURETYPE(US.BRKEY, US.STRUNITKEY)) = 3 then
          '4'
         when e.elem_KEY IN (202,
                             203,
                             204,
                             205,
                             206,
                             207,
                             208,
                             210,
                             211,
                             212,
                             213,
                             215,
                             216,
                             217,
                             218,
                             219,
                             220,
                             225,
                             226,
                             227,
                             228,
                             229,
                             231,
                             233,
                             234,
                             235,
                             236,
                             6000) AND
              LENGTH(F_STRUCTURETYPE(US.BRKEY, US.STRUNITKEY)) <> 3 then
          '3'
         when e.elem_KEY IN (202,
                             203,
                             204,
                             205,
                             206,
                             207,
                             208,
                             210,
                             211,
                             212,
                             213,
                             215,
                             216,
                             217,
                             218,
                             219,
                             220,
                             225,
                             226,
                             227,
                             228,
                             229,
                             231,
                             233,
                             234,
                             235,
                             236,
                             6000) AND
              LENGTH(F_STRUCTURETYPE(US.BRKEY, US.STRUNITKEY)) = 3 then
          '4'
         else
          '-1'
       end as elemtype,*/
       case
         when length(f_structuretype(us.brkey, us.strunitkey)) <> 3 then
          'B'
         else
          'C'
       end as culv_y_n
  FROM  BRIDGE BR
 INNER JOIN PON_ELEM_INSP B
 ON BR.BRKEY = B.BRKEY
 INNER JOIN USERSTRUNIT US
    ON B.BRKEY = US.BRKEY and
       b.strunitkey = us.strunitkey
 INNER JOIN PON_ELEM_DEFS E
    ON B.ELEM_KEY = E.ELEM_KEY
 INNER JOIN METRIC_ENGLISH P
    ON P.PAIRCODE = E.ELEM_PAIRCODE
 INNER JOIN BRIDGE BR
 ON BR.BRKEY = B.BRKEY
  INNER JOIN mv_latest_inspection mv
 on b.brkey = mv.brkey and
    b.inspkey = mv.inspkey
 WHERE BR.DISTRICT <> '9';