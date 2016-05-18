CREATE OR REPLACE TRIGGER pontis.STATEDFS_DELTRG
               BEFORE DELETE
               ON pontis.STATEDFS
               FOR EACH ROW
            DECLARE
               v_ELEMKEY VARCHAR2(100);
               v_SKEY VARCHAR2(100);
            BEGIN
               SELECT :OLD.ELEMKEY ,
                      :OLD.SKEY
                 INTO v_ELEMKEY,
                      v_SKEY
                 FROM DUAL ;
               DELETE MRRACTDF
                WHERE MRRACTDF.ELEMKEY = v_ELEMKEY
                        AND MRRACTDF.SKEY = v_SKEY;
               DELETE STATMDLS
                WHERE STATMDLS.ELEMKEY = v_ELEMKEY
                        AND STATMDLS.SKEY = v_SKEY;
        END;
/