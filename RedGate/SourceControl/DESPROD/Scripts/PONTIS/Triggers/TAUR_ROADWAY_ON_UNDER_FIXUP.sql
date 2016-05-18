CREATE OR REPLACE TRIGGER pontis.taur_roadway_on_under_fixup
   AFTER INSERT OR UPDATE OF on_under
   ON pontis.roadway
   FOR EACH ROW
     WHEN (NVL (NEW.on_under, '-1') <> NVL (OLD.on_under, '-1')) BEGIN
   IF INSTR (
         TRIM (:NEW.on_under),
         '|1|2|A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|'
      ) > 0            /* This is an NBI ON_UNDER value, so set flag ON = 1 */
   THEN
      /*  only set  NBI_RW_FLAG if empty or not in set NULL, 0, 1 */

      UPDATE roadway
         SET nbi_rw_flag = '1'
       WHERE nbi_rw_flag IS NULL
         AND roadway.brkey = :NEW.brkey
         AND roadway.on_under = :NEW.on_under;
   ELSE
        /* AR Marshall, CS, 2002.01.29 */
       /* If the on_under code is not in the set of NBI values, set to 0 meaning NOT an NBI roadway record - something else */
      /*  only set  NBI_RW_FLAG if empty or not in set NULL, 0, 1 */
      UPDATE roadway
         SET nbi_rw_flag = '0'
       WHERE nbi_rw_flag IS NULL
         AND roadway.brkey = :NEW.brkey
         AND roadway.on_under = :NEW.on_under;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      BEGIN
         DBMS_OUTPUT.put_line ('hua_ROADWAY_ON_UNDER_FIXUP failed');
      END;
/*ADVICE(35): A WHEN OTHERS clause is used in the exception section without
              any other specific handlers [201] */

END taur_roadway_on_under_fixup;
/*ADVICE(39): ADVICE SUMMARY

Count  Recommendation
-----  --------------
    1  [201]  A WHEN OTHERS clause is used in the exception section
              without any other specific handlers

                  There isn't necessarily anything wrong with using WHEN
                  OTHERS, but it can cause you to "lose" error information
                  unless your handler code is relatively sophisticated.

 */
/