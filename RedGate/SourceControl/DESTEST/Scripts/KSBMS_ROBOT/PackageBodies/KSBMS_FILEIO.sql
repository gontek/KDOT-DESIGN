CREATE OR REPLACE PACKAGE BODY ksbms_robot."KSBMS_FILEIO"
IS
   /*
   Revision History:
   2001-12-03 - ARM - adapted for KANSAS Department of Transportation
   from old fileio package.  Renamed.
   */
   -- Private type declarations
   --type <TypeName> is <Datatype>;

   -- Private constant declarations
   --<ConstantName> constant <Datatype> := <Value>;

   -- Private variable declarations
   --<VariableName> <Datatype>;
   g_show_trace_messages   BOOLEAN         := FALSE; -- default to NOT SHOW TRACE MESSAGES (non-error)
   g_show_debug_messages   BOOLEAN         := TRUE; -- default to SHOW debug errors
   --g_emit_modulo           PLS_INTEGER       := 100; -- how often to print out records
   g_searchpath            VARCHAR2 (1024); -- OK for Oracle 8 and above
   g_dirsepchar            VARCHAR2 (1)    := '/'; -- slash for Unix - default OS, or backslash for NT
   g_pathdelim             VARCHAR2 (1)    := ':'; -- path separator - use ; for NT, : for Unix - default OS

-- Working directories for FileIO
-- these directory literals must also be defined in the instance' INIT.ORA file
-- oracle process must have full control over files in these directions, and probably should
-- own the directories as well.  In Linux, use chown oracle:orainstall <dirname>
-- fileio package never uses '.' or * as shorthands for current dir
--------------------------------------------------------------------------------------------
   g_systempdir            VARCHAR2 (255)  := '/tmp/ora';
   g_tempdir               VARCHAR2 (255)  := '/u03/tmp';
   g_workdir               VARCHAR2 (255)  := '/u02/816/tmp/oradata/kansas01';
   g_defaultdir            VARCHAR2 (255)  := '/u03/tmp';

   PROCEDURE io_debug_message (buffer IN VARCHAR2)
   IS
   BEGIN
      IF g_show_debug_messages
      THEN
         IF LOWER (SQLERRM) = LOWER ('User-Defined EXCEPTION')
         THEN
            ksbms_fw.pl (
                  'DBG: '
               || NVL (buffer, 'Unknown user/application exception raised')
            );
         ELSE
            ksbms_fw.pl (
                  'DBG: '
               || NVL (   SQLERRM
                       || ' - ', '') -- OK
               || NVL (buffer, 'Unknown SYSTEM exception raised')
            );
         END IF;
      END IF;
   END io_debug_message;

   PROCEDURE io_trace_message (buffer IN VARCHAR2)
   IS
   BEGIN
      IF g_show_trace_messages
      THEN
         ksbms_fw.pl (
               'TRC: '
            || NVL (buffer, 'Unknown processing step completed...')
         );
      END IF;
   END io_trace_message;

   /*
   PROCEDURE set_emit_modulo ( freq IN PLS_INTEGER := 100 )
   IS
   BEGIN
      -- set the 'how often to show data' modulo #
      -- every 100, every 10, etc.
      -- pass an integer number to reset emit frequency from default e.g. fileio.set_emit_modulo(10) to
      -- print a debug line every 10th record...
      -- check for valid # > 0 if not NULL
      IF freq IS NOT NULL
      THEN
         ksbms_fw.is_true ( freq > 0, 'Printout frequency for diagnostics <=0' );
      END IF;

      -- recover from null by setting to default of 100
      g_emit_modulo := NVL ( freq, 100 );
   END set_emit_modulo;
   */
   PROCEDURE set_debug_state (str IN VARCHAR2)
   IS
   BEGIN
      -- debug messages suppressed by default if no arg or anything other than Y
      g_show_debug_messages := UPPER (NVL (str, 'Y')) = 'Y';

      IF g_show_debug_messages
      THEN
         ksbms_fw.pl ('Debug turned ON');
      ELSE
         ksbms_fw.pl ('Debug turned OFF');
      END IF;
   END set_debug_state;

   PROCEDURE set_trace_state (str IN VARCHAR2)
   IS
   BEGIN
      -- debug messages suppressed by default if no arg or anything other than Y
      g_show_trace_messages := UPPER (NVL (str, 'N')) = 'Y';

      IF g_show_trace_messages
      THEN
         ksbms_fw.pl ('Trace messages turned ON');
      ELSE
         ksbms_fw.pl ('Trace messages turned OFF');
      END IF;
   END set_trace_state;

   PROCEDURE set_utl_file_dirs (
      str1   IN   VARCHAR2,
      str2   IN   VARCHAR2,
      str3   IN   VARCHAR2
   )
   IS
   BEGIN
      g_systempdir := NVL (str1, '/tmp/ora');
      g_tempdir := NVL (str2, '/u03/tmp');
      g_workdir := NVL (str3, '/u02/816/wrk/states01/wydot');
   END set_utl_file_dirs;

   PROCEDURE setdirsepchar (str IN VARCHAR2)
   IS
   BEGIN
      g_dirsepchar := NVL (str, '/'); -- assume / if nothing available
      io_trace_message (   'g_dirsepchar is now '
                        || g_dirsepchar);
   END setdirsepchar;

   FUNCTION getdirsepchar -- function has no arguments - OK
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_dirsepchar;
   END getdirsepchar;

   PROCEDURE setpathsepchar (str IN VARCHAR2)
   IS
   BEGIN
      g_pathdelim := NVL (str, ':'); -- assume UNIX default, set to ; for NT server
      io_trace_message (   'g_pathdelim is now '
                        || g_pathdelim);
   END setpathsepchar;

   PROCEDURE setdefaultdir (str IN VARCHAR2)
   IS
   BEGIN
      -- see if desired default exists in the path of valid UTL_FILE directories
      ksbms_fw.istrue (
         INSTR (g_searchpath, str) > 0,
         'Invalid default directory setting - not  in search path!'
      );
      g_defaultdir := str;
      io_trace_message (   'g_defaultdir is now '
                        || g_defaultdir);
   END setdefaultdir;

   FUNCTION getdefaultdir -- function has no arguments - OK
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_defaultdir;
   END getdefaultdir;

   PROCEDURE setpath (str IN VARCHAR2)
   IS
   BEGIN
      /* append these
      g_systempdir           := nvl( str1, '/tmp/ora');
      g_tempdir              := nvl( str2, '/u03/tmp');
      g_workdir              := nvl( str3, '/u02/816/wrk/states01/wydot');
      */

