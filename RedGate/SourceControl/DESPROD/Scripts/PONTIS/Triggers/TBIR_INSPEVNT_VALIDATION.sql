CREATE OR REPLACE TRIGGER pontis.tbir_inspevnt_validation
     BEFORE INSERT
     ON pontis.inspevnt
     FOR EACH ROW
-- Allen Marshall, CS - 2002.12.20 - BEFORE INSERT trigger to perform various recoding and checking prior to insert of a new row on INSPEVNT
-- implemented - recode all dates to missing for subsequent fixup.
-- only does this if the inspevnt record is being created RIGHT AFTER the BRIDGE record (within 10 seconds)
-- Allen Marshall, CS - 2003.01.07 - Used to check by time, now sees if the bridge is in the collection of bridges being inserted (statement level triggers
-- changed date conversions in TO_CHAR to use HH24MISS 


DECLARE
     -- local variables here
     -- Allen Marshall, CS -2002.12.20 - use the default missing date string from ksbms_pontis_util.f_return_missing_date_string,
     ls_date_format             VARCHAR2 (10);
     ld_missing_date            DATE;
     -- when was my parent bridge created?
     ld_bridge_createdatetime   DATE;
     ld_now                     DATE;
     ll_time_window             CONSTANT PLS_INTEGER             := 10; -- SECONDS change if shorter window is desired.
     ls_bridge_id               bridge.bridge_id%TYPE; -- interrogate KSBMS_SCOREBOARD collection variable for this
     ls_brkey                   inspevnt.brkey%TYPE;
BEGIN
     IF INSERTING and KSBMS_SCOREBOARD.v_bool_br_insert_underway -- NEW WAY, PAY ATTENTION TO SCOREBOARD WINDOW
     THEN
      /*    BEGIN
               -- find out parent CREATEDATETIME.  If this record is being made right after its parent, set its inspection values to missing dates
               SELECT :new.createdatetime
                 INTO ld_bridge_createdatetime
                 FROM bridge
                WHERE brkey = :NEW.brkey;
          EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                    BEGIN
                         ksbms_util.p_sql_error ('A SQL  error NO_DATA_FOUND occurred trying to determine the create date & time for a new structure in tbir_inspevnt_validation'
                                                );
                    END;
               WHEN OTHERS
               THEN
                    BEGIN
                         ksbms_util.p_sql_error ('A SQL  error occurred trying to determine the create date time for a new structure in tbir_inspevnt_validation'
                                                );
                    END;
          END;
*/
          -- Allen Marshall, CS - 2002.12.20 - new behavior - set inspdate(s) missing for auto-inserted records and records inserted through the Pontis GUI.
           -- SPECIAL CASE - IF THIS IS A TOTALLY NEW INSPECTION, IT FORCES IT TO BE MISSING FOR DATE ON INSERT
          IF NVL (ksbms_util.f_get_coption_value ('SETNEWINSPDATEMISSING'),
                  'Y'
                 ) = 'Y'
          THEN
          
              -- OLD WAY
              /*
               -- Allen Marshall, CS -2003.01.07
               -- see if the time RIGHT NOW is within ll_time_window of the time the bridge was created - default is 10 seconds
               -- fragile if a pending commit hangs save of the BRIDGE record, but probably OK
               -- updated TBIDR BRIDGE TO STAMP NEW ROWS WITH SYSDATE JUST BEFORE SAVE
               -- compares two ordinal integers
               ld_Now := SYSDATE;
                                               
               IF ABS (  TO_NUMBER (TO_CHAR (ld_Now, 'hh24miss')) -- changed to HH24 ARM 2003.01.09
                       - TO_NUMBER (TO_CHAR (ld_bridge_createdatetime,
                                             'hh24miss' -- changed to HH24 ARM 2003.01.09
                                            )
                                   )
                      ) <= ll_time_window
               THEN -- bridge was created within 10 seconds
               
               
               */
                
                    ls_date_format :=
                         NVL (ksbms_util.f_get_coption_value ('DEFAULTDATEFORMAT'
                                                             ),
                              'YYYY-MM-DD'
                             );

                    -- Allen Marshall, CS - 2005-06-06
                    -- added an NVL wrapper here to force the date to be 1901-01-01 if nothing is found by 
                    -- the call to f_return_missing_date_string
                    
                    ld_missing_date :=
                         TO_DATE ( NVL( SUBSTR (ksbms_pontis_util.f_return_missing_date_string,
                                          1,
                                          10
                                         ), '1901-01-01'),
                                  ls_date_format
                                 );
                    :NEW.inspdate := ld_missing_date;
                    :NEW.nextinsp := ld_missing_date;
                    :NEW.elinspdate := ld_missing_date;
                    :NEW.elnextdate := ld_missing_date;
                    :NEW.oslastinsp := ld_missing_date;
                    :NEW.osnextdate := ld_missing_date;
                    :NEW.fclastinsp := ld_missing_date;
                    :NEW.fcnextdate := ld_missing_date;
                    :NEW.uwlastinsp := ld_missing_date;
                    :NEW.uwnextdate := ld_missing_date;
               -- augment here to set other stuff to missing for really really new records (time window determined) if desired.
               /* END IF; OLD WAY DIDN'T CHECK SCOREBOARD TABLE*/  
          END IF;
     END IF;
END tbir_inspevnt_validation;
/