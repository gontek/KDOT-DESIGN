CREATE OR REPLACE FORCE VIEW pontis.v_mat_dist_report1 (brkey,deck_area,materialtype) AS
SELECT B.BRKEY,
                      B.DECK_AREA,
                      DECODE(B.MATERIALMAIN,
                             '1','CONCRETE',
                             '2','CONCRETE',
                             '3','STEEL',
                             '4','STEEL',
                             '5','PRE-STRESSED CONCRETE',
                             '6','PRE-STRESSED CONCRETE',
                             '7','TIMBER',
                             'OTHER')
                      AS MATERIALTYPE
            FROM  BRIDGE B
            WHERE B.DESIGNMAIN NOT IN ('19','9','10','13','14');