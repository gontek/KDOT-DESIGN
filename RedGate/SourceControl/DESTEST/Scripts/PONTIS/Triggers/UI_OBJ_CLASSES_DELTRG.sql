CREATE OR REPLACE TRIGGER pontis.UI_OBJ_CLASSES_DELTRG
               BEFORE DELETE
               ON pontis.UI_OBJ_CLASSES
               FOR EACH ROW
            DECLARE
               v_OBJ_CLASS_ID VARCHAR2(100);

            BEGIN
               SELECT :OLD.OBJ_CLASS_ID

                 INTO v_OBJ_CLASS_ID
                 FROM DUAL ;
               DELETE UI_APP_OBJ_MAP

                WHERE UI_APP_OBJ_MAP.OBJ_CLASS_ID = v_OBJ_CLASS_ID;
        END;
/