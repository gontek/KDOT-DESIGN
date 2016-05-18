CREATE OR REPLACE FORCE VIEW pontis.v_hix (brkey,inspkey,hix) AS
SELECT BRKEY,
                    INSPKEY,
                    Round(CASE
                          WHEN
                            SUM(ELEM_QUANTITY * ELEMVALUE)>0
                          THEN
                            (SUM(ELEM_QUANTITY * ELEMVALUE * (ELEM_PCTSTATE1 + S2FACTOR * ELEM_PCTSTATE2 + S3FACTOR * ELEM_PCTSTATE3 + S4FACTOR * ELEM_PCTSTATE4)) /  SUM(ELEM_QUANTITY * ELEMVALUE))
                          ELSE -1 END,2)
                          AS HIX  FROM PON_ELEM_INSP, V_ELEMVALUE  WHERE PON_ELEM_INSP.ELEM_KEY = V_ELEMVALUE.ELEMKEY GROUP BY BRKEY, INSPKEY;