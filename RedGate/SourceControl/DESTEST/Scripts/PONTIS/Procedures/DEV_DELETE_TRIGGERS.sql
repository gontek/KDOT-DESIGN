CREATE OR REPLACE procedure pontis.dev_delete_triggers( the_trigger_mask IN VARCHAR,       the_schema   IN   sys.all_tables.owner%TYPE) is

-- DROP 1 or more triggers in schema PONTIS by trigger mask, or explicit name
  
      ls_schema             user_triggers.table_owner%TYPE;
      ls_ddlstring            VARCHAR2 (255);
      no_schema_owner         EXCEPTION;
      no_trigger_mask         EXCEPTION;
   BEGIN
      LOOP
         -- look up triggers for logged in or Pontis schema, selecting only those that
         -- that are found in the view USER_TRIGGERS.  These have to be disabled before

         -- default schema to logged in user if missing
         ls_schema := UPPER( nvl( the_schema, USER) );

         IF the_trigger_mask IS NULL
          THEN
              RAISE no_trigger_mask ;
          END IF;
          
         -- load a cursor from USER_triggers
         /*
         We are creating the following DDL dynamically ...
         DROP  trigger pontis.taur_userbrdg_bridgemed;
         */
         
         
         FOR the_trigger_rec IN  (SELECT *
                                    FROM user_triggers
                                    WHERE table_owner = ls_schema AND
                                    trigger_name LIKE ''|| the_trigger_mask||'%'|| '' )
                                   
         LOOP
            BEGIN
               ls_ddlstring :=
                        'DROP TRIGGER '|| ls_schema || '.' ||the_trigger_rec.trigger_name;
               DBMS_OUTPUT.put_line (ls_ddlstring);
               -- EXECUTE IMMEDIATE ls_ddlstring;
               DBMS_OUTPUT.put_line (
                     ls_schema
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
        EXIT WHEN TRUE;
        
  END LOOP;
end dev_delete_triggers;

 
/