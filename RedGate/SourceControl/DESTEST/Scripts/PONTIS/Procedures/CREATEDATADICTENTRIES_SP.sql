CREATE OR REPLACE PROCEDURE pontis.CreateDataDictEntries_SP
        (iv_TableName IN VARCHAR2 DEFAULT NULL)
        AS
           v_TableName VARCHAR2(30) := iv_TableName;
        BEGIN

           v_TableName := UPPER(RTRIM(v_TableName)) ;
           INSERT INTO DATADICT
             ( TABLE_NAME, COL_NAME, COL_ALIAS, V2CONVERT, DATATYPE, WIDTH, DEC_PLCS, NULL_ALLOW, UNIQUEKEY, POSITION, NBI_CD, VALTYPE, VALATTR1, VALATTR2, SYSFIELD, SYSDEFAULT, KEYATTR1, UNIQUE_FLD, HELPID, PAIRCODE, CONVERSIONRULES, SNOTES, NOTES )
            SELECT  col.TABLE_NAME,
                    col.COLUMN_NAME,
                    col.COLUMN_NAME,
                    '-1', --V2CONVERT
                    col.DATA_TYPE,
                    --WIDTH Width for storage and display.
                    CASE WHEN col.DATA_TYPE IN ('CHAR', 'VARCHAR2', 'VARCHAR', 'NCHAR', 'NVARCHAR2', 'NVARCHAR')
                        THEN col.CHAR_LENGTH
                        ELSE COL.DATA_LENGTH
                    END,
                    col.DATA_SCALE, --DEC_PLCS
                    CASE WHEN col.NULLABLE IS NOT NULL --NULL_ALLOW
                        THEN COL.NULLABLE
                        ELSE 'Y'
                    END,
                    -- UNIQUEKEY, Flag indicating whether field value must be unique.
                    -- Find columns that are the only column in a primary or unique constraint.
                    CASE WHEN col.COLUMN_NAME IN (SELECT MAX(COLS.COLUMN_NAME)
                                                 FROM USER_CONSTRAINTS C
                                                 INNER JOIN USER_CONS_COLUMNS COLS
                                                 ON C.CONSTRAINT_NAME = COLS.CONSTRAINT_NAME
                                                 WHERE C.TABLE_NAME = v_TableName
                                                 AND C.CONSTRAINT_TYPE IN ('P', 'U')
                                                 GROUP BY COLS.CONSTRAINT_NAME
                                                 HAVING COUNT(*) = 1)
                        THEN 'Y'
                        ELSE 'N'
                    END,
                    col.COLUMN_ID , --POSITION
                    '-1', --NBI_CD
                    '-1', --VALTYPE
                    '-1', --VALATTR1
                    '-1', --VALATTR2
                    '_', --SYSFIELD
                    '-1', --SYSDEFAULT
                    'Y', --KEYATTR1
                    col.COLUMN_NAME, --UNIQUE_FLD
                    -1 , --HELPID
                    -1 , --PAIRCODE
                    '-1' , --CONVERSIONRULES
                    'This is table ' || col.TABLE_NAME || ' column' || col.COLUMN_NAME , --SNOTES
                    'This is table ' || col.TABLE_NAME || ' column' || col.COLUMN_NAME  --NOTES
                FROM USER_TAB_COLUMNS col
                WHERE col.TABLE_NAME = V_TABLENAME
                AND col.COLUMN_NAME NOT IN ( SELECT UPPER(RTRIM(DD.COL_NAME))
                                            FROM DATADICT DD
                                              WHERE UPPER(RTRIM(DD.TABLE_NAME)) = V_TABLENAME);
        END;
/