CREATE OR REPLACE PACKAGE BODY ksbms_robot."KSBMS_DATA_SYNC_EXAMPLE"
IS
   -- Private type declarations
   gl_job_id           PLS_INTEGER;
   gb_keep_log
/*ADVICE(6): This item should be defined in a deeper scope [558] */
                       BOOLEAN                              := TRUE; -- keep log after run
   g_expire_log
/*ADVICE(9): Unreferenced variable [553] */
                       PLS_INTEGER                          := 15; -- Keep time in days.
   g_debug             BOOLEAN                              := FALSE;
   g_verbose
/*ADVICE(13): Unreferenced variable [553] */
                       BOOLEAN                    := ksbms_util.f_get_verbose (

                                                     );
   g_msglevel          PLS_INTEGER              := ksbms_util.f_get_msg_level (

                                                   );
   gs_status_message   VARCHAR2 (32767);
/*ADVICE(21): VARCHAR2 declaration with length greater than 500 characters
              [307] */

   gs_default_email    ds_config_options.optionvalue%TYPE; -- updated table name 2002.01.04 ARM

   PROCEDURE set_debug_mode (off_on IN BOOLEAN)
   IS
   BEGIN
      g_debug := off_on;
   END;

   FUNCTION get_debug_mode
      RETURN BOOLEAN
/*ADVICE(34): Function has no parameters [514] */

   IS
   BEGIN
      RETURN g_debug;
   END get_debug_mode;

   PROCEDURE ds_reset_log -- empty sync log for this session ( DELETE FROM )
/*ADVICE(42): This item should be defined in a deeper scope [558] */

/*ADVICE(44): Procedure has no parameters [516] */

   IS
   BEGIN
      gs_status_message := ''
/*ADVICE(49): In Oracle 8 strings of zero length are not equivalent to a NULL
              [111] */
                             ;
   END ds_reset_log;

   PROCEDURE ds_expire_log -- expire old entries in sync log for this session ( DELETE FROM )
/*ADVICE(55): This item should be defined in a deeper scope [558] */

/*ADVICE(57): Procedure has no parameters [516] */

   IS
   BEGIN
      -- default - always purge gs_status_message
      gs_status_message := ''
/*ADVICE(63): In Oracle 8 strings of zero length are not equivalent to a NULL
              [111] */
                             ;
   END ds_expire_log;

   PROCEDURE ds_log (msg_in
/*ADVICE(69): Unreferenced parameter [552] */
                            IN VARCHAR2)
   IS
   BEGIN
      NULL;
/*ADVICE(74): Use of NULL statements [532] */

   END;

   PROCEDURE ds_log (msg_in
/*ADVICE(79): Unreferenced parameter [552] */
                            IN VARCHAR2, verbose
/*ADVICE(81): Unreferenced parameter [552] */
                                                 IN BOOLEAN)
   IS
   BEGIN
      NULL;
/*ADVICE(86): Use of NULL statements [532] */

   END;

   PROCEDURE ds_log (msg_in IN VARCHAR2, msglevel IN PLS_INTEGER)
   IS
   BEGIN
      ds_log (
         msg_in,
         NVL (ksbms_util.f_get_coption_value ('MESSAGEFORMAT'), 'TEXT'),
         msglevel
      );
   END;

   PROCEDURE ds_log (
      msg_in     IN   VARCHAR2,
      msg_fmt
/*ADVICE(103): Unreferenced parameter [552] */
                 IN   VARCHAR2,
      msglevel   IN   PLS_INTEGER
   )
   IS
      crlf   VARCHAR2 (2) :=    CHR (13)
                             || CHR (10);
   BEGIN
      LOOP
         IF msg_in IS NULL
         THEN
            EXIT;
/*ADVICE(115): IF THEN EXIT should be replaced by EXIT WHEN [401] */

         END IF;

         IF    msglevel IS NULL
            OR msglevel > ksbms_util.f_get_msg_level ()
         THEN
            EXIT;
/*ADVICE(123): IF THEN EXIT should be replaced by EXIT WHEN [401] */

         END IF;

         DBMS_OUTPUT.put_line (msg_in);
         gs_status_message :=    gs_status_message
                              || msg_in
                              || crlf;
         EXIT WHEN TRUE;
      END LOOP;
/*ADVICE(133): Presence of more than one exit point from a loop [503] */

   END ds_log;

   FUNCTION ds_log (
      msg_in
/*ADVICE(139): Unreferenced parameter [552] */
                 IN   VARCHAR2,
      msg_fmt
/*ADVICE(142): Unreferenced parameter [552] */
                 IN   VARCHAR2,
      msglevel
/*ADVICE(145): Unreferenced parameter [552] */
                 IN   PLS_INTEGER
   )
      RETURN BOOLEAN
   IS
      lb_failed   BOOLEAN := TRUE;
   BEGIN
      LOOP
         lb_failed := FALSE;
         EXIT WHEN TRUE;
      END LOOP;

      RETURN lb_failed;
   END ds_log;

   -- procedures used by ds_sync_exec - forward declaration
   PROCEDURE ds_sync_init
