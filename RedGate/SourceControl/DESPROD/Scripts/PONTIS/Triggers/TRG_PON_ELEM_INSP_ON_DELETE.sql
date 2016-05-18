CREATE OR REPLACE TRIGGER pontis.TRG_PON_ELEM_INSP_ON_DELETE
                    after delete on pontis.PON_ELEM_INSP
                    DECLARE
                    v_isConverted NUMBER(10,0);
                    begin
                    for i in 1 .. PON_ELEM_INSP_ARRAY.oldvals.count loop
                    SELECT COUNT(BRKEY)
                    INTO v_isConverted
                    FROM PON_ELEM_INSP
                    WHERE BRKEY = PON_ELEM_INSP_ARRAY.oldvals(i).brkey AND INSPKEY = PON_ELEM_INSP_ARRAY.oldvals(i).inspkey AND ROWNUM <= 5;

                    IF v_isConverted > 0 THEN
                    BEGIN
                    UPDATE INSPEVNT
                    SET ELEMCONVERT = 'Y'
                    WHERE BRKEY = PON_ELEM_INSP_ARRAY.oldvals(i).brkey  AND INSPKEY = PON_ELEM_INSP_ARRAY.oldvals(i).inspkey;
                    END;
                    ELSE
                    BEGIN
                    UPDATE INSPEVNT
                    SET ELEMCONVERT = 'N'
                    WHERE BRKEY = PON_ELEM_INSP_ARRAY.oldvals(i).brkey  AND INSPKEY = PON_ELEM_INSP_ARRAY.oldvals(i).inspkey;
                    END;
                    END IF;
                    end loop;
                    end;
/