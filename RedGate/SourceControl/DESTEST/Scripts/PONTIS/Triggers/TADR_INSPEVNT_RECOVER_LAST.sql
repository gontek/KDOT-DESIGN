CREATE OR REPLACE TRIGGER pontis.tadr_inspevnt_recover_last
   AFTER DELETE
   ON pontis.inspevnt
   FOR EACH ROW
   
 -- Allen Marshall, CS -2003.01.04 - supposed to take N-1 INSPEVNT information when latest is deleted
 -- and fire phony updates which propagate to the log.
 -- when all rows are gone, throws an exception which we accept silently e.g. bridge was deleted, all rows in INSPEVNT gone
 


DISABLE DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
   -- local variables here
   ls_this_inspkey   inspevnt.inspkey%TYPE   := :OLD.inspkey;
   ls_last_inspkey   inspevnt.inspkey%TYPE;
   ls_where_clause   VARCHAR2 (255);
BEGIN
-- get latest by date, see if the one we are deleting is the latest, if so continue

   SELECT MAX (inspkey)
     INTO ls_last_inspkey
     FROM inspevnt
    WHERE inspdate = (SELECT MAX (inspdate)
                        FROM inspevnt
                       WHERE brkey = :OLD.brkey);

                       
   IF ls_last_inspkey = :OLD.inspkey
   THEN -- this is indeed the latest, now do the work

-- get prior if any - if none, do nothing....
      SELECT MAX (inspkey)
        INTO ls_last_inspkey
        FROM inspevnt
       WHERE inspkey <> :OLD.inspkey
         AND brkey = :OLD.brkey
         AND inspdate = (SELECT MAX (inspdate)
                           FROM inspevnt
                          WHERE brkey = :OLD.brkey AND inspkey <> :OLD.inspkey);

      IF ls_last_inspkey IS NOT NULL
      THEN
         ls_where_clause :=
                ' WHERE BRKEY = '
             || ''''
             || :OLD.brkey
             || ''''
             || '  and  INSPKEY = '
             || ''''
             || ls_last_inspkey
             || '''';
             
             -- first put in all the changes from USERINSP, since some INSPEVNT columns depend on USERINSP values (recodes)
          ksbms_pontis.p_false_upd_all_tbl_cols ('USERINSP',
                                                ls_where_clause,
                                                FALSE
                                               );
          -- now fire in the INSPEVNT values from the prior inspection                                         
         ksbms_pontis.p_false_upd_all_tbl_cols ('INSPEVNT',
                                                ls_where_clause,
                                                FALSE
                                               );
      END IF;
   END IF; -- was this the latest inspevnt record we were deleting?
   EXCEPTION
            WHEN OTHERS THEN -- nothing to do, no data available, all rows gone...
                 NULL;
                 
END tadr_inspevnt_recover_last;
/