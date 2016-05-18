CREATE OR REPLACE PACKAGE ksbms_robot.ksbms_fw
IS
   
  -- Author  : ARM
  -- Created : 2001-05-24 09:27:58
  -- Purpose : provide framework functions for general usage in other
  -- packages 
/*
  -- Public type declarations
  type <TypeName> is <Datatype>;


*/

/*
  -- Public constant declarations
  <ConstantName> constant <Datatype> := <Value>;
*/

/*
  -- Public variable declarations
  <VariableName> <Datatype>;
*/
/*
  -- Public function and procedure declarations
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
*/

-- from Fueurstein Oracle Best Practices, pp. 67-68, O'Reilly
/* STANDARD ASSERTIONS */
-- IsTable - the passed argument is a table or view name
   FUNCTION IsTable( the_arg_in IN sys.all_tables.table_name%TYPE)
   RETURN BOOLEAN;
   
-- istrue - usage fw.istrue( condition_in => BOOLEAN CONDITION,message_in => 'ASSERTION ERROR MESSAGE',raise_exception_in => TRUE,exception_in => 'EXCEPTION NAME');
   PROCEDURE istrue (
       condition_in        IN   BOOLEAN,
      message_in           IN   VARCHAR2,
      raise_exception_in   IN   BOOLEAN := TRUE,
      exception_in         IN   VARCHAR2 := 'VALUE_ERROR'
    );

   PROCEDURE isnotnull (
       value_in            IN   VARCHAR2,
      message_in           IN   VARCHAR2,
      raise_exception_in   IN   BOOLEAN := TRUE,
      exception_in         IN   VARCHAR2 := 'VALUE_ERROR'
    );

   PROCEDURE isnotnull (
       value_in            IN   DATE,
      message_in           IN   VARCHAR2,
      raise_exception_in   IN   BOOLEAN := TRUE,
      exception_in         IN   VARCHAR2 := 'VALUE_ERROR'
    );

   PROCEDURE isnotnull (
       value_in            IN   NUMBER,
      message_in           IN   VARCHAR2,
      raise_exception_in   IN   BOOLEAN := TRUE,
      exception_in         IN   VARCHAR2 := 'VALUE_ERROR'
    );

   PROCEDURE isnotnull (
       value_in            IN   BOOLEAN,
      message_in           IN   VARCHAR2,
      raise_exception_in   IN   BOOLEAN := TRUE,
      exception_in         IN   VARCHAR2 := 'VALUE_ERROR'
    );

   
