CREATE OR REPLACE FORCE VIEW pontis.v_bridge_anal1 (brkey,ykey,totwork,discwork) AS
SELECT F.BRKEY,
                     F.YKEY,
                     (SELECT 0 + SUM(P.AGCYCOST) FROM PONT_WORK P WHERE P.SCKEY = F.SCKEY AND
                             P.BRKEY = F.BRKEY AND P.YKEY = F.YKEY AND P.SYSFLAG1 = 0) AS TOTWORK,
            /* ORACLE DOES NOT ALLOW THE USE OF A COLUMN ALIASE IN THE SAME SELECT STATEMENT,   */
            /* SO INSTEAD OF USING "TOTWORK" AS THE 1ST ARGUMENT BELOW, ITS COMPUTATION IS      */
            /* REPEATED.*/
                     (SELECT 0 + SUM(P.AGCYCOST) FROM PONT_WORK P WHERE P.SCKEY = F.SCKEY AND
                               P.BRKEY = F.BRKEY AND P.YKEY = F.YKEY AND P.SYSFLAG1 = 0)*POWER(
                         (SELECT NVL( TO_NUMBER(OPTIONVAL), .95 )FROM PON_COPTIONS WHERE UPPER(OPTIONNAME) = 'DISCRATE'),
                     (F.YKEY-(SELECT MIN(YKEY) FROM FUTMETRIC F2 WHERE
                                         F2.SCKEY = F.SCKEY AND F2.BRKEY = F.BRKEY))) AS DISCWORK
            FROM FUTMETRIC F
            WHERE F.SCKEY = (SELECT OPTIONVAL FROM PON_COPTIONS WHERE OPTIONNAME = 'BRIDGEANALSCEN')
            UNION
            SELECT BRKEY, YKEY, 0, 0 FROM FUTMETRIC GROUP BY BRKEY, YKEY;