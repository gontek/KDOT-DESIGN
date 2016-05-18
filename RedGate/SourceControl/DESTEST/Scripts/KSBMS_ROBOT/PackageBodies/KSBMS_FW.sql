CREATE OR REPLACE PACKAGE BODY ksbms_robot.ksbms_fw
IS
   
/*
  -- Private type declarations
  type <TypeName> is <Datatype>;
*/
/*
  -- Private constant declarations
  <ConstantName> constant <Datatype> := <Value>;

*/
/*
  -- Private variable declarations
  <VariableName> <Datatype>;

*/
/*
  -- Function and procedure implementations
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
    <LocalVariable> <Datatype>;
  begin
    <Statement>;
    return(<Result>);
  end;


*/
/* ASSERTIONS */
/* 
|| FUNCTION IsTable - tests whethere a given table or view name exists in ALL_TABLES or ALL_VIEWS
|| does not report multiple hits as an error, even though this is presumably not allowed by Oracle
*/

  FUNCTION IsTable( the_arg_in IN sys.all_tables.table_name%TYPE)
   RETURN BOOLEAN
   IS
      ll_dummy PLS_INTEGER := 0;
  BEGIN
       SELECT 1 INTO ll_dummy FROM sys.all_tables  where table_name =  UPPER( the_arg_in )  AND
          owner = ksbms_fw.get_object_owner( 'FW') ;
            ll_dummy := 1;
      RETURN ( ll_dummy > 0 );
      
   EXCEPTION
      WHEN NO_DATA_FOUND THEN -- found no match, table does not exist
           BEGIN -- see if it's  valid VIEW name 
                 SELECT 1 INTO ll_dummy  FROM sys.all_views where view_name = UPPER(  the_arg_in ) AND
                        owner = ksbms_fw.get_object_owner('FW');
                              ll_dummy := 1;
                              
                              RETURN ( ll_dummy > 0 );
                 EXCEPTION
                     WHEN NO_DATA_FOUND THEN -- neither a view nor a table
                          RETURN FALSE;
                     WHEN TOO_MANY_ROWS THEN -- got too many but that's presumably OK, the view must exist
                          RETURN TRUE;
                     WHEN OTHERS THEN
                          RETURN FALSE;
           END;
      WHEN TOO_MANY_ROWS THEN 
           RETURN TRUE; -- got too many but that's presumably OK, the table must exist
      WHEN OTHERS THEN
           RETURN FALSE;
   END;

   
   PROCEDURE istrue (
       condition_in        IN   BOOLEAN,
      message_in           IN   VARCHAR2,
      raise_exception_in   IN   BOOLEAN := TRUE,
      exception_in         IN   VARCHAR2 := 'VALUE_ERROR'
    )
   IS
   BEGIN
      IF    NOT condition_in -- is true
         OR condition_in IS NULL
      THEN
         pl ('Assertion Failure!' );
         pl ( message_in );
         pl ('' );

         IF raise_exception_in
         THEN
            EXECUTE IMMEDIATE    'BEGIN RAISE '
                              || exception_in
                              || '; END;';
         END IF;
      END IF;
   END istrue;

   PROCEDURE isnotnull (
       value_in            IN   VARCHAR2,
      message_in           IN   VARCHAR2,
      raise_exception_in   IN   BOOLEAN := TRUE,
      exception_in         IN   VARCHAR2 := 'VALUE_ERROR'
    )
   IS
   BEGIN
      istrue (
          value_in IS NOT NULL,
         message_in,
         raise_exception_in,
         exception_in
       );
   END isnotnull;

   PROCEDURE isnotnull (
       value_in            IN   DATE,
      message_in           IN   VARCHAR2,
      raise_exception_in   IN   BOOLEAN := TRUE,
      exception_in         IN   VARCHAR2 := 'VALUE_ERROR'
    )
   IS
   BEGIN
      istrue (
          value_in IS NOT NULL,
         message_in,
         raise_exception_in,
         exception_in
       );
   END isnotnull;

   PROCEDURE isnotnull (
       value_in            IN   NUMBER,
      message_in           IN   VARCHAR2,
      raise_exception_in   IN   BOOLEAN := TRUE,
      exception_in         IN   VARCHAR2 := 'VALUE_ERROR'
    )
   IS
   BEGIN
      istrue (
          value_in IS NOT NULL,
         message_in,
         raise_exception_in,
         exception_in
       );
   END isnotnull;

   PROCEDURE isnotnull (
       value_in            IN   BOOLEAN,
      message_in           IN   VARCHAR2,
      raise_exception_in   IN   BOOLEAN := TRUE,
      exception_in         IN   VARCHAR2 := 'VALUE_ERROR'
    )
   IS
   BEGIN
      istrue (
          value_in IS NOT NULL,
         message_in,
         raise_exception_in,
         exception_in
       );
   END isnotnull;

   