/*ADVICE(162): This item should be defined in a deeper scope [558] */
                         (the_ds_job_id_in IN VARCHAR2);

   PROCEDURE ds_sync_collect_changes
/*ADVICE(166): This item should be defined in a deeper scope [558] */
                                    (the_ds_job_id_in IN VARCHAR2); -- get changes from Pontis and CANSYS

   PROCEDURE ds_merge_changes
/*ADVICE(170): This item should be defined in a deeper scope [558] */
                             (the_ds_job_id_in IN VARCHAR2); -- Broker changes between Pontis and CANSYS

   PROCEDURE ds_sync_propagate_changes
/*ADVICE(174): This item should be defined in a deeper scope [558] */
                                      (the_ds_job_id_in IN VARCHAR2); -- SEND brokered changes to Pontis and CANSYS

   PROCEDURE ds_sync_archive_changes
/*ADVICE(178): This item should be defined in a deeper scope [558] */
                                    (the_ds_job_id_in IN VARCHAR2); -- archive all changes from a job run

   PROCEDURE ds_sync_notify
/*ADVICE(182): This item should be defined in a deeper scope [558] */
                           (
      the_ds_job_id_in     IN   VARCHAR2,
      the_result_code_in   IN   PLS_INTEGER
   ); -- Send current message log via notification mechanism;

   PROCEDURE ds_sync_report
/*ADVICE(189): This item should be defined in a deeper scope [558] */
                           (the_ds_job_id_in IN VARCHAR2); -- Generate job summary report

   PROCEDURE ds_sync_reset
/*ADVICE(193): This item should be defined in a deeper scope [558] */
                          (the_ds_job_id_in IN VARCHAR2); -- cleanup after synchronization, reset job environment


-- synchronization processing
   PROCEDURE ds_sync_exec
/*ADVICE(199): This item should be defined in a deeper scope [558] */

/*ADVICE(201): Procedure has no parameters [516] */

   IS
   BEGIN

-- ds_job ( the_ora_dbmsjob_id IN PLS_INTEGER)
      gl_job_id := -1;
      ds_sync_exec (gl_job_id);
   END ds_sync_exec;

   PROCEDURE ds_sync_exec (the_ora_dbmsjob_id IN user_jobs.job%TYPE) -- run synchronization routines
   IS
      ls_ds_job_id   VARCHAR2 (32) := SYS_GUID (); -- initialize the job id for this run of the procedure
   BEGIN
      gl_job_id := the_ora_dbmsjob_id; -- set to calling ORACLE QUEUE JOB #
      ds_log (
            'Oracle Job #'
         || TO_CHAR (gl_job_id)
         || ' starting...',
         g_msglevel
      );
      ds_log (
            'Internal DS job ID is: [ '
         || ls_ds_job_id
         || ' ]',
         g_msglevel
      );
      ds_log ('Starting synchronization routines...', g_msglevel);

      -- startup synchronization, perform initialization tasks
      BEGIN
         ds_sync_init (ls_ds_job_id);
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE;
/*ADVICE(237): A WHEN OTHERS clause is used in the exception section without
              any other specific handlers [201] */

      END;

      -- collect changes from CANSYS and Pontis
      BEGIN
         ds_sync_collect_changes (ls_ds_job_id);
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE;
/*ADVICE(249): A WHEN OTHERS clause is used in the exception section without
              any other specific handlers [201] */

      END;

      -- broker / merge changes to eliminate stale, conflicts, etc.
      BEGIN
         ds_merge_changes (ls_ds_job_id);
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE;
/*ADVICE(261): A WHEN OTHERS clause is used in the exception section without
              any other specific handlers [201] */

      END;

      -- collect changes from CANSYS and Pontis
      BEGIN
         ds_sync_propagate_changes (ls_ds_job_id);
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE;
/*ADVICE(273): A WHEN OTHERS clause is used in the exception section without
              any other specific handlers [201] */

      END;

      -- collect changes from CANSYS and Pontis
      BEGIN
         ds_sync_archive_changes (ls_ds_job_id);
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE;
/*ADVICE(285): A WHEN OTHERS clause is used in the exception section without
              any other specific handlers [201] */

      END;

      -- generate activity report
      BEGIN
         ds_sync_report (ls_ds_job_id);
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE;
/*ADVICE(297): A WHEN OTHERS clause is used in the exception section without
              any other specific handlers [201] */

      END;

      ds_log (
            'DS Job run ['
         || ls_ds_job_id
         || ' ] completed normally',
         g_msglevel
      );
      --notify, via e-mail if selected.
      ds_sync_notify (ls_ds_job_id, SQLCODE);

      -- clean up message, log etc.
       -- restore operating environment to pre-sync state if possible.
      BEGIN
         ds_sync_reset (ls_ds_job_id);
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE;
/*ADVICE(319): A WHEN OTHERS clause is used in the exception section without
              any other specific handlers [201] */

      END;

