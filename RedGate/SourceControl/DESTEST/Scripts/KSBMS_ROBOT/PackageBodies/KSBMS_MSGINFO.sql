CREATE OR REPLACE PACKAGE BODY ksbms_robot."KSBMS_MSGINFO"
IS
  -- package locals, not publicly writable
   g_pkg_owner   sys.all_objects.owner%TYPE; -- schema under which this is executing
   gi_default_app PLS_INTEGER ;

   FUNCTION msgrow (
      the_appcode_in   IN   PLS_INTEGER,
      the_msgcode_in   IN   PLS_INTEGER,
      the_type_in      IN   VARCHAR2
   )
      RETURN ksbms_msg_info%ROWTYPE
   IS
      msg_cur          PLS_INTEGER              := DBMS_SQL.open_cursor; --OK for 8.0
      ll_fetchedrows   PLS_INTEGER              := 0;

-- return a message record given its numeric code and the message type (EXCEPTION)
      --CURSOR msg_cur
      --IS
      -- parameters are the_type_in and the_msgcode_in, and the schema owner as
      -- determined by init_owner in PACKAGE load.
      my_sqlstring     VARCHAR2 (255)
   :=    ' SELECT * FROM ksbms_msg_info '
      || ' WHERE '
      || ' UPPER( owner ) = UPPER(  :the_schema_in ) '
      || ' AND '
      || ' appcode = :the_appcode_in'
      || ' AND '
      || ' msgcode = :the_msgcode_in'
      || ' AND '
      || ' msgtype = :the_type_in ';