-- todo...
-- isdate
--   IF (to_date (....) IS NOT NULL)
-- ischar
--   IF ( To_char(expr, format, nlsparam) IS NOT NULL )
-- isnumber
--   IF ( To_number(char, format, nlsparam) IS NOT NULL )
-- isfloat
--     IF arg - trunc(arg) > 0 -- remainder, so floatish...
-- isnull
--   IF NOT isnotnull(arg...) - so we can reuse the isnotnull functions?

/* UTILITIES */
-- pl - print a line passed by a calling program to the console
-- usage:  ksbms_fw.pl( arg);

   PROCEDURE pl (
       str        IN   VARCHAR2,
      len         IN   PLS_INTEGER := 80,
      expand_in   IN   BOOLEAN := TRUE
    )
   -- print line to console, wrapper for DBMS_OUTPUT.PUT_LINE
   IS
      v_len   PLS_INTEGER       := LEAST ( len, 255 );
      v_str   VARCHAR2 ( 2000 );
   BEGIN
      IF LENGTH ( str ) > v_len
      THEN
         -- to do - fix  to chop at closest blank for multi-line output
         v_str := SUBSTR ( str, 1, v_len );
         DBMS_OUTPUT.put_line ( v_str );
         pl ( SUBSTR ( str,   len
                            + 1 ), v_len, expand_in );
      ELSE
         v_str := str;
         DBMS_OUTPUT.put_line ( v_str );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IF expand_in
         THEN
            DBMS_OUTPUT.enable ( 1000000 );
         ELSE
            RAISE;
         END IF;

         DBMS_OUTPUT.put_line ( v_str );
   END pl;

   PROCEDURE dyn_plsql ( blk IN VARCHAR2 )
   
-- execute arbitrary block of PLSQL code...
--package example:
--BEGIN
-- dyn_plsql ('undefined.packagevar := ''abc''');
--EXCEPTION
--   WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE (sqlcode);
--END;
   IS
      cur    PLS_INTEGER := DBMS_SQL.open_cursor;
      fdbk   PLS_INTEGER;
   BEGIN
      DBMS_SQL.parse (
          cur,
            'BEGIN '
         || RTRIM ( blk, ';' )
         || '; END;',
         DBMS_SQL.native
       );
      fdbk := DBMS_SQL.EXECUTE ( cur );
      DBMS_SQL.close_cursor ( cur );
   END dyn_plsql;

   
