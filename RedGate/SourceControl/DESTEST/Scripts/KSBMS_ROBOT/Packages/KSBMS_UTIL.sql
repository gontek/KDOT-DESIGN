CREATE OR REPLACE PACKAGE ksbms_robot.Ksbms_Util IS
  -- Author  : ARM
  -- Created : 2001-06-22 17:34:05
  -- Purpose : General purpose utilities used by all KSBMS routines

  -- Revision History
  -- ARM JAN 2, 2002 - FIXED TABLE NAME KSBMS_CONFIG_OPTIONS, tested e-mail functionality
  -- SJH JUN 29, 2004 - Added the following for P_GEN_PONTIS_EMAIL_REPORT stored procedure
  --                    generic_list_type, f_tcp_connect, and p_parse_list

  TYPE Generic_List_Type IS VARRAY(500) OF VARCHAR2(4000); -- must accommodate COPTIONS.OPTIONVAL%TYPE (VARCHAR2)255))

  FUNCTION f_Tcp_Connect(The_Connection OUT Utl_Smtp.Connection,
                         The_Mailhost   OUT Coptions.Optionval%TYPE)
    RETURN BOOLEAN;

  PROCEDURE p_Parse_List(The_List_In      IN OUT VARCHAR2,
                         The_Delimiter_In IN VARCHAR2 := ',',
                         The_Cell_Limit   IN PLS_INTEGER := 500,
                         The_Array        OUT Generic_List_Type);

  -- Public type declarations
  --type <TypeName> is <Datatype>;
  SUBTYPE Email_List_Type IS ksbms_robot.Ds_Config_Options.Optionvalue%TYPE;

  -- Accumulates the email text
  -- Be sure to make email_msg type 'gi_email_length' characters long!
  Gi_Email_Length CONSTANT PLS_INTEGER := 8192; -- 8*1024

  SUBTYPE Email_Msg IS VARCHAR2(8192); -- CANNOT substitute gi_email_length here

  -- Allen Marshall, CS -1/17/2003 add up to 255 chars to stack,  p_push will  truncate any stack additions after that - appraximately 4000/255 stack entries
  -- PUBLIC SUBTYPE (in specification)
  -- Allen Marshall, CS- 01/31/2003 - used in lots of other packages so PUBLIC
  SUBTYPE Context_String_Type IS VARCHAR2(255);

  Gs_Email_Msg Email_Msg;
  Gi_Sqlcode   PLS_INTEGER := 0; -- Set in 
  -- Public constant declarations

  --<ConstantName> constant <Datatype> := <Value>;

  c_Dblink_Name CONSTANT VARCHAR2(255) := 'highways';
  -- modes for e-mail   - XML, Plain Text, Mixture (attachment...)
  c_Xmlbody       CONSTANT VARCHAR2(10) := 'XML';
  c_Plaintextbody CONSTANT VARCHAR2(10) := 'PLAINTEXT';
  c_Mixedbody     CONSTANT VARCHAR2(10) := 'MIXED';
  Crlf            CONSTANT VARCHAR2(2) := Chr(13) || Chr(10); -- carriage return AND New line?  Does this work...dk
  Cr              CONSTANT VARCHAR2(1) := Chr(13); -- carriage return only                                          
  -- For f_random_float() and f_random_integer()
  m  CONSTANT NUMBER := 100000000; /* initial conditions */
  M1 CONSTANT NUMBER := 10000; /* (for best results) */
  b  CONSTANT NUMBER := 31415821; /*                    */
  a        NUMBER; /* seed */
  The_Date DATE; /*                             */
  Days     NUMBER; /* for generating initial seed */
  Secs     NUMBER; /*                             */
  -- Public variable declarations
  Generic_Exception EXCEPTION;
  PRAGMA EXCEPTION_INIT(Generic_Exception, -20300);

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  PROCEDURE Istrue(Condition_In       IN BOOLEAN,
                   Message_In         IN VARCHAR2,
                   Raise_Exception_In IN BOOLEAN := TRUE,
                   Exception_In       IN VARCHAR2 := 'VALUE_ERROR');

  PROCEDURE Isnotnull(Value_In           IN VARCHAR2,
                      Message_In         IN VARCHAR2,
                      Raise_Exception_In IN BOOLEAN := TRUE,
                      Exception_In       IN VARCHAR2 := 'VALUE_ERROR');

  PROCEDURE Isnotnull(Value_In           IN DATE,
                      Message_In         IN VARCHAR2,
                      Raise_Exception_In IN BOOLEAN := TRUE,
                      Exception_In       IN VARCHAR2 := 'VALUE_ERROR');

  PROCEDURE Isnotnull(Value_In           IN NUMBER,
                      Message_In         IN VARCHAR2,
                      Raise_Exception_In IN BOOLEAN := TRUE,
                      Exception_In       IN VARCHAR2 := 'VALUE_ERROR');

  PROCEDURE Isnotnull(Value_In           IN BOOLEAN,
                      Message_In         IN VARCHAR2,
                      Raise_Exception_In IN BOOLEAN := TRUE,
                      Exception_In       IN VARCHAR2 := 'VALUE_ERROR');

  PROCEDURE Isnumber(Stringarg_In       IN VARCHAR2, -- assert that string argument is a number, or raise exception
                     Message_In         IN VARCHAR2,
                     Raise_Exception_In IN BOOLEAN := TRUE,
                     Exception_In       IN VARCHAR2 := 'VALUE_ERROR');

  FUNCTION Isnumber(The_Token_In IN VARCHAR2) RETURN BOOLEAN;

  FUNCTION Try_Isnumber(The_Token_In IN VARCHAR2) RETURN BOOLEAN;

  FUNCTION f_Isnumber(The_Token_In IN VARCHAR2) RETURN BOOLEAN;

  --ARMarshall, ARM LLC 20150615 - added for check of real change for values 
  -- returns the closeness tolerance percentage for a given table/column (that is a number)...
  FUNCTION f_Get_Delta_Tolerance(Ptab IN All_Tab_Cols.Table_Name%TYPE,
                                 Pcol IN All_Tab_Cols.Column_Name%TYPE)
    RETURN DOUBLE PRECISION;

  FUNCTION Get_Object_Owner(Name_In IN VARCHAR2)
    RETURN Sys.All_Objects.Owner%TYPE;

  FUNCTION Display_Zero_As_Label(The_Arg        IN PLS_INTEGER,
                                 The_Format     IN VARCHAR2,
                                 The_Zero_Label IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION Sq(String_Arg IN VARCHAR2) -- enclose in quotes
   RETURN VARCHAR2;

  FUNCTION Dq(String_Arg IN VARCHAR2) -- enclose in doublquotes
   RETURN VARCHAR2;

  -- functions for getting and setting option values
  FUNCTION f_Get_Coption_Value(Opt_Name IN ksbms_robot.Ds_Config_Options.Optionname%TYPE /* ARM JAN 2, 2002 - FIXED TABLE NAME */)
    RETURN ksbms_robot.Ds_Config_Options.Optionvalue%TYPE;

  /* ARM JAN 2, 2002 - FIXED TABLE NAME */

  FUNCTION f_Set_Coption_Value(Opt_Name IN ksbms_robot.Ds_Config_Options.Optionname%TYPE,
                               /* ARM JAN 2, 2002 - FIXED TABLE NAME */
                               Opt_Val IN ksbms_robot.Ds_Config_Options.Optionvalue%TYPE)
    RETURN BOOLEAN;

  FUNCTION f_Insert_Coption(Opt_Name IN ksbms_robot.Ds_Config_Options.Optionname%TYPE,
                            /* ARM JAN 2, 2002 - FIXED TABLE NAME */
                            Opt_Val IN ksbms_robot.Ds_Config_Options.Optionvalue%TYPE
                            /* ARM JAN 2, 2002 - FIXED TABLE NAME */)
    RETURN BOOLEAN;

  /*
     FUNCTION f_parse_mailing_list (the_list_in IN email_list_type)
        RETURN address_list_type;
  */
  FUNCTION f_Email(The_List    IN Email_List_Type,
                   The_Message IN VARCHAR2,
                   The_Subject IN VARCHAR2) RETURN BOOLEAN;

  FUNCTION f_Email(The_List    IN Email_List_Type,
                   The_Message IN VARCHAR2,
                   The_Subject IN VARCHAR2,
                   The_Mode    IN VARCHAR2) RETURN BOOLEAN;

  FUNCTION f_Xmlemail(The_List       IN Email_List_Type,
                      The_Xmlmessage IN VARCHAR2,
                      The_Subject    IN VARCHAR2) RETURN BOOLEAN;

  FUNCTION f_Get_Table_Owner(Name_In IN Sys.All_Tables.Table_Name%TYPE)
    RETURN Sys.All_Tables.Owner%TYPE;

  FUNCTION f_Is_Table(Name_In IN Sys.All_Tables.Table_Name%TYPE)
    RETURN BOOLEAN;

  FUNCTION f_Get_View_Owner(Name_In IN Sys.All_Views.View_Name%TYPE)
    RETURN Sys.All_Views.Owner%TYPE;

  FUNCTION f_Is_View(Name_In IN Sys.All_Views.View_Name%TYPE) RETURN BOOLEAN;

  FUNCTION f_Set_Msg_Level(The_Msg_Level IN VARCHAR2 := 'VERBOSE')
    RETURN BOOLEAN;

  FUNCTION f_Set_Msg_Level(The_Msg_Level IN BOOLEAN := FALSE) RETURN BOOLEAN;

  FUNCTION f_Get_Verbose RETURN BOOLEAN;

  FUNCTION f_Get_Msg_Level RETURN PLS_INTEGER;

  FUNCTION f_Get_Object_Owner(Name_In IN VARCHAR2)
  -- Using DBMS_UTILITY.NAME_RESOLVE, we can retrieve schema owner for
    -- the (Pontis) BRDESCRP table, which should be authoritative.
   RETURN Sys.All_Objects.Owner%TYPE;

  FUNCTION Iscolumn(The_Table  IN Sys.All_Tab_Columns.Table_Name%TYPE,
                    The_Column IN Sys.All_Tab_Columns.Column_Name%TYPE)
    RETURN BOOLEAN; -- FALSE MEANS NOT A COLUMN!!  

  -- Function to determine if an arbitrary string is a TABLE that exists in the database
  FUNCTION Istable(The_Table IN Sys.All_Tables.Table_Name%TYPE)
    RETURN BOOLEAN; -- FALSE MEANS NOT A TABLE!!

  -- Function to determine if an arbitrary string is a TABLE or VIEW that exists in the database
  FUNCTION Istableorview(The_Table IN Sys.All_Tables.Table_Name%TYPE)
    RETURN BOOLEAN; -- FALSE MEANS NOT A TABLE OR VIEW!!

  -- Captures the SQL error message and the passed context in a global string,
  -- and raises a generic_exception
  PROCEDURE p_Sql_Error(Psi_Context IN Context_String_Type);

  -- Captures the SQL error message and the passed context in a global string,
  -- WITHOUT raising a generic_exception;
  -- Call this variant outside the outermost exception block.
  PROCEDURE p_Sql_Error2(Psi_Context IN Context_String_Type);

  -- Captures the SQL error message and the passed context in a global string,
  -- WITHOUT raising a generic_exception;
  -- WITHOUT adding message to gs_sql_error or email message
  -- Call this variant outside the outermost exception block.
  PROCEDURE p_Sql_Error3(Psi_Context IN Context_String_Type);

  -- Accumulate the passed string in a global global string         
  PROCEDURE p_Add_Msg(Psi_Msg IN VARCHAR2);

  -- Hoyt 01/14/2002 Prepend 'Bug: ' to the (otherwise same as) p_add_msg()        
  PROCEDURE p_Bug(Psi_Msg IN VARCHAR2);

  -- Call this function on fatal error, esp. with SQL
  -- It will rollback and optionally raise an error, 
  -- depending on the value of RAISE_MERGE_ERROR in DS_CONFIG_OPTIONS.
  PROCEDURE p_Clean_Up_After_Raise_Error(Psi_Context IN Context_String_Type);

  -- Variant 2 does NOT do a rollback -- you can call it in a trigger 
  PROCEDURE p_Clean_Up_After_Raise_Error2(Psi_Context IN Context_String_Type);

  FUNCTION f_Wordwrap(Str  IN VARCHAR2,
                      Len  IN PLS_INTEGER := 80,
                      Rest OUT VARCHAR2) RETURN Coptions.Optionval%TYPE;

  -- Allen 2002-11-7 forced anchored types here for optionname and optionvalue
  FUNCTION f_Get_Config_Option2(Psi_Optionname IN Ds_Config_Options.Optionname%TYPE)
    RETURN Ds_Config_Options.Optionvalue%TYPE;

  -- Variant returns string so it can be called in line;
  -- the magic string 'ls_return_failure' indicates a failure.

  -- Returns TRUE if the passed parameter is any of a variety of yes-ish string
  FUNCTION f_Is_Yes(Pis_Yes_Candidate IN VARCHAR2) RETURN BOOLEAN;

  -- Returns the value of the global email message string
  FUNCTION f_Get_Email_Msg RETURN VARCHAR2;

  -- Set the email message to the passed string
  PROCEDURE p_Set_Email_Msg(Psi_Msg VARCHAR2);

  -- Returns the value of the global SQL error string
  FUNCTION f_Get_Sql_Error RETURN VARCHAR2;

  -- These 'clear out' (set to the empty string) the global strings
  PROCEDURE p_Clear_Sql_Error;

  PROCEDURE p_Clear_Email_Msg;

  -- Hoyt 01/06/2002 Moved from ksbms_fw (to avoid having to move THAT one to Pontis)
  PROCEDURE Pl(Str       IN VARCHAR2,
               Len       IN PLS_INTEGER := 80,
               Expand_In IN BOOLEAN := TRUE);

  PROCEDURE Count_Rows_For_Table(The_String_In    IN VARCHAR2,
                                 The_Where_Clause IN VARCHAR2,
                                 The_Mode         IN VARCHAR2,
                                 The_Count        OUT PLS_INTEGER,
                                 The_Error        OUT BOOLEAN);

  FUNCTION f_Any_Rows_Exist(The_Stringarg_In IN VARCHAR2,
                            The_Where_Clause IN VARCHAR2) RETURN BOOLEAN;

  /* VARIANT - Pass well-formed SQL statement, get count back - RETURNS TRUE on FAILURE (bad SQL)
  || Pass a (presumably  valid ) SELECT statement with SELECT 1  as a string, get back 1 if any exist, 0 if none, returns TRUE on failure
  || can take a SELECT of any complexity up to 500 chars in length
  || During development, test SQL in an SQL before using in code
  || This variant does not use a where clause...
  || usage: select fw.any_rows_in_table( 'SELECT 1 FROM BRIDGE b, ELEMINSP e WHERE b,BRKEY ='||fw.sq('AAQ') || ' AND b.brkey = e.elemkey ', rows_exist ) from DUAL;
  */
  FUNCTION f_Any_Rows_Exist(The_Stringarg_In IN VARCHAR2) RETURN BOOLEAN;

  FUNCTION f_Rowcount(The_Stringarg_In IN VARCHAR2,
                      The_Where_Clause IN VARCHAR2) RETURN PLS_INTEGER;

  FUNCTION f_Rowcount(The_Stringarg_In IN VARCHAR2) RETURN PLS_INTEGER;

  FUNCTION Random RETURN PLS_INTEGER;

  FUNCTION Random(Numdigits IN PLS_INTEGER) RETURN PLS_INTEGER;

  FUNCTION f_Now RETURN VARCHAR2;

  FUNCTION f_Today RETURN VARCHAR2;

  FUNCTION f_Get_Entry_Id RETURN VARCHAR2;

  FUNCTION f_Get_Change_Log_Seqnum RETURN PLS_INTEGER;

  FUNCTION f_Ns(Psi_String IN VARCHAR2) RETURN BOOLEAN;

  -- function will return true if two numbers are different enough...
  FUNCTION f_Numbers_Differ(Oldnum1           IN NUMBER,
                            Newnum2           IN NUMBER,
                            Precision_Limit   IN DOUBLE PRECISION := NULL,
                            Notify_On_Missing IN BOOLEAN := TRUE)
    RETURN BOOLEAN;

  FUNCTION f_Wrap_Data_Value(Psi_Table_Name    IN Sys.All_Tab_Columns.Table_Name%TYPE,
                             Psi_Column_Name   IN Sys.All_Tab_Columns.Column_Name%TYPE,
                             Psio_Column_Value IN OUT VARCHAR2)
    RETURN BOOLEAN;

  -- Returns random float between [0, 1] */
  FUNCTION f_Random_Float RETURN NUMBER;

  -- Returns an integer between [0, r-1]
  FUNCTION f_Random_Integer(r IN NUMBER) RETURN NUMBER;

  -- Replace all instances of the old token with the new token
  FUNCTION f_Substr(The_String    IN VARCHAR2,
                    The_Old_Token IN VARCHAR2,
                    The_New_Token IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_Commit_Or_Rollback(Pbi_Failed  BOOLEAN,
                                Psi_Context IN Context_String_Type)
    RETURN BOOLEAN;

  FUNCTION f_Clean_Up_Nl_Cr(Psio_String IN OUT VARCHAR2) RETURN BOOLEAN;

  FUNCTION f_Substr2(The_String    IN VARCHAR2,
                     The_Old_Token IN VARCHAR2,
                     The_New_Token IN VARCHAR2) RETURN VARCHAR2;

  PROCEDURE p_Log(Psi_Job_Id IN Ds_Message_Log.Job_Id%TYPE,
                  Psi_Msg    IN Ds_Message_Log.Msg_Body%TYPE);

  PROCEDURE p_Log(Psi_Msg IN Ds_Message_Log.Msg_Body%TYPE);

  PROCEDURE p_Push(Psi_Context IN Context_String_Type); -- Allen Marshall, CS - 1/17/2003 - made context string a global type , added basic protection from stack overflow

  PROCEDURE p_Pop(Psi_Context IN Context_String_Type); -- Allen Marshall, CS - 1/17/2003 - made context string a global type 

  FUNCTION f_Stack RETURN VARCHAR2;

  FUNCTION f_Context RETURN VARCHAR2;

  FUNCTION f_Make_Oracle_Error_4_Testing RETURN BOOLEAN;

  FUNCTION f_Add_Comma(Psi_String IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_Is_Brkey(Psi_Brkey IN Bridge.Brkey%TYPE)
  -- Returns TRUE if the passed string is a valid BRKEY
   RETURN BOOLEAN;

  FUNCTION f_Display_Date_Format RETURN VARCHAR2;

  FUNCTION f_Display_Datetime_Format RETURN VARCHAR2;

  FUNCTION f_To_Date(Pdti_Date IN DATE) RETURN VARCHAR2;

  FUNCTION f_To_Datetime(Pdti_Date IN DATE) RETURN VARCHAR2;

  FUNCTION f_Get_Column_Data_Type(Psi_Table_Name  IN Sys.All_Tab_Columns.Table_Name%TYPE,
                                  Psi_Column_Name IN Sys.All_Tab_Columns.Column_Name%TYPE)
    RETURN Sys.All_Tab_Columns.Data_Type%TYPE;

  FUNCTION f_To_Datetime_String(Pdti_Date IN DATE) RETURN VARCHAR2;

  FUNCTION f_To_Date_String(Pdti_Date IN DATE) RETURN VARCHAR2;

  FUNCTION f_Send_Notification(The_Ds_Job_Id_In IN VARCHAR2,
                               The_Ora_Job_Id   IN PLS_INTEGER)
    RETURN BOOLEAN;

  PROCEDURE p_Log_Last(Psi_Fixed_Part   IN VARCHAR2,
                       Psi_Variant_Part IN VARCHAR2);
  PROCEDURE p_Init_Jobruns_History(p_Jobid           IN Ds_Jobruns_History.Job_Id%TYPE,
                                   p_Ora_Dbms_Job_Id IN Ds_Jobruns_History.Ora_Dbms_Job_Id%TYPE, -- this scheduled JOB ID
                                   p_Jobstatus       IN Ds_Jobruns_History.Job_Status%TYPE,
                                   p_Statmsg         IN Ds_Jobruns_History.Remarks%TYPE);

  PROCEDURE p_Update_Jobruns_History(p_Jobid     IN Ds_Jobruns_History.Job_Id%TYPE,
                                     p_Jobstatus IN Ds_Jobruns_History.Job_Status%TYPE,
                                     p_Statmsg   IN Ds_Jobruns_History.Remarks%TYPE);

  PROCEDURE p_Clean_Jobruns_History; -- use default
  PROCEDURE p_Clean_Jobruns_History(Psi_Ora_Dbms_Jobid IN Ds_Jobruns_History.Ora_Dbms_Job_Id%TYPE); -- delete explicitly

  PROCEDURE p_Snapshot_Changelogs(p_Ora_Dbms_Job_Id IN Ds_Jobruns_History.Ora_Dbms_Job_Id%TYPE -- this scheduled JOB ID
                                  );

  FUNCTION f_Get_Dummy_Ora_Dbms_Jobid(The_Ora_Dbms_Jobid OUT Ds_Jobruns_History.Ora_Dbms_Job_Id%TYPE)
    RETURN BOOLEAN;

  PROCEDURE Documentation; -- Allen Marshall, CS - 1/16/2003 - added

END Ksbms_Util;
/