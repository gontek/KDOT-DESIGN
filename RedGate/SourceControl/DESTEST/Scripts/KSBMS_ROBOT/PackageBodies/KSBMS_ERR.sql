CREATE OR REPLACE PACKAGE BODY ksbms_robot."KSBMS_ERR"
IS
   g_target    PLS_INTEGER    := c_table;
   g_file      VARCHAR2 (255) := 'BMS_ERR.log';
   -- based on ksbms_fileio global
   g_dir       VARCHAR2 (255); -- ksbms_fileio.getdefaultdir ( ); - set in logging routine if null;
   gb_logerr   BOOLEAN        := FALSE;

   PROCEDURE handle (
      the_appcode_in   IN   PLS_INTEGER,
      the_errcode_in   IN   PLS_INTEGER,
      the_errmsg_in    IN   VARCHAR2,
      the_logerr       IN   BOOLEAN := NULL,
      the_reraise      IN   BOOLEAN := NULL
   )
   IS
   BEGIN
      errhandler (
         the_appcode_in,
         the_errcode_in,
         the_errmsg_in,
         the_logerr,
         the_reraise
      );
   END;

   PROCEDURE errhandler (
      the_appcode_in   IN   PLS_INTEGER,
      the_errcode_in   IN   PLS_INTEGER,
      the_errmsg_in    IN   VARCHAR2,
      the_logerr       IN   BOOLEAN := NULL,
      the_reraise      IN   BOOLEAN := NULL
   )
   IS
   BEGIN
      NULL;

      IF the_logerr
      THEN
         ksbms_err.LOG (
            NVL (the_appcode_in, ksbms_msginfo.get_default_app ()),
            the_errcode_in,
            the_errmsg_in
         );
      END IF;

      IF the_reraise
      THEN
         ksbms_err.RAISE (
            the_appcode_in,
            the_errcode_in,
            NVL (the_errmsg_in, '')
         );
      END IF;
   END errhandler;

