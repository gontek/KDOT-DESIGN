CREATE OR REPLACE PACKAGE BODY ksbms_robot.ksbms_ds_job_util
IS
   -- Private type declarations
   --type <TypeName> is <Datatype>;

   -- Private constant declarations
   --<ConstantName> constant <Datatype> := <Value>;

   -- Private variable declarations
   --<VariableName> <Datatype>;

   -- Function and procedure implementations
   /*
   function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
     <LocalVariable> <Datatype>;
   begin
     <Statement>;
     return(<Result>);
   end;
    */
   PROCEDURE ds_submit_job
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE ds_job_status
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE ds_kill_job
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE ds_run_job
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE ds_clear_log
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE ds_reset_job_seqnum
   IS
   BEGIN
      NULL;
   END;

   FUNCTION ds_get_session_id
      RETURN VARCHAR2
   IS
   BEGIN
      NULL;
   END;

   FUNCTION ds_get_new_job_id
      RETURN PLS_INTEGER
   IS
   BEGIN
      NULL;
   END;

   FUNCTION ds_get_jobs
      RETURN ds_jobs
   IS
   BEGIN
      NULL;
   END;

BEGIN
   -- Initialization
   --<Statement>;
   NULL;
END ksbms_ds_job_util;
/