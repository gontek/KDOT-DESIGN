CREATE OR REPLACE PACKAGE ksbms_robot."KSBMS_ERR"
/*
|| PACKAGE KSBMS_ERR
|| Provides basic errhandlerr for all exceptions, ability to LOG exceptions to a file or database table.
|| depends on KSBMSBMS_EXC, the exception declaration and initializaiton package.
|| uses FW package for FW.PL in several functions - replaced DBMS_OUTPUT.PUT_LINE
|| uses FILEIO for error logging to text file when necessary.
|| --------------------------------------------- Revision History ---------------------------------------------------------------
|| Client:  Kansas  Department Of Transportation, 2001
|| Cambridge Systematics, Inc., Asset Management Group
|| Developer: Allen Marshall
|| Created: 2001-05-10 10:40:26, adapted from sample source in PL/SQL Programming by Feuerstein et all
|| Last Revised: 2001-12-03
|| Revision history:
|| Revised: 6/13/2001
|| reformatted, commented each unit end statement
|| changed to use revised msg functions in msginfo
|| Revised 6/21/2001 only activates logging dir global g_dir if necessary.  See logto function
|| 2001-12-03 - ARM - revised table structure for appcode

*/
IS
   c_table    CONSTANT PLS_INTEGER := 1; -- Default
   c_file     CONSTANT PLS_INTEGER := 2;
   c_screen   CONSTANT PLS_INTEGER := 3;

    -- ARM Default APP CODE
   -- c_default_app   CONSTANT PLS_INTEGER := 3; -- defaults to a generic KSBMS utility
    -- use ksbms_msginfo.get_default_app;  INSTEAD
/*
PROCEDURE errhandler (
      -- pass error code and message and this function will errhandler logging the messsage
      -- automatically as well as RERAISE the error for application notification
      the_appcode      IN   PLS_INTEGER,
      the_errcode_in   IN   PLS_INTEGER,
      the_errmsg_in    IN   VARCHAR2,
      the_logerr           IN   BOOLEAN := NULL,
      the_reraise          IN   BOOLEAN := NULL
   );
   */

   PROCEDURE handle (
      the_appcode_in   IN   PLS_INTEGER,
      the_errcode_in   IN   PLS_INTEGER,
      the_errmsg_in    IN   VARCHAR2,
      the_logerr       IN   BOOLEAN := NULL,
      the_reraise      IN   BOOLEAN := NULL
   );

   PROCEDURE errhandler (
      the_appcode_in   IN   PLS_INTEGER,
      the_errcode_in   IN   PLS_INTEGER,
      the_errmsg_in    IN   VARCHAR2,
      the_logerr       IN   BOOLEAN := NULL,
      the_reraise      IN   BOOLEAN := NULL
   );

/*
   PROCEDURE RAISE (

-- err.raise provides a wrapper function for raising an error
      the_appcode_in   IN   PLS_INTEGER := NULL,
      the_errcode_in   IN   PLS_INTEGER := NULL
   );
*/

   PROCEDURE RAISE (

-- err.raise provides a wrapper function for raising an error
      the_appcode_in   IN   PLS_INTEGER := NULL,
      the_errcode_in   IN   PLS_INTEGER := NULL,
      the_errmsg_in    IN   VARCHAR2 := NULL
   );

   PROCEDURE LOG (

-- logs the error to target.
      the_appcode_in   IN   PLS_INTEGER := NULL,
      the_errcode_in   IN   PLS_INTEGER := NULL,
      the_errmsg_in    IN   VARCHAR2 := NULL
   );

   PROCEDURE logto (
-- sets logging target - table, file, etc.
                    target IN PLS_INTEGER, dir IN VARCHAR2 := NULL, FILE IN VARCHAR2 := NULL);

   PROCEDURE test_exception_errhandler (
      -- utility to test err/exception errhandlerrs...
      the_appcode_in   IN   PLS_INTEGER,
      the_exception    IN   VARCHAR2 := 'too_many_datadict_rows',
      test_reraise     IN   BOOLEAN := FALSE
   );

   FUNCTION logging_to

-- returns indicator of log target to user.
      RETURN PLS_INTEGER;

   FUNCTION get_sqlerror (
      p_appcode   IN   PLS_INTEGER,
      p_objname   IN   VARCHAR2,
      p_appmsg    IN   VARCHAR2
   )

-- formats the error message for use with DBMS_OUTPUT.PUT_LINE (fw.pl)
      RETURN VARCHAR2;

   PROCEDURE set_log_errors (the_errlog_mode IN BOOLEAN);
END ksbms_err;
 
/