/*
   PROCEDURE RAISE (
      the_appcode_in   IN   PLS_INTEGER := NULL,
      the_errcode_in   IN   PLS_INTEGER := NULL
   )
   IS
   BEGIN
      ksbms_err.RAISE (the_appcode_in, the_errcode_in, '');
   END;
*/

   PROCEDURE RAISE (
      the_appcode_in   IN   PLS_INTEGER := NULL,
      the_errcode_in   IN   PLS_INTEGER := NULL,
      the_errmsg_in    IN   VARCHAR2 := NULL
   )
   IS
      l_appcode    PLS_INTEGER                   := NVL (the_appcode_in, 3);
      l_errcode    PLS_INTEGER                   := NVL (
                                                       the_errcode_in,
                                                       SQLCODE
                                                    );
      l_errmsg     VARCHAR2 (1000)               := NVL (
                                                       the_errmsg_in,
                                                       SQLERRM
                                                    );
      ls_errtext   ksbms_msg_info.msgtext%TYPE;
   BEGIN
        --Allen 5/29/2001 put agency error message
       -- goto msg_info table, retrieve message text for the passed code, if any.
      -- if null agency error text in ls_errtext, just append a blank
      -- Allen 2001.06.18 only lookup ksbms_msginfo.getmsgtext if we are in the user message range

      IF l_errcode BETWEEN -20999 AND -20000
      -- Enduser application error # range
      THEN
         ls_errtext := NVL (
                             '( '
                          || ksbms_msginfo.getmsgtext (
                                l_appcode,
                                l_errcode,
                                'EXCEPTION',
                                TRUE
                             )
                          || ' )',
                          ' '
                       );
         -- Allen 2001.06.21 separate standard message from errtext with a -
         raise_application_error (
            l_errcode,
               l_errmsg
            || ' - '
            || ls_errtext
         );
      /* Use positive error numbers -- lots to choose from! */
      ELSIF      l_errcode > 0
             AND l_errcode NOT IN (1, 100)
      THEN
         ls_errtext := NVL (
                             '( '
                          || ksbms_msginfo.getmsgtext (
                                l_appcode,
                                l_errcode,
                                'EXCEPTION',
                                TRUE
                             )
                          || ' )',
                          ' '
                       );
         raise_application_error (
            -20000,
               l_errcode
            || '-'
            || l_errmsg
            || ls_errtext
         );
      /* Can't EXCEPTION_INIT -1403 */
      ELSIF l_errcode IN (100, -1403)
      THEN
         RAISE NO_DATA_FOUND;
      /* Re-raise any other exception. */
      ELSIF l_errcode != 0
      THEN
         /*PLVdyn.plsql ('DECLARE myexc EXCEPTION; ' ||
                          '   PRAGMA EXCEPTION_INIT (myexc, ' ||
                          TO_CHAR (l_errcode) ||
                          ');' ||
                          'BEGIN  RAISE myexc; END;'
         );*/

         -- In this case, the only error message displayed is the system message
         -- User-defined messages for Oracle error numbers are swallowed.

         DECLARE
            my_cur   PLS_INTEGER := DBMS_SQL.open_cursor;
            li_rc    PLS_INTEGER := 0;
         BEGIN
            DBMS_SQL.parse (
               my_cur,
                  ' DECLARE myexc EXCEPTION;  PRAGMA EXCEPTION_INIT (myexc, '
               || TO_CHAR (l_errcode)
               || ');'
               || '   BEGIN  RAISE myexc; END;',
               DBMS_SQL.native
            );
            li_rc := DBMS_SQL.EXECUTE (my_cur);
            DBMS_SQL.close_cursor (my_cur);
         END;
      END IF;
   END raise;

   /*PROCEDURE LOG (
      the_errcode_in   IN   PLS_INTEGER := NULL,
      the_errmsg_in    IN   VARCHAR2 := NULL
   )
   IS
   BEGIN
      LOG (c_default_app, the_errcode_in, the_errmsg_in);
   END log;*/

   PROCEDURE LOG (
      the_appcode_in   IN   PLS_INTEGER := NULL,
      the_errcode_in   IN   PLS_INTEGER := NULL,
      the_errmsg_in    IN   VARCHAR2 := NULL
   )
   IS
      PRAGMA autonomous_transaction;
      l_owner     sys.all_objects.owner%TYPE;
      l_appcode   PLS_INTEGER
                    := NVL (the_appcode_in, ksbms_msginfo.get_default_app ());
      l_sqlcode   PLS_INTEGER                  := NVL (
                                                     the_errcode_in,
                                                     SQLCODE
                                                  );
      l_sqlerrm   VARCHAR2 (1000)              := NVL (
                                                     the_errmsg_in,
                                                     SQLERRM
                                                  );
   BEGIN
      IF g_target = c_table
      THEN
         /* Initialize owner using the appcode - appcode is unique across all entries */
         SELECT owner
           INTO l_owner
           FROM ksbms_app_register
          WHERE appcode = l_appcode;

         INSERT INTO ksbms_errlog
                     (owner, appcode, errcode, errmsg, createdatetime,
                      createuserid)
              VALUES (l_owner, l_appcode, l_sqlcode, l_sqlerrm, SYSDATE,
                      USER); --logged IN USER
      ELSIF g_target = c_file
      THEN
         DECLARE
            -- ARM 5/29/2001 use ksbms_fileio functions here to wrap calls to UTL_FILE,
            -- errhandler problems directly.
            fid            ksbms_fileio.fid; --UTL_FILE.file_type;
            the_filename   VARCHAR2 (255)
     :=    ksbms_fileio.getdefaultdir
        || ksbms_fileio.getdirsepchar
        || g_file;
         BEGIN
            -- if we never initialized the storage dir for error messages, set to ksbms_fileio default.
            IF g_dir IS NULL
            THEN
               g_dir := ksbms_fileio.getdefaultdir ();
            END IF;

            fid := ksbms_fileio.f_fopen (g_dir, ksbms_fileio.append);

            --UTL_FILE.fopen (g_dir, g_file, 'A');
            IF ksbms_fileio.f_exists (the_filename, FALSE)
            THEN
               -- message to disk - write USER and SYSDATE
               IF NOT ksbms_fileio.f_put_line (
                         fid,
                            'Error log by '
                         || USER
                         || ' at  '
                         || TO_CHAR (SYSDATE, 'mm/dd/yyyy')
                      )
               THEN
                  errhandler (
                     l_appcode,
                     ksbms_exc.application_exception,
                     'Unable to log error to disk - could not write to log file'
                  );
               END IF;

               --
               IF NOT ksbms_fileio.f_put_line (
                         fid,
                         NVL (the_errmsg_in, SQLERRM)
                      )
               THEN
                  NULL;
                  errhandler (
                     -- specific exception errhandlerr package reference ksbms_exc
                     l_appcode,
                     ksbms_exc.fileio_write_file,
                     'Unable to log error to disk - could not write to log file'
                  );
               END IF;

               IF NOT ksbms_fileio.f_fclose2 (fid)
               THEN
                  --UTL_FILE.fclose (fid);
                  NULL;
                  errhandler (
                     -- specific exception errhandlerr package reference ksbms_exc
                     l_appcode,
                     ksbms_exc.fileio_close_file,
                     'Unable to log error to disk - could not close file'
                  );
               END IF;
            ELSE
               NULL;
               errhandler (
                  -- specific exception errhandlerr package reference ksbms_exc
                  l_appcode,
                  ksbms_exc.fileio_file_not_exist,
                  'Unable to log error to disk - file does not exist'
               );
            END IF;
           /* UTL_FILE.put_line (fid,
               'Error log by ' || USER || ' at  ' ||
                  TO_CHAR (SYSDATE, 'mm/dd/yyyy')
            );*/
