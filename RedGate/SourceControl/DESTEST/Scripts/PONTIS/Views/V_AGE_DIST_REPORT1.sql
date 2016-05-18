CREATE OR REPLACE FORCE VIEW pontis.v_age_dist_report1 (brkey,bridge_id,yearbuilt,age) AS
SELECT BRIDGE.BRKEY,
                      BRIDGE.BRIDGE_ID,
                      BRIDGE.YEARBUILT,
                      (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))-BRIDGE.YEARBUILT)
                      AS AGE
            FROM  BRIDGE;