-- if a path is passed, use it otherwise just use the standard directories in the globals.
      IF str IS NOT NULL
      THEN
         g_searchpath :=    str
                         || g_pathdelim
                         || g_systempdir
                         || g_pathdelim
                         || g_tempdir
                         || g_pathdelim
                         || g_workdir;
      ELSE
         g_searchpath :=    g_systempdir
                         || g_pathdelim
                         || g_tempdir
                         || g_pathdelim
                         || g_workdir;
      END IF;

      io_trace_message (   'path is now '
                        || g_searchpath);
   END setpath;

   FUNCTION getpath -- function has no arguments - OK
      --usage: ls_path VARCHAR2 (1024) := fileio.getpath;
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_searchpath;
   END getpath;


 -- Function and procedure implementations
--  function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
 --   <LocalVariable> <Datatype>;
--  begin
--    <Statement>;
--    return(<Result>);
--  end;

   FUNCTION f_erase (the_file_in IN VARCHAR2)
      -- UTL_FILE cannot erase files.  This function just sets the length to 0 or whatever an empty string
      -- takes up.
      -- empties the file by opening it in Write mode and emitting nothing
      RETURN BOOLEAN
   IS
      lb_failed              BOOLEAN        := TRUE;
      the_fid                fid;
      ls_errmsg              VARCHAR2 (255);
      function_call_failed   EXCEPTION;
   BEGIN
      IF f_exists (the_file_in, TRUE)
      THEN -- if it exists, then close it
         the_fid := f_fopen (the_file_in, rw); -- it exists, reopen in rw mode

         IF the_fid.id IS NULL
         THEN
            ls_errmsg := 'Call to f_fopen returned NULL';
            RAISE function_call_failed;
         END IF;

         -- write NOTHING to the file - this is the only
         -- erasure mechanism available under 8i
         IF f_put (the_fid, NULL)
         THEN
            ls_errmsg := 'Call to f_put failed';
            RAISE function_call_failed;
         END IF; -- put nothing in the file (0 length)

         IF f_fclose1 (the_fid, TRUE)
         THEN
            ls_errmsg := 'Call to f_fclose1 failed';
            RAISE function_call_failed;
         END IF;
      END IF;

      lb_failed := FALSE;
      RETURN lb_failed;
   EXCEPTION
      WHEN function_call_failed
      THEN
         BEGIN
            io_debug_message (
                  NVL (   SQLERRM
                       || ' - ', ' ')
               || NVL (ls_errmsg, 'Function call failed exception raised')
            );

            IF NOT f_fcloseall
            THEN
               io_debug_message (
                     NVL (   SQLERRM
                          || ' - ', ' ')
                  || NVL (ls_errmsg, 'Function call failed exception raised')
               );
               RAISE;
            END IF;
         END;

         RETURN lb_failed;
      WHEN OTHERS
      THEN
         BEGIN
            io_debug_message (
                  NVL (   SQLERRM
                       || ' - ', ' ')
               || NVL (ls_errmsg, 'Unknown exception raised')
            );

            IF the_fid.id IS NOT NULL
            THEN
               IF f_fclose1 (the_fid, NULL)
               THEN
                  RAISE;
                  RETURN lb_failed;
               END IF;
            END IF;
         END;

         RETURN lb_failed;
   END f_erase;


-- Check if file exists - pass simple name or fully-qualified - if open ANYWHERE, this will return TRUE
-- Wrapper for UTL_FILE.IS_OPEN
-- page 415 of Fuerstein
   FUNCTION f_is_open (the_fid IN fid)
      RETURN BOOLEAN
   IS
      ls_errmsg   VARCHAR2 (255);
      lb_isopen   BOOLEAN        := FALSE; -- name is 'is_open', so ion calling routine, NOT is_open is failure
   BEGIN
      ls_errmsg := 'Problem in f_is_open with UTL_FILE.IS_OPEN';
      lb_isopen := UTL_FILE.is_open (the_fid);
      RETURN lb_isopen;
   EXCEPTION
      -- UTL_FILE.IS_OPEN has no associated Oracle exceptions, apparently
      -- as a 'safeguard' we'll put in INTERNAL ERROR.
      WHEN UTL_FILE.internal_error
      THEN
         ksbms_fw.pl ('internal_error');
         io_debug_message ('internal_error');
         RAISE;
         RETURN lb_isopen;
      WHEN OTHERS -- OK single exception handler
      THEN
         BEGIN
            ls_errmsg := 'Call failed to UTL_FILE.IS_OPEN in f_is_open';
            io_debug_message (ls_errmsg);
            -- propagate to calling routine - an exception here is bad!!!
            RAISE;
         END;

         RETURN lb_isopen;
   END f_is_open;

   FUNCTION f_exists (
      the_file_in        IN   VARCHAR2,
      close_if_open_in   IN   BOOLEAN := FALSE
   ) -- PASS TRUE TO CLOSE IF OPEN
      RETURN BOOLEAN
   IS
      the_fid     fid; -- UTL_FILE.FILE_TYPE;
      lb_exists   BOOLEAN        := FALSE; -- assume it doesn't exist
      ls_errmsg   VARCHAR2 (255);

      -- local procedure - pass close directive...
      PROCEDURE closeif (open_fid IN OUT fid, close_in IN BOOLEAN)
      -- close the file if open
      IS
         function_call_failed   EXCEPTION;
      BEGIN
         IF      close_in -- passed TRUE to close if OPEN
             AND UTL_FILE.is_open (open_fid) -- and really is OPEN
         THEN
         -- was NOT, should return TRUE on fail
            IF  f_fclose1 (open_fid, TRUE)
            THEN
               ls_errmsg := 'Call to f_fclose1 failed';
               -- LOCAL USER EXCEPTION
               RAISE function_call_failed;
            END IF;
         END IF;
      EXCEPTION -- to UTL_FILE.is_open
         -- UTL_FILE.IS_OPEN has no associated Oracle exceptions, apparently
         -- as a 'safeguard' we'll put in INTERNAL ERROR.
         WHEN UTL_FILE.internal_error
         THEN
            BEGIN
               ksbms_fw.pl ('internal_error');
               io_debug_message ('internal_error');
               RAISE;
            END;
         WHEN OTHERS
         THEN
            BEGIN
               io_debug_message ('Unknown exception raised');
               RAISE;
            END;
      END closeif;
   BEGIN -- function body
      /* Open the file in READ ONLY MODE. */
      the_fid := f_fopen (the_file_in, ro);
      lb_exists := the_fid.id IS NOT NULL;

      IF lb_exists
      THEN
         /* Return the result of a check with IS_OPEN. If it exists and is open then */
         IF UTL_FILE.is_open (the_fid)
         THEN
            closeif (the_fid, close_if_open_in);
         END IF;
      END IF;

      RETURN lb_exists;
   EXCEPTION
         -- UTL_FILE.IS_OPEN has no associated Oracle exceptions, apparently
      -- as a 'safeguard' we'll put in INTERNAL ERROR.
      WHEN UTL_FILE.internal_error
      THEN
         BEGIN
            ksbms_fw.pl ('internal_error');
            io_debug_message ('internal_error');
            RAISE;
         END;

         RETURN lb_exists;
      WHEN OTHERS
      THEN
         BEGIN
            closeif (the_fid, close_if_open_in);
            io_debug_message ('Unknown exception raised');
         END;

         RETURN lb_exists;
   END f_exists;

   FUNCTION f_fopen (
      the_filename   IN   VARCHAR2, -- the file
      the_filemode   IN   VARCHAR2 -- read, write, append
   )

