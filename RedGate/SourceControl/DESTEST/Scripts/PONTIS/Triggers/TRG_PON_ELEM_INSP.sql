CREATE OR REPLACE TRIGGER pontis.TRG_PON_ELEM_INSP
            AFTER INSERT ON pontis.PON_ELEM_INSP
            FOR EACH ROW
        DECLARE
            isConverted number;
            SRCBRKEY PON_ELEM_INSP.BRKEY%TYPE;
            SRCINSPKEY PON_ELEM_INSP.INSPKEY%TYPE;
        BEGIN
            SRCBRKEY := :new.BRKEY;
            SRCINSPKEY := :new.INSPKEY;

            SELECT COUNT(SRCBRKEY) into isConverted
            FROM ELEMINSP
            WHERE BRKEY = SRCBRKEY
              AND INSPKEY= SRCINSPKEY
              AND ROWNUM = 1;

            IF isConverted > 0 THEN
                UPDATE INSPEVNT
                SET ELEMCONVERT = 'Y'
                WHERE BRKEY = SRCBRKEY
                  AND INSPKEY = SRCINSPKEY;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE;

        END TRG_PON_ELEM_INSP;
/