-- EXCEPTION BLOCK FOR WHOLE ds_sync_exec
   EXCEPTION
      WHEN OTHERS
      THEN
         ds_log (
               'DS Job run ['
            || ls_ds_job_id
            || ' ] raised an exception',
            g_msglevel
         );
         ds_log (
               'Error in ds_sync_exec'
            || ksbms_msginfo.getmsgtext (2, SQLCODE, 'EXCEPTION', TRUE),
            g_msglevel
         );
         ds_sync_notify (ls_ds_job_id, SQLCODE); -- goes out before the error is raised...
         -- handle the error, reraise.
         ksbms_err.errhandler (
            2,
            SQLCODE,
            'Error in ds_sync_exec',
            TRUE,
            TRUE
         ); -- don't raise yet!
/*ADVICE(348): A WHEN OTHERS clause is used in the exception section without
              any other specific handlers [201] */

   END ds_sync_exec;

   PROCEDURE ds_sync_init (the_ds_job_id_in
/*ADVICE(354): Unreferenced parameter [552] */
                                            IN VARCHAR2) -- setup for synchronization
   IS
   BEGIN
      NULL;
/*ADVICE(359): Use of NULL statements [532] */

      ds_log (
         'Initializing data synchronization system for job...',
         g_msglevel
      );
   END ds_sync_init;

   PROCEDURE ds_sync_collect_changes (the_ds_job_id_in
/*ADVICE(368): Unreferenced parameter [552] */
                                                       IN VARCHAR2) -- get changes from Pontis and CANSYS
   IS
   BEGIN
      NULL;
/*ADVICE(373): Use of NULL statements [532] */

      ds_log (
         'Collecting pending changes from CANSYS and Pontis schemas for job...',
         g_msglevel
      );
   END ds_sync_collect_changes;

   PROCEDURE ds_merge_changes (the_ds_job_id_in
/*ADVICE(382): Unreferenced parameter [552] */
                                                IN VARCHAR2) -- Broker changes between Pontis and CANSYS
   IS
   BEGIN
      NULL;
/*ADVICE(387): Use of NULL statements [532] */

      ds_log (
         'Merging changes to CANSYS and Pontis schemas for job...',
         g_msglevel
      );
   END ds_merge_changes;

   PROCEDURE ds_sync_propagate_changes (the_ds_job_id_in
/*ADVICE(396): Unreferenced parameter [552] */
                                                         IN VARCHAR2) -- SEND brokered changes to Pontis and CANSYS
   IS
   BEGIN
      NULL;
/*ADVICE(401): Use of NULL statements [532] */

      ds_log (
         'Propagating changes to CANSYS and Pontis schemas for job...',
         g_msglevel
      );
   END ds_sync_propagate_changes;

   PROCEDURE ds_sync_archive_changes (the_ds_job_id_in
/*ADVICE(410): Unreferenced parameter [552] */
                                                       IN VARCHAR2) -- archive all changes from a job run
   IS
   BEGIN
      NULL;
/*ADVICE(415): Use of NULL statements [532] */

      ds_log ('Archiving changes for job...', g_msglevel);
   END ds_sync_archive_changes;

   PROCEDURE ds_sync_report (the_ds_job_id_in
/*ADVICE(421): Unreferenced parameter [552] */
                                              IN VARCHAR2) -- Generate job summary report
   IS
   BEGIN
      ds_log ('Generating synchronization session summary...', g_msglevel);
      ds_log ('Synchronization summary report completed.', g_msglevel);
   END ds_sync_report;

   PROCEDURE ds_sync_notify (
      the_ds_job_id_in     IN   VARCHAR2,
      the_result_code_in   IN   PLS_INTEGER --:= 0
   ) -- with current message, send results e-mail
   IS
   BEGIN
      -- if we are emailing results, generate a message....
      IF NVL (ksbms_util.f_get_coption_value ('EMAILNOTIFICATION'), 'ON') =
                                                                         'ON'
      THEN
         IF ksbms_util.f_email (
               NVL (
                  ksbms_util.f_get_coption_value ('EMAIL_NOTIFICATION_LIST'),
                  gs_default_email
               ),
               gs_status_message,
                  'DS JOB [ '
               || the_ds_job_id_in
               || ' ] SQLCODE = '
               || TO_CHAR (the_result_code_in) -- with final run code = ...TBD
            )
         THEN
            DBMS_OUTPUT.put_line ('Unable to mail results report');
         END IF;
      ELSE
         NULL;