-- wrapper for UTL_FILE.FOPEN ( dir, file, accces);
-- either we pass a simple file name, in which case the searchpath is used to find and open
-- or we pass a fully qualified file name with directory, in which case it is parsed to open
-- by extracting the dir and filename.

      RETURN fid
   IS
      -- dir/path handling - see if there is a directory separator character in the incoming file name
      v_loc       PLS_INTEGER
                            := NVL (INSTR (the_filename, g_dirsepchar, -1), 0); -- look for /, starting at the right
      v_dir       VARCHAR2 (500);
      the_fid     fid; -- returned file handle
      ls_errmsg   VARCHAR2 (255);
   BEGIN
      -- check parameters
      -- check filename
      ls_errmsg := 'Null file name passed to f_fopen';
      ksbms_fw.istrue (the_filename IS NOT NULL, ls_errmsg);
      -- check filemode
      ls_errmsg := 'Null file access mode passed to f_fopen';
      ksbms_fw.istrue (the_filemode IS NOT NULL, ls_errmsg);
      -- check value for file access mode - must be in the constants ro, rw, append
      ls_errmsg :=
           'Invalid file access mode passed to f_fopen -- must be in R, W, A';
      -- use INSTR - if all return 0, none of the valid filemodes were found
      ksbms_fw.istrue (
         NOT (    INSTR (UPPER (the_filemode), ro) = 0
              AND INSTR (UPPER (the_filemode), rw) = 0
              AND INSTR (UPPER (the_filemode), append) = 0
             ),
         ls_errmsg
      );

      -- ok, continue


      IF v_loc > 0
      THEN -- filename contains directory, so parse and open
         BEGIN
            DECLARE
               v_file   VARCHAR2 (500);
            BEGIN
               v_dir := SUBSTR (the_filename, 1,   v_loc
                                                 - 1);
               v_file := SUBSTR (the_filename,   v_loc
                                               + 1);
               io_trace_message (
                     'Attempting to open file '
                  || v_dir
                  || g_dirsepchar
                  || v_file
                  || ' in mode '
                  || the_filemode
               );
               ls_errmsg :=
                     'Open file failed in simple parse of directory and filename';
               the_fid := UTL_FILE.fopen (v_dir, v_file, the_filemode);
               io_trace_message (
                     'Open file succeeded '
                  || v_dir
                  || g_dirsepchar
                  || v_file
               );
            EXCEPTION

