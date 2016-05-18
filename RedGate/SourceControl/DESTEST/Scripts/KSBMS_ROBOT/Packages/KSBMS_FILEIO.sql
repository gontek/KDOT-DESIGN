CREATE OR REPLACE PACKAGE ksbms_robot."KSBMS_FILEIO"
IS
   -- Author  : ARM
   -- Created : 2001-05-21 14:56:39
   -- Updated : 2001-05-23 12:56
   -- Purpose : Wrapper for all UTL_FILE Calls
   -- also, extra public functions for unique system file name, file exists, and file erase
   -- and getdirsepchar, getdefaultdir, getpath, set_debug_state, set_trace_state

   -- requires: ksbms_fw package
   -- requires: ksbms_err package
   -- requires: ksbms_msginfo package
   --
   -- Public type declarations

   --type <TypeName> is <Datatype>;
   -- save typing - we can just say it''s a file_ref....
   --TYPE fid IS UTL_FILE%file_type;


   -- subtype to save typing UTL_FILE.FILE_TYPE over and over....
   -- usage in user programs:
      -- declare
      -- fid fileio.fid; initializes a file handle variable.
      -- fid := f_fopen( the_file, the_filemode);

   /*
   Revision History:
   2001-12-03 - ARM - adapted for KANSAS Department of Transportation
   from old fileio package.  Renamed.


   */


   SUBTYPE fid IS UTL_FILE.file_type;

   -- Public constant declarations
   --<ConstantName> constant <Datatype> := <Value>;
   ro       CONSTANT VARCHAR2 (1) := 'R'; -- access for read-only
   rw       CONSTANT VARCHAR2 (1) := 'W'; -- overwrite file
   append   CONSTANT VARCHAR2 (1) := 'A'; -- add to the end of existing file

   --usage:
   -- indirect usage
   -- declaration
   -- the_filemode := fileio.ro; set the file access mode to READONLY
   -- fid fileio.fid; initializes a file handle variable.
      -- fid := f_fopen( the_file, the_filemode); -- opens the file in RO mode

   -- or direct reference

   -- fid := f_open( the_file, fileio.ro);


   -- Public variable declarations
   -- <VariableName> <Datatype>;
   -- NO USER ACCESSIBLE PUBLIC VARIABLES

   -- Public function and procedure declarations
   -- function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
   FUNCTION f_fclose1 (the_fid IN OUT fid, flush_in IN BOOLEAN := TRUE) -- OUT parameters OK
      -- wrapper for UTL_FILE.CLOSE( fID);
      -- closes an open file by handle.
      RETURN BOOLEAN;

   FUNCTION f_fclose2 (the_fid IN OUT fid) -- OUT parameters OK
      -- wrapper for UTL_FILE.CLOSE( fID);
      -- closes an open file by handle.
      -- simple close always flushes the buffer...
      -- calls complex variant f_fclose( the_fid IN OUT fid, flush_in IN BOOLEAN )
      -- usage: if f_fclose( fid ) then ..do something to recover...
      RETURN BOOLEAN;

   FUNCTION f_fopen (
--wrapper for UTL_FILE.OPEN ( dir, file, accces)
-- either we pass a simple file name, in which case the searchpath is used to find and open
-- or we pass a fully qualified file name with directory, in which case it is parsed to open
-- by extracting the dir and filename.
                     the_filename IN VARCHAR2, the_filemode IN VARCHAR2)
      RETURN fid;

   FUNCTION f_erase (the_file_in IN VARCHAR2)
      -- actually, just empties the file by opening it in Write mode and emitting nothing
      RETURN BOOLEAN;

   FUNCTION f_exists (the_file_in IN VARCHAR2, close_if_open_in IN BOOLEAN := FALSE)
      -- determines if the file exists on disk by attempting to open it read only mode
      RETURN BOOLEAN;

   FUNCTION f_is_open (the_fid IN fid)
      -- determines if a file is open using UTL_FILE.IS_OPEN;
      RETURN BOOLEAN;

   FUNCTION f_sysfile (the_dir IN VARCHAR2, the_datemask IN VARCHAR2)
      -- generate a formatted unique filename
      RETURN VARCHAR2;

   FUNCTION f_put (the_fid IN fid, the_buffer IN VARCHAR2)
      -- wrapper for UTL_FIlE.PUT( the_fid, the_buffer);
      RETURN BOOLEAN;

   FUNCTION f_put_line (the_fid IN fid, the_buffer IN VARCHAR2)

-- wrapper for   UTL_FILE.PUT_LINE( the_fID, the_buffer );
      RETURN BOOLEAN;

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
      RETURN BOOLEAN;

   FUNCTION f_new_line (the_fid IN fid, the_count IN PLS_INTEGER)
      -- Wrapper for UTL_FILE.NEW_LINE;
      RETURN BOOLEAN;

   FUNCTION f_fflush (the_fid IN fid)
      -- Wrapper for UTL_FILE.FFLUSH( the_fID);
      RETURN BOOLEAN;

   FUNCTION f_fcloseall -- function has no arguments - OK

-- wrapper FOR PROCEDURE utl_file.CLOSEALL;
      RETURN BOOLEAN;

   PROCEDURE p_get_line (
      the_fid        IN       fid,

-- get a line from the file uses UTL_FILE.GET_LINE;
      the_line_out   OUT      VARCHAR2,
      eof_out        OUT      BOOLEAN
   );

    -- the next ones are NOT public
   -- file finding related functions
   --PROCEDURE setpath ( str IN VARCHAR2 );

   -- file finding related functions - what character separates directories
   --PROCEDURE setdirsepchar ( str IN VARCHAR2 );

   -- file finding related functions - what character separates PATH values
   --PROCEDURE setpathsepchar ( str IN VARCHAR2 );

   -- pick a default dir from the directories in the path
   --PROCEDURE setdefaultdir ( str IN VARCHAR2 );

   -- return default directory from package.
   FUNCTION getdefaultdir -- function has no arguments - OK
      RETURN VARCHAR2;

   -- return dirsepchar for OS
   FUNCTION getdirsepchar -- function has no arguments - OK
      RETURN VARCHAR2;

   FUNCTION getpath -- function has no arguments - OK
      --usage: ls_path VARCHAR2 (1024) := getpath;
      RETURN VARCHAR2;

   -- pass Y to turn on DEBUG messages.
   PROCEDURE set_debug_state (str IN VARCHAR2);

   -- pass Y to turn on TRACE messages (flow monitoring)
   PROCEDURE set_trace_state (str IN VARCHAR2);

   -- pass an integer number to reset emit frequency from default e.g. fileio.set_emit_modulo(10) to
   -- print a debug line every 10th record...
   --PROCEDURE set_emit_modulo ( freq IN PLS_INTEGER );

   -- run me to see the functions and procedures exercised
   -- SQL> execute fileio.selftest;
--   PROCEDURE io_debug_message( buffer IN VARCHAR2);

--   PROCEDURE io_trace_message( buffer IN VARCHAR2);


   PROCEDURE selftest (
      the_default_filename   IN   VARCHAR2 := 'dummy.txt',
      the_default_dir        IN   VARCHAR2 --:= g_defaultdir
   );
END ksbms_fileio;
 
/