CREATE OR REPLACE procedure ksbms_robot.dev_delete_triggers( the_trigger_mask IN VARCHAR,       the_schema   IN   sys.all_tables.owner%TYPE) is

-- DROP 1 or more triggers in schema PONTIS by trigger mask, or explicit name
  
      ls_ddlstring            VARCHAR2 (255);
      no_schema_owner         EXCEPTION;
      no_trigger_mask         EXCEPTION;
   BEGIN
      LOOP
         -- look up triggers for Pontis schema, selecting only those that
         -- that are found in the table DS_TRIGGERS.  These have to be disabled before
         -- we proceed with our synchronization.
         -- select into cursor
         -- requires grant alter any trigger to ksbms_robot;

         IF the_schema IS NULL
         THEN
            RAISE no_schema_owner;
         END IF;

         IF the_trigger_mask IS NULL
          THEN
              RAISE no_trigger_mask ;
          END IF;
          
         -- load a cursor from datasync_triggers
         /*
         We are creating the following DDL dynamically ...
         alter trigger pontis.taur_userbrdg_bridgemed DISABLE;

         Trigger altered

         SQL> alter trigger pontis.taur_userbrdg_bridgemed ENABLE;
         */

         FOR the_trigger_rec IN  (SELECT *
                                    FROM all_triggers
                                    WHERE owner = the_schema AND
                                    trigger_name LIKE ''|| the_trigger_mask||'%'|| '' )
                                   
         LOOP
            BEGIN
               ls_ddlstring :=
                        'DROP TRIGGER '|| the_trigger_rec.trigger_name;
               DBMS_OUTPUT.put_line (ls_ddlstring);
               -- EXECUTE IMMEDIATE ls_ddlstring;
               DBMS_OUTPUT.put_line (
                     the_schema
                  || ': '
                  || 'Trigger '
                  || the_trigger_rec.trigger_name
                  || ' '

                  || 'DROPPED successfully'
               );
            EXCEPTION
               WHEN OTHERS
               THEN
                  BEGIN
                     RAISE;
                     EXIT;
               END;
            END;
         END LOOP;
        
  END LOOP;
end dev_delete_triggers;

 
/