-- standard exceptions for UTL_FILE.FOPEN
               WHEN UTL_FILE.invalid_path
               THEN
                  ksbms_fw.pl ('invalid_path');
                  RAISE;
                  RETURN NULL;
               WHEN UTL_FILE.invalid_mode
               THEN
                  ksbms_fw.pl ('invalid_mode');
                  RAISE;
                  RETURN NULL;
               WHEN UTL_FILE.invalid_maxlinesize -- per Fueursten OBIP, p. 395
               THEN
                  ksbms_fw.pl ('invalid_maxlinesize');
                  RAISE;
                  RETURN NULL;
               WHEN UTL_FILE.invalid_operation
               THEN
                  ksbms_fw.pl ('invalid_operation');
                  RAISE;
                  RETURN NULL;
               WHEN OTHERS
               THEN
                  io_debug_message (ls_errmsg);
                  RAISE; -- failed...
                  RETURN NULL;
            END;
         END; -- END block for simple file name test (file with directory)
      ELSE -- search the paths
         -- loop through paths looking for the file
         -- section may raise an exception if search fails, and may
         -- raise an exception if it fails to find a file to open rw/append and cannot create it
         -- in the default directory g_defaultdir...

         DECLARE
            v_lastsep            PLS_INTEGER := 1;
            v_sep                PLS_INTEGER
                                := NVL (INSTR (g_searchpath, g_pathdelim), 0);
            create_file_failed   EXCEPTION; -- IF we search and don't find it, try to create it, raise this exception if unable to open (RW and APP only)
            search_failed        EXCEPTION; -- cannot find  a file using the search  in RO
         BEGIN
            LOOP
               BEGIN
                  IF v_sep = 0
                  THEN
                     -- SUBSTR of PATH FROM 1
                     v_dir := SUBSTR (g_searchpath, v_lastsep);
                  ELSE
                     -- SUBSTR position of ; - start position
                     v_dir :=
                        SUBSTR (g_searchpath, v_lastsep,   v_sep
                                                         - v_lastsep);
                  END IF;

                  -- attempt open...
                  the_fid :=
                            UTL_FILE.fopen (v_dir, the_filename, the_filemode);
                  EXIT; -- loop exit
               EXCEPTION
                  -- insert UTL_FILE.FOPEN EXCEPTIONS HERE
                  WHEN UTL_FILE.internal_error
                  THEN
                     ksbms_fw.pl ('internal_error');
                     RAISE;
                     RETURN NULL;
                  WHEN OTHERS -- UTL_FILE.FOPEN couldn't do it in the trial directory, raised an exception
                  THEN
                     IF v_sep = 0
                     THEN
                        -- special case - file doesn't exist in any directory, so create in default if not
                        -- explicitly located with directory in filename
                        -- this should NOT occur for a RO file - these are illogical to open for read if non-existent.
                        IF the_filemode <> ro
                        THEN -- attempt to create the file in the default dir
                           the_fid := f_fopen (
                                            g_defaultdir
                                         || g_dirsepchar
                                         || the_filename,
                                         the_filemode
                                      );

                           IF the_fid.id IS NULL
                           THEN
                              RAISE create_file_failed;
                           END IF;

                           io_trace_message (
                                 'Create file in default directory '
                              || g_systempdir
                              || the_filename
                           );
                           RETURN the_fid;
                        ELSE
                           ls_errmsg := 'Search for file failed in f_fopen!';
                           RAISE search_failed; -- not found, but...
                        -- no more path chunks to test, so we can't try any more directories
                        END IF;
                     ELSE
                        v_lastsep :=   v_sep
                                     + 1; -- try next path chunk in g_searchpath
                        v_sep :=
                               INSTR (g_searchpath, g_pathdelim,   v_sep
                                                                 + 1);
                     END IF; -- v_sep := 0;
               END; -- loop body
            END LOOP; -- end of loop
         EXCEPTION -- related to search path processing
            WHEN search_failed
            THEN
               BEGIN
                  io_debug_message (
                        NVL (   SQLERRM
                             || ' - ', ' ')
                     || NVL (
                           ls_errmsg,
                              'Unable to find the file'
                           || the_filename
                           || ' in any directory in the path '
                           || g_searchpath
                        )
                  );
                  RETURN NULL; -- null FID
               END;
            WHEN create_file_failed
            THEN
               BEGIN
                  io_debug_message (
                        NVL (   SQLERRM
                             || ' - ', ' ')
                     || NVL (
                           ls_errmsg,
                              'Unable to create the file '
                           || the_filename
                           || ' in RW mode in the default directory '
                           || g_systempdir
                        )
                  );
                  RETURN NULL; -- null FID
               END;
            WHEN OTHERS
            THEN
               ls_errmsg :=
                        'Search for file in f_fopen raised UNKNOWN exception';
               io_debug_message (ls_errmsg);
               RAISE;
         END; -- block with path search for file;
      END IF; -- test for either fully-qualified filename or simple filename with directory search

      RETURN the_fid; -- single point of return for value
   EXCEPTION -- global to function
      -- insert UTL_FILE.FOPEN EXCEPTIONS HERE
      WHEN UTL_FILE.invalid_path
      THEN
         ksbms_fw.pl ('invalid_path');
         RAISE;
         RETURN NULL;
      WHEN UTL_FILE.invalid_mode
      THEN
         ksbms_fw.pl ('invalid_mode');
         RAISE;
         RETURN NULL;
      WHEN UTL_FILE.invalid_filehandle
      THEN
         ksbms_fw.pl ('invalid_filehandle');
         RAISE;
         RETURN NULL;
      WHEN UTL_FILE.invalid_operation
      THEN
         ksbms_fw.pl ('invalid_operation');
         RAISE;
         RETURN NULL;
      WHEN UTL_FILE.read_error
      THEN
         ksbms_fw.pl ('read_error');
         RAISE;
         RETURN NULL;
      WHEN UTL_FILE.write_error
      THEN
         ksbms_fw.pl ('write_error');
         RAISE;
         RETURN NULL;
      WHEN UTL_FILE.internal_error
      THEN
         ksbms_fw.pl ('internal_error');
         RAISE;
         RETURN NULL;
      WHEN OTHERS
      THEN
         BEGIN
            io_debug_message (
                  NVL (   SQLERRM
                       || ' - ', ' ')
               || NVL (
                     ls_errmsg,
                     'Unknown exception raised in f_fopen (object level)'
                  )
            );
         END;

         RETURN NULL; -- invalid filehandle
   END f_fopen;

   FUNCTION f_fclose1 (the_fid IN OUT fid, flush_in IN BOOLEAN := TRUE) -- out parameters OK
      -- wrapper for UTL_FILE.FCLOSE( fID); -- which has in out parameter.
      RETURN BOOLEAN
   IS
      -- assume failed unless proven otherwise
      lb_failed   BOOLEAN := TRUE;
   BEGIN
   -- must have non-NULL fid.id, exception if not
      IF f_is_open( the_fid ) then
      UTL_FILE.fclose (the_fid);
      END IF;
      lb_failed := FALSE;
      io_trace_message ('File closed successfully!');
      RETURN lb_failed;
   EXCEPTION
      -- insert UTL_FILE.FCLOSE EXCEPTIONS HERE

      WHEN UTL_FILE.invalid_filehandle
      THEN
         BEGIN
            ksbms_fw.pl ('invalid_filehandle');
            RAISE;
         END;

         RETURN lb_failed;
      WHEN UTL_FILE.write_error -- raised by error or if buffer contents not yet written...
      THEN
         BEGIN
            -- see if WRITE FLUSH was requested ( default is TRUE )
            IF flush_in
            THEN -- attempt to flush buffer to disk
               lb_failed := f_fflush (the_fid);

               IF lb_failed
               THEN
                  ksbms_fw.pl ('write_error trying to flush buffer');
                  RAISE;
               ELSE
                  BEGIN
                     -- try close again, but more drastically
                     UTL_FILE.fclose_all;
                     RAISE; -- propagate failure since we had to close all the active files
                  EXCEPTION
                     WHEN UTL_FILE.invalid_filehandle
                     THEN
                        BEGIN
                           ksbms_fw.pl ('invalid_filehandle');
                           RAISE;
                        END;

                        RETURN lb_failed;
                     WHEN UTL_FILE.write_error -- raised by error or if buffer contents not yet written...
                     THEN
                        BEGIN
                           ksbms_fw.pl (
                              'write_error trying to close buffer after flush'
                           );
                           RAISE;
                        END;

                        RETURN lb_failed;
                     WHEN OTHERS
                     THEN
                        BEGIN
                           ksbms_fw.pl (
                              'write_error trying to close buffer after flush'
                           );
                           RAISE;
                        END;
                  END;
               END IF;
            ELSE -- no flush requested, raise exception and quit
               ksbms_fw.pl ('write_error');
               RAISE;
            END IF; -- if flush_in
         END;

         RETURN lb_failed;
      WHEN UTL_FILE.internal_error
      THEN
         BEGIN
            ksbms_fw.pl ('internal_error');
            RAISE;
         END;

         RETURN lb_failed;
      WHEN OTHERS
      THEN
         BEGIN
            io_debug_message ('File NOT closed with f_fclose1()!');

            IF f_fcloseall () -- fails..
            THEN
               RAISE;
            END IF;
         END;

         RETURN lb_failed;
   END f_fclose1;

   FUNCTION f_fclose2 (the_fid IN OUT fid) -- out parameters OK
      -- simple close always flushes the buffer...
      -- wrapper for UTL_FILE.FCLOSE( fID); -- which has in out parameter.
      RETURN BOOLEAN
   IS
      -- assume failed unless proven otherwise
      lb_failed   BOOLEAN := TRUE;
   BEGIN
      lb_failed := f_fclose1 (the_fid, TRUE);
      RETURN lb_failed;
   END f_fclose2;