-- from Fueurstein Oracle Built-ins page 555
   PROCEDURE show_name_components ( name_in IN VARCHAR2 )
   IS
      /* variables to hold components of the name */
      schema                  VARCHAR2 ( 100 );
      part1                   VARCHAR2 ( 100 );
      part2                   VARCHAR2 ( 100 );
      dblink                  VARCHAR2 ( 100 );
      part1_type              NUMBER;
      object_number           NUMBER;
      object_does_not_exist   EXCEPTION; -- trap -6564 (Oracle 8i)
      -- return some kind of reasonable message for the situation where
      -- the passed object name does not exist
      PRAGMA exception_init ( object_does_not_exist,  -06564 );

      /*--------------------- Local Module -----------------------*/
      FUNCTION object_type ( type_in IN PLS_INTEGER )
         RETURN VARCHAR2
      /* Return name for integer type */
      IS
         synonym_type     CONSTANT PLS_INTEGER := 5;
         procedure_type   CONSTANT PLS_INTEGER := 7;
         function_type    CONSTANT PLS_INTEGER := 8;
         package_type     CONSTANT PLS_INTEGER := 9;
      BEGIN
         IF type_in = synonym_type
         THEN
            RETURN 'Synonym';
         ELSIF type_in = procedure_type
         THEN
            RETURN 'Procedure';
         ELSIF type_in = function_type
         THEN
            RETURN 'Function';
         ELSIF type_in = package_type
         THEN
            RETURN 'Package';
         END IF;
      END object_type;
   BEGIN
      /* Break down the name into its components */
      DBMS_UTILITY.name_resolve (
          name_in,
         1,
         schema,
         part1,
         part2,
         dblink,
         part1_type,
         object_number
       );

      /* If the object number is NULL, name resolution failed. */
      IF object_number IS NULL
      THEN
         ksbms_fw.pl (
               'Name "'
            || name_in
            || '" does not identify a valid object.'
          );
      ELSE
         /* Display the schema, which is always available. */
         ksbms_fw.pl (   'Schema: '
                || schema );

         /* If there is a first part to name, have a package module */
         IF part1 IS NOT NULL
         THEN
            /* Display the first part of the name */
            ksbms_fw.pl (    object_type ( part1_type )
                   || ': '
                   || part1 );

            /* If there is a second part, display that. */
            IF part2 IS NOT NULL
            THEN
               ksbms_fw.pl (   'Name: '
                      || part2 );
            END IF;
         ELSE
            /* No first part of name. Just display second part. */
            ksbms_fw.pl (    object_type ( part1_type )
                   || ': '
                   || part2 );
         END IF;

         /* Display the database link if it is present. */
         IF dblink IS NOT NULL
         THEN
            ksbms_fw.pl (   'Database Link:'
                   || dblink );
         END IF;
      END IF;
   EXCEPTION
      WHEN -- return some kind of reasonable message for the situation where
           -- the passed object name does not exist
           object_does_not_exist
      THEN
         RAISE;
   END show_name_components;

   FUNCTION get_object_owner ( name_in IN VARCHAR2 )
      RETURN sys.all_objects.owner%TYPE
   IS
      schema                  sys.all_objects.owner%TYPE;
      part1                   VARCHAR2 ( 100 );
      part2                   VARCHAR2 ( 100 );
      dblink                  VARCHAR2 ( 100 );
      part1_type              NUMBER;
      object_number           NUMBER;
      object_does_not_exist   EXCEPTION; -- trap -6564 (Oracle 8i)
      -- return some kind of reasonable message for the situation where
      -- the passed object name does not exist
      PRAGMA exception_init ( object_does_not_exist,  -06564 );
   BEGIN
      /* Break down the name into its components */
      DBMS_UTILITY.name_resolve (
          name_in,
         1,
         schema,
         part1,
         part2,
         dblink,
         part1_type,
         object_number
       );
      RETURN schema;
   EXCEPTION
      WHEN object_does_not_exist
      THEN
         RETURN NULL;
   END get_object_owner;
   
   FUNCTION sq( string_arg IN VARCHAR2 ) -- enclose in quotes
   RETURN VARCHAR2
   IS
      BEGIN
                  RETURN '''' || string_arg  || '''';
      END;
   
   FUNCTION dq( string_arg IN VARCHAR2 ) -- enclose in dquotes
   RETURN VARCHAR2
   IS
     BEGIN
           RETURN '"' || string_arg || '"';
     END;

   -- take a string, return either the formatted value or a label
   FUNCTION display_zero_as_label( the_arg IN PLS_INTEGER, 
   the_format IN VARCHAR2, 
   the_zero_label IN VARCHAR2)
   
   RETURN VARCHAR2 
   
   IS
     
     ls_ret VARCHAR2(80) :=  the_zero_label ;
     
   BEGIN
       IF the_arg > 0 then
        ls_ret := to_char( the_arg, the_format);
       END IF;
     RETURN ls_ret;
   END display_zero_as_label;
  
  
   /* COUNT_ROWS_FOR_TABLE
   || Pass list of 1:N tables, comma separated, the where_clause, get COUNT back - returns TRUE ON FAILURE
   || where clause is arbitrarily complex, logic must match table list
   || can take a view name
   || after call, var the_count holds the # of rows
   ||  usage: select ksbms_fw.count_rows_for_table( 'BRIDGE b, ELEMINSP e', 'b,BRKEY ='||sq('AAQ') || ' AND b.brkey = e.elemkey ', the_count) from DUAL;
   */
   
   FUNCTION f_rowcount( the_stringarg_in IN VARCHAR2, the_where_clause IN VARCHAR2 )
   RETURN PLS_INTEGER
          IS
    lb_failed BOOLEAN := TRUE;
    ll_count PLS_INTEGER;
          
   BEGIN
    
    count_rows_for_table( the_stringarg_in, the_where_clause, 'COUNT', ll_count, lb_Failed );

    IF lb_Failed THEN
       ll_count := -1;
    END IF;

    RETURN ll_count;
    
   END f_rowcount;
   
   FUNCTION f_rowcount( the_stringarg_in IN VARCHAR2 )
    RETURN PLS_INTEGER
        IS
    lb_failed BOOLEAN := TRUE;
    ll_count PLS_INTEGER;
          
   BEGIN
    count_rows_for_table( the_stringarg_in, NULL, 'COUNT', ll_count, lb_Failed );
    IF lb_Failed THEN
       ll_count := -1;
    END IF;
    RETURN ll_count;
   END f_rowcount;
   

   /* COUNT_ROWS_FOR_TABLE
   || PASS well formed SQL string, or list of 1:N tables, comma separated, optional where_clause, mode ANY  or COUNT , get COUNT or 1,0 back - returns TRUE ON FAILURE in the_error
   || where clause is arbitrarily complex, logic must match table list
   || can take a view name
   || after call, arg the_count holds the # of rows
   ||  usage: select ksbms_fw.count_rows_for_table( 'BRIDGE b, ELEMINSP e', 'b,BRKEY ='||sq('AAQ') || ' AND b.brkey = e.elemkey ', the_count) from DUAL;
   */

     
   PROCEDURE count_rows_for_table( the_string_in IN VARCHAR2, the_where_clause IN VARCHAR2, 
              the_mode IN VARCHAR2, the_count OUT PLS_INTEGER, the_error OUT BOOLEAN )
   IS 
   lc_cur PLS_INTEGER := DBMS_SQL.Open_Cursor;
   ll_RetVal PLS_INTEGER := 0; -- return value from EXECUTE_AND_FETCH

   ls_SQLString VARCHAR2(2000);
   ll_count PLS_INTEGER := 0;
   ls_table_token sys.all_tables.table_name%TYPE;
   ll_StartPos PLS_INTEGER  := 1; 
   ll_EndPos PLS_INTEGER    := 0;
   
   /* Known Oracle Errors */
   invalid_SQL_statement EXCEPTION;
   PRAGMA EXCEPTION_INIT ( invalid_SQL_statement, -00900 );
   table_does_not_exist EXCEPTION;
   PRAGMA EXCEPTION_INIT ( table_does_not_exist, -00942 );

   /* User Exceptions */
   -- none
      
   BEGIN
   LOOP
   
   the_error := TRUE; -- assume failure.
      
    /* either count or  ANY directive */
      IF INSTR( TRIM( the_String_in ), 'SELECT ',1) = 0  THEN -- incoming string does not contain SELECT
            
            IF UPPER( the_mode ) = 'ANY' THEN
             ls_SQLString := 'SELECT 1 FROM  ';
            ELSE
             ls_SQLString  := 'SELECT COUNT(*) FROM  ' ;
            END IF; 
            
            ll_StartPos := 1 ; -- 1, 9, etc.
            ll_EndPos := INSTR ( TRIM( the_String_in ), ',', 1 ); 
            
            IF ll_endPos >0  THEN -- at least 1 comma found...
                     LOOP
                     -- parse table list, extract all names, check if valid table or view
                     -- if we cannot retrieve anything using SUBSTR from the string, return a dash which will cause fail in ISTABLE
                     
                     ls_table_Token := TRIM( NVL( SUBSTR( TRIM( the_String_in ), ll_startpos,  ll_EndPos - ll_StartPos  ), '-' ) ) ;
            
                           -- is the argument a valid table ?
                           IF NOT isTable( ls_Table_Token ) then 
                              RAISE table_does_not_exist;  -- an Oracle error.
                           END IF;
                           
                        ll_StartPos := ll_EndPos + 1 ;               
                        
                        IF ll_StartPos < length ( the_String_in ) THEN
                        
                           ll_EndPos := NVL( INSTR( the_String_in, ',', ll_StartPos , 1 ) , 0 );                    
                           
                           IF ll_EndPos = 0 THEN -- no more commas (arguments)
                              ll_EndPos := LENGTH( TRIM( the_String_in ) )  + 1 ;
                          
                           END IF;
      
                        ELSE
                            EXIT;
                        END IF;
                        
                   END LOOP;
                     
            ELSE
                     -- is the argument a valid table ?
                     IF NOT isTable( TRIM( the_String_in ) ) then 
                        RAISE table_does_not_exist; 
                     END IF;
            END IF;

      END IF; -- IN String was not a SQL Statement (NO SELECT )
      
      -- fixup where if necessary.
      

       IF the_where_clause IS NOT NULL AND length( TRIM( the_where_clause ) ) > 0 THEN
            IF INSTR( UPPER( the_where_clause ), 'WHERE' ) = 0 THEN -- word WHERE not found, concatenate clause to WHERE
                 ls_SQLString := ls_SQLString  || the_String_in || ' WHERE ' || NVL( the_where_clause, ' ');
            ELSE      -- use WHERE CLAUSE AS IS
                  ls_SQLString := ls_SQLString  || the_String_in || ' ' || NVL( the_where_clause, ' ');
            END IF;
       ELSE -- no where clause to use
                   ls_SQLString := ls_SQLString  ||' '||the_String_in ;
       END IF;

        -- OK - done putting together a SELECT statement
        
        -- PARSE SQL String to see if SYNTAX is right, raises exception if not
        BEGIN -- parse block starts
        DBMS_SQL.PARSE(lc_cur, ls_SQLString, DBMS_SQL.Native);
        EXCEPTION
           WHEN OTHERS THEN
                BEGIN
                     RAISE;
                EXIT;
                END;
                      
        END;
        
        -- associate column  with argument
        BEGIN
        DBMS_SQL.DEFINE_COLUMN(lc_Cur, 1, the_count);
        EXCEPTION
           WHEN OTHERS THEN
                ksbms_err.errhandler( ksbms_msginfo.get_default_app(),SQLCODE, 'DBMS_SQL.Define_Column call failed',FALSE, TRUE );
                EXIT;
        END;

        -- execute SQL in cursor
        BEGIN
        ll_retVal := DBMS_SQL.EXECUTE_AND_FETCH( lc_Cur ) ;
        EXCEPTION
           WHEN OTHERS THEN
                ksbms_err.errhandler( ksbms_msginfo.get_Default_app(),SQLCODE, 'DBMS_SQL.EXECUTE call failed',FALSE, TRUE );
                EXIT;
        END;
        
        -- something (a row) was fetched
        -- Get value into count argument
        -- if the_count NOT <0 , that's okay. In other words, if FALSE, we succeeded.
        BEGIN        
           DBMS_SQL.COLUMN_VALUE(lc_Cur, 1, the_count);
        EXCEPTION
           WHEN OTHERS THEN
                ksbms_err.errhandler( ksbms_msginfo.get_default_app(),SQLCODE, 'DBMS_SQL.COLUMN_VALUE call failed',FALSE, TRUE );
                EXIT;
        END;
        
        IF the_mode = 'ANY' THEN
                the_count := ll_retval ; -- why? Because if RETVAL = 1, then a row came back, no
                                         -- matter whether COUNT(*) or SELECT 1 was fired
        END IF;

        the_error := FALSE; -- success
       
      EXIT WHEN TRUE;
      
   END LOOP;
   
     -- Always close when finished to avoid ORA-1000 (too many cursors)
     IF DBMS_SQL.IS_OPEN( lc_Cur ) THEN
          DBMS_SQL.CLOSE_CURSOR( lc_Cur);
     END IF;
   

   EXCEPTION 
   
               WHEN table_does_not_exist THEN
                 BEGIN
                    -- TIDY
                    IF DBMS_SQL.IS_OPEN( lc_Cur ) THEN
                         DBMS_SQL.CLOSE_CURSOR( lc_Cur);
                    END IF;
                  
                   the_count := sqlcode;
                   ksbms_fw.pl( 'Table does not exist processing count_rows_for_table - SQL was ' ||  NVL( ls_SQLString, '?') );
                   ksbms_err.errhandler(ksbms_msginfo.get_default_app(), sqlcode, 'Table does not exist processing count_rows_for_table - SQL was ' ||  NVL( ls_SQLString, '?') , FALSE, TRUE );
                 END;
    
             WHEN invalid_SQL_statement THEN
                 BEGIN
                    -- TIDY
                    IF DBMS_SQL.IS_OPEN( lc_Cur ) THEN
                         DBMS_SQL.CLOSE_CURSOR( lc_Cur);
                    END IF;
                  
                   the_count := sqlcode;
                   ksbms_fw.pl( 'Invalid SQL statement processing count_rows_for_table' );
                   ksbms_fw.pl(  'SQL was ' ||  NVL( ls_SQLString, '?'  ) );
                   ksbms_err.errHANDLEr( ksbms_msginfo.get_default_app(),sqlcode, 'Invalid SQL statement processing count_rows_for_table - SQL was ' ||  NVL( ls_SQLString , '?'), FALSE, TRUE  );
               END;
               
            WHEN OTHERS THEN 
                 BEGIN
                    -- TIDY
                    IF DBMS_SQL.IS_OPEN( lc_Cur ) THEN
                         DBMS_SQL.CLOSE_CURSOR( lc_Cur);
                    END IF;
                    the_count := sqlcode;
                    ksbms_fw.pl(  'Unknown error encountered in count_rows_for_table');
                    ksbms_fw.pl(  'SQL was ' ||  NVL( ls_SQLString, '?'  ) );
                    ksbms_err.errHANDLEr(ksbms_msginfo.get_default_app(), sqlcode, 'Unknown error encountered in count_rows_for_table - SQL was ' ||  NVL( ls_SQLString, '?'  ), FALSE, TRUE  );
                 END;
   END count_rows_for_table;

   
   /* Pass table, where clause, get back 1 if rows exist, 0 if no rows, RETURNS TRUE on FAILURE 
   || where clause is arbitrarily complex, logic must match table list
   || avoids table scan for COUNT(*) if program only needs to know if any rows exist ( more than 0)
   || can take a view name
   ||  usage: select ksbms_fw.any_rows_in_table( 'BRIDGE ', 'BRKEY ='||ksbms_fw.sq('AAQ'), the_count) from DUAL;
   || OR
   || VARIANT - Pass several tables, where clause, get back 1 if rows exist, 0 if no rows, RETURNS TRUE on FAILURE 
   || where clause is arbitrarily complex, logic must match table list
   || avoids table scan for COUNT(*) if program only needs to know if any rows exist ( more than 0)
   || can take a view name
   ||  usage: select ksbms_fw.any_rows_in_table( 'BRIDGE b, ELEMINSP e', 'b.BRKEY ='||ksbms_fw.sq('AAQ') || ' AND b.brkey = e.elemkey ', the_count) from DUAL;
   */
   FUNCTION f_any_rows_exist( the_stringarg_in IN VARCHAR2, the_where_clause IN VARCHAR2 )
   RETURN BOOLEAN
   IS 
      ll_count PLS_INTEGER := 0;

      lb_Failed BOOLEAN := TRUE;
      lb_rows_exist BOOLEAN := FALSE;
      
   BEGIN
      
       count_rows_for_table( the_stringarg_in,  the_where_clause ,  'ANY'  , ll_count, lb_failed  ); -- FAILED = TRUE
      
       IF NOT lb_failed then
               lb_rows_exist := ( NVL( ll_count, 0 ) > 0 ) ;
       ELSE
               lb_rows_exist := NULL;
       END IF;
    
      
     RETURN  lb_rows_Exist ; -- IF ll_count IS >=0, then we succeed - check rows exist to see if any rows match criteria
 
   EXCEPTION 
     WHEN OTHERS THEN 
        BEGIN
          lb_rows_exist := NULL; -- so, if we get null back, then we know the call failed.
        END;
      RETURN lb_rows_Exist;
   END f_any_rows_exist;

   
  
   /* VARIANT - Pass well-formed SQL statement, get count back - RETURNS TRUE on FAILURE (bad SQL) 
   || Pass a (presumably  valid ) SELECT statement with SELECT 1  as a string, get back 1 if any exist, 0 if none, returns TRUE on failure
   || can take a SELECT of any complexity up to 500 chars in length
   || During development, test SQL in an SQL before using in code
   || This variant does not use a where clause...
   || usage: select ksbms_fw.any_rows_in_table( 'SELECT 1 FROM BRIDGE b, ELEMINSP e WHERE b,BRKEY ='||ksbms_fw.sq('AAQ') || ' AND b.brkey = e.elemkey ', rows_exist ) from DUAL;
   */
   FUNCTION f_any_rows_exist( the_stringarg_in IN VARCHAR2 )
   RETURN BOOLEAN 
   IS 
      ll_count PLS_INTEGER := 0;
      lb_Failed BOOLEAN := TRUE;
      lb_rows_exist BOOLEAN := FALSE;
      
   BEGIN
   
       count_rows_For_table( the_stringarg_in,  NULL,  'ANY'  , ll_count, lb_failed  ); -- FAILED = TRUE
      
       IF NOT lb_failed then
               lb_rows_exist := ( NVL( ll_count, 0 ) > 0 ) ;
       ELSE
               lb_rows_exist := NULL;
       END IF;
    
       
     RETURN  lb_rows_Exist ; -- IF ll_count IS >=0, then we succeed - check rows exist to see if any rows match criteria

   EXCEPTION
        WHEN OTHERS THEN
        BEGIN
          lb_rows_exist := NULL; -- so, if we get null back, then we know the call failed.
        END;
      RETURN lb_rows_exist;
   END f_any_rows_exist;