--            UTL_FILE.put_line (fid, NVL (errmsg, SQLERRM));
--            UTL_FILE.fclose (fid);
         EXCEPTION
            WHEN OTHERS
            THEN
               IF NOT ksbms_fileio.f_fclose2 (fid)
               THEN
                  --UTL_FILE.fclose (fid);


                  errhandler (
                     -- specific exception errhandlerr package reference ksbms_exc
                     l_appcode,
                     ksbms_exc.fileio_close_file,
                     'Unable to log error to disk - could not close file'
                  );
               END IF;
         END;
      ELSIF g_target = c_screen
      THEN
         -- use FW
         ksbms_fw.pl (
               'Error log by '
            || USER
            || ' at  '
            || TO_CHAR (SYSDATE, 'mm/dd/yyyy')
         );
         ksbms_fw.pl (NVL (the_errmsg_in, SQLERRM));
      END IF;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
   END log;

   PROCEDURE logto (
      target   IN   PLS_INTEGER,
      dir      IN   VARCHAR2 := NULL,
      FILE     IN   VARCHAR2 := NULL
   )
   IS
   BEGIN
      g_target := target;
      g_dir := dir;
      g_file := FILE;
   END logto;

   FUNCTION logging_to
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN g_target;
   END logging_to;

   FUNCTION get_sqlerror (
      p_appcode   IN   PLS_INTEGER,
      p_objname   IN   VARCHAR2,
      p_appmsg    IN   VARCHAR2
   )

