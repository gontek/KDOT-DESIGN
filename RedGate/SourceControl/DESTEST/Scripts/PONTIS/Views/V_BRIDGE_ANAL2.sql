CREATE OR REPLACE FORCE VIEW pontis.v_bridge_anal2 (brkey,ykey,totwork,discwork,cumwork,cumdiscwork) AS
SELECT V1A.BRKEY,
                     V1A.YKEY,
                     V1A.TOTWORK AS TOTWORK,
                     V1A.DISCWORK AS DISCWORK,
                     (SELECT SUM(V2.TOTWORK) FROM V_BRIDGE_ANAL1 V2 WHERE V2.BRKEY = V1A.BRKEY
                       AND V2.YKEY <= V1A.YKEY ) AS CUMWORK,
                     (SELECT SUM(V3.DISCWORK) FROM V_BRIDGE_ANAL1 V3 WHERE V3.BRKEY = V1A.BRKEY
                       AND V3.YKEY <= V1A.YKEY ) AS CUMDISCWORK
            FROM V_BRIDGE_ANAL1 V1A;