/*ADVICE(455): Use of NULL statements [532] */

      -- or, dump to console TBD
      END IF;
   END ds_sync_notify;

   PROCEDURE ds_sync_reset (the_ds_job_id_in
/*ADVICE(462): Unreferenced parameter [552] */
                                             IN VARCHAR2) -- cleanup after synchronization, reset job environment
   IS
   BEGIN
      NULL;
/*ADVICE(467): Use of NULL statements [532] */


      IF NOT gb_keep_log
      THEN
         ds_reset_log; -- all done...
      ELSE
         ds_expire_log;
      END IF;
   END ds_sync_reset;

BEGIN
   -- Initialization

   --<Statement>;
   IF g_debug IS NULL
   THEN
      set_debug_mode (TRUE);
   END IF;

   -- init message logging level (see KSBMS_UTIL )
   IF g_msglevel IS NULL
   THEN
      g_msglevel := ksbms_util.f_get_msg_level ();
   END IF;

   IF gs_default_email IS NULL
   THEN
      gs_default_email := 'arm@camsys.com';
   END IF;
END ksbms_data_sync_example;
/*ADVICE(498): ADVICE SUMMARY

Count  Recommendation
-----  --------------
    2  [111]  In Oracle 8 strings of zero length are not equivalent
              to a NULL

                  PL/SQL treats any zero-length string like a null. This
                  includes values returned by character functions and boolean
                  expressions.
                  According to the ANSI SQL 1992 Transitional standard, a
                  zero-length or empty string is not the same as NULL. The
                  Oracle database server may comply fully with this aspect of
                  the standard in the future.Therefore, it is recommended that
                  applications ensure that empty strings values and NULL are
                  not treated equivalently.
                  To concatenate an expression that might be null, use the NVL
                  function to explicitly convert the expression to a
                  zero-length string.

    8  [201]  A WHEN OTHERS clause is used in the exception section
              without any other specific handlers

                  There isn't necessarily anything wrong with using WHEN
                  OTHERS, but it can cause you to "lose" error information
                  unless your handler code is relatively sophisticated.

    1  [307]  VARCHAR2 declaration with length greater than 500
              characters

                  Prior to Oracle8, VARCHAR2 variables are treated like
                  variable-length strings for purposes of manipulation and
                  evaluation, but Oracle does allocate the full amount of
                  memory upon declaration. If you declare a variable
                  VARCHAR2(2000), then Oracle does allocate 2000 bytes, even
                  if you only use three.

    2  [401]  IF THEN EXIT should be replaced by EXIT WHEN

                  If the IF clause does not contain any code except for an
                  EXIT statement, then use of the EXIT WHEN <expression>
                  syntax is more intuitive and involves less coding

    4  [408]  END of program unit, package or type is not labeled

                  Repeating names on the end of these compound statements
                  ensures consistency throughout the code. In addition, the
                  named end provides a reference for the reader if the unit
                  spans a page or screen boundary or if it contains a nested
                  unit.

    1  [503]  Presence of more than one exit point from a loop

                  If you have multiple exit points within the loop, then it is
                  harder to debug and maintain your code.

    1  [514]  Function has no parameters

                  While this is not necessarily a problem, a function without
                  any parameters is more likely to (a) depend on global
                  variables for data or (b) not be as reusable as it could be.

    3  [516]  Procedure has no parameters

                  While this is not necessarily a problem, a procedure without
                  any parameters is more likely to (a) depend on global
                  variables for data or (b) not be as reusable as it could be.

    9  [532]  Use of NULL statements



   14  [552]  Unreferenced parameter

                  You have defined a parameter in the parameter list, but it
                  is not used inside the program. This can occur as the result
                  of deprecations in code over time, but you should make sure
                  that this situation does not reflect a problem.

    2  [553]  Unreferenced variable

                  You have defined a parameter in the parameter list, but it
                  is not used inside the program. This can occur as the result
                  of deprecations in code over time, but you should make sure
                  that this situation does not reflect a problem. And you
                  should remove the declaration to avoid maintenance errors in
                  the future.

   12  [558]  This item should be defined in a deeper scope

                  It is a good practice to declare variables, cursors,
                  functions and other objects as deep as possible, in order to
                  reduce the chance of unintended use by other sections of the
                  code.

 */
/