CREATE OR REPLACE PACKAGE ksbms_robot."KSBMS_DATA_SYNC_EXAMPLE"

is

  -- Author  : ARM
  -- Created : 2002-01-04
  -- Purpose : Skeleton for collecting changes, evaluating, brokering and propagating changes between
  -- PONTIS 4.0 db and CANSYS

  -- Public type declarations
  --type <TypeName> is <Datatype>;
  SUBTYPE A_SQLString IS VARCHAR2( 2048 );
  SUBTYPE A_MailMEssage IS VARCHAR2( 8000 );

  -- Public constant declarations
  -- <ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  -- <VariableName> <Datatype>;


  -- Public function and procedure declarations
  -- function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;


/*

 FUNCTION Update_T1( the_target IN VARCHAR2, the_source IN VARCHAR2)
     RETURN BOOLEAN;

*/


-- function that constructs SQL UPDATE statements for
-- arbitrary combinations of target table and column.


PROCEDURE set_debug_mode ( off_on IN BOOLEAN );
FUNCTION get_debug_mode RETURN BOOLEAN;

-- synchronization processing
PROCEDURE ds_sync_exec; -- run synchronization routines - assume default JOB ID - convenience only
-- the real job that is run by the Oracle Queue.
PROCEDURE ds_sync_exec( the_ora_dbmsjob_id IN user_jobs.job%TYPE ); -- run synchronization routines

-- messaging (trace/log/email)
PROCEDURE ds_log( msg_in IN VARCHAR2 );
PROCEDURE ds_log( msg_in IN VARCHAR2, verbose IN BOOLEAN );
PROCEDURE ds_log( msg_in IN VARCHAR2, msglevel IN PLS_INTEGER );
PROCEDURE ds_log( msg_in IN VARCHAR2, msg_fmt IN VARCHAR2, msglevel IN PLS_INTEGER );
FUNCTION ds_log( msg_in IN VARCHAR2, msg_fmt IN VARCHAR2, msglevel IN PLS_INTEGER )
RETURN BOOLEAN;

end ksbms_data_sync_example;
 
/