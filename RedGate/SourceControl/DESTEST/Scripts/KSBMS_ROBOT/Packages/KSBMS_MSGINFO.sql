CREATE OR REPLACE PACKAGE ksbms_robot."KSBMS_MSGINFO"
/*
|| Package msginfo provides a set of generic message handlers for looking up
|| messages in TABLE KSBMS_MSG_INFO.  The table can also be used with procedure gen_exc_pkg
|| to generate an EXCEPTION HANDLER package with a user defined name.  This allows
|| all code to use named exceptions instead of #, which is particularly beneficial
|| when defining identical or very simila errors across PL/SQL modules, such as when
|| implementing error handlers in triggers.
||----------------------------------------------------------------------------------
|| Created: 5/2001 by Allen Marshall
|| Initial coding: based on Fueurstein guidelines and example.
||----------------------------------------------------------------------------------
|| Last Revised: 6.20.2001 - Allen Marshall
|| Changed SELECT * FROM MSG_INFO to be an ordered select
|| Also, changed get functions to handle NO_DATA_FOUND in MSG_INFO.
*/
IS


   FUNCTION getmsgname (
      the_appcode_in   IN   PLS_INTEGER,
      the_msgcode_in   IN   PLS_INTEGER,
      the_msgtype_in   IN   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION getmsgtext (
      the_appcode_in   IN   PLS_INTEGER,
      the_msgcode_in   IN   PLS_INTEGER,
      the_type_in      IN   VARCHAR2,
      use_sqlerrm      IN   BOOLEAN := TRUE
   )
      RETURN VARCHAR2;

   FUNCTION getmsgcode (
      the_appcode_in   IN   PLS_INTEGER,
      the_msgname_in   IN   VARCHAR2,
      the_msgtype_in   IN   VARCHAR2
   )
      RETURN PLS_INTEGER;

   -- anchored to sys.all_objects view column
   PROCEDURE gen_exc_pkg (
      schema_in        IN   sys.all_objects.owner%TYPE DEFAULT USER,
      pkgname_in       IN   sys.all_objects.object_name%TYPE,
      the_appcode_in   IN   ksbms_msg_info.appcode%TYPE, --:= get_Default_app(),
      oradev_use       IN   BOOLEAN := TRUE,
      spool_out        IN   BOOLEAN := TRUE,
      file_out         IN   BOOLEAN := FALSE,
      debug_in         IN   BOOLEAN := FALSE,
      trace_in         IN   BOOLEAN := FALSE
   );

   FUNCTION get_default_app
   -- Function to determine default app for messages retrieved from KSBMS_MSG_INFO
   -- programs should never set this, just get it.

   RETURN PLS_INTEGER;

   PROCEDURE selftest (
      the_appcode_in   IN   PLS_INTEGER,
      the_msgcode_in   IN   PLS_INTEGER,
      the_msgname_in   IN   VARCHAR2,
      the_msgtype_in   IN   VARCHAR2,
      use_sqlerrm      IN   BOOLEAN := TRUE
   );
END ksbms_msginfo;
 
/