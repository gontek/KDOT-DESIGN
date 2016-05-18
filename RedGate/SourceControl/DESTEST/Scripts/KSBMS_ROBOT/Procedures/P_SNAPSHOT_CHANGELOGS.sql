CREATE OR REPLACE PROCEDURE ksbms_robot.p_snapshot_changelogs(
     p_ora_dbms_job_id IN ds_jobruns_history.ora_dbms_job_id%TYPE -- this is a scheduled JOB ID
     )     IS
     ll_Seq PLS_INTEGER;
     ls_Seq VARCHAR2( 12 );
     ls_today VARCHAR2(10);
      ls_SQLString VARCHAR2( 2000 );
     BEGIN
     
         
          ls_today := TO_CHAR( SYSDATE, 'MMDDYYYY');
          SELECT seq_changelog_snapshot_id.NEXTVAL into ll_seq from DUAL;
          ls_seq := TO_CHAR( ll_SEQ, '09999999' ); -- changed to 9 digit max on 12-2-2005, table name was erroring out because of size 

          
          -- DS_CHANGE_LOG >> DS_SNAP_CL_MMDDYYYY0000001
          -- DS_LOOKUP_KEYVALS
          -- DS_CHANGE_LOG_C
          -- DS_LOOKUP_KEYVALS_C
          
          ls_SQLString := 'CREATE TABLE DS_SNAP_CL_'|| p_ora_dbms_job_id ||ls_today||ls_seq;
          ls_SQLSTRING := ls_SQLSTRING || ' AS SELECT * FROM DS_CHANGE_LOG';
          
          BEGIN
          
               EXECUTE IMMEDIATE ls_SQLString;
               
          EXCEPTION
              WHEN OTHERS THEN 
                   RAISE;    
          END;
          
          ls_SQLString := 'CREATE TABLE DS_SNAP_CL_C_'|| p_ora_dbms_job_id ||ls_today||ls_seq;
          ls_SQLSTRING := ls_SQLSTRING || ' AS SELECT * FROM DS_CHANGE_LOG_C';
          
          BEGIN
          
               EXECUTE IMMEDIATE ls_SQLString;
               
          EXCEPTION
              WHEN OTHERS THEN 
                   RAISE;    
          END;
          ls_SQLString := 'CREATE TABLE DS_SNAP_LUKV_'|| p_ora_dbms_job_id ||ls_today||ls_seq;
          ls_SQLSTRING := ls_SQLSTRING || ' AS SELECT * FROM DS_LOOKUP_KEYVALS';
          
          BEGIN
          
               EXECUTE IMMEDIATE ls_SQLString;
          EXCEPTION
              WHEN OTHERS THEN 
                   RAISE;    
          END;
          
          ls_SQLString := 'CREATE TABLE DS_SNAP_LUKV_C_'|| p_ora_dbms_job_id ||ls_today||ls_seq;
          ls_SQLSTRING := ls_SQLSTRING || ' AS SELECT * FROM DS_LOOKUP_KEYVALS_C';
          
          BEGIN
          
               EXECUTE IMMEDIATE ls_SQLString;
          EXCEPTION
              WHEN OTHERS THEN 
                   RAISE;    
          END;
          
     EXCEPTION
              WHEN OTHERS THEN 
                   RAISE;     
          
     END p_snapshot_changelogs;

 
/