-- generate unique filenames for batch processing purposes - use a mask approach
   FUNCTION f_sysfile (the_dir IN VARCHAR2, the_datemask IN VARCHAR2)
      RETURN VARCHAR2
   IS
      the_sysfile        VARCHAR2 (255);
      the_fileseq        PLS_INTEGER;
      invalid_sequence   EXCEPTION;
      ls_errmsg          VARCHAR2 (255);
   BEGIN
      the_sysfile := NULL; -- by default

      /* file looks like dir + UID + SYSDATE with only nums + zero-led sequence number +'.fio' to indicate generated by fileio */



      BEGIN
         SELECT uniquefile_sequence.NEXTVAL
           INTO the_fileseq
           FROM DUAL;

         IF the_fileseq IS NULL
         THEN -- something NULL came back even though select did not raise exception
            ls_errmsg :=
                  'Invalid sequence encountered - possibly missing sequence UNIQUEFILE_SEQNUM';
            RAISE invalid_sequence;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN -- sequence SELECT failed
            BEGIN
               -- this should fail - we need to use the sequence
               ls_errmsg :=
                     'NO DATA FOUND in SELECT uniquefile_sequence.NEXTVAL INTO the_fileseq FROM DUAL ';
               io_debug_message (
                     NVL (   SQLERRM
                          || ' - ', ' ')
                  || NVL (ls_errmsg, 'Unknown exception raised')
               );
               RAISE;
            --the_fileseq := NULL;
            END;
      END;

      -- concatenate dir + user + date+ sequence+fio for sysfile name
      -- get rid of blanks with replace

      the_sysfile := REPLACE (
                           NVL (the_dir, g_systempdir)
                        || g_dirsepchar
                        || UID
                        || TO_CHAR (
                              SYSDATE,
                              NVL (the_datemask, 'YYYYMMDDHHMISS')
                           )
                        || TO_CHAR (
                              NVL (the_fileseq, 99999999999),
                              '09999999999'
                           )
                        || '.fio',
                        ' ',
                        '' -- OK
                     ); -- created by fileio...
      RETURN the_sysfile;
   EXCEPTION
      WHEN invalid_sequence
      THEN
         BEGIN
            io_debug_message (
                  NVL (   SQLERRM
                       || ' - ', ' ')
               || NVL (ls_errmsg, 'Unknown error')
            );
         END;

         RETURN NULL;
      WHEN OTHERS
      THEN
         BEGIN
            io_debug_message (
                  NVL (   SQLERRM
                       || ' - ', ' ')
               || NVL (ls_errmsg, 'Unknown error')
            );
         END;

         RETURN NULL;
   END f_sysfile;

   FUNCTION f_put (the_fid IN fid, the_buffer IN VARCHAR2)
      -- wrapper for UTL_FIlE.PUT( file, buffer);
      RETURN BOOLEAN
   IS
      -- assume failed unless proven otherwise
      lb_failed   BOOLEAN := TRUE;
   BEGIN
      UTL_FILE.put (the_fid, the_buffer);
      io_trace_message ('UTL_FILE.PUT call succeeded!');
      lb_failed := FALSE;
      RETURN lb_failed;
   EXCEPTION
      -- insert UTL_FILE.PUT EXCEPTIONS HERE

      WHEN UTL_FILE.invalid_path
      THEN
         ksbms_fw.pl ('invalid_path');
         RAISE;
      WHEN UTL_FILE.invalid_mode
      THEN
         ksbms_fw.pl ('invalid_mode');
         RAISE;
      WHEN UTL_FILE.invalid_filehandle
      THEN
         ksbms_fw.pl ('invalid_filehandle');
         RAISE;
      WHEN UTL_FILE.invalid_operation
      THEN
         ksbms_fw.pl ('invalid_operation');
         RAISE;
      WHEN UTL_FILE.read_error
      THEN
         ksbms_fw.pl ('read_error');
         RAISE;
      WHEN UTL_FILE.write_error
      THEN
         ksbms_fw.pl ('write_error');
         RAISE;
      WHEN UTL_FILE.internal_error
      THEN
         ksbms_fw.pl ('internal_error');
         RAISE;
      WHEN OTHERS
      THEN
         BEGIN
            io_debug_message (
                  NVL (   SQLERRM
                       || ' - ', ' ')
               || 'UTL_FILE.PUT call failed!'
            );
         END;

         RETURN lb_failed;
   END f_put;

   FUNCTION f_put_line (the_fid IN fid, the_buffer IN VARCHAR2)

