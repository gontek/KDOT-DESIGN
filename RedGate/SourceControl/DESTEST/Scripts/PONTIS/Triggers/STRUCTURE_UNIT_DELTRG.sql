CREATE OR REPLACE TRIGGER pontis.STRUCTURE_UNIT_DELTRG
               BEFORE DELETE
               ON pontis.STRUCTURE_UNIT
               FOR EACH ROW
            DECLARE
               v_BRKEY VARCHAR2(100);
               v_STRUNITKEY VARCHAR2(100);
            BEGIN
               SELECT :OLD.BRKEY ,
                      :OLD.STRUNITKEY
                 INTO v_BRKEY,
                      v_STRUNITKEY
                 FROM DUAL ;
               DELETE ELEMINSP
                WHERE ELEMINSP.BRKEY = v_BRKEY
                        AND ELEMINSP.STRUNITKEY = v_STRUNITKEY;
         DELETE PON_INSP_WORKCAND
          WHERE PON_INSP_WORKCAND.BRKEY = v_BRKEY
            AND PON_INSP_WORKCAND.STRUNITKEY = v_STRUNITKEY;
        END;
/