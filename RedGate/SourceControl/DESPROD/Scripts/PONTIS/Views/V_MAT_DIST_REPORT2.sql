CREATE OR REPLACE FORCE VIEW pontis.v_mat_dist_report2 (materialtype,deckarea,bridgecount,displayorder) AS
SELECT MATERIALTYPE,
                       SUM(DECK_AREA) AS DECKAREA,
                       COUNT(BRKEY) AS BRIDGECOUNT,
                          DECODE(MATERIALTYPE,
                                   'CONCRETE',3,
                              'STEEL',1,
                              'PRE-STRESSED CONCRETE',4,
                              'TIMBER',2,
                              5)
                          AS DISPLAYORDER
                  FROM V_MAT_DIST_REPORT1
              GROUP BY MATERIALTYPE
              ORDER BY DISPLAYORDER;