-- wrapper for   UTL_FILE.PUT_LINE( the_fID, the_buffer);
      RETURN BOOLEAN
   IS
      -- assume failed unless proven otherwise
      lb_failed   BOOLEAN := TRUE;
   BEGIN
      UTL_FILE.put_line (the_fid, the_buffer);
      io_trace_message ('UTL_FILE.PUT_LINE call succeeded!');
      -- tell the calling routine we SUCCEEDED because Return FALSE means success
      lb_failed := FALSE;
      RETURN lb_failed;
   EXCEPTION
      -- insert UTL_FILE.PUT_LINE EXCEPTIONS HERE
      WHEN UTL_FILE.invalid_filehandle
      THEN
         ksbms_fw.pl ('invalid_filehandle');
         RAISE;
      WHEN UTL_FILE.invalid_operation
      THEN
         ksbms_fw.pl ('invalid_operation');
         RAISE;
      WHEN UTL_FILE.write_error
      THEN
         ksbms_fw.pl ('write_error');
         RAISE;
      WHEN UTL_FILE.internal_error
      THEN
         ksbms_fw.pl ('internal_error');
         RAISE;
      WHEN OTHERS
      THEN
         BEGIN
            io_debug_message (
                  NVL (   SQLERRM
                       || ' - ', ' ')
               || 'UTL_FILE.PUT_LINE call failed!'
            );
         END;

         RETURN lb_failed;
   END f_put_line;

   FUNCTION f_putf (
      the_fid    IN   fid,
      the_fmt    IN   VARCHAR2,
      the_str1   IN   VARCHAR2,
      the_str2   IN   VARCHAR2,
      the_str3   IN   VARCHAR2,
      the_str4   IN   VARCHAR2,
      the_str5   IN   VARCHAR2
   )
      -- Wrapper for UTL_FILE.PUTF( file, format, 1:5 strings);
      RETURN BOOLEAN
   IS
      -- assume failed unless proven otherwise
      lb_failed   BOOLEAN := TRUE;
   BEGIN
      --  see pp. 400-401 of Fuerstein et al Built-In Packages
      UTL_FILE.putf (
         the_fid,
         the_fmt,
         the_str1,
         the_str2,
         the_str3,
         the_str4,
         the_str5
      );
      io_trace_message ('UTL_FILE.PUTF call succeeded!');
      -- tell the calling routine we SUCCEEDED because Return FALSE means success
      lb_failed := FALSE;
      RETURN lb_failed;
   EXCEPTION
      -- insert UTL_FILE.PUTF EXCEPTIONS HERE
      WHEN UTL_FILE.invalid_filehandle
      THEN
         ksbms_fw.pl ('invalid_filehandle');
         RAISE;
      WHEN UTL_FILE.invalid_operation
      THEN
         ksbms_fw.pl ('invalid_operation');
         RAISE;
      WHEN UTL_FILE.write_error
      THEN
         ksbms_fw.pl ('write_error');
         RAISE;
      WHEN UTL_FILE.internal_error
      THEN
         ksbms_fw.pl ('internal_error');
         RAISE;
      WHEN OTHERS
      THEN
         BEGIN
            io_debug_message (
                  NVL (   SQLERRM
                       || ' - ', ' ')
               || 'UTL_FILE.PUTF call failed!'
            );
         END;

         RETURN lb_failed;
   END f_putf;

   FUNCTION f_new_line (the_fid IN fid, the_count IN PLS_INTEGER)
      -- Wrapper for UTL_FILE.NEW_LINE;
      RETURN BOOLEAN
   IS
      -- assume failed unless proven otherwise
      lb_failed   BOOLEAN := TRUE;
   BEGIN
      UTL_FILE.new_line (the_fid, the_count);
      io_trace_message ('UTL_FILE.NEW_LINE call succeeded!');
      -- tell the calling routine we SUCCEEDED because Return FALSE means success
      lb_failed := FALSE;
      RETURN lb_failed;
   EXCEPTION
      -- insert UTL_FILE.NEW_LINE EXCEPTIONS HERE

      WHEN UTL_FILE.invalid_filehandle
      THEN
         ksbms_fw.pl ('invalid_filehandle');
         RAISE;
      WHEN UTL_FILE.invalid_operation
      THEN
         ksbms_fw.pl ('invalid_operation');
         RAISE;
      WHEN UTL_FILE.write_error
      THEN
         ksbms_fw.pl ('write_error');
         RAISE;
      WHEN UTL_FILE.internal_error
      THEN
         ksbms_fw.pl ('internal_error');
         RAISE;
      WHEN OTHERS
      THEN
         BEGIN
            io_debug_message ('UTL_FILE.NEW_LINE call failed!');
         END;

         RETURN lb_failed;
   END f_new_line;

   FUNCTION f_fflush (the_fid IN fid)
      -- Wrapper for UTL_FILE.FFLUSH( the_fID);
      RETURN BOOLEAN
   IS
      -- assume failed unless proven otherwise
      lb_failed   BOOLEAN := TRUE;
   BEGIN
      UTL_FILE.fflush (the_fid);
      io_trace_message ('File flushed successfully with FFLUSH!');
      -- tell the calling routine we SUCCEEDED because Return FALSE means success
      lb_failed := FALSE;
      RETURN lb_failed;
   EXCEPTION
      -- insert UTL_FILE.FFLUSH EXCEPTIONS HERE
      WHEN UTL_FILE.invalid_filehandle
      THEN
         ksbms_fw.pl ('invalid_filehandle');
         RAISE;
      WHEN UTL_FILE.invalid_operation
      THEN
         ksbms_fw.pl ('invalid_operation');
         RAISE;
      WHEN UTL_FILE.write_error
      THEN
         ksbms_fw.pl ('write_error');
         RAISE;
      WHEN UTL_FILE.internal_error
      THEN
         ksbms_fw.pl ('internal_error');
         RAISE;
      WHEN OTHERS
      THEN
         BEGIN
            io_debug_message ('File NOT flushed successfully with FFLUSH!');
         END;

         RETURN lb_failed;
   END f_fflush;

   -- Public function and procedure declarations
   -- function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;

   FUNCTION f_fcloseall -- function has no arguments - OK
      -- wrapper FOR PROCEDURE utl_file.CLOSEALL;
      RETURN BOOLEAN
   IS
      -- assume failed unless proven otherwise
      lb_failed   BOOLEAN := TRUE;
   BEGIN
      UTL_FILE.fclose_all;
      io_trace_message ('ALL Files closed successfully with FCLOSE_ALL!');
      -- tell the calling routine we SUCCEEDED because Return FALSE means success
      lb_failed := FALSE;
      RETURN lb_failed;
   EXCEPTION
      -- insert UTL_FILE.FCLOSE_ALL EXCEPTIONS HERE

      WHEN UTL_FILE.write_error
      THEN
         ksbms_fw.pl ('write_error');
         RAISE;
      WHEN UTL_FILE.internal_error
      THEN
         ksbms_fw.pl ('internal_error');
         RAISE;
      WHEN OTHERS
      THEN
         BEGIN
            io_debug_message ('ALL Files NOT closed with FCLOSE_ALL!');
         END;

         RETURN lb_failed;
   END f_fcloseall;

   PROCEDURE p_get_line (
      -- get a line from the file uses UTL_FILE.GET_LINE;

      the_fid        IN       fid,
      -- get a line from the file uses UTL_FILE.GET_LINE;
      the_line_out   OUT      VARCHAR2,
      eof_out        OUT      BOOLEAN
   )

-- usage


-- end_of_file := FALSE;
-- while not end_of_file
--         p_Get_line( the_fID, the_line_out, end_of_file );
--         lines_read_ctr := lines_read_ctr +1;
-- loop

   IS
   -- adapted from Oracle BIP, Feurstein et al page 413
   BEGIN
      UTL_FILE.get_line (the_fid, the_line_out);
      eof_out := FALSE;
   EXCEPTION
      -- insert UTL_FILE.GET_LINE EXCEPTIONS HERE

      WHEN UTL_FILE.invalid_filehandle
      THEN
         ksbms_fw.pl ('invalid_filehandle');
         RAISE;
      WHEN UTL_FILE.invalid_operation
      THEN
         ksbms_fw.pl ('invalid_operation');
         RAISE;
      WHEN UTL_FILE.read_error
      THEN
         ksbms_fw.pl ('read_error');
         RAISE;
      WHEN UTL_FILE.internal_error
      THEN
         ksbms_fw.pl ('internal_error');
         RAISE;
      WHEN VALUE_ERROR
      THEN
         ksbms_fw.pl (
            'value error encountered in p_getline ( calling UTL_FILE.GET_LINE)'
         );
         RAISE;
      WHEN NO_DATA_FOUND
      THEN -- end of file...
         the_line_out := NULL;
         eof_out := TRUE;
   END p_get_line;

   PROCEDURE selftest (
      the_default_filename   IN   VARCHAR2 := 'dummy.txt',
      the_default_dir        IN   VARCHAR2 --:= g_defaultdir
   )
   -- run me to see the functions and procedures exercised
   -- SQL> execute fileio.selftest;
   -- meaningful test blocks are separated with  =======
   IS
      -- Non-scalar parameters require additional processing
      result               fid;
      the_filename         VARCHAR2 (255);
      the_filemode         VARCHAR2 (10);
      ls_errmsg            VARCHAR2 (255)
                 := 'selftest failed - Unhandled or SYSTEM exception occurred';
      selftest_exception   EXCEPTION;
   BEGIN
      set_debug_state ('Y');
      set_trace_state ('Y');
      setdirsepchar ('/'); -- unix
      setpathsepchar (';'); -- whatever, either ; or :
      setpath (NULL);
      setdefaultdir (g_systempdir);
      io_trace_message (' ');
      io_trace_message (' ');
      io_trace_message (' ');
      io_trace_message (' ');
      io_trace_message ('Testing Open File RO with dummy, no directory');
      io_trace_message ('*************************************');
      io_trace_message ('*************************************');
      io_trace_message (' ');

         -- test file open