FUNCTION random
RETURN PLS_INTEGER
IS
BEGIN
  RETURN random( 1 );
END random;
  
FUNCTION random( numdigits IN PLS_INTEGER )
RETURN PLS_INTEGER
IS
  lf_remainder DOUBLE PRECISION ;

BEGIN
 LOOP
 <<control_loop>>

-- the next statement generates a remainder from the 32-bit HEXCODE generated by 
-- a call to sys_guid().  The GUID is converted to a number and divided by 10^25 to
-- generate a float, and then  the same number FLOORED is subtracted.  The result is
-- a float decimal < 1.  

-- we have to have at least 10^1 to return an integer.
-- so we always use greatest( 1, numdigits ) in this calculation
-- the next step results in decimal number, with variable digits of precision
-- numdigits can be from 1 - 9.  Larger # generate numeric overflow errors.

-- Caution:  the results of repeated calls will be consecutive through the range of the numdigits
-- and rotate around at the end - this is because SYS_GUID is essentially an ordinal number itself.

       SELECT
              TO_NUMBER( 
                    ''||sys_guid()||'' ,
                    'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' ) / POWER( 10, 24 + greatest( 1, least( numdigits, 9 ) ) ) 
             - FLOOR( 
                TO_NUMBER(
                 ''||sys_guid()||'' ,
                  'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' ) / POWER( 10, 24 + greatest( 1, least( numdigits, 9 ) ) ) )
                    INTO lf_remainder FROM DUAL;

   EXIT WHEN TRUE;
   
END LOOP control_loop;

  -- return value is always POSITIVE
  RETURN ABS( lf_remainder * Power( 10, greatest( 1, least( numdigits, 9 )  )  )  ) ; -- so, if 0, the float * 1

EXCEPTION
    WHEN OTHERS THEN
         RAISE;
         RETURN NULL;
END random;
   
begin
-- Initialization
--  <Statement>;
    NULL;    
END ksbms_fw;
/