----------------------------------------------  function errhandler_conversion_exceptions ------------------------------------
-- Based on sqlcode and sqlerrm, compose a diagnostic error message for the calling routine
-- Arguments:
--  p_objname object name varchar2 e.g. TUB_XX_DDDDDD
--  p_appmsg application message to extend the default SQL error message if desired
-- Returns
-- sResultMsg - VARCHAR2(2000) error message with # embedded
------------------------------------------------ Usage Notes -------------------------------------------------------------------
-- Used by: All simple conversion triggers
------------------------------------------------ Logic Summary -----------------------------------------------------------------
-- Composes a nice error message string based on current SQLCODE and SQLERRM system variables
----------------------------------------------- Revision History ---------------------------------------------------------------
-- Client:  Wyoming Department Of Transportation, 2001
-- Cambridge Systematics, Inc., Asset Management Group
-- Developer: Allen Marshall
-- Created: 2001.04.25
-- Last Revised: 2001.05.25
-- Revision history:
-- Allen 5/1/2001 added p_appmsg to allow user defined message to accompany SQLERRM. Only added if not null
-- Allen 5/25/2001 removed extraneous exception block, eliminated raising exception if no object context passed.
--------------------------------------------------------------------------------------------------------------------------------
      RETURN VARCHAR2
   IS
      sresultmsg   VARCHAR2 (500);
      ls_context   VARCHAR2 (80)  := 'get_SQLError';
   BEGIN
      -- if p_objname is null, errhandler with NVL Allen 5/25/2001
      -- errhandler missing sqlcode (probably never) in-line with NVL
      -- errhandler missing sqlerrm in-line with NVL
      -- Allen 5/1/2001
      -- extend message with application context-specific message
      -- errhandler null with NVL

      sresultmsg :=    'Application ID = '
                    || TO_CHAR (p_appcode)
                    || ', In object [ '
                    || NVL (p_objname, 'Unknown')
                    || ' ], SQLCode= <'
                    || NVL (TO_CHAR (SQLCODE), '???')
                    || '> - SQL Error Message = '
                    || NVL (SQLERRM, 'No error message available')
                    || NVL (   ' --> '
                            || p_appmsg, ' --> no further details');
      RETURN (sresultmsg);
   EXCEPTION
      WHEN OTHERS
      THEN
         BEGIN
            -- specific exception errhandlerr package reference ksbms_exc
            ksbms_err.RAISE (
               p_appcode,
               ksbms_exc.application_exception,
                  'Error in '
               || ls_context
            );
         END;

         RETURN NULL;
   END get_sqlerror;

   PROCEDURE test_exception_errhandler (
      the_appcode_in   IN   PLS_INTEGER,
      the_exception    IN   VARCHAR2 := 'too_many_datadict_rows',
      test_reraise     IN   BOOLEAN := FALSE
   )
   IS
      l_appcode    PLS_INTEGER
                    := NVL (the_appcode_in, ksbms_msginfo.get_default_app ()); -- generic exceptions are appcode 3
      ls_errmsg    VARCHAR2 (500)
                           := 'Raised exception in test_exception_errhandlerr';
      ls_objname   VARCHAR2 (40)  := 'Test_Exception_errhandlerr';
   BEGIN
      ksbms_fw.pl (   'Raising exception: '
                   || the_exception);
      -- specific exception errhandlerr package reference ksbms_exc
      EXECUTE IMMEDIATE    'BEGIN  RAISE ksbms_exc.exc_'
                        || the_exception
                        || '; END;';
                                          -- specific exception errhandlerr package reference ksbms_exc
      -- RAISE ksbms_exc.exc_too_many_datadict_rows;
      ksbms_fw.pl ('++++++++++++++++');
   EXCEPTION
      -- specific exception errhandlerr package reference ksbms_exc
      WHEN ksbms_exc.exc_too_many_datadict_rows
      THEN
         BEGIN
            ksbms_fw.pl ('++++++++++++++++');
            ksbms_fw.pl ('++++++++++++++++');
            ksbms_fw.pl (
                  'Handling '
               || ksbms_msginfo.getmsgname (l_appcode, SQLCODE, 'EXCEPTION')
            );
            ksbms_fw.pl ('++++++++++++++++');
            ksbms_fw.pl ('++++++++++++++++');
            ksbms_fw.pl (' ');
            ksbms_fw.pl (
                  'GET_SQL_ERROR = '
               || get_sqlerror (
                     l_appcode,
                     ls_objname,
                        ls_errmsg
                     || ' -- '
                     || ksbms_msginfo.getmsgtext (
                           l_appcode,
                           SQLCODE,
                           'EXCEPTION',
                           TRUE
                        )
                  )
            );
            ksbms_fw.pl ('++++++++++++++++');
            ksbms_fw.pl ('++++++++++++++++');
            ksbms_fw.pl (
                  'ksbms_msginfo.getmsgname = '
               || ksbms_msginfo.getmsgname (l_appcode, SQLCODE, 'EXCEPTION')
            );
            ksbms_fw.pl ('++++++++++++++++');
            ksbms_fw.pl ('++++++++++++++++');
            ksbms_fw.pl (' ');
            NULL;
            errhandler (
               l_appcode,
               ksbms_msginfo.getmsgcode (
                  l_appcode,
                  the_exception,
                  'EXCEPTION'
               ),
                  'ksbms_err.errhandler MESSAGE = '
               || ksbms_msginfo.getmsgtext (
                     l_appcode,
                     SQLCODE,
                     'EXCEPTION',
                     TRUE
                  ),
               NULL,
               NVL (test_reraise, FALSE)
            ); --  reraise OFF...
            ksbms_fw.pl ('++++++++++++++++');
         END;
      WHEN OTHERS
      THEN
         BEGIN
            ksbms_fw.pl (get_sqlerror (l_appcode, ls_objname, ls_errmsg));
            NULL;
            errhandler (
               l_appcode,
               ksbms_msginfo.getmsgcode (
                  l_appcode,
                  the_exception,
                  'EXCEPTION'
               ),
                  'ksbms_err.errhandler MESSAGE = '
               || ksbms_msginfo.getmsgtext (
                     l_appcode,
                     SQLCODE,
                     'EXCEPTION',
                     TRUE
                  ),
               gb_logerr,
               NVL (test_reraise, FALSE)
            ); --  reraise OFF ...
            ksbms_fw.pl ('++++++++++++++++');
         END;
   END test_exception_errhandler;

   PROCEDURE set_log_errors (the_errlog_mode IN BOOLEAN)
   IS
   BEGIN
      gb_logerr := the_errlog_mode;
   END;

BEGIN -- initialization section
   gb_logerr := FALSE;
END ksbms_err;
/