-- TODO - embed schema so the same table can be used globally...
--        ' SCHEMA = UID  AND ' ||

      the_msg_rec      ksbms_msg_info%ROWTYPE;
   /*
         Name                                                  Null?    Type
   ----------------------------------------------------- -------- ------------------------------------
   MSGCODE                                               NOT NULL NUMBER
   MSGTYPE                                                        VARCHAR2(30)
   MSGTEXT                                                        VARCHAR2(2000)
   MSGNAME                                                        VARCHAR2(30)
   DESCRIPTION                                                    VARCHAR2(2000)
   */

   BEGIN -- msgrow
      --OPEN msg_cur;
      DBMS_SQL.parse (msg_cur, my_sqlstring, DBMS_SQL.native);
      DBMS_SQL.bind_variable (msg_cur, 'the_schema_in', g_pkg_owner);
      DBMS_SQL.bind_variable (msg_cur, 'the_appcode_in', the_appcode_in);
      DBMS_SQL.bind_variable (msg_cur, 'the_msgcode_in', the_msgcode_in);
      DBMS_SQL.bind_variable (msg_cur, 'the_type_in', the_type_in);
      -- defing columns for the_msg_rec...
      DBMS_SQL.define_column (msg_cur, 1, the_msg_rec.owner, 30);
      DBMS_SQL.define_column (msg_cur, 2, the_msg_rec.appcode);
      DBMS_SQL.define_column (msg_cur, 3, the_msg_rec.msgcode);
      DBMS_SQL.define_column (msg_cur, 4, the_msg_rec.msgtype, 30);
      DBMS_SQL.define_column (msg_cur, 5, the_msg_rec.msglevel);
      DBMS_SQL.define_column (msg_cur, 6, the_msg_rec.msgtext, 2000);
      DBMS_SQL.define_column (msg_cur, 7, the_msg_rec.msgname, 30);
      DBMS_SQL.define_column (msg_cur, 8, the_msg_rec.helpid);
      DBMS_SQL.define_column (msg_cur, 9, the_msg_rec.url, 255);
      DBMS_SQL.define_column (msg_cur, 10, the_msg_rec.description, 2000);
      DBMS_SQL.define_column (msg_cur, 11, the_msg_rec.createdatetime);
      DBMS_SQL.define_column (msg_cur, 12, the_msg_rec.createuserid, 30);
      DBMS_SQL.define_column (msg_cur, 13, the_msg_rec.modtime);
      DBMS_SQL.define_column (msg_cur, 14, the_msg_rec.changeuserid, 30);
      --FETCH msg_cur INTO the_msg_rec - count goes in ll_fetchedrows,which is null if
      -- TOO_MANY_ROWS exception is raised pp. 74 and 75 of Fueuerstein OBIP;

      ll_fetchedrows := DBMS_SQL.execute_and_fetch (msg_cur, TRUE); -- set to TRUE TO GET 1 ROW BACK
      -- assing results to columns in the_msg_rec
      DBMS_SQL.column_value (msg_cur, 1, the_msg_rec.owner);
      DBMS_SQL.column_value (msg_cur, 2, the_msg_rec.appcode);
      DBMS_SQL.column_value (msg_cur, 3, the_msg_rec.msgcode);
      DBMS_SQL.column_value (msg_cur, 4, the_msg_rec.msgtype);
      DBMS_SQL.column_value (msg_cur, 5, the_msg_rec.msgcode);
      DBMS_SQL.column_value (msg_cur, 6, the_msg_rec.msgtext);
      DBMS_SQL.column_value (msg_cur, 7, the_msg_rec.msgname);
      DBMS_SQL.column_value (msg_cur, 8, the_msg_rec.helpid);
      DBMS_SQL.column_value (msg_cur, 9, the_msg_rec.url);
      DBMS_SQL.column_value (msg_cur, 10, the_msg_rec.description);
      DBMS_SQL.column_value (msg_cur, 11, the_msg_rec.createdatetime);
      DBMS_SQL.column_value (msg_cur, 12, the_msg_rec.createuserid);
      DBMS_SQL.column_value (msg_cur, 13, the_msg_rec.modtime);
      DBMS_SQL.column_value (msg_cur, 14, the_msg_rec.changeuserid);
      -- diagnostic..
      --ksbms_fw.pl( the_msg_rec.msgtype ||' - ' || the_msg_rec.msgtext);
      DBMS_SQL.close_cursor (msg_cur);
      --CLOSE msg_cur;

      RETURN the_msg_rec;
   EXCEPTION
      WHEN TOO_MANY_ROWS
      THEN
         BEGIN
            ksbms_fw.pl ('Too many rows found fetching from KSBMS_MSG_INFO');
            RAISE;
         END;

         RETURN NULL;
      --Allen 2001.06.13 - there very well may be no message available for some
      -- reason.
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            ksbms_fw.pl ('No error messsage available in KSBMS_MSG_INFO');
            RETURN NULL;
         -- benign
         END;
      WHEN OTHERS
      THEN
         BEGIN
            RAISE;
         END;

         RETURN NULL;
   END msgrow;

   -- Renamed from text by ARM 6/13/2001
   FUNCTION getmsgtext (
      the_appcode_in   IN   PLS_INTEGER,
      the_msgcode_in   IN   PLS_INTEGER,
      the_type_in      IN   VARCHAR2,
      use_sqlerrm      IN   BOOLEAN := TRUE
   )
      RETURN VARCHAR2
   IS
      msg_rec   ksbms_msg_info%ROWTYPE;
   -- using the exception code, get the message from KSBMS_MSG_INFO using msgrow
   BEGIN
      msg_rec := msgrow (the_appcode_in, the_msgcode_in, the_type_in);

      IF      msg_rec.msgtext IS NULL
          AND use_sqlerrm
      THEN
         msg_rec.msgtext := SQLERRM (the_msgcode_in);
      END IF;

      RETURN msg_rec.msgtext;
   END getmsgtext;

   -- Renamed from name by ARM 6/13/2001
   FUNCTION getmsgname (
      the_appcode_in   IN   PLS_INTEGER,
      the_msgcode_in   IN   PLS_INTEGER,
      the_msgtype_in   IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      msg_rec   ksbms_msg_info%ROWTYPE;
   --using the exception code get the exception name from KSBMS_MSG_INFO using msgrow
   BEGIN
      -- ARM 6/21/2001
      msg_rec := msgrow (the_appcode_in, the_msgcode_in, the_msgtype_in);

      IF msg_rec.msgname IS NULL
      THEN
         msg_rec.msgname := 'NA';
      END IF;

      -- END CHANGE

      RETURN msg_rec.msgname;
   END getmsgname;

   FUNCTION getmsgcode (
      the_appcode_in   IN   PLS_INTEGER,
      the_msgname_in   IN   VARCHAR2,
      the_msgtype_in   IN   VARCHAR2
   )
      RETURN PLS_INTEGER
   IS
      msg_rec   ksbms_msg_info%ROWTYPE;

      -- using the message's name, get the code from KSBMS_MSG_INFO using msgrow_byname
      FUNCTION msgrow_byname (
         the_appcode_in   IN   PLS_INTEGER,
         the_msgname_in   IN   VARCHAR2,
         the_msgtype_in   IN   VARCHAR2
      )
         RETURN ksbms_msg_info%ROWTYPE
      IS
         -- return a message record given its literal name
         CURSOR msg_cur
         IS
            SELECT *
              FROM ksbms_msg_info
             WHERE UPPER (owner) =
                                UPPER (NVL (ksbms_msginfo.g_pkg_owner, USER))
               AND msgtype = the_msgtype_in
               AND appcode = the_appcode_in
               AND LOWER (msgname) = LOWER (the_msgname_in);

         the_msg_rec   ksbms_msg_info%ROWTYPE;
      BEGIN
         OPEN msg_cur;
         FETCH msg_cur INTO the_msg_rec;
         CLOSE msg_cur;
         RETURN the_msg_rec;
      EXCEPTION -- Allen 2001.06.13
         WHEN NO_DATA_FOUND
         THEN
            RETURN NULL;
         WHEN OTHERS
         THEN
            RETURN NULL;
      END msgrow_byname;
   BEGIN
      -- null is ok
      msg_rec :=
               msgrow_byname (the_appcode_in, the_msgname_in, the_msgtype_in);
      RETURN msg_rec.msgcode;
   END getmsgcode;

   PROCEDURE gen_exc_pkg (
      schema_in        IN   sys.all_objects.owner%TYPE DEFAULT USER,
      pkgname_in       IN   sys.all_objects.object_name%TYPE, -- anchored to view column
      the_appcode_in   IN   ksbms_msg_info.appcode%TYPE, --:= get_Default_app(),
      oradev_use       IN   BOOLEAN := TRUE,
      spool_out        IN   BOOLEAN := TRUE,
      file_out         IN   BOOLEAN := FALSE,
      debug_in         IN   BOOLEAN := FALSE,
      trace_in         IN   BOOLEAN := FALSE
   )
    --  spool_out BOOLEAN := TRUE; -- echos writeln to spool file for gen of package script.
   -- file_out BOOLEAN := FALSE; -- if TRUE, creates a server-side SQL script in the default UTL_FILE directory
                               -- to generate the exceptions.  Only enable if UTL_FILE_DIR directives have been set in
                               -- INIT.ORA
    --debug_in BOOLEAN := FALSE; -- prints error diagnostics.
    --trace_in BOOLEAN := FALSE; -- prints progress diagnostics


   IS
      -- generates file
      -- storage of PL/SQL code for debugging purposes.
      my_sqlstring   VARCHAR2 (30000); -- 4000 bytes limit....
      /* builds up My_SQLString using these bits */
      my_strtoken    VARCHAR2 (2000);
      ls_filename    VARCHAR2 (255);
      fid            ksbms_fileio.fid;
      -- li_rc               PLS_INTEGER;
       -- exceptions - cannot open, cannot write, cannot close, doesn't exists
       -- at end of processing
      -- use standard exceptions in BMS_EXC....
      --file_open_failed    EXCEPTION;
      --file_close_failed   EXCEPTION;
      --file_not_found      EXCEPTION;
      ls_errmsg      VARCHAR2 (255);

      CURSOR exc_20000
      IS
         SELECT   *
             FROM ksbms_msg_info
            WHERE appcode = 2 -- get_default_app() -- global, default was 3 12/3/2001
              AND msgcode BETWEEN -20999 AND -20000
              AND msgtype = 'EXCEPTION'
         ORDER BY msgcode DESC; -- Allen 06.19.2001 - ordered

      PROCEDURE writeln (the_fid IN ksbms_fileio.fid, the_buffer IN VARCHAR2)
      IS
      BEGIN -- writeln
         IF file_out
         THEN -- only write if TRUE
            ksbms_fw.istrue (
               the_buffer IS NOT NULL,
               'Input line for WRITELN is NULL'
            );

            IF ksbms_fileio.f_put_line (the_fid, the_buffer)
            THEN
               ksbms_err.RAISE( gi_default_app, ksbms_exc.fileio_write_file, '');
            END IF;
         END IF;
      EXCEPTION
         WHEN ksbms_exc.exc_fileio_write_file
         THEN
            RAISE; -- propagate
         WHEN OTHERS
         THEN
            RAISE; -- propagate
      END writeln;
   BEGIN
      /* Simple generator, based on DBMS_OUTPUT. */
      -- How to use
      -- 1) Add any new exception entries to the table ksbms_msg_info.  Each exception
      -- should be identified by a unique code between -20999 and -20000 (1000 entries)
      -- Don't put  in entries that duplicate ORACLE errors anyway.  They should be application specific

      -- 2) Run this procedure in SQL*PLUS as:
      -- EXECUTE ksbms_msg_info.Gen_exc_Pkg( 'bms_exc', TRUE);
      -- this will create the file in the following way
      --ls_filename :=    fileio.getdefaultdir
      --              || fileio.getdirsepchar
      --              || 'build_exceptions.sql';

      -- the file build_exceptions.sql will reside on the ORACLE HOST
      -- run this file on the ORACLE HOST to rebuild the exceptions enumeration package ksbms_exc.

        -- 3) in code, refer to the exceptions as
       -- if (some condition)
       --    raise ksbms_exc.exception_name;
      -- or ksbms_err.handle( ksbms_exc.exception_name,'Some message....');
       -- end if
       -- EXCEPTION
       --    when ksbms_exc.exception_name then

      --    when OTHERS then
      -- etc.
      -- to retrieve error code, call
      -- msginfo.text( ksbms_exc.exception_code

      -- set these as desired to watch progress of fileio operations
      -- default is off
      -- Allen 6/12/2001 - conditional write to file

      IF file_out
      THEN -- spool to a file
         ls_filename :=    ksbms_fileio.getdefaultdir
                        || ksbms_fileio.getdirsepchar
                        || 'build_exceptions.sql';
         -- get a file handle

         fid := ksbms_fileio.f_fopen (ls_filename, ksbms_fileio.rw);

         -- did we open it successfully
         IF NOT ksbms_fileio.f_is_open (fid)
         THEN
            ksbms_err.RAISE ( gi_default_app, ksbms_exc.fileio_open_file);
         END IF;
      END IF;

      --IF lb_echo_line THEN DBMS_OUTPUT.enable (100000); END IF;
      -- Note - this next statement creates the package under the logged in USER
      -- to make a general package, that might need to be SYSTEM, but there are other things that
      -- need to be done, like taking ownership of the ksbms_msg_info table and making the package publicly
      -- executable and so on..
      my_strtoken :=    'CREATE OR REPLACE PACKAGE '
                     || NVL (schema_in, USER)
                     || '.'
                     || pkgname_in;

      IF spool_out
      THEN
         ksbms_fw.pl (my_strtoken);
      END IF;

      writeln (fid, my_strtoken);
      -- Init My_SQLString, build it up from bits stored in My_StrToken.  Emit the bits using DBMS_OUTPUT.PUT_LINE;

      my_sqlstring := my_strtoken;
      my_strtoken := ' IS '; -- Allen 5/29/2001 added a leading blank

      IF spool_out
      THEN
         ksbms_fw.pl (my_strtoken);
      END IF;

      writeln (fid, my_strtoken);
      my_sqlstring :=    TRIM (my_sqlstring)
                      || ' '
                      || my_strtoken;

      FOR msg_rec IN exc_20000
      LOOP
         IF exc_20000%ROWCOUNT > 1
         THEN
            my_strtoken := ' ';

            IF spool_out
            THEN
               ksbms_fw.pl (my_strtoken);
            END IF;

            writeln (fid, my_strtoken);
            my_sqlstring :=    TRIM (my_sqlstring)
                            || ' '
                            || my_strtoken;
         END IF;

         my_strtoken :=    '   exc_'
                        || msg_rec.msgname
                        || ' EXCEPTION;';

         IF spool_out
         THEN
            ksbms_fw.pl (my_strtoken);
         END IF;

         writeln (fid, my_strtoken);
         my_sqlstring :=    TRIM (my_sqlstring)
                         || ' '
                         || my_strtoken;
         my_strtoken :=    '   en_'
                        || msg_rec.msgname
                        || ' CONSTANT PLS_INTEGER := '
                        || msg_rec.msgcode
                        || ';';

         IF spool_out
         THEN
            ksbms_fw.pl (my_strtoken);
         END IF;

         writeln (fid, my_strtoken);
         my_sqlstring :=    my_sqlstring
                         || my_strtoken;
         my_strtoken :=    '   PRAGMA EXCEPTION_INIT (exc_'
                        || msg_rec.msgname
                        || ', '
                        || msg_rec.msgcode
                        || ');';

         IF spool_out
         THEN
            ksbms_fw.pl (my_strtoken);
         END IF;

         writeln (fid, my_strtoken);
         my_sqlstring :=    TRIM (my_sqlstring)
                         || ' '
                         || my_strtoken;

         IF oradev_use
         THEN
            my_strtoken :=
                     '   FUNCTION '
                  || msg_rec.msgname
                  || ' RETURN PLS_INTEGER;';

            IF spool_out
            THEN
               ksbms_fw.pl (my_strtoken);
            END IF;

            writeln (fid, my_strtoken);
            my_sqlstring :=    TRIM (my_sqlstring)
                            || ' '
                            || my_strtoken;
         END IF;

         IF trace_in
         THEN
            ksbms_fw.pl (
                  ' my_SQLString Length IS now '
               || TO_CHAR (LENGTH (my_sqlstring))
            );
         END IF;

         IF    LENGTH (my_sqlstring) = 0
            OR my_sqlstring IS NULL
         THEN
            IF debug_in
            THEN
               ksbms_fw.pl ('STRING WENT SOUTH!');
            END IF;
         END IF;
      END LOOP;

      my_strtoken :=    'END '
                     || pkgname_in
                     || ';';

      IF spool_out
      THEN
         ksbms_fw.pl (my_strtoken);
      END IF;

      writeln (fid, my_strtoken);
      my_sqlstring :=    TRIM (my_sqlstring)
                      || ' '
                      || my_strtoken;
      my_strtoken := '/';

      IF spool_out
      THEN
         ksbms_fw.pl (my_strtoken);
      END IF;

      writeln (fid, my_strtoken);
      my_sqlstring :=    my_sqlstring
                      || my_strtoken;

      IF oradev_use
      THEN
         my_strtoken :=    'CREATE OR REPLACE PACKAGE BODY '
                        || pkgname_in;

         IF spool_out
         THEN
            ksbms_fw.pl (my_strtoken);
         END IF;

         writeln (fid, my_strtoken);
         my_sqlstring :=    my_sqlstring
                         || my_strtoken;
         my_strtoken := 'IS ';

         IF spool_out
         THEN
            ksbms_fw.pl (my_strtoken);
         END IF;

         writeln (fid, my_strtoken);
         my_sqlstring :=    my_sqlstring
                         || my_strtoken;

         FOR msg_rec IN exc_20000
         LOOP
            my_strtoken :=
                      '   FUNCTION '
                   || msg_rec.msgname
                   || ' RETURN PLS_INTEGER';

            IF spool_out
            THEN
               ksbms_fw.pl (my_strtoken);
            END IF;

            writeln (fid, my_strtoken);
            my_sqlstring :=    my_sqlstring
                            || my_strtoken;
            my_strtoken :=    '   IS BEGIN RETURN en_'
                           || msg_rec.msgname
                           || '; END '
                           || msg_rec.msgname
                           || ';';

            IF spool_out
            THEN
               ksbms_fw.pl (my_strtoken);
            END IF;

            writeln (fid, my_strtoken);
            my_sqlstring :=    my_sqlstring
                            || my_strtoken;
            my_strtoken := '   ';

            IF spool_out
            THEN
               ksbms_fw.pl (my_strtoken);
            END IF;

            writeln (fid, my_strtoken);
            my_sqlstring :=    my_sqlstring
                            || my_strtoken;

            IF trace_in
            THEN
               ksbms_fw.pl (
                     ' my_SQLString Length IS now '
                  || TO_CHAR (LENGTH (my_sqlstring))
               );
            END IF;
         END LOOP;

         my_strtoken :=    'END '
                        || pkgname_in
                        || ';';

         IF spool_out
         THEN
            ksbms_fw.pl (my_strtoken);
         END IF;

         writeln (fid, my_strtoken);
         my_sqlstring :=    my_sqlstring
                         || my_strtoken;
         my_strtoken := '/';

         IF spool_out
         THEN
            ksbms_fw.pl (my_strtoken);
         END IF;

         writeln (fid, my_strtoken);
         my_sqlstring :=    my_sqlstring
                         || my_strtoken;
      END IF;

      IF file_out
      THEN -- spool to a file
         IF ksbms_fileio.f_fclose2 (fid)
         THEN
            ksbms_err.RAISE ( gi_default_app, ksbms_exc.fileio_close_file);
         END IF;

         -- see if the file exists, then close if open.
         IF NOT ksbms_fileio.f_exists (ls_filename, FALSE)
         THEN
            ksbms_err.RAISE (gi_default_app, ksbms_exc.fileio_file_not_exist);
         END IF;
      END IF; --IF file_out

      IF trace_in
      THEN
         ksbms_fw.pl (
               ' my_SQLString Length, just before build,  IS now '
            || TO_CHAR (LENGTH (my_sqlstring))
         );
      END IF;

      IF trace_in
      THEN
         ksbms_fw.pl (my_sqlstring);
      END IF;
   /* Uncomment the next couple  lines if this package is being run off the Oracle server through
   a shell session - otherwise, these will attempt to execute the file created on the server
   even though connected on a local workstation as a terminal
   */
   -- ksbms_fw.pl (   '@'
   --       || ls_filename);
   -- ksbms_fw.pl ('/');


   EXCEPTION
      WHEN ksbms_exc.exc_fileio_open_file
      THEN
         BEGIN
            ls_errmsg :=    'Could not open file '
                         || ls_filename
                         || ' to create exceptions package '
                         || pkgname_in;

            IF debug_in
            THEN
               ksbms_fw.pl (ls_errmsg);
            END IF;
                  -- note, there is a recursion here.  If you cannot rebuild
                  -- ksbms_exc for some reason, this call will fail, and you
                  -- won't be able to recompile this procedure, which generates the script that
                  -- builds ksbms_exc.  So comment out the next line if necessary until
                  -- you can rebuild ksbms_exc.
         /*         ksbms_err.handle (
                     the_appcode_in,
                     ksbms_exc.fileio_open_file,
                     ls_errmsg
                  ); */
         END;
      WHEN ksbms_exc.exc_fileio_close_file
      THEN
         BEGIN
            ls_errmsg :=    'Could not close file '
                         || ls_filename
                         || ' used to create exceptions package '
                         || pkgname_in;

            IF debug_in
            THEN
               ksbms_fw.pl (ls_errmsg);
            END IF;

            -- note, there is a recursion here.  If you cannot rebuild
            -- bms_exc for some reason, this call will fail, and you
            -- won't be able to recompile this procedure, which generates the script that
            -- builds ksbms_exc.  So comment out the next line if necessary until
            -- you can rebuild ksbms_exc.
/*            ksbms_err.handle (the_appcode_in, ksbms_exc.fileio_close_file, ls_errmsg);
*/         END;
      WHEN ksbms_exc.exc_fileio_file_not_exist
      THEN
         BEGIN
            ls_errmsg :=    'Could not find file '
                         || ls_filename
                         || ' used to create exceptions package '
                         || pkgname_in;

            IF debug_in
            THEN
               ksbms_fw.pl (ls_errmsg);
            END IF;

               -- note, there is a sort of recursion here.  If you cannot rebuild
            -- bms_exc for some reason, this call will fail, and you
            -- won't be able to recompile this procedure, which generates the script that
            -- builds ksbms_exc.  So comment out the next line if necessary until
            -- you can rebuild ksbms_exc.
/*            ksbms_err.handle (ksbms_exc.fileio_file_not_exist (), ls_errmsg);
*/         END;
   END gen_exc_pkg;

   PROCEDURE init_msgowner

-- private procedure - called internally only
--Allen 6/13/2001 - use a call to ksbms_fw.get_object_owner to find (my) owner
-- so that any messages (I) return come from the rows where (I am) the owner
-- see function msgrow

   IS
   BEGIN
      -- initialize schema
      g_pkg_owner := ksbms_fw.get_object_owner ('KSBMS_MSGINFO');

      -- we don't want a null owner - how can an object have no owner?
      -- report an error.

      IF g_pkg_owner IS NULL
      THEN
          NULL;
  /*       ksbms_err.handle ( c_default_app,

            ksbms_exc.application_exception,
            'Unable to determine package owner!'
         );*/
      END IF;
   END init_msgowner;

   PROCEDURE init_default_app

-- private procedure - called internally only
-- Sets default app to 3 which means a generic utility in KSBMS, not necessarily
-- part of the synchronization (2) or Pontis data autocalculation routines (1)
-- Thus, any specialized module can store messages for itself by ID (appcode) so
-- they can all coexist in one message table.

   IS
   BEGIN
        gi_default_app := 3;
   END init_default_app;

  FUNCTION get_default_app
   RETURN PLS_INTEGER
   IS
   BEGIN
               RETURN  gi_default_app ;
   END;

  procedure set_default_app (pii_default_app pls_integer)
  -- Hoyt 01/04/2002 So we can SET the default application instead of hard-code it
  is
  begin
     gi_default_app := pii_default_app;
  end;

   PROCEDURE selftest (
      the_appcode_in   IN   PLS_INTEGER,
      the_msgcode_in   IN   PLS_INTEGER,
      the_msgname_in   IN   VARCHAR2,
      the_msgtype_in   IN   VARCHAR2,
      use_sqlerrm      IN   BOOLEAN := TRUE
   )
   IS
      ls_result     VARCHAR2 (255);
      ls_testname   VARCHAR2 (80);

      PROCEDURE printresult (
         pr_testname_in   IN   VARCHAR2,
         pr_msgname_in    IN   VARCHAR2,
         pr_msgtype_in    IN   VARCHAR2,
         pr_appcode_in    IN   PLS_INTEGER,
         pr_msgcode_in    IN   PLS_INTEGER,
         pr_result        IN   VARCHAR2 := '??'
      )
      IS
      BEGIN
         ksbms_fw.pl (   'Self Test = '
                      || pr_testname_in);
         ksbms_fw.pl (
               'App code =  '
            || TO_CHAR (pr_appcode_in)
            || ', Message code = '
            || TO_CHAR (pr_msgcode_in)
            || ', name in = '
            || pr_msgname_in
            || ', type in = '
            || pr_msgtype_in
            || ', message lookup result = '
            || pr_result
         );
         ksbms_fw.pl (' ');
         ksbms_fw.pl (' ');
      END printresult;
   BEGIN
      BEGIN
         -- first test
         -- Call the function msginfo.getmsgcode


         ls_testname :=
                  'Get message code number based on name and message type...';
         ls_result := TO_CHAR (
                         getmsgcode (
                            the_appcode_in,
                            NVL (
                               the_msgname_in,
                               getmsgname (
                                  the_appcode_in,
                                  the_msgcode_in,
                                  the_msgtype_in
                               )
                            ),
                            NVL (the_msgtype_in, 'EXCEPTION')
                         )
                      );
         printresult (
            ls_testname,
            the_msgname_in,
            NVL (the_msgtype_in, 'EXCEPTION'),
            the_appcode_in,
            the_msgcode_in,
            ls_result
         );
      END;

      BEGIN
         -- Call the function msginfo.name
         ls_testname := 'Get message name based on code number and type';
         ls_result := getmsgname (
                         the_appcode_in,
                         the_msgcode_in,
                         NVL (the_msgtype_in, 'EXCEPTION')
                      );
         printresult (
            ls_testname,
            NVL (
               the_msgname_in,
               getmsgname (the_appcode_in, the_msgcode_in, the_msgtype_in)
            ),
            NVL (the_msgtype_in, 'EXCEPTION'),
            the_appcode_in,
            the_msgcode_in,
            ls_result
         );
      END;

      BEGIN
         -- Call the function ksbms_msginfo.getmsgtext
         ls_testname :=
               'Get text for message based on code, type, and whether to use SQLERRM ';
         ls_result := getmsgtext (
                         the_appcode_in,
                         the_msgcode_in,
                         NVL (the_msgtype_in, 'EXCEPTION'),
                         use_sqlerrm
                      );
         printresult (
            ls_testname,
            NVL (
               the_msgname_in,
               getmsgname (the_appcode_in, the_msgcode_in, the_msgtype_in)
            ),
            NVL (the_msgtype_in, 'EXCEPTION'),
            the_appcode_in,
            the_msgcode_in,
            ls_result
         );
      END;
   END selftest;


   PROCEDURE documentation
   -- Hoyt 01/04/2002 Per e-mail from Allen -- note changes in this DOCUMENTATION procedure
   -- PLEASE put a comment or two here about what you did elsewhere
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
         'Hoyt 01/04/2002 - Added procedure set_default_app '
      );
   END documentation;


BEGIN

--Allen 6/13/2001
-- determine owner of KSBMS_MSGINFO package when first loaded....
-- allows retrieval of owner specific messages from table ksbms_msg_info
-- thus, if this package is owned by somebody else, e.g. reused, then
-- that owner can go to a common error table and find its messages.

   init_msgowner;
   init_default_app;

END ksbms_msginfo;
/