CREATE OR REPLACE PACKAGE ksbms_robot.ksbms_ds_job_util AUTHID CURRENT_USER
IS
   -- Author  : ARM
   -- Created : 2001-07-03 09:48:54
   -- Purpose : Setup and manage data synchronization jobs.

   -- Public type declarations
   --type <TypeName> is <Datatype>;
   TYPE ds_jobs IS varray (50) OF INTEGER;

   -- Public constant declarations
   --<ConstantName> constant <Datatype> := <Value>;

   -- Public variable declarations
   -- <VariableName> <Datatype>;

   -- Public function and procedure declarations
   -- function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
   PROCEDURE ds_submit_job;

   PROCEDURE ds_job_status;

   PROCEDURE ds_kill_job;

   PROCEDURE ds_run_job;

   PROCEDURE ds_clear_log;

   PROCEDURE ds_reset_job_seqnum;

   FUNCTION ds_get_session_id
      RETURN VARCHAR2;

   FUNCTION ds_get_new_job_id
      RETURN PLS_INTEGER;

   FUNCTION ds_get_jobs
      RETURN ds_jobs;
END ksbms_ds_job_util;

 
/