/* PUBLIC UTILITIES */
   /* echo a line to the console IF SERVEROUTPUT ON>..*/
   PROCEDURE pl (
       str        IN   VARCHAR2,
      len         IN   PLS_INTEGER := 80,
      expand_in   IN   BOOLEAN := TRUE
    );

   /* programmatically execute a block of PL/SQL */
   PROCEDURE dyn_plsql ( blk IN VARCHAR2 );

   /* use to show all information about a schema object that is relevant */
   PROCEDURE show_name_components ( name_in IN VARCHAR2 );
   
   -- return the object owner using DBMS_UTILITY.NAME_RESOLVE
   FUNCTION get_object_owner ( name_in IN VARCHAR2 )
      RETURN sys.all_objects.owner%TYPE;
      
   -- enquote strings to simplify concatenation
   -- take a string,return 'string'
   FUNCTION sq ( string_arg IN VARCHAR2)
      RETURN VARCHAR2;

   -- enquote strings to simplify concatenation
   -- take a string,return "string"
   FUNCTION dq ( string_arg IN VARCHAR2)
      RETURN VARCHAR2;
      
   FUNCTION display_zero_as_label( the_arg IN PLS_INTEGER, 
    the_format IN VARCHAR2, 
    the_zero_label IN VARCHAR2)
   RETURN VARCHAR2;
   
   /*
   ||The next functions wrap all attempts to count rows with uniform exception handlers 
   ||Errors in SQL are handled internally.  Calling program must evaluate return and
   ||decide what to do
   ||example of branching based on return value (TRUE means failed)
   || if fw.count_rows_for_table( 'BRIDGE', 'BRKEY ='||sq('AAQ'), the_count ) then // failed
   ||    EXIT
   || end if
   ||... continue using value for the_count
   || or, if we just need to know if there are any to process at all, presumably prior to declaring a
   || cursor to process them or whatever,
   || if fw.any_rows_exist( 'BRIDGE', 'BRKEY ='||sq('AAQ'), rows_exist ) then // failed
   ||    EXIT
   || end if
   ||
   */
   
   /* COUNT_ROWS_FOR_TABLE
   || Pass single TABLE name, WHERE_CLAUSE, get COUNT back - RETURNS TRUE ON FAILURE 
   || can take a view name
   || after call, var the_count holds the # of rows
   || usage: select fw.count_rows_for_table( 'BRIDGE', 'BRKEY ='||sq('AAQ'), the_count) from DUAL; 
    */
   
    /* 
   || Pass list of 1:N tables, comma separated, the where_clause, get COUNT back - returns TRUE ON FAILURE
   || where clause is arbitrarily complex, logic must match table list
   || can take a view name
   || returns the # of rows from 0 ::N or NULL
   ||  usage: select fw.count_rows_for_table( 'BRIDGE b, ELEMINSP e', 'b,BRKEY ='||sq('AAQ') || ' AND b.brkey = e.elemkey ', the_count) from DUAL;
   */
   
   FUNCTION f_rowcount( the_stringarg_in IN VARCHAR2 )
   RETURN PLS_INTEGER ;
   /*
   || returns the # of rows from 0 ::N or NULL
   || Pass 'ANY' in the_mode to get a 1 back if rows exist.
   */
   FUNCTION f_rowcount( the_stringarg_in IN VARCHAR2, the_where_clause IN VARCHAR2 )
   RETURN PLS_INTEGER;

   /* VARIANT - Pass several tables, where clause, get back 1 if rows exist, 0 if no rows, RETURNS TRUE on FAILURE 
   || where clause is arbitrarily complex, logic must match table list
   || avoids table scan for COUNT(*) if program only needs to know if any rows exist ( more than 0)
   || can take a view name
   ||  usage: select fw.any_rows_in_table( 'BRIDGE b, ELEMINSP e', 'b.BRKEY ='||fw.sq('AAQ') || ' AND b.brkey = e.elemkey ', the_count) from DUAL;
   || OR
   || Pass table, where clause, get back 1 if rows exist, 0 if no rows, RETURNS TRUE on FAILURE 
   || where clause is arbitrarily complex, logic must match table list
   || avoids table scan for COUNT(*) if program only needs to know if any rows exist ( more than 0)
   || can take a view name
   ||  usage: select fw.any_rows_in_table( 'BRIDGE ', 'BRKEY ='||fw.sq('AAQ'), the_count) from DUAL;
   */ 
   FUNCTION f_any_rows_exist( the_stringarg_in IN VARCHAR2,  the_where_clause IN VARCHAR2  )
   RETURN BOOLEAN;
   
   /* VARIANT - Pass a single string oeither a list of tables, or a well-formed SQL statement, get count back - RETURNS TRUE on FAILURE (bad SQL) 
   || Pass a (presumably  valid ) SELECT statement with SELECT 1  as a string, get back 1 if any exist, 0 if none, returns TRUE on failure
   || can take a SELECT of any complexity up to 500 chars in length
   || During development, test SQL in an SQL before using in code
   || This variant does not use a where clause...
   || usage: select fw.any_rows_in_table( 'SELECT 1 FROM BRIDGE b, ELEMINSP e WHERE b,BRKEY ='||fw.sq('AAQ') || ' AND b.brkey = e.elemkey ', rows_exist ) from DUAL;
   */
   FUNCTION f_any_rows_exist( the_stringarg_in IN VARCHAR2 )
   RETURN BOOLEAN; -- TRUE if ROWS EXIST
   
   /* Routine that actually does the counting or determining if a row exists */
   
   PROCEDURE count_rows_for_table( the_string_in IN VARCHAR2, the_where_clause IN VARCHAR2, 
              the_mode IN VARCHAR2, the_count OUT PLS_INTEGER, the_error OUT BOOLEAN );

   -- return a random integer from 0 - 9 (ALWAYS POSITIVE)
   -- Caution:  the results of repeated calls will be consecutive through the range of the numdigits
   -- and rotate around at the end - this is because SYS_GUID is essentially an ordinal number itself.
   -- overloaded

   FUNCTION random
   RETURN PLS_INTEGER;

   -- return a POSITIVE random integer from 0 - X  - pass digits
   -- to generate a number for the # of digits e.g. 2 generates a number from 0 - 99.
   -- min is a 1 digit number
   -- max is a 9 digit number - multiply multiple calls together to make bigger numbers if necessary or 
   -- just revert to using SYS_GUID() directly.
   -- usage select fw.random( 9 ) from  dual generates
   -- 115705996,for example, and definitely no more tha 999999999
   -- Distribution is not likely to be very uniform etc. but use for identifiers, not statistics
   
   FUNCTION random( numdigits IN PLS_INTEGER )
   RETURN PLS_INTEGER;
         
END ksbms_fw;

 
/