/* ========================================= */
      BEGIN
         -- Call the function fopen with default filename

         the_filemode := ro;
         result := f_fopen (the_default_filename, the_filemode);
         ls_errmsg := 'Attempting to see if RESULT is NULL';
         io_trace_message ('Checking if a valid result came back');

         IF NOT f_is_open (result)
         THEN
            ls_errmsg :=
                    'Open File Failed for filename = '
                 || the_default_filename;
            RAISE selftest_exception;
         END IF;

         io_trace_message ('Open File Succeeded');

         IF f_fclose2 (result)
         THEN
            ls_errmsg := 'Close File Failed';
            RAISE selftest_exception;
         END IF;

         io_trace_message ('Close File Succeeded');
      EXCEPTION
         WHEN selftest_exception
         THEN
            BEGIN
               io_debug_message (ls_errmsg);
            END;
         WHEN OTHERS
         THEN
            io_debug_message (ls_errmsg);
      END;


/* ========================================= */
      io_trace_message (' ');
      io_trace_message (' ');
      -- test file open - null filename
      io_trace_message (
         'Testing Open File RO with NULL filename passed, no directory'
      );
      io_trace_message ('*************************************');
      io_trace_message ('*************************************');
      io_trace_message (' ');

      BEGIN
         -- Call the function
         the_filename := NULL;
         result := f_fopen (the_filename, ro);
      END;


/* ========================================= */

      io_trace_message ('*************************************');
      io_trace_message ('*************************************');
      io_trace_message (' ');
      -- test file open - system filename
      io_trace_message (' ');
      io_trace_message (' ');
      io_trace_message (
         'Testing Open File RW with sysfile name, default sysfile directory'
      );
      io_trace_message ('*************************************');
      io_trace_message ('*************************************');
      io_trace_message (' ');

      BEGIN
         -- Call the function f_sysfile, assume default dir and datemask in call
         the_filename := f_sysfile (NULL, NULL);
         the_filemode := rw;
         result := f_fopen (the_filename, the_filemode);

         IF NOT f_is_open (result)
         THEN
            RAISE selftest_exception;
         END IF;

         IF NOT f_fclose1 (result, TRUE)
         THEN
            RAISE selftest_exception;
         END IF;
      EXCEPTION
         WHEN selftest_exception
         THEN
            BEGIN
               io_debug_message (ls_errmsg);
            END;
         WHEN OTHERS
         THEN
            BEGIN
               io_debug_message (ls_errmsg);
               RAISE;
            END;
      END;

      -- test file open - system filename, target dir
      io_trace_message (' ');
      io_trace_message (' ');
      io_trace_message (
         'Testing Open File RW with sysfile name, default sysfile directory'
      );
      io_trace_message ('*************************************');
      io_trace_message ('*************************************');
      io_trace_message (' ');

      BEGIN
         -- Call the function f_sysfile, trial dir and null datemask
         the_filename := f_sysfile (the_default_dir, NULL);
         the_filemode := rw;
         result := f_fopen (the_filename, the_filemode);

         IF NOT f_is_open (result)
         THEN
            RAISE selftest_exception;
         END IF;

         IF NOT f_fclose1 (result, TRUE)
         THEN
            RAISE selftest_exception;
         END IF;
      EXCEPTION
         WHEN selftest_exception
         THEN
            BEGIN
               io_debug_message (ls_errmsg);
            END;
         WHEN OTHERS
         THEN
            BEGIN
               io_debug_message (ls_errmsg);
               RAISE;
            END;
      END;


/* ========================================= */
      io_trace_message ('*************************************');
      io_trace_message ('*************************************');
      io_trace_message (' ');
      -- test file open RW- user filename dummy.txt
      io_trace_message (' ');
      io_trace_message (' ');
      io_trace_message (
         'Testing Open File RW with dummy.txt filename in default directory'
      );
      io_trace_message ('*************************************');
      io_trace_message ('*************************************');
      io_trace_message (' ');

      BEGIN
         the_filename := the_default_filename;
         the_filemode := rw;
         result := f_fopen (the_filename, the_filemode); -- should use default if RW (Create) but not if APPEND or RO

         IF NOT f_is_open (result)
         THEN
            ls_errmsg :=
                         'Open File Failed RW for filename = '
                      || the_filename;
            RAISE selftest_exception;
         END IF;

         io_trace_message (
               'Open File RW Succeeded for filename = '
            || the_filename
         );

         IF f_fclose2 (result)
         THEN
            ls_errmsg := 'Close File Failed';
            RAISE selftest_exception;
         END IF;

         io_trace_message ('Close File Succeeded');
      EXCEPTION
         WHEN selftest_exception
         THEN
            BEGIN
               io_debug_message (ls_errmsg);
            END;
         WHEN OTHERS
         THEN
            BEGIN
               io_debug_message (ls_errmsg);
               RAISE;
            END;
      END;


/* ========================================= */

      io_trace_message (' ');
      io_trace_message (' ');
      -- test file open RW- user filename g_systempdir||odummy.txt
      io_trace_message (
            'Testing Open File RO with file = '
         || the_default_filename
         || ' in default directory '
         || g_systempdir
      );
      io_trace_message ('*************************************');
      io_trace_message ('*************************************');
      io_trace_message (' ');

      BEGIN
         the_filename :=
                         g_systempdir
                      || g_dirsepchar
                      || the_default_filename;
         result := f_fopen (the_filename, rw);

         IF NOT f_is_open (result)
         THEN
            ls_errmsg :=
                         'Open File Failed RW for filename = '
                      || the_filename;
            RAISE selftest_exception;
         END IF;

         io_trace_message (
               'Open File RW Succeeded for filename = '
            || the_filename
         );

         IF f_fclose2 (result)
         THEN
            ls_errmsg := 'Close File Failed';
            RAISE selftest_exception;
         END IF;

         io_trace_message ('Close File Succeeded');
      EXCEPTION
         WHEN selftest_exception
         THEN
            BEGIN
               io_debug_message (ls_errmsg);
            END;
         WHEN OTHERS
         THEN
            BEGIN
               io_debug_message (ls_errmsg);

               IF f_fcloseall ()
               THEN
                  ls_errmsg := 'CloseALL File Failed';
                  RAISE;
               END IF;

               RAISE;
            END;
      END;


/* ========================================= */
      io_trace_message (' ');
      io_trace_message (' ');
      -- test WRITING TO file open RW- user filename g_systempdir||dummy.txt
      io_trace_message (
            'test WRITING TO file open RW- user filename ='
         || g_systempdir
         || the_default_filename
      );
      io_trace_message ('*************************************');
      io_trace_message ('*************************************');
      io_trace_message (' ');

      BEGIN
         the_filename :=
                         g_systempdir
                      || g_dirsepchar
                      || the_default_filename;
         result := f_fopen (the_filename, rw);

         IF NOT UTL_FILE.is_open (result)
         THEN
            ls_errmsg :=
                         'Open File Failed RW for filename = '
                      || the_filename;
            RAISE selftest_exception;
         END IF;

         io_trace_message (
               'Open File RW Succeeded for filename = '
            || the_filename
         );


-- PUT PUT PUT, THEN PUT_LINE, THEN NEW_LINE 5
         IF f_put (result, 'Write and ')
         THEN
            ls_errmsg := 'Put 1 to File Failed';
            RAISE selftest_exception;
         END IF;

         IF f_put (result, 'Write and ')
         THEN
            ls_errmsg := 'Put 2 to File Failed';
            RAISE selftest_exception;
         END IF;

         IF f_put (result, 'Write and ')
         THEN
            ls_errmsg := 'Put 3 to File Failed';
            RAISE selftest_exception;
         END IF;

         IF f_put_line (result, 'Write! ')
         THEN
            ls_errmsg := 'Put_line to File Failed';
            RAISE selftest_exception;
         END IF;


/* ========================================= */
            -- close the file, reopen to read.

         IF f_fclose2 (result)
         THEN
            ls_errmsg := 'Close File Failed';
            RAISE selftest_exception;
         END IF;

         io_trace_message ('Close File Succeeded after open RW');
         result := f_fopen (the_filename, ro);

         IF NOT f_is_open (result)
         THEN
            ls_errmsg :=
                         'Open File Failed RO for filename = '
                      || the_filename;
            RAISE selftest_exception;
         END IF;

         io_trace_message (
               'Open File RO Succeeded for filename = '
            || the_filename
         );

         BEGIN
            DECLARE
               end_of_file    BOOLEAN       := FALSE;
               line_counter   PLS_INTEGER   := 0;
               the_line_out   VARCHAR2 (80);
            BEGIN
               -- read lines from the file until empty ( 4?)
               WHILE NOT end_of_file
               LOOP
                  p_get_line (result, the_line_out, end_of_file);

                  IF NOT end_of_file
                  THEN
                     ksbms_fw.pl (the_line_out);
                     line_counter :=   line_counter
                                     + 1;
                  END IF;
               END LOOP;

               IF f_fclose2 (result)
               THEN
                  ls_errmsg := 'Close File Failed after read';
                  RAISE selftest_exception;
               END IF;

               io_trace_message (
                  'Close File Succeeded after open RO and reading'
               );
            END;
         END;


/* ========================================= */
         io_trace_message (' ');
         io_trace_message (' ');
         -- test f_exists - it ought to, so this should say TRUE
         io_trace_message (   'test f_exists with '
                           || the_filename);
         io_trace_message ('*************************************');
         io_trace_message ('*************************************');
         io_trace_message (' ');

         IF NOT f_exists (the_filename, FALSE)
         THEN
            ksbms_fw.pl (   'File '
                         || the_filename
                         || ' does not exist');
         ELSE
            ksbms_fw.pl (   'File '
                         || the_filename
                         || ' EXISTS');
         END IF;


/* ========================================= */
         IF f_erase ( the_filename )
         THEN
            ls_errmsg :=
                           'File Erase Failed for filename = '
                        || the_filename;
            RAISE selftest_exception;
         END IF;

         io_trace_message ('Erase File Succeeded after open RO and reading');

         IF NOT f_exists (the_filename, FALSE)
         THEN
            ksbms_fw.pl (
                  'File '
               || the_filename
               || ' does not exist, but SHOULD!'
            );
         ELSE
            ksbms_fw.pl (
                  'File '
               || the_filename
               || ' EXISTS after erase, but has 0 length'
            );
         END IF;
      EXCEPTION
         WHEN selftest_exception
         THEN
            BEGIN
               io_debug_message (ls_errmsg);

               IF f_fcloseall ()
               THEN
                  ls_errmsg := 'FCloseALL File Failed';
                  RAISE;
               END IF;
            END;
         WHEN OTHERS
         THEN
            BEGIN
               io_debug_message (ls_errmsg);

               IF f_fcloseall ()
               THEN
                  ls_errmsg := 'FCloseALL File Failed';
                  RAISE;
               END IF;

               RAISE;
            END;
      END;

      io_trace_message ('Self Test Succeeded!');
   EXCEPTION
      WHEN selftest_exception
      THEN
         BEGIN
            io_debug_message (ls_errmsg);

            -- ensure cleanup...
            IF NOT f_fcloseall
            THEN
               ls_errmsg :=
                     'ALL Files NOT closed with FCLOSE_ALL - maybe OK since we are at the end of the test!';
               ksbms_err.errhandler ( ksbms_msginfo.get_default_app(),
                  ksbms_exc.en_fileio_close_file,
                  ls_errmsg,
                  FALSE,
                  TRUE
               );
            END IF;
         END;
      WHEN OTHERS
      THEN
         BEGIN
            io_debug_message (ls_errmsg);

            -- ensure cleanup...
            IF NOT f_fcloseall
            THEN
               ls_errmsg :=
                     'ALL Files NOT closed with FCLOSE_ALL - this may be OK since we are at the end of the test!';
               ksbms_err.errhandler ( ksbms_msginfo.get_default_app(),
                  ksbms_exc.en_fileio_close_file,
                  ls_errmsg,
                  FALSE,
                  TRUE
               );
            END IF;
         END;
   END selftest;
-- main body begins here....
--BEGIN
   -- Initialization
--   NULL;
--  <Statement>;
END ksbms_fileio;
/