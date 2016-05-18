CREATE OR REPLACE PACKAGE BODY ksbms_robot.Ksbms_Util IS
  /* Revision history
  
    Hoyt      01/06/2002 Used by p_sql_error() and p_sql_error2()
    Allen     1/8/2002   Declared this in ksbms_msg_info table  and package ksbms_exc as well
    Hoyt      1/8/2002   Added f_now(), f_get_entry_id(), f_get_column_data_type(),
                         f_wrap_data_value(), f_ns()
    Hoyt      02/15/2002 Added upper() to count_rows_for_table()
    Moved to  Emperor on 3/3/2002
    Hoyt      08/07/2002 Modified f_wrap_data_value() to handle a NULL value gracefully
  
    SJH JUN 29, 2005 - Added f_tcp_connect() and p_parse_list() for P_GEN_PONTIS_EMAIL_REPORT stored procedure                    
                       
    -- SEE DOCUMENTATION PROCEDURE!!!!!
  */

  -- Captures the SQLCODE and SQERRM(essage) in p_sql_error()
  Gs_Sql_Error VARCHAR2(4000);
  -- Default(s) from ds_config_coptions are initialized in the package body
  Gb_Raise_Error_On_Failure BOOLEAN;
  Gs_Crlf CONSTANT VARCHAR2(2) := Chr(13) || Chr(10);
  Gs_Cr   CONSTANT VARCHAR2(1) := Chr(13); -- carriage return only                                          
  -- Allen 2002-11-7 forced anchored types here for optionname and optionvalue
  Gs_Failure_Return           CONSTANT ksbms_robot.Ds_Config_Options.Optionvalue%TYPE := '<FAILURE>';
  Gs_Raise_Merge_Error_Option CONSTANT ksbms_robot.Ds_Config_Options.Optionname%TYPE := 'RAISE_MERGE_ERROR';
  -- End: Hoyt 01/06/2001

  -- Allen Marshall, CS - 09/20/2004 - referenced in PONTIS.KSBMS_PONTIS and KSBMS_PONTIS_UTIL
  c_Synch_Dummy_Jobid CONSTANT Ds_Jobruns_History.Ora_Dbms_Job_Id%TYPE := 999;

  -- Hoyt 01/29/2002 Globals for log job_id and context
  -- These set by one of the overloaded  p_log() calls,
  -- and are referenced by another p_log() which does NOT pass these arguments
  g_Uninitialized CONSTANT VARCHAR2(15) := 'UNINITIALIZED';
  g_Job_Id  Ds_Message_Log.Job_Id%TYPE := g_Uninitialized;
  g_Context Ds_Message_Log.Msg_Id%TYPE := g_Uninitialized;
  -- Hoyt 01/29/2002 This is the stack operated upon by p_push() and p_pop()
  -- Allen Marshall, CS -1/17/2003 - made p_push trim stack to this size....
  Gl_Stacksize           PLS_INTEGER := 4000; -- match this and the next line to size the stack
  Gl_Context_String_Size PLS_INTEGER := 255; -- update global context string  type too ( SUBTYPE context_String_type IS VARCHAR2(255); 
  g_Stack                VARCHAR2(4000) := '';

  SUBTYPE Email_Address_Type IS ksbms_robot.Ds_Config_Options.Optionvalue%TYPE;

  TYPE Address_List_Type IS VARRAY(50) OF Email_Address_Type;

  /*   TYPE smtp_connection IS RECORD(
          host            VARCHAR2(255),
          port            PLS_INTEGER,
          private_ctp_con UTL_TCP.connection,
          private_state   PLS_INTEGER
     );
  
     TYPE smtp_reply IS RECORD(
          code       PLS_INTEGER,
          text       VARCHAR2( 508 )
     );
     TYPE smtp_replies IS TABLE of SMTP_reply INDEX BY BINARY_INTEGER; -- multiple reply lines
  */
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;
  g_Notify_List Address_List_Type;
  g_Alert_List  Address_List_Type;
  --message level for processing - set to true for exhaustive diagnostics
  Verbose          BOOLEAN := FALSE; -- all or nothing
  Msglvl_None      PLS_INTEGER := 0;
  Msglvl_Info      PLS_INTEGER := 1;
  Msglvl_Normal    PLS_INTEGER := 1;
  Msglvl_Warning   PLS_INTEGER := 2;
  Msglvl_Sysinfo   PLS_INTEGER := 3;
  Msglvl_Trace     PLS_INTEGER := 4;
  Msglvl_Error     PLS_INTEGER := 5;
  Msglvl_Exception PLS_INTEGER := 6;
  Msglvl_Cutoff    PLS_INTEGER := 1;

  -- in code, pass KSBMS_UTIL.NORMAL etc to a msg-level aware routine, which should
  -- decide whether to put the message into the log or not depending on what
  -- level of message tracking we are running at.
  -- e.g. (for a given call to the logger, with incoming_msg_level) 
  -- if incoming msg_level > package_msg_level then RETURN;

  -- Function and procedure implementations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
  -- <LocalVariable> <Datatype>;
  --begin
  --  <Statement>;
  --  return(<Result>);
  --end;

  --     SJH JUN 29, 2004 - Added for P_GEN_PONTIS_EMAIL_REPORT stored procedure                    
  FUNCTION f_Tcp_Connect(The_Connection OUT Utl_Smtp.Connection,
                         The_Mailhost   OUT Coptions.Optionval%TYPE)
    RETURN BOOLEAN IS
    Lb_Failed BOOLEAN := TRUE;
    -- default is mail unless overridden in configuration table
    -- CS Default is mail.
    Mailhost VARCHAR2(30) := Nvl(Ksbms_Util.f_Get_Coption_Value('MAILHOST'),
                                 'CVO-74F3N01.int.camsys.com');
    -- default is 25 unless overridden in configuration table
    Smtp_Port PLS_INTEGER := Nvl(To_Number(Ksbms_Util.f_Get_Coption_Value('SMTPPORT')),
                                 25);
    /* Allen Marshall, CS, 3/5/2002 - to trap error when package is missing
     This exception is caused when the java support for SMTP and TCP is missing.
     We'll just let the function return TRUE (Failed) in that case.  Programs should trap the result of
     f_email, which calls this function and figure out if the mail could be sent and act accordingly
    */
    Utl_Tcp_Connect_Error EXCEPTION;
    PRAGMA EXCEPTION_INIT(Utl_Tcp_Connect_Error, -29540);
  
  BEGIN
    <<control_Loop>>
    BEGIN
      The_Connection := Utl_Smtp.Open_Connection(Mailhost, Smtp_Port);
      IF The_Connection.Host IS NULL OR The_Connection.Port IS NULL THEN
        Ksbms_Util.p_Log('Mail send failed because the mailer_connect port (usually 25) could not be opened to start a mail conversation - check that SMTP relay host is working');
        RETURN Lb_Failed;
      END IF;
      The_Mailhost := The_Connection.Host; -- we need to know this for the calling context where the actual conversation occurs...
      Lb_Failed    := FALSE; -- SUCCESS!
      RETURN Lb_Failed;
    
    EXCEPTION
      WHEN Utl_Tcp_Connect_Error THEN
        BEGIN
          Ksbms_Util.p_Log(g_Job_Id,
                           'Mail send failed because necessary Oracle built-in packages are not available');
          RETURN Lb_Failed;
        END;
      WHEN OTHERS THEN
        BEGIN
          -- Just log it, don't make a  SQL error for this - handled as 'benign'
          Ksbms_Util.p_Log('Mail send failed because an exception was raised in f_sendmail ' ||
                           SQLERRM);
          RETURN Lb_Failed;
        END;
    END;
  END f_Tcp_Connect;

  --     SJH JUN 29, 2004 - Added for P_GEN_PONTIS_EMAIL_REPORT stored procedure                    
  PROCEDURE p_Parse_List(The_List_In      IN OUT VARCHAR2,
                         The_Delimiter_In IN VARCHAR2 := ',',
                         The_Cell_Limit   IN PLS_INTEGER := 500,
                         The_Array        OUT Generic_List_Type)
  
   IS
  
    Ith         PLS_INTEGER := 1;
    Li_Startpos PLS_INTEGER;
    Li_Endpos   PLS_INTEGER;
    Li_Last     PLS_INTEGER;
    Ls_Token    VARCHAR2(80);
  BEGIN
    The_Array := Generic_List_Type();
  
    LOOP
      <<control_Loop>>
      IF The_List_In IS NULL OR Length(The_List_In) = 0 THEN
        EXIT;
      END IF;
    
      -- kill leading delimiters if any,
      -- this may null out the list
      LOOP
        EXIT WHEN Substr(The_List_In, 1, 1) <> The_Delimiter_In OR Length(The_List_In) = 0 OR The_List_In IS NULL;
        The_List_In := TRIM(Substr(The_List_In, 2, Length(The_List_In)));
      END LOOP;
    
      -- EXCEPTION!!!
      IF The_List_In IS NULL THEN
        EXIT; -- control_loop;
      END IF;
    
      -- kill any pointless trailing delimiters
      Li_Last := Length(The_List_In);
      LOOP
        EXIT WHEN Substr(The_List_In, Li_Last, 1) <> The_Delimiter_In;
        BEGIN
          The_List_In := Substr(The_List_In, 1, Li_Last - 1);
          Li_Last     := Length(The_List_In);
        END;
      END LOOP;
    
      Ith         := 1;
      Li_Startpos := 1;
      Li_Endpos   := Instr(The_List_In, The_Delimiter_In, 1);
    
      IF Li_Endpos > 0 THEN
      
        -- kill double delimiters e.g. ,,
        LOOP
          EXIT WHEN Instr(The_List_In,
                          The_Delimiter_In || The_Delimiter_In,
                          1) = 0;
          The_List_In := REPLACE(The_List_In,
                                 The_Delimiter_In || The_Delimiter_In,
                                 The_Delimiter_In);
        END LOOP;
      
        -- nothing left but a delimiter?         
        IF Length(The_List_In) = 1 AND The_List_In = The_Delimiter_In THEN
          EXIT;
        END IF;
      
        LOOP
          -- extract string token
          Ls_Token := Substr(The_List_In,
                             Li_Startpos,
                             Li_Endpos - Li_Startpos);
          The_Array.Extend;
          The_Array(Ith) := Ls_Token;
        
          Dbms_Output.Put_Line('Token ' || Ls_Token);
          Ith := Ith + 1;
        
          IF Ith > The_Cell_Limit THEN
            EXIT;
          END IF; -- only 500 cells for destination 
        
          -- reset start with next token                 
        
          Li_Startpos := Li_Endpos + 1;
        
          IF Li_Startpos > Length(The_List_In) THEN
            EXIT;
          END IF;
        
          -- see if there is another token (another , )                
          Li_Endpos := Instr(The_List_In, The_Delimiter_In, 1, Ith);
          EXIT WHEN Li_Endpos = 0; -- no more commas or the_delimiter_In
        END LOOP;
      
        IF Ith > 1 AND Ith <= The_Cell_Limit THEN
          -- get the last token 
          BEGIN
            The_Array.Extend;
            Li_Last := Length(The_List_In) + 1 - Li_Startpos;
            Ls_Token := TRIM(Substr(The_List_In, Li_Startpos, Li_Last));
            The_Array(Ith) := Ls_Token;
            Dbms_Output.Put_Line('Token ' || Ls_Token);
          END;
        END IF;
      
      ELSE
      
        The_Array.Extend;
        The_Array(1) := The_List_In;
        Dbms_Output.Put_Line('Token ' || The_List_In);
      
      END IF;
    
      EXIT WHEN TRUE;
    END LOOP Control_Loop;
  
    --RETURN the_array;
  
  END p_Parse_List;

  -- ASSERTIONS -ARM 1/9/2002
  PROCEDURE Istrue(Condition_In       IN BOOLEAN,
                   Message_In         IN VARCHAR2,
                   Raise_Exception_In IN BOOLEAN := TRUE,
                   Exception_In       IN VARCHAR2 := 'VALUE_ERROR') IS
  BEGIN
    IF NOT Condition_In -- is true
       OR Condition_In IS NULL THEN
      Pl('Assertion Failure!');
      Pl(Message_In);
      Pl('');
    
      IF Raise_Exception_In THEN
        EXECUTE IMMEDIATE 'BEGIN RAISE ' || Exception_In || '; END;';
      END IF;
    END IF;
  END Istrue;

  PROCEDURE Isnotnull(Value_In           IN VARCHAR2,
                      Message_In         IN VARCHAR2,
                      Raise_Exception_In IN BOOLEAN := TRUE,
                      Exception_In       IN VARCHAR2 := 'VALUE_ERROR') IS
  BEGIN
    Istrue(Value_In IS NOT NULL,
           Message_In,
           Raise_Exception_In,
           Exception_In);
  END Isnotnull;

  PROCEDURE Isnotnull(Value_In           IN DATE,
                      Message_In         IN VARCHAR2,
                      Raise_Exception_In IN BOOLEAN := TRUE,
                      Exception_In       IN VARCHAR2 := 'VALUE_ERROR') IS
  BEGIN
    Istrue(Value_In IS NOT NULL,
           Message_In,
           Raise_Exception_In,
           Exception_In);
  END Isnotnull;

  PROCEDURE Isnotnull(Value_In           IN NUMBER,
                      Message_In         IN VARCHAR2,
                      Raise_Exception_In IN BOOLEAN := TRUE,
                      Exception_In       IN VARCHAR2 := 'VALUE_ERROR') IS
  BEGIN
    Istrue(Value_In IS NOT NULL,
           Message_In,
           Raise_Exception_In,
           Exception_In);
  END Isnotnull;

  PROCEDURE Isnotnull(Value_In           IN BOOLEAN,
                      Message_In         IN VARCHAR2,
                      Raise_Exception_In IN BOOLEAN := TRUE,
                      Exception_In       IN VARCHAR2 := 'VALUE_ERROR') IS
  BEGIN
    Istrue(Value_In IS NOT NULL,
           Message_In,
           Raise_Exception_In,
           Exception_In);
  END Isnotnull;

  -- assert that string argument is a number, or raise exception
  PROCEDURE Isnumber(Stringarg_In       IN VARCHAR2,
                     Message_In         IN VARCHAR2,
                     Raise_Exception_In IN BOOLEAN := TRUE,
                     Exception_In       IN VARCHAR2 := 'VALUE_ERROR') IS
  BEGIN
    Istrue(Isnumber(Stringarg_In),
           Message_In,
           Raise_Exception_In,
           Exception_In);
  END Isnumber;

  FUNCTION Get_Object_Owner(Name_In IN VARCHAR2)
    RETURN Sys.All_Objects.Owner%TYPE IS
    SCHEMA        Sys.All_Objects.Owner%TYPE;
    Part1         VARCHAR2(100);
    Part2         VARCHAR2(100);
    Dblink        VARCHAR2(100);
    Part1_Type    NUMBER;
    Object_Number NUMBER;
    Object_Does_Not_Exist EXCEPTION; -- trap -6564 (Oracle 8i)
    -- return some kind of reasonable message for the situation where
    -- the passed object name does not exist
    PRAGMA EXCEPTION_INIT(Object_Does_Not_Exist, -06564);
  BEGIN
    /* Break down the name into its components */
    Dbms_Utility.Name_Resolve(Name_In,
                              1,
                              SCHEMA,
                              Part1,
                              Part2,
                              Dblink,
                              Part1_Type,
                              Object_Number);
    RETURN SCHEMA;
  EXCEPTION
    WHEN Object_Does_Not_Exist THEN
      RETURN NULL;
  END Get_Object_Owner;

  FUNCTION Display_Zero_As_Label(The_Arg        IN PLS_INTEGER,
                                 The_Format     IN VARCHAR2,
                                 The_Zero_Label IN VARCHAR2) RETURN VARCHAR2 IS
    Ls_Ret VARCHAR2(80) := The_Zero_Label;
  BEGIN
    IF The_Arg > 0 THEN
      Ls_Ret := To_Char(The_Arg, The_Format);
    END IF;
  
    RETURN Ls_Ret;
  END Display_Zero_As_Label;

  FUNCTION Sq(String_Arg IN VARCHAR2) -- enclose in quotes
   RETURN VARCHAR2 IS
    Ls_Temp VARCHAR2(4000);
    --   ARMarshall, CS, 1/15/2001. Changed sq and dq functions to have 4K string buffers, max for VARCHAR2 variables
  BEGIN
    Ls_Temp := TRIM('''' || String_Arg || '''');
    RETURN Ls_Temp;
  END;

  FUNCTION Dq(String_Arg IN VARCHAR2) -- enclose in dquotes
   RETURN VARCHAR2 IS
    Ls_Temp VARCHAR2(4000);
    --   ARMarshall, CS, 1/15/2001. Changed sq and dq functions to have 4K string buffers, max for VARCHAR2 variables
  BEGIN
    Ls_Temp := TRIM('"' || String_Arg || '"');
    RETURN Ls_Temp;
  END;

  FUNCTION Isnumber(The_Token_In IN VARCHAR2) RETURN BOOLEAN IS
    Ll_Numtest NUMBER;
  BEGIN
    Ll_Numtest := The_Token_In; -- raise exception if this fails
    RETURN TRUE;
  EXCEPTION
    WHEN Value_Error THEN
      -- must be a string, so wrap with quotes
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE;
  END Isnumber;

  FUNCTION f_Set_Msg_Level(The_Msg_Level IN BOOLEAN := FALSE) RETURN BOOLEAN IS
  BEGIN
    Verbose := Nvl(The_Msg_Level, FALSE);
    RETURN Verbose;
  END;

  FUNCTION f_Set_Msg_Level(The_Msg_Level IN VARCHAR2 := 'VERBOSE')
    RETURN BOOLEAN IS
  BEGIN
    Verbose := (Upper(The_Msg_Level) = 'VERBOSE');
    RETURN Verbose;
  END;

  FUNCTION f_Get_Delta_Tolerance(Ptab IN All_Tab_Cols.Table_Name%TYPE,
                                 Pcol IN All_Tab_Cols.Column_Name%TYPE)
    RETURN DOUBLE PRECISION IS
    RESULT DOUBLE PRECISION;
  BEGIN
  
    SELECT d.Transfer_Delta_Value
      INTO RESULT
      FROM Ds_Transfer_Delta_Tolerances d
     INNER JOIN Ds_Transfer_Map Dstm
        ON d.Exchange_Rule_Id = Dstm.Exchange_Rule_Id
       AND Lower(Dstm.Table_Name) = Lower(Ptab)
       AND Lower(Dstm.Column_Name) = Lower(Pcol)
     WHERE d.Tolerance_Chk_Status = 1;
    RETURN RESULT;
  
  EXCEPTION
    WHEN No_Data_Found THEN
      RETURN NULL;
    WHEN OTHERS THEN
      RAISE;
    
  END f_Get_Delta_Tolerance;


  FUNCTION f_Get_Verbose RETURN BOOLEAN IS
  BEGIN
    RETURN Verbose;
  END f_Get_Verbose;

  FUNCTION f_Get_Coption_Value(Opt_Name IN ksbms_robot.Ds_Config_Options.Optionname%TYPE)
    RETURN ksbms_robot.Ds_Config_Options.Optionvalue%TYPE IS
    RESULT ksbms_robot.Ds_Config_Options.Optionvalue%TYPE;
  BEGIN
    LOOP
      -- get the option value for the opt_name, which must be
      -- upperized as all optionname values are upperized.
      /* ARM JAN 2, 2001 - FIXED TABLE NAME */
      SELECT Optionvalue
        INTO RESULT
        FROM ksbms_robot.Ds_Config_Options
       WHERE Optionname = Upper(Opt_Name);
    
      RETURN(RESULT);
      EXIT WHEN TRUE;
    END LOOP;
  EXCEPTION
    WHEN No_Data_Found THEN
      RETURN NULL;
    WHEN OTHERS THEN
      RETURN NULL;
  END f_Get_Coption_Value;

  FUNCTION f_Set_Coption_Value(Opt_Name IN ksbms_robot.Ds_Config_Options.Optionname%TYPE,
                               /* ARM JAN 2, 2001 - FIXED TABLE NAME */
                               Opt_Val IN ksbms_robot.Ds_Config_Options.Optionvalue%TYPE
                               /* ARM JAN 2, 2001 - FIXED TABLE NAME */)
    RETURN BOOLEAN
  -- function returns FALSE on success, TRUE on FAILURE
   IS
    Lb_Failed BOOLEAN := TRUE; -- assume failure
  BEGIN
    LOOP
      UPDATE ksbms_robot.Ds_Config_Options
         SET Optionvalue = Opt_Val
       WHERE Optionname = Upper(Opt_Name);
    
      COMMIT;
      -- success!
      Lb_Failed := FALSE;
      EXIT WHEN TRUE;
    END LOOP;
  
    RETURN Lb_Failed;
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        ROLLBACK;
      END;
    
      RETURN Lb_Failed;
  END f_Set_Coption_Value;

  FUNCTION f_Insert_Coption(Opt_Name IN ksbms_robot.Ds_Config_Options.Optionname%TYPE,
                            /* ARM JAN 2, 2001 - FIXED TABLE NAME */
                            Opt_Val IN ksbms_robot.Ds_Config_Options.Optionvalue%TYPE
                            /* ARM JAN 2, 2001 - FIXED TABLE NAME */)
    RETURN BOOLEAN
  -- function returns FALSE on success, TRUE on FAILURE
   IS
    Lb_Failed BOOLEAN := TRUE; -- assume failure
  BEGIN
    LOOP
      INSERT INTO ksbms_robot.Ds_Config_Options
        (Optionname, Optionvalue)
      VALUES
        (Upper(Opt_Name), Opt_Val);
    
      COMMIT;
      Lb_Failed := FALSE;
      EXIT WHEN TRUE;
    END LOOP;
  
    RETURN Lb_Failed;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN Lb_Failed;
  END f_Insert_Coption;

  FUNCTION f_Parse_Mailing_List(The_List_In IN Email_List_Type)
    RETURN Address_List_Type IS
    Ls_Addr     Email_Address_Type;
    Lv_Result   Address_List_Type := Address_List_Type(); -- initialize to EMPTY ( not null );
    Ith         PLS_INTEGER := 1;
    Li_Startpos PLS_INTEGER;
    Li_Endpos   PLS_INTEGER;
    Li_Last     PLS_INTEGER;
  BEGIN
    LOOP
    
      <<control_Loop>>
      IF The_List_In IS NULL THEN
        EXIT;
      END IF;
    
      Ith         := 1;
      Li_Startpos := 1;
      Li_Endpos   := Instr(The_List_In, ',', 1);
    
      IF Li_Endpos > 0 THEN
        LOOP
          -- extract string token
          Lv_Result.Extend;
          Lv_Result(Ith) := Substr(The_List_In,
                                   Li_Startpos,
                                   Li_Endpos - Li_Startpos);
          Ith := Ith + 1;
        
          IF Ith > 50 THEN
            EXIT;
          END IF; -- only 50 cells for destination addresses  
        
          -- reset start with next token                 
        
          Li_Startpos := Li_Endpos + 1;
        
          IF Li_Startpos > Length(The_List_In) THEN
            EXIT;
          END IF;
        
          -- see if there is another token (another , )                
          Li_Endpos := Instr(The_List_In, ',', 1, Ith);
          EXIT WHEN Li_Endpos = 0; -- no more commas
        END LOOP;
      
        IF Ith > 1 THEN
          BEGIN
            Lv_Result.Extend;
            Li_Last := Length(The_List_In) + 1 - Li_Startpos;
            Ls_Addr := TRIM(Substr(The_List_In, Li_Startpos, Li_Last));
            Lv_Result(Ith) := Ls_Addr;
          END;
        END IF;
      ELSE
        Lv_Result.Extend;
        Lv_Result(1) := The_List_In;
      END IF;
    
      EXIT WHEN TRUE;
    END LOOP Control_Loop;
  
    RETURN Lv_Result;
  END;

  PROCEDURE Gen_Mail_Header(The_Subject_In   IN VARCHAR2,
                            The_Address_List IN Email_List_Type,
                            The_Sender_In    IN VARCHAR2,
                            The_Header_Out   OUT VARCHAR2) IS
    Ls_Header  VARCHAR2(1000);
    Ls_Datestr VARCHAR2(30);
    Crlf       VARCHAR2(2) := Chr(13) || Chr(10);
  BEGIN
    SELECT To_Char(SYSDATE, 'DY, DD MON YYYY HH24:MI:SS') ||
           Nvl(f_Get_Coption_Value('TIMEZONE'), 'CST')
      INTO Ls_Datestr
      FROM Dual;
  
    Ls_Header      := 'Date:  ' || Ls_Datestr || Crlf;
    Ls_Header      := Ls_Header || 'From:  ' ||
                      Nvl(The_Sender_In, 'nobody') || Crlf;
    Ls_Header      := Ls_Header || 'To:  ' ||
                      Nvl(The_Address_List, 'nobody') || Crlf;
    Ls_Header      := Ls_Header || 'Subject:  '
                     --                      || 'KSBMS_UTIL: ' -- Commented out by ARM 2002.01.02
                      || Nvl(The_Subject_In, 'no subject') || Crlf;
    Ls_Header      := Ls_Header || 'CC:' || Crlf;
    Ls_Header      := Ls_Header || 'Comment:  ' ||
                      'Generated by KSBMS_UTIL auto-notify' || Crlf;
    The_Header_Out := Ls_Header;
  END Gen_Mail_Header;

  FUNCTION f_Sendmail(The_List    IN Email_List_Type,
                      The_Message IN VARCHAR2,
                      The_Subject IN VARCHAR2,
                      The_Mode    IN VARCHAR2) RETURN BOOLEAN IS
    Lb_Failed      BOOLEAN := TRUE; -- TRUE = FAILURE
    Mailer_Connect Utl_Smtp.Connection;
    -- default is mail unless overridden in configuration table
    -- CS Default is mail.
    Mailhost VARCHAR2(30) := Nvl(f_Get_Coption_Value('MAILHOST'),
                                 'deb@ksdot.org');
    -- default is 25 unless overridden in configuration table
    Smtp_Port    PLS_INTEGER := Nvl(To_Number(f_Get_Coption_Value('SMTPPORT')),
                                    25);
    Ith          PLS_INTEGER := 0;
    Ls_Header    VARCHAR2(1000); -- 3/5/2002 was too small
    Crlf         VARCHAR2(8) := Chr(13) || Chr(10);
    Ls_Sender    Email_List_Type := Nvl(f_Get_Coption_Value('POSTMASTER'),
                                        'deb@ksdot.org');
    Mailing_List Address_List_Type := f_Parse_Mailing_List(The_List);
    Ls_Context   Context_String_Type := 'f_sendmail()';
    /* Allen Marshall, CS, 3/5/2002 - to trap error when package is missing
     This exception is caused when the java support for SMTP and TCP is missing.
     We'll just let the function return TRUE (Failed) in that case.  Programs should trap the result of
     f_email, which calls this function and figure out if the mail could be sent and act accordingly
    */
    Utl_Tcp_Connect_Error EXCEPTION;
    PRAGMA EXCEPTION_INIT(Utl_Tcp_Connect_Error, -29540);
  BEGIN
    p_Push(Ls_Context);
  
    LOOP
    
      <<control_Loop>>
      BEGIN
        Mailer_Connect := Utl_Smtp.Open_Connection(Mailhost, Smtp_Port);
      
        IF Mailer_Connect.Host IS NULL OR Mailer_Connect.Port IS NULL THEN
          p_Log('Mail send failed because the mailer_connect port (usually 25) could not be opened to start a mail conversation - check that SMTP relay host is working');
          EXIT;
        END IF;
      EXCEPTION
        WHEN Utl_Tcp_Connect_Error THEN
          BEGIN
            p_Log(g_Job_Id,
                  'Mail send failed because necessary Oracle built-in packages are not available');
            EXIT; -- get out of the control loop and return
          END;
        WHEN OTHERS THEN
          BEGIN
            -- Just log it, don't make a  SQL error for this - handled as 'benign'
            p_Log('Mail send failed because an exception was raised in f_sendmail ' ||
                  SQLERRM);
            EXIT; -- get out of the control loop and return
          END;
      END;
    
      Utl_Smtp.Helo(Mailer_Connect, Mailhost);
      Utl_Smtp.Mail(Mailer_Connect, Ls_Sender);
    
      IF Mailing_List.Count > 1 THEN
        FOR Ith IN Mailing_List.First .. Mailing_List.Last LOOP
          Utl_Smtp.Rcpt(Mailer_Connect, Mailing_List(Ith));
        END LOOP;
      ELSE
        Utl_Smtp.Rcpt(Mailer_Connect, Mailing_List(1));
      END IF;
    
      -- format a nice header for the e-mail message             
      Gen_Mail_Header(The_Subject, The_List, Ls_Sender, Ls_Header);
      Utl_Smtp.Data(Mailer_Connect,
                    Nvl(Ls_Header, Crlf) || Crlf || The_Message);
      Utl_Smtp.Quit(Mailer_Connect);
      Lb_Failed := FALSE; -- success
      EXIT WHEN TRUE;
    END LOOP Control_Loop;
  
    p_Pop(Ls_Context);
    RETURN Lb_Failed;
  EXCEPTION
    WHEN OTHERS THEN
      p_Pop(Ls_Context);
      RETURN Lb_Failed;
    
  END f_Sendmail;

  FUNCTION f_Email(The_List    IN Email_List_Type,
                   The_Message IN VARCHAR2,
                   The_Subject IN VARCHAR2) RETURN BOOLEAN IS
    Lb_Failed BOOLEAN := TRUE;
    The_Mode  VARCHAR2(10) := c_Plaintextbody;
  BEGIN
    Lb_Failed := f_Sendmail(The_List, The_Message, The_Subject, The_Mode);
    RETURN Lb_Failed;
  END f_Email;

  FUNCTION f_Email(The_List    IN Email_List_Type,
                   The_Message IN VARCHAR2,
                   The_Subject IN VARCHAR2,
                   The_Mode    IN VARCHAR2) RETURN BOOLEAN IS
    Lb_Failed BOOLEAN := TRUE;
  BEGIN
    Lb_Failed := f_Sendmail(The_List, The_Message, The_Subject, The_Mode);
    RETURN Lb_Failed;
  END f_Email;

  FUNCTION f_Xmlemail(The_List       IN Email_List_Type,
                      The_Xmlmessage IN VARCHAR2,
                      The_Subject    IN VARCHAR2) RETURN BOOLEAN IS
    Lb_Failed BOOLEAN := TRUE;
    The_Mode  VARCHAR2(10) := c_Xmlbody;
  BEGIN
    Lb_Failed := f_Sendmail(The_List, The_Xmlmessage, The_Subject, The_Mode);
    RETURN Lb_Failed;
  END;

  FUNCTION f_Get_Table_Owner(Name_In IN Sys.All_Tables.Table_Name%TYPE)
    RETURN Sys.All_Tables.Owner%TYPE IS
    Ls_Result Sys.All_Tables.Owner%TYPE;
  BEGIN
    SELECT Owner
      INTO Ls_Result
      FROM Sys.All_Tables
     WHERE Table_Name = Upper(Name_In);
  
    RETURN Ls_Result;
  EXCEPTION
    WHEN Too_Many_Rows THEN
      RETURN 'XMULTIPLE_REFSX';
    WHEN No_Data_Found THEN
      RETURN NULL;
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  FUNCTION f_Is_Table(Name_In IN Sys.All_Tables.Table_Name%TYPE)
    RETURN BOOLEAN IS
    Ls_Retval Sys.All_Tables.Owner%TYPE;
    Lb_Result BOOLEAN := FALSE;
  BEGIN
    Ls_Retval := f_Get_Table_Owner(Name_In);
  
    IF Ls_Retval IS NOT NULL THEN
      Lb_Result := TRUE;
    END IF;
  
    RETURN Lb_Result;
  END f_Is_Table;

  FUNCTION f_Get_View_Owner(Name_In IN Sys.All_Views.View_Name%TYPE)
    RETURN Sys.All_Views.Owner%TYPE IS
    Ls_Result Sys.All_Views.Owner%TYPE;
  BEGIN
    SELECT Owner
      INTO Ls_Result
      FROM Sys.All_Views
     WHERE View_Name = Upper(Name_In);
  
    RETURN Ls_Result;
  EXCEPTION
    WHEN Too_Many_Rows THEN
      RETURN 'XMULTIPLE_REFSX';
    WHEN No_Data_Found THEN
      RETURN NULL;
    WHEN OTHERS THEN
      RETURN NULL;
  END f_Get_View_Owner;

  FUNCTION Try_Isnumber(The_Token_In IN VARCHAR2) RETURN BOOLEAN IS
    Ll_Numtest NUMBER;
  BEGIN
    IF TRIM(The_Token_In) IS NULL THEN
      RETURN FALSE;
    END IF;
    Ll_Numtest := TRIM(The_Token_In) + 0; -- raises an exception if this assignment fails
    RETURN TRUE;
  EXCEPTION
    WHEN Value_Error THEN
      -- conversion failed, which is what we were testing for   
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE;
  END Try_Isnumber;
  FUNCTION f_Isnumber(The_Token_In IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN Try_Isnumber(The_Token_In);
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END f_Isnumber;
  FUNCTION f_Is_View(Name_In IN Sys.All_Views.View_Name%TYPE) RETURN BOOLEAN IS
    Ls_Retval Sys.All_Views.Owner%TYPE;
    Lb_Result BOOLEAN := FALSE;
  BEGIN
    Ls_Retval := f_Get_View_Owner(Name_In);
  
    IF Ls_Retval IS NOT NULL THEN
      Lb_Result := TRUE;
    END IF;
  
    RETURN Lb_Result;
  END f_Is_View;

  FUNCTION f_Get_Object_Owner(Name_In IN VARCHAR2)
  -- Using DBMS_UTILITY.NAME_RESOLVE, we can retrieve schema owner for
    -- the (Pontis) BRDESCRP table, which should be authoritative.
  
   RETURN Sys.All_Objects.Owner%TYPE IS
    SCHEMA        Sys.All_Objects.Owner%TYPE;
    Part1         VARCHAR2(100);
    Part2         VARCHAR2(100);
    Dblink        VARCHAR2(100);
    Part1_Type    NUMBER;
    Object_Number NUMBER;
    Object_Does_Not_Exist EXCEPTION; -- trap -6564 (Oracle 8i)
    -- return some kind of reasonable message for the situation where
    -- the passed object name does not exist
    PRAGMA EXCEPTION_INIT(Object_Does_Not_Exist, -06564);
  BEGIN
    /* Break down the name into its components */
    Dbms_Utility.Name_Resolve(Name_In,
                              1,
                              SCHEMA,
                              Part1,
                              Part2,
                              Dblink,
                              Part1_Type,
                              Object_Number);
    RETURN SCHEMA;
  EXCEPTION
    WHEN Object_Does_Not_Exist THEN
      BEGIN
        SELECT Owner
          INTO SCHEMA
          FROM Sys.All_Objects
         WHERE Object_Name = Upper(Name_In);
      
        RETURN SCHEMA;
      EXCEPTION
        WHEN Too_Many_Rows THEN
          Dbms_Output.Put_Line('Object ' || Name_In ||
                               ' has multiple instances...');
          RETURN NULL;
        WHEN No_Data_Found THEN
          Dbms_Output.Put_Line('Object ' || Name_In || ' Not Found');
          RETURN NULL;
        WHEN OTHERS THEN
          Dbms_Output.Put_Line('Object ' || Name_In || ' caused an error');
          RETURN NULL;
      END;
  END f_Get_Object_Owner;

  FUNCTION f_Get_Msg_Level RETURN PLS_INTEGER IS
  BEGIN
    RETURN Msglvl_Cutoff;
  END;

  FUNCTION Iscolumn(The_Table  IN Sys.All_Tab_Columns.Table_Name%TYPE,
                    The_Column IN Sys.All_Tab_Columns.Column_Name%TYPE)
    RETURN BOOLEAN -- FALSE MEANS NOT A COLUMN!!
   IS
    Ll_Dummy Sys.All_Tab_Columns.Column_Id%TYPE;
  BEGIN
    SELECT Column_Id
      INTO Ll_Dummy
      FROM Sys.All_Tab_Columns
     WHERE Table_Name = Upper(TRIM(The_Table))
       AND Column_Name = Upper(TRIM(The_Column));
  
    IF Ll_Dummy IS NOT NULL THEN
      RETURN TRUE;
    END IF;
  EXCEPTION
    WHEN Too_Many_Rows THEN
      RETURN TRUE; -- too many is okay, but impossible.
    WHEN No_Data_Found THEN
      RETURN FALSE;
    WHEN OTHERS THEN
      RETURN FALSE;
  END Iscolumn;

  FUNCTION Istable(The_Table IN Sys.All_Tables.Table_Name%TYPE)
    RETURN BOOLEAN -- FALSE MEANS NOT A TABLE!!
   IS
    Ls_Dummy Sys.All_Tables.Table_Name%TYPE;
  BEGIN
    SELECT Table_Name
      INTO Ls_Dummy
      FROM Sys.All_Tables
     WHERE Table_Name = Upper(TRIM(The_Table));
  
    IF Ls_Dummy IS NOT NULL THEN
      RETURN TRUE;
    END IF;
  EXCEPTION
    WHEN Too_Many_Rows THEN
      RETURN TRUE; -- too many is okay, but impossible.
    WHEN No_Data_Found THEN
      RETURN FALSE;
    WHEN OTHERS THEN
      RETURN FALSE;
  END Istable;

  FUNCTION Istableorview(The_Table IN Sys.All_Tables.Table_Name%TYPE)
    RETURN BOOLEAN -- FALSE MEANS NOT A TABLE!!
   IS
    Ls_Dummy Sys.All_Tables.Table_Name%TYPE;
  BEGIN
    -- first see if it is a table, then check if it is a view.
    IF NOT Istable(The_Table) THEN
      SELECT View_Name
        INTO Ls_Dummy
        FROM Sys.All_Views
       WHERE View_Name = Upper(TRIM(The_Table));
    
      IF Ls_Dummy IS NOT NULL THEN
        RETURN TRUE;
      END IF;
    ELSE
      RETURN TRUE;
    END IF;
  EXCEPTION
    WHEN Too_Many_Rows THEN
      RETURN TRUE; -- too many is okay, but impossible.
    WHEN No_Data_Found THEN
      RETURN FALSE;
    WHEN OTHERS THEN
      RETURN FALSE;
  END Istableorview;

  /* These wrappers can be used to avoid always
     prefacing the calls with 'ksbms_util.'
  
  ----------------------------------------------------------------
  -- Wrappers for functions in the ksbms_util and ksbms_fw package
  ----------------------------------------------------------------
  procedure p_add_msg (psi_msg in varchar2)
  is
  begin
     ksbms_util.p_add_msg (psi_msg);
  end p_add_msg;
  
  procedure p_bug (psi_msg in varchar2)
  is
  begin
     ksbms_util.p_bug (psi_msg);
  end p_bug;
  
  procedure p_clean_up_after_raise_error (psi_context in context_string_type)
  is
  begin
     ksbms_util.p_clean_up_after_raise_error (psi_context);
  end p_clean_up_after_raise_error;
  
  procedure p_sql_error (psi_msg in varchar2)
  is
  begin
     ksbms_util.p_sql_error (psi_msg);
  end p_sql_error;
  
  procedure p_sql_error2 (psi_msg in varchar2)
  is
  begin
    ksbms_util.p_sql_error2 (psi_msg);
  end p_sql_error2;
  
  procedure pl (psi_msg in varchar2)
  is
  BEGIN
     -- NB: In ksbms_fw, not ksbms_util
     ksbms_fw.pl (psi_msg);
  end pl; -- END: Wrappers
  */
  PROCEDURE p_Add_Msg(Psi_Msg IN VARCHAR2)
  -- Hoyt 01/06/2001
    -- Append psi_msg to the global string that will be returned to the invoking procedure
   IS
    Ll_Msglen PLS_INTEGER := 0;
    Ls_Msg    VARCHAR2(8192); -- gi_email_length cannot be substituted here?!
    --PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    -- Clean up the message
    -- Allen Marshall, CS - 2003-03-06 - TRIM
    Ls_Msg := TRIM(Psi_Msg); -- So we can modify it
  
    IF f_Clean_Up_Nl_Cr(Ls_Msg) THEN
      Pl('f_clean_up_nl_cr() failed with message ''' || Ls_Msg || '''');
    END IF;
  
    -- Do not display null or empty strings
    IF f_Ns(Ls_Msg) THEN
      RETURN;
    END IF;
  
    -- Check to see if the message is going to be too long
    -- Allen Marshall, CS - 2003-03-06
    -- incorporate cr
    -- Allen Marshall, CS - 2003.04.13 - changed to TRIM
    Ll_Msglen := Length(TRIM(Gs_Email_Msg) || Gs_Crlf) +
                 Length(TRIM(Ls_Msg));
  
    IF Ll_Msglen > Gi_Email_Length THEN
      -- This will indicate the overflow problem
      Gs_Email_Msg := Substr(TRIM(Gs_Email_Msg), 1, Gi_Email_Length - 10) ||
                      ' TOO LONG!';
    ELSE
      -- Accumulate the msg, each msg on its own line
    
      Gs_Email_Msg := TRIM(TRIM(Gs_Email_Msg) || TRIM(Ls_Msg) || Gs_Crlf);
    END IF;
  
    -- Log the message too
    p_Log(Ls_Msg);
  END p_Add_Msg;

  PROCEDURE p_Bug(Psi_Msg IN VARCHAR2)
  -- Hoyt 01/14/2001
    -- PREPEND 'Bug: ' to psi_message, then
    -- append psi_msg to the global string that will be returned to the invoking procedure.
    -- This is identical to p_add_msg() accept it prepends 'Bug: '.
   IS
  BEGIN
    -- Just pass it along to the usual, with "Bug" to highlight that it's NOT expected
    p_Log('Bug: ' || Psi_Msg);
  END p_Bug;

  PROCEDURE p_Sql_Error(Psi_Context IN Context_String_Type)
  -- Hoyt 01/06/2001
    -- Append psi_context PLUS the SQLCODE and SQLERRM(essage) 
    -- to the global string that will be returned to the invoking procedure,
    -- and also to the message that will be e-mailed 
   IS
    Ls_Error VARCHAR2(2000);
  BEGIN
    -- Call the variant (which doesn't do a RAISE) to form and add the message
    p_Sql_Error2(Psi_Context);
    -- Raise an error (which may or may not be handled)
    RAISE Generic_Exception;
  END p_Sql_Error;

  PROCEDURE p_Sql_Error2(Psi_Context IN Context_String_Type)
  -- Hoyt 01/06/2001
    -- Variant 2 does NOT raise an error.
    -- Call this version in wrap-up code, e.g. when doing your
    -- final clean-up (rollback, commit) at the bottom of your code.
   IS
    Ls_Error   VARCHAR2(2000);
    Ls_Sqlerrm VARCHAR2(2000);
    Ls_End     VARCHAR2(2000);
    Ll_Pos     PLS_INTEGER;
  BEGIN
    -- Build the error string: context + SQL result
    Ls_Error := Psi_Context;
    -- Remove any redundant message
    Ls_Sqlerrm := SQLERRM;
    -- The newline delimits the repetition of the error?!
    Ll_Pos := Instr(Ls_Sqlerrm, Chr(10));
  
    IF Ll_Pos > 0 THEN
      Ls_End := Substr(Ls_Sqlerrm, Ll_Pos + 1);
    
      IF Instr(Ls_Sqlerrm, Ls_End) > 0 THEN
        -- Truncate at the second newline
        Ls_Sqlerrm := Substr(Ls_Sqlerrm, 1, Ll_Pos - 1);
      END IF;
    END IF;
  
    -- Do NOT add SQLERRM if it is 'successful completion' (meaningless)
    IF Instr(Ls_Sqlerrm, 'successful completion') = 0 AND
       Instr(Ls_Error, SQLERRM) = 0 -- Somehow it was getting in there twice?!
     THEN
      Ls_Error := Gs_Crlf || 'EXCEPTION RAISED: ' || Ls_Sqlerrm -- Includes the SQLCODE, kind of
                  || Gs_Crlf || Ls_Error;
    END IF;
  
    -- Capture the error in the global string (accumulating it)
    Gs_Sql_Error := Gs_Sql_Error || Ls_Error;
  
    -- Clean up the message
    IF f_Clean_Up_Nl_Cr(Ls_Error) THEN
      p_Bug('Bad SQL error passed to f_clean_up_nl_cr() in p_clean_up_after_raise_error');
    ELSE
      -- Log the SQL error message
      p_Log(Ls_Error);
    END IF;
    -- Allen Marshall, CS - 2003.03.06 - this is supposed to turn off the  logging of the message
    -- Do NOT add the error to the mail message
    p_Add_Msg(Ls_Error);
  END p_Sql_Error2;

  PROCEDURE p_Sql_Error3(Psi_Context IN Context_String_Type)
  -- Hoyt 01/06/2001
    -- Variant 3 does NOT raise an error, does not add the error to gs_sql_error, thereby keeping the error out of email
    -- error still goes to log
    ----------------------------------------------------------------------------------------------
    -- WARNING - Call this version  only if you do not want to see the SQL error in email.
    ----------------------------------------------------------------------------------------------
    -- final clean-up (rollback, commit) at the bottom of your code.
   IS
    Ls_Error   VARCHAR2(2000);
    Ls_Sqlerrm VARCHAR2(2000);
    Ls_End     VARCHAR2(2000);
    Ll_Pos     PLS_INTEGER;
  BEGIN
    -- Build the error string: context + SQL result
    Ls_Error := Psi_Context;
    -- Remove any redundant message
    Ls_Sqlerrm := SQLERRM;
    -- The newline delimits the repetition of the error?!
    Ll_Pos := Instr(Ls_Sqlerrm, Chr(10));
  
    IF Ll_Pos > 0 THEN
      Ls_End := Substr(Ls_Sqlerrm, Ll_Pos + 1);
    
      IF Instr(Ls_Sqlerrm, Ls_End) > 0 THEN
        -- Truncate at the second newline
        Ls_Sqlerrm := Substr(Ls_Sqlerrm, 1, Ll_Pos - 1);
      END IF;
    END IF;
  
    -- Do NOT add SQLERRM if it is 'successful completion' (meaningless)
    IF Instr(Ls_Sqlerrm, 'successful completion') = 0 AND
       Instr(Ls_Error, SQLERRM) = 0 -- Somehow it was getting in there twice?!
     THEN
      Ls_Error := Gs_Crlf || 'EXCEPTION RAISED: ' || Ls_Sqlerrm -- Includes the SQLCODE, kind of
                  || Gs_Crlf || Ls_Error;
    END IF;
  
    -- Allen MArshall, CS - 2003.03.06 - suppress this SQL error from global SQL error string
    -- Capture the error in the global string (accumulating it)
    -- IGNORE
    --gs_sql_error := gs_sql_error || ls_error;
  
    -- Clean up the message
    IF f_Clean_Up_Nl_Cr(Ls_Error) THEN
      p_Bug('Bad SQL error passed to f_clean_up_nl_cr() in p_clean_up_after_raise_error');
    ELSE
      -- Log the SQL error message
      p_Log(Ls_Error);
    END IF;
    -- Allen Marshall, CS - 2003.03.06 - this is supposed to turn off the  logging of the message
    -- Do NOT add the error to the mail message
    -- p_add_msg (ls_error);
  END p_Sql_Error3; -- END NO EMAIL

  PROCEDURE p_Clean_Up_After_Raise_Error(Psi_Context IN Context_String_Type)
  -- Hoyt 01/06/2001
    -- Call this function on fatal error, esp. with SQL
    -- It will rollback and optionally raise an error, 
    -- depending on the value of RAISE_MERGE_ERROR in DS_CONFIG_OPTIONS.
   IS
    Li_Sqlcode   PLS_INTEGER; -- For capturing the SQLCODE
    Ls_Sql_Error VARCHAR2(4000); -- So we can see in the debugger
  BEGIN
    -- This prevents redundant entries (errors causing errors)
    IF Instr(SQLERRM, 'The SQLCODE is out of range: -20300') <> 0 THEN
      -- We've already done all this processing
      --  Allen Marshall, CS, 2002-11-07
      --WATCH OUT FOR  ORA-21000 error number argument to raise_application_error of stringstring is out of range
      --Cause: An attempt was made to specify a number not in the allowed range.
      --Action: Use an error number in the range of -20000 to -20999, inclusive.
      -- CHECK BOUNDARY - add sqlcode and gs_sql_error to generic message if applicable
      IF (SQLCODE >= -20999 AND SQLCODE <= -20000) THEN
        Raise_Application_Error(SQLCODE, Gs_Sql_Error);
      ELSE
        -- Allen Marshall 11/07/2002 TODO - drive error # and message from table.
        -- assume -20999 not used elsewhere
        Raise_Application_Error(-20999,
                                Gs_Sql_Error || ' ( SQLCODE = ' ||
                                To_Char(SQLCODE) || ')');
      END IF;
    END IF;
  
    -- We failed, so rollback, and so notify
    Li_Sqlcode := SQLCODE; -- Capture the SQLCODE before rolling back, to preserve it
  
    -- Only reset the global if it hasn't been reset already
  
    IF Gi_Sqlcode = 0 THEN
      Gi_Sqlcode := SQLCODE; -- Reported by f_send_notification()
    END IF;
  
    Ls_Sql_Error := Gs_Sql_Error;
    -- No error checking on the rollback, please!
    ROLLBACK;
    -- Add that to the email message
    p_Add_Msg('Rolled back after error');
    -- Get rid of extraneous spaces
    Gs_Sql_Error := TRIM(Gs_Sql_Error);
    Gs_Email_Msg := TRIM(Gs_Email_Msg);
  
    -- Handle null SQL error;
    IF Gs_Sql_Error IS NULL THEN
      IF Instr(SQLERRM, 'successful completion') = 0 THEN
        Gs_Sql_Error := SQLERRM || Gs_Crlf;
      ELSE
        Gs_Sql_Error := 'No SQL Error' || Gs_Crlf;
      END IF;
    END IF;
  
    -- Append the accumulated email message to the SQL error message
    IF Instr(Gs_Sql_Error, 'Job status:') = 0 THEN
      Gs_Sql_Error := Gs_Sql_Error || Gs_Crlf || Gs_Crlf || 'Job status:' ||
                      Gs_Crlf || Gs_Crlf || Gs_Email_Msg;
      Ls_Sql_Error := Gs_Sql_Error;
    END IF;
  
    IF f_Clean_Up_Nl_Cr(Gs_Email_Msg) THEN
      p_Bug('Bad EMAIL message passed to f_clean_up_nl_cr() in p_clean_up_after_raise_error');
      Gs_Email_Msg := 'E-mail: None';
    END IF;
  
    -- Append the context (if we haven't ready, and the stack contains something)
    IF Instr(Gs_Sql_Error, 'Stack') = 0 AND NOT f_Ns(f_Stack) THEN
      Gs_Sql_Error := Gs_Sql_Error || Gs_Crlf || 'Stack: ' || f_Stack;
    END IF;
  
    -- Insert the SQL error into the log
    -- p_log (gs_sql_error);
    Ls_Sql_Error := Gs_Sql_Error; -- View in debugger
  
    -- Clean up the messages
  
    IF f_Clean_Up_Nl_Cr(Gs_Sql_Error) THEN
      p_Bug('Bad SQL error passed to f_clean_up_nl_cr() in p_clean_up_after_raise_error');
    ELSE
      -- Log the SQL error message
      p_Log(Gs_Sql_Error);
    END IF;
  
    Ls_Sql_Error := Gs_Sql_Error; -- View in debugger
  
    -- Do we want to see the RAISE_MERGE_ERROR  error message? Should this be passed in?
  
    IF f_Is_Yes(f_Get_Config_Option2(Gs_Raise_Merge_Error_Option)) THEN
      -- Allen 11/7/2002  TRAP DB ERROR CODES HERE LIKE 6502
      -- If the code is NOT in the 'application' range,
      -- then fix it: the sqlcode is typically -20300 generically
      IF -20000 < Li_Sqlcode OR Li_Sqlcode < -20999 THEN
        -- Allen Marshall 11/07/2002 trap missing raise merge error
        Gs_Sql_Error := Gs_Sql_Error || Gs_Crlf ||
                        'The SQLCODE is from an Oracle error: ' ||
                        ' SQLCODE = ' || To_Char(Li_Sqlcode);
        Li_Sqlcode   := -20300; -- FIXUP So it's in range
      END IF;
    
      --Display the message box! NB: Passing in the SAVED SQLCODE            
    
      Raise_Application_Error(Li_Sqlcode, Gs_Sql_Error); -- NB: Passing in the SAVED SQLCODE
    END IF;
  END p_Clean_Up_After_Raise_Error;

  PROCEDURE p_Clean_Up_After_Raise_Error2(Psi_Context IN Context_String_Type)
  -- Hoyt 01/06/2001
    -- This variant does NOT rollback... so you can call it when handling triggers!
   IS
    Li_Sqlcode PLS_INTEGER; -- For capturing the SQLCODE
  BEGIN
    -- Save this for the raise-application
    Li_Sqlcode := SQLCODE;
  
    -- Only reset the global if it hasn't been reset already
    IF Gi_Sqlcode = 0 THEN
      Gi_Sqlcode := SQLCODE; -- Reported by f_send_notification()
    END IF;
  
    -- Handle null SQL error;
    IF Gs_Sql_Error IS NULL THEN
      Gs_Sql_Error := 'No SQL Error' || Gs_Crlf;
    END IF;
  
    -- Append the accumulated email message to the SQL error message
    IF Instr(Gs_Sql_Error, 'Job status:') = 0 THEN
      Gs_Sql_Error := Gs_Sql_Error || Gs_Crlf || Gs_Crlf || 'Job status:' ||
                      Gs_Crlf || Gs_Crlf || Gs_Email_Msg;
    END IF;
  
    -- Clean up the messages
    IF f_Clean_Up_Nl_Cr(Gs_Sql_Error) THEN
      p_Bug('Bad SQL error passed to f_clean_up_nl_cr() in p_clean_up_after_raise_error');
    END IF;
  
    IF f_Clean_Up_Nl_Cr(Gs_Email_Msg) THEN
      p_Bug('Bad EMAIL message passed to f_clean_up_nl_cr() in p_clean_up_after_raise_error');
    END IF;
  
    -- Append the context
    Gs_Sql_Error := Gs_Sql_Error || Gs_Crlf || 'Stack ' || f_Stack;
    -- Insert the SQL error into the log
    p_Log(Gs_Sql_Error);
  
    -- Do we want to see the RAISE_MERGE_ERROR missing option error message? Should this be passed in?
    IF f_Is_Yes(f_Get_Config_Option2(Gs_Raise_Merge_Error_Option)) THEN
      -- Allen 11/7/2002  TRAP DB ERROR CODES HERE LIKE 6502
      -- If the code is NOT in the 'application' range,
      -- then fix it: the sqlcode is typically -20300 generically
      IF -20000 < Li_Sqlcode OR Li_Sqlcode < -20999 THEN
        -- Allen Marshall 11/07/2002 
        Gs_Sql_Error := Gs_Sql_Error || Gs_Crlf ||
                        'The SQLCODE is from an Built-In Oracle error: ' -- Allen Marshall, CS, 1/16/2003
                        || ' SQLCODE = ' || To_Char(Li_Sqlcode);
        Li_Sqlcode   := -20300; -- So it's in range
      END IF;
    
      --Display the message box! NB: Passing in the SAVED SQLCODE
      Raise_Application_Error(Li_Sqlcode, Gs_Sql_Error); -- NB: Passing in the SAVED SQLCODE
    END IF;
  END p_Clean_Up_After_Raise_Error2;

  FUNCTION f_Wordwrap(Str  IN VARCHAR2,
                      Len  IN PLS_INTEGER := 80,
                      Rest OUT VARCHAR2) RETURN Coptions.Optionval%TYPE IS
    v_Len       PLS_INTEGER := Least(Len, 132);
    v_Tokenlen  PLS_INTEGER;
    v_Str       VARCHAR2(32767);
    Ll_Crlf_Pos PLS_INTEGER;
    v_Blankpos  PLS_INTEGER := 0;
  
  BEGIN
    IF Length(Str) > v_Len -- only for overlong lines
     THEN
      Ll_Crlf_Pos := Instr(Str, Crlf);
    
      IF Ll_Crlf_Pos = 0 THEN
        -- no CR/LF
        v_Str      := Substr(Str, 1, v_Len); -- part 1 is the length from 1 to 80
        v_Blankpos := Instr(v_Str, ' ', -1, 1); --starting at end, back to first blank
      
        IF v_Blankpos > 0 THEN
          -- found a blank
          IF v_Blankpos > v_Len THEN
            v_Str      := Substr(Str, 1, v_Len);
            v_Tokenlen := Length(v_Str);
          ELSE
            -- chop off at blankpos -1
            v_Str      := Substr(Str, 1, v_Blankpos); -- so, printable is from 1 to the blank, -1
            v_Tokenlen := v_Blankpos; --start AFTER the BLANK
          END IF;
        ELSE
          -- no blank encountered
          v_Str      := Substr(Str, 1, v_Len);
          v_Tokenlen := Length(v_Str);
        END IF;
      ELSE
        -- chop at closest cr/lf
        IF Ll_Crlf_Pos > v_Len THEN
          v_Str      := Substr(Str, 1, v_Len);
          v_Tokenlen := Length(v_Str);
        ELSE
          v_Str      := Substr(Str, 1, Ll_Crlf_Pos - 1); -- strip cr/lf, since this is a PUT_LINE (with implied CR/LF)
          v_Tokenlen := Ll_Crlf_Pos; --start AFTER the CR/LF
        END IF;
      END IF;
    
      -- recursion, return remainder of line
      Rest := Substr(Str, v_Tokenlen + 1);
      RETURN v_Str;
    
    ELSE
      Ll_Crlf_Pos := Instr(Str, Crlf);
    
      IF Ll_Crlf_Pos > 0 THEN
        Rest := NULL;
        RETURN Substr(Str, Ll_Crlf_Pos - 1);
      ELSE
        Rest := NULL;
        RETURN Str;
      END IF;
    END IF;
    -- DONE!
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END f_Wordwrap;

  FUNCTION f_Get_Config_Option2(Psi_Optionname IN Ds_Config_Options.Optionname%TYPE)
  -- Hoyt 01/06/2002
    -- Variant returns string so it can be called in line;
    -- the magic string 'ls_return_failure' indicates a failure.
    -- Allen 2002-11-7 forced anchored types here for optionname and optionvalue
   RETURN Ds_Config_Options.Optionvalue%TYPE IS
    Ls_Optionvalue ksbms_robot.Ds_Config_Options.Optionvalue%TYPE;
    /* Usage:
    
    This example shows how to capture the result, then test it
    against the magic string 'gs_failure_return' ( <NO DATA> )
    to see if the function worked. If it DID work, then the
    value is converted to a number.
    
          -- How old is 'stale'?
       ls_result := f_get_config_option ('STALE_NUMBER_OF_DAYS');
       if ls_result = ls_failure_return
       then
          -- f_get_config_option() failed, so take the default
          li_stale_number_of_days := gi_default_stale_days;
       else
          li_stale_number_of_days := to_number (ls_result);
       end if;
    
    If the value you want is a string, then you can get it directly:
    
       -- What is the e-mail target?
       ls_email_target := f_get_config_option( 'EMAIL_TARGET' );
       if ls_email_target := ls_failure_return then
          ... handle the failure ...
       end if
    
    If you want to find out if an option is 'Yes':
    
       lb_raise_error := f_is_yes( f_get_config_option ('RAISE_ERROR') );
    
    The above does NOT check for a ls_failure_return, because a failure
    is NOT YES.
    
    */
  BEGIN
    Ls_Optionvalue := Gs_Failure_Return; --  -- Allen 2002-11-7 forced anchored types here for optionname and optionvalue
  
    SELECT Optionvalue
      INTO Ls_Optionvalue
      FROM ksbms_robot.Ds_Config_Options
     WHERE Optionname = Psi_Optionname;
  
    RETURN Ls_Optionvalue;
  EXCEPTION
    WHEN No_Data_Found THEN
      RETURN Gs_Failure_Return;
    WHEN OTHERS THEN
      p_Sql_Error('Getting the option value for the option named ' ||
                  Psi_Optionname);
      RETURN Gs_Failure_Return;
  END f_Get_Config_Option2;

  FUNCTION f_Is_Yes(Pis_Yes_Candidate IN VARCHAR2)
  -- Hoyt 01/06/2001
    -- Returns TRUE if the passed string is any of |on|ok|o|y|yes|t|true|1|
   RETURN BOOLEAN IS
    Li_Position      PLS_INTEGER;
    Ls_Yes_Candidate ksbms_robot.Ds_Config_Options.Optionvalue%TYPE;
  BEGIN
    -- Treat a NULL parameter as NO (or as NOT "yes", anyway)
    IF Pis_Yes_Candidate IS NULL THEN
      RETURN FALSE;
    END IF;
  
    -- "Regularize" it: lowercase, trimmed
    Ls_Yes_Candidate := Ltrim(Rtrim(Lower(Pis_Yes_Candidate)));
    -- These magic strings are "yes" -- the "1" is a one
    Li_Position := Instr('|on|ok|o|y|yes|t|true|1|',
                         '|' || Ls_Yes_Candidate || '|');
    -- 'Yes' (in some form) was found if li_position is non-zero
    RETURN Li_Position > 0;
  END f_Is_Yes;

  FUNCTION f_Get_Email_Msg RETURN VARCHAR2 IS
  BEGIN
    RETURN Gs_Email_Msg;
  END f_Get_Email_Msg;

  PROCEDURE p_Set_Email_Msg(Psi_Msg VARCHAR2) IS
  BEGIN
    Gs_Email_Msg := Psi_Msg;
  END p_Set_Email_Msg;

  FUNCTION f_Get_Sql_Error RETURN VARCHAR2 IS
  BEGIN
    RETURN Gs_Sql_Error;
  END f_Get_Sql_Error;

  PROCEDURE p_Clear_Email_Msg IS
  BEGIN
    Gs_Email_Msg := '';
  END p_Clear_Email_Msg;

  PROCEDURE p_Clear_Sql_Error IS
  BEGIN
    Gs_Sql_Error := '';
  END p_Clear_Sql_Error;

  PROCEDURE Pl( --ARM 1/8/2002 lots of work here to improve word wrap behavior and so on.  If used judiciously with reasonable input lines, this procedure
               -- will format over-long messages pretty nicely to fit on a variable widht screen output.
               Str       IN VARCHAR2,
               Len       IN PLS_INTEGER := 80,
               Expand_In IN BOOLEAN := TRUE)
  -- print line to console, wrapper for DBMS_OUTPUT.PUT_LINE
   IS
    v_Len       PLS_INTEGER := Least(Len, 255);
    v_Tokenlen  PLS_INTEGER;
    v_Str       VARCHAR2(5000);
    Ll_Crlf_Pos PLS_INTEGER;
    v_Blankpos  PLS_INTEGER := 0;
  BEGIN
    IF Length(Str) > v_Len -- only for overlong lines
     THEN
      Ll_Crlf_Pos := Instr(Str, Crlf);
    
      IF Ll_Crlf_Pos = 0 THEN
        -- no CR/LF
        v_Str      := Substr(Str, 1, v_Len); -- part 1 is the length from 1 to 80
        v_Blankpos := Instr(v_Str, ' ', -1, 1); --starting at end, back to first blank
      
        IF v_Blankpos > 0 THEN
          -- found a blank
          IF v_Blankpos > v_Len THEN
            v_Str      := Substr(Str, 1, v_Len);
            v_Tokenlen := Length(v_Str);
          ELSE
            -- chop off at blankpos -1
            v_Str      := Substr(Str, 1, v_Blankpos); -- so, printable is from 1 to the blank, -1
            v_Tokenlen := v_Blankpos; --start AFTER the BLANK
          END IF;
        ELSE
          -- no blank encountered
          v_Str      := Substr(Str, 1, v_Len);
          v_Tokenlen := Length(v_Str);
        END IF;
      ELSE
        -- chop at closest cr/lf
        IF Ll_Crlf_Pos > v_Len THEN
          v_Str      := Substr(Str, 1, v_Len);
          v_Tokenlen := Length(v_Str);
        ELSE
          v_Str      := Substr(Str, 1, Ll_Crlf_Pos - 1); -- strip cr/lf, since this is a PUT_LINE (with implied CR/LF)
          v_Tokenlen := Ll_Crlf_Pos; --start AFTER the CR/LF
        END IF;
      END IF;
    
      Dbms_Output.Put_Line(v_Str);
      -- recursion, print remainder of line
    
      Pl(Substr(Str, v_Tokenlen + 1), v_Len, Expand_In);
    ELSE
      Ll_Crlf_Pos := Instr(Str, Crlf);
    
      IF Ll_Crlf_Pos > 0 THEN
        Dbms_Output.Put_Line(Substr(Str, Ll_Crlf_Pos - 1));
      ELSE
        Dbms_Output.Put_Line(Str);
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF Expand_In THEN
        Dbms_Output.Enable(1000000);
      ELSE
        RAISE;
      END IF;
    
      Dbms_Output.Put_Line(v_Str);
  END Pl;

  /* COUNT_ROWS_FOR_TABLE
  || PASS well formed SQL string, or list of 1:N tables, comma separated, optional where_clause, mode ANY  or COUNT , get COUNT or 1,0 back - returns TRUE ON FAILURE in the_error
  || where clause is arbitrarily complex, logic must match table list
  || can take a view name
  || after call, arg the_count holds the # of rows
  ||  usage: select fw.count_rows_for_table( 'BRIDGE b, ELEMINSP e', 'b,BRKEY ='||sq('AAQ') || ' AND b.brkey = e.elemkey ', the_count) from DUAL;
  */
  PROCEDURE Count_Rows_For_Table(The_String_In    IN VARCHAR2,
                                 The_Where_Clause IN VARCHAR2,
                                 The_Mode         IN VARCHAR2,
                                 The_Count        OUT PLS_INTEGER,
                                 The_Error        OUT BOOLEAN) IS
    Lc_Cur         PLS_INTEGER := Dbms_Sql.Open_Cursor;
    Ll_Retval      PLS_INTEGER := 0; -- return value from EXECUTE_AND_FETCH
    Ls_Sqlstring   VARCHAR2(2000);
    Ll_Count       PLS_INTEGER := 0;
    Ls_Table_Token Sys.All_Tables.Table_Name%TYPE;
    Ll_Startpos    PLS_INTEGER := 1;
    Ll_Endpos      PLS_INTEGER := 0;
    /* Known Oracle Errors */
    Invalid_Sql_Statement EXCEPTION;
    PRAGMA EXCEPTION_INIT(Invalid_Sql_Statement, -00900);
    Table_Does_Not_Exist EXCEPTION;
    PRAGMA EXCEPTION_INIT(Table_Does_Not_Exist, -00942);
    /* User Exceptions */
    -- none
  
  BEGIN
    LOOP
      The_Error := TRUE; -- assume failure.
    
      /* either count or  ANY directive */
      -- Hoyt 02/15/2002 Added upper()
      IF Instr(Upper(TRIM(The_String_In)), 'SELECT ', 1) = 0 THEN
        -- incoming string does not contain SELECT
        IF Upper(The_Mode) = 'ANY' THEN
          Ls_Sqlstring := 'SELECT 1 FROM  ';
        ELSE
          Ls_Sqlstring := 'SELECT COUNT(*) FROM  ';
        END IF;
      
        Ll_Startpos := 1; -- 1, 9, etc.
        Ll_Endpos   := Instr(TRIM(The_String_In), ',', 1);
      
        IF Ll_Endpos > 0 THEN
          -- at least 1 comma found...
          LOOP
            -- parse table list, extract all names, check if valid table or view
            -- if we cannot retrieve anything using SUBSTR from the string, return a dash which will cause fail in ISTABLE
          
            Ls_Table_Token := TRIM(Nvl(Substr(TRIM(The_String_In),
                                              Ll_Startpos,
                                              Ll_Endpos - Ll_Startpos),
                                       '-'));
          
            -- is the argument a valid table ?
            IF NOT Istableorview(Ls_Table_Token) -- ALlen Marshall, CS - 2003.03.31 - allow a view to work too
             THEN
              RAISE Table_Does_Not_Exist; -- an Oracle error.
            END IF;
          
            Ll_Startpos := Ll_Endpos + 1;
          
            IF Ll_Startpos < Length(The_String_In) THEN
              Ll_Endpos := Nvl(Instr(The_String_In, ',', Ll_Startpos, 1), 0);
            
              IF Ll_Endpos = 0 THEN
                -- no more commas (arguments)
                Ll_Endpos := Length(TRIM(The_String_In)) + 1;
              END IF;
            ELSE
              EXIT;
            END IF;
          END LOOP;
        ELSE
          -- is the argument a valid table ?
          IF NOT Istableorview(TRIM(The_String_In)) -- ALlen Marshall, CS - 2003.03.31 - allow a view to work too
           THEN
            RAISE Table_Does_Not_Exist;
          END IF;
        END IF;
      END IF; -- IN String was not a SQL Statement (NO SELECT )
    
      -- fixup where if necessary.
    
      IF The_Where_Clause IS NOT NULL AND
         Length(TRIM(The_Where_Clause)) > 0 THEN
        IF Instr(Upper(The_Where_Clause), 'WHERE') = 0 THEN
          -- word WHERE not found, concatenate clause to WHERE
          Ls_Sqlstring := Ls_Sqlstring || The_String_In || ' WHERE ' ||
                          Nvl(The_Where_Clause, ' ');
        ELSE
          -- use WHERE CLAUSE AS IS
          Ls_Sqlstring := Ls_Sqlstring || The_String_In || ' ' ||
                          Nvl(The_Where_Clause, ' ');
        END IF;
      ELSE
        -- no where clause to use
        Ls_Sqlstring := Ls_Sqlstring || ' ' || The_String_In;
      END IF;
    
      -- OK - done putting together a SELECT statement
    
      -- PARSE SQL String to see if SYNTAX is right, raises exception if not
      BEGIN
        -- parse block starts
        Dbms_Sql.Parse(Lc_Cur, Ls_Sqlstring, Dbms_Sql.Native);
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            RAISE;
            EXIT;
          END;
      END;
    
      -- associate column  with argument
      BEGIN
        Dbms_Sql.Define_Column(Lc_Cur, 1, The_Count);
      EXCEPTION
        WHEN OTHERS THEN
          --                err.handle( SQLCODE, 'DBMS_SQL.Define_Column call failed',FALSE, TRUE );
          EXIT;
      END;
    
      -- execute SQL in cursor
      BEGIN
        Ll_Retval := Dbms_Sql.Execute_And_Fetch(Lc_Cur);
      EXCEPTION
        WHEN OTHERS THEN
          --                err.handle( SQLCODE, 'DBMS_SQL.EXECUTE call failed',FALSE, TRUE );
          EXIT;
      END;
    
      -- something (a row) was fetched
      -- Get value into count argument
      -- if the_count NOT <0 , that's okay. In other words, if FALSE, we succeeded.
      BEGIN
        Dbms_Sql.Column_Value(Lc_Cur, 1, The_Count);
      EXCEPTION
        WHEN OTHERS THEN
          --                err.handle( SQLCODE, 'DBMS_SQL.COLUMN_VALUE call failed',FALSE, TRUE );
          EXIT;
      END;
    
      IF The_Mode = 'ANY' THEN
        The_Count := Ll_Retval; -- why? Because if RETVAL = 1, then a row came back, no
        -- matter whether COUNT(*) or SELECT 1 was fired
      END IF;
    
      The_Error := FALSE; -- success
      EXIT WHEN TRUE;
    END LOOP;
  
    -- Always close when finished to avoid ORA-1000 (too many cursors)
    IF Dbms_Sql.Is_Open(Lc_Cur) THEN
      Dbms_Sql.Close_Cursor(Lc_Cur);
    END IF;
  EXCEPTION
    WHEN Table_Does_Not_Exist THEN
      BEGIN
        -- TIDY
        IF Dbms_Sql.Is_Open(Lc_Cur) THEN
          Dbms_Sql.Close_Cursor(Lc_Cur);
        END IF;
      
        The_Count := SQLCODE;
        Pl('Table does not exist processing count_rows_for_table - SQL was ' ||
           Nvl(Ls_Sqlstring, '?'));
        --                   err.HANDLE( sqlcode, 'Table does not exist processing count_rows_for_table - SQL was ' ||  NVL( ls_SQLString, '?') , FALSE, TRUE );
      END;
    WHEN Invalid_Sql_Statement THEN
      BEGIN
        -- TIDY
        IF Dbms_Sql.Is_Open(Lc_Cur) THEN
          Dbms_Sql.Close_Cursor(Lc_Cur);
        END IF;
      
        The_Count := SQLCODE;
        Pl('Invalid SQL statement processing count_rows_for_table');
        Pl('SQL was ' || Nvl(Ls_Sqlstring, '?'));
        --err.HANDLE( sqlcode, 'Invalid SQL statement processing count_rows_for_table - SQL was ' ||  NVL( ls_SQLString , '?'), FALSE, TRUE  );
      END;
    WHEN OTHERS THEN
      BEGIN
        -- TIDY
        IF Dbms_Sql.Is_Open(Lc_Cur) THEN
          Dbms_Sql.Close_Cursor(Lc_Cur);
        END IF;
      
        The_Count := SQLCODE;
        Pl('Unknown error encountered in count_rows_for_table');
        Pl('SQL was ' || Nvl(Ls_Sqlstring, '?'));
        --err.HANDLE( sqlcode, 'Unknown error encountered in count_rows_for_table - SQL was ' ||  NVL( ls_SQLString, '?'  ), FALSE, TRUE  );
      END;
  END Count_Rows_For_Table;

  FUNCTION f_Rowcount(The_Stringarg_In IN VARCHAR2,
                      The_Where_Clause IN VARCHAR2) RETURN PLS_INTEGER IS
    Lb_Failed BOOLEAN := TRUE;
    Ll_Count  PLS_INTEGER;
  BEGIN
    Count_Rows_For_Table(The_Stringarg_In,
                         The_Where_Clause,
                         'COUNT',
                         Ll_Count,
                         Lb_Failed);
  
    IF Lb_Failed THEN
      Ll_Count := -1;
    END IF;
  
    RETURN Ll_Count;
  END f_Rowcount;

  FUNCTION f_Rowcount(The_Stringarg_In IN VARCHAR2) RETURN PLS_INTEGER IS
    Lb_Failed BOOLEAN := TRUE;
    Ll_Count  PLS_INTEGER;
  BEGIN
    Count_Rows_For_Table(The_Stringarg_In,
                         NULL,
                         'COUNT',
                         Ll_Count,
                         Lb_Failed);
  
    IF Lb_Failed THEN
      Ll_Count := -1;
    END IF;
  
    RETURN Ll_Count;
  END f_Rowcount;

  /* Pass table, where clause, get back 1 if rows exist, 0 if no rows, RETURNS TRUE on FAILURE
  || where clause is arbitrarily complex, logic must match table list
  || avoids table scan for COUNT(*) if program only needs to know if any rows exist ( more than 0)
  || can take a view name
  ||  usage: select fw.any_rows_in_table( 'BRIDGE ', 'BRKEY ='||fw.sq('AAQ'), the_count) from DUAL;
  || OR
  || VARIANT - Pass several tables, where clause, get back 1 if rows exist, 0 if no rows, RETURNS TRUE on FAILURE
  || where clause is arbitrarily complex, logic must match table list
  || avoids table scan for COUNT(*) if program only needs to know if any rows exist ( more than 0)
  || can take a view name
  ||  usage: select fw.any_rows_in_table( 'BRIDGE b, ELEMINSP e', 'b.BRKEY ='||fw.sq('AAQ') || ' AND b.brkey = e.elemkey ', the_count) from DUAL;
  */
  FUNCTION f_Any_Rows_Exist(The_Stringarg_In IN VARCHAR2,
                            The_Where_Clause IN VARCHAR2) RETURN BOOLEAN IS
    Ll_Count      PLS_INTEGER := 0;
    Lb_Failed     BOOLEAN := TRUE;
    Lb_Rows_Exist BOOLEAN := FALSE;
  BEGIN
    Count_Rows_For_Table(The_Stringarg_In,
                         The_Where_Clause,
                         'ANY',
                         Ll_Count,
                         Lb_Failed); -- FAILED = TRUE
  
    IF NOT Lb_Failed THEN
      Lb_Rows_Exist := (Nvl(Ll_Count, 0) > 0);
    ELSE
      Lb_Rows_Exist := NULL;
    END IF;
    COMMIT;
    RETURN Lb_Rows_Exist; -- IF ll_count IS >=0, then we succeed - check rows exist to see if any rows match criteria
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        ROLLBACK;
        Lb_Rows_Exist := NULL; -- so, if we get null back, then we know the call failed.
        RETURN Lb_Rows_Exist;
      END;
    
  END f_Any_Rows_Exist;

  /* VARIANT - Pass well-formed SQL statement, get count back - RETURNS TRUE on FAILURE (bad SQL)
  || Pass a (presumably  valid ) SELECT statement with SELECT 1  as a string, get back 1 if any exist, 0 if none, returns TRUE on failure
  || can take a SELECT of any complexity up to 500 chars in length
  || During development, test SQL in an SQL before using in code
  || This variant does not use a where clause...
  || usage: select fw.any_rows_in_table( 'SELECT 1 FROM BRIDGE b, ELEMINSP e WHERE b,BRKEY ='||fw.sq('AAQ') || ' AND b.brkey = e.elemkey ', rows_exist ) from DUAL;
  */
  FUNCTION f_Any_Rows_Exist(The_Stringarg_In IN VARCHAR2) RETURN BOOLEAN IS
    Ll_Count      PLS_INTEGER := 0;
    Lb_Failed     BOOLEAN := TRUE;
    Lb_Rows_Exist BOOLEAN := FALSE;
  BEGIN
    Count_Rows_For_Table(The_Stringarg_In,
                         NULL,
                         'ANY',
                         Ll_Count,
                         Lb_Failed); -- FAILED = TRUE
  
    IF NOT Lb_Failed THEN
      Lb_Rows_Exist := (Nvl(Ll_Count, 0) > 0);
    ELSE
      Lb_Rows_Exist := NULL;
    END IF;
    COMMIT;
    RETURN Lb_Rows_Exist; -- IF ll_count IS >=0, then we succeed - check rows exist to see if any rows match criteria
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        ROLLBACK;
        Lb_Rows_Exist := NULL; -- so, if we get null back, then we know the call failed.
        RETURN Lb_Rows_Exist;
      END;
  END f_Any_Rows_Exist;

  FUNCTION Random RETURN PLS_INTEGER IS
  BEGIN
    RETURN Random(1);
  END Random;

  -- Used by f_random_integer() and f_random_float()
  FUNCTION Mult(p IN NUMBER, q IN NUMBER) RETURN NUMBER IS
    P1 NUMBER;
    P0 NUMBER;
    Q1 NUMBER;
    Q0 NUMBER;
  BEGIN
    P1 := Trunc(p / M1);
    P0 := MOD(p, M1);
    Q1 := Trunc(q / M1);
    Q0 := MOD(q, M1);
    RETURN(MOD((MOD(P0 * Q1 + P1 * Q0, M1) * M1 + P0 * Q0), m));
  END Mult;

  -- Returns an integer between [0, r-1]
  FUNCTION f_Random_Integer(r IN NUMBER) RETURN NUMBER IS
  BEGIN
    -- Generate a random number and set it to be the new seed 
    a := MOD(Mult(a, b) + 1, m);
    -- Convert it to integer between [0, r-1] and return it 
    RETURN(Trunc((Trunc(a / M1) * r) / M1));
  END f_Random_Integer;

  -- Returns random real between [0, 1] 
  FUNCTION f_Random_Float RETURN NUMBER IS
  BEGIN
    -- Generate a random number and set it to be the new seed 
    a := MOD(Mult(a, b) + 1, m);
    -- Return it
    RETURN(a / m);
  END f_Random_Float;

  FUNCTION Random(Numdigits IN PLS_INTEGER) RETURN PLS_INTEGER IS
    Lf_Remainder DOUBLE PRECISION;
    i            PLS_INTEGER;
    Ls_Seconds   VARCHAR2(2);
  BEGIN
    LOOP
    
      <<control_Loop>>
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
    
      -- Hoyt 01/11/2002 Substituted the following for the SELECT
      -- below, because the latter was generating very large numbers.
      Lf_Remainder := f_Random_Float;
    
      /*
               select     to_number (   ''
                                     || sys_guid ()
                                     || '', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
                        / power (10,   24
                                     + greatest (1, least (numdigits, 9)))
                      - floor (
                             to_number (   ''
                                        || sys_guid ()
                                        || '', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
                           / power (10,   24
                                        + greatest (1, least (numdigits, 9)))
                        )
                 into lf_remainder
                 from dual;
      
               -- Hoyt 1/12/2002 Make sure it's under 1.0?!
               declare
                  li_whole_number   pls_integer;
               begin
                  li_whole_number := lf_remainder; -- Truncate decimal part
                  lf_remainder :=   lf_remainder
                                  - li_whole_number; -- Remove integer part
               end;
      */
      -- Hoyt 01/12/2002 This is failing
      IF Lf_Remainder >= 1.0 THEN
        p_Sql_Error('random(digits) Failed: Remainder is greater than 1: ' ||
                    To_Char(Lf_Remainder));
      END IF;
    
      EXIT WHEN TRUE;
    END LOOP Control_Loop;
  
    -- return value is always POSITIVE
    RETURN Abs(Lf_Remainder * Power(10, Greatest(1, Least(Numdigits, 9)))); -- so, if 0, the float * 1
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
      RETURN NULL;
  END Random;

  -- Return the time formatted rather precisely
  FUNCTION f_Now RETURN VARCHAR2 IS
  BEGIN
    RETURN To_Char(SYSDATE, 'YYYY-MM-DD HH24:MI:SS');
  END f_Now;

  -- Return the date formatted in a standard way
  -- ENHANCEMENT: Look up the format in the config options?
  FUNCTION f_Today RETURN VARCHAR2 IS
  BEGIN
    RETURN To_Char(SYSDATE, 'YYYY-MM-DD');
  END f_Today;

  -- Insert a message into ds_message_log
  /* Usage:
  
  Call this variant p_log( s, s ) at the top of your script, passing along
  the job_id along with the message, presuming that you know your job_id:
  
     ls_job_id := f_get_entry_id;
     p_log( ls_job_id, 'Staring processing of whatever' );
  
  Call the above just once, to set the job_id. That way, all the
  ensuing p_log( s ) calls (which pass JUST the message) will have
  the same job_id, making it easy to isolate that group of messages.
  
  If you do NOT know your job_id, then presumably it has been
  set already, and you can simply pass the context and the
  message using the p_log( s ) variant:
  
      p_log( 'Starting processing at ' || f_now );
  
  Do NOT call p_bug() in this function -- it's circular because p_bug() calls p_log()!
  
  */
  PROCEDURE p_Log(Psi_Job_Id IN Ds_Message_Log.Job_Id%TYPE,
                  Psi_Msg    IN Ds_Message_Log.Msg_Body%TYPE) IS
    Ls_Msg       VARCHAR2(32000); -- Not ds_message_log.msg_body%type because it might be longer
    Ls_Remainder VARCHAR2(32000);
    Ll_Length    PLS_INTEGER;
    Ls_Context   Context_String_Type := 'p_log ( psi_job_id, psi_msg )';
    PRAGMA AUTONOMOUS_TRANSACTION; -- So we can commit JUST THIS db operation
  BEGIN
    -- Allen Marshall, CS- 01/31/2003 - changed to use ls_context instead of hardwired functionname
    -- NO NO p_push (ls_context);                      -- Allen Marshall, CS - 01/31/2003 - added stack push
    -- we need the immediate PRIOR context not this one
    -- Capture this for application by the variant
    g_Job_Id := Psi_Job_Id;
    -- Check the message!
    Ls_Msg := Psi_Msg; -- So we can modify it
  
    -- Clean up the message
  
    IF f_Clean_Up_Nl_Cr(Ls_Msg) THEN
      Pl('f_clean_up_nl_cr() failed with message ''' || Ls_Msg || '''');
    END IF;
  
    IF f_Ns(Psi_Msg) THEN
      IF Ls_Msg IS NULL THEN
        Ls_Msg := 'NULL message passed to p_log()!'; -- We don't know which variant
      ELSE
        Ls_Msg := 'Empty message ('''') passed to p_log()!';
      END IF;
    END IF;
  
    -- If the message is longer than 4000, then break it into bits,
    -- because msg_body can only accept 4000 characters.
    Ll_Length := Length(Ls_Msg);
  
    IF Length(Ls_Msg) > 4000 THEN
      Ls_Remainder := Substr(Ls_Msg, 4001); -- The rest of the message
      Ls_Msg       := Substr(Ls_Msg, 1, 4000);
    ELSE
      -- So we know not to pass it along later
      Ls_Remainder := 'NONE';
    END IF;
  
    -- Insert the row into ds_message_log
    BEGIN
      -- All these columns except msg_body are NOT NULL
      INSERT INTO Ds_Message_Log
        (Job_Id,
         SCHEMA,
         Msg_Id,
         Msg_Seqnum,
         Msg_Format,
         Createdatetime,
         Createuserid,
         Modtime,
         Changeuserid,
         Msg_Body)
      VALUES
        (Psi_Job_Id,
         'P', -- Pontis
         f_Context, -- Which function is running?
         Uniquefile_Sequence.Nextval,
         'TEXT', -- Whatever
         SYSDATE,
         USER,
         SYSDATE,
         USER,
         Ls_Msg);
    
      -- Commit so the log is there even if the code hangs
      COMMIT;
    
      -- If there is any remainder, pass it along (recursion)
      IF Ls_Remainder <> 'NONE' THEN
        p_Log(Ls_Remainder);
      END IF;
      -- No error checking because... no infinite loops!
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          ROLLBACK;
          -- Do not call routine error-handlers, 
          -- or there's danger of getting in an infinite loop if
          -- the function continues to fail....
          -- Allen Marshall, CS- 01/31/2003 - changed to use ls_context instead of hardwired functionname
          Pl(Ls_Context || ' failed to INSERT message: ' || Psi_Msg ||
             ' for context ' || f_Context);
          Pl(Ls_Context || ' SQL Error: ' || SQLERRM);
        END;
    END;
  
    -- Allen Marshall, CS- 01/31/2003 - changed to use ls_context instead of hardwired functionname
    -- NO NO - do not keep this one's context p_pop (ls_context);
    -- we need the immediate PRIOR context not this one
  END p_Log;

  -- Variant p_log( s ) takes just the context and the message body,
  -- applies the job_id from the preceding p_log( s,s,s ) call
  -- Do NOT call p_bug() in this function -- it's circular because p_bug() calls p_log()!
  PROCEDURE p_Log(Psi_Msg IN Ds_Message_Log.Msg_Body%TYPE) IS
  BEGIN
    -- If the job_id is not initialized, take the most recent one
    IF g_Job_Id = g_Uninitialized THEN
      BEGIN
        -- Take the most-recently-started job
        SELECT Job_Id
          INTO g_Job_Id
          FROM Ds_Jobruns_History
         WHERE Job_Start_Time =
               (SELECT MAX(Job_Start_Time) FROM Ds_Jobruns_History);
      EXCEPTION
        WHEN No_Data_Found THEN
          -- Set it!
          -- Do NOT use standard error handling - infinite loop danger!
          Pl('Guessing JOB ID -  NO_DATA_FOUND');
        
          g_Job_Id := Ksbms_Pontis_Util.f_Get_Entry_Id;
        WHEN OTHERS THEN
          -- Do NOT use standard error handling - infinite loop danger!
          Pl('p_log( s, s ) SQL Error: ' || SQLERRM);
      END;
    END IF;
  
    -- Call the "real" f_log() passing the global parameters
    p_Log(g_Job_Id, Psi_Msg);
  END p_Log;

  /* ARMarshall, CS - 20040923 - new procedure 
  The procedure p_snapshot_changelogs(  p_jobid IN ds_jobruns_history.job_id%type) 
  will make a copy of the 4 change log tables prior to a job run, by creating scratch tables that 
  are named after the original table, the date, the jobid, and a sequence. 
  These tables can serve to rollback the change log easily if a run fails. 
  
  Another procedure is needed to purge these when desired if old 
  
  ARMarshall, CS - 2005-12-1 - the table stamping stuff was making the table names too long (must be < 30 characters in toto) so 
  a table stamp is now constructed that when appended to the stem name will be in line. 
  
  
  
  */

  PROCEDURE p_Snapshot_Changelogs(p_Ora_Dbms_Job_Id IN Ds_Jobruns_History.Ora_Dbms_Job_Id%TYPE -- this scheduled JOB ID 
                                  ) IS
    Ll_Seq         PLS_INTEGER;
    Ls_Seq         VARCHAR2(9);
    Ls_Today       VARCHAR2(10);
    Ls_Table_Stamp VARCHAR2(20);
    Ls_Sqlstring   VARCHAR2(2000);
  BEGIN
  
    Ls_Today := To_Char(SYSDATE, 'MMDDYYYY');
    SELECT Seq_Changelog_Snapshot_Id.Nextval INTO Ll_Seq FROM Dual;
    Ls_Seq         := TRIM(To_Char(Ll_Seq, '09999999')); -- changed to 9 digit max on 12-2-2005, table name was erroring out because of size 
    Ls_Table_Stamp := TRIM(To_Char(p_Ora_Dbms_Job_Id)) || TRIM(Ls_Today) ||
                      TRIM(Ls_Seq); -- 20 characters appended to table stem name 
  
    -- DS_CHANGE_LOG >> DS_SNAP_CL_MMDDYYYY0000001 
    -- DS_LOOKUP_KEYVALS 
    -- DS_CHANGE_LOG_C 
    -- DS_LOOKUP_KEYVALS_C 
  
    Ls_Sqlstring := 'CREATE TABLE DS_SS_CL_' || Ls_Table_Stamp;
    Ls_Sqlstring := Ls_Sqlstring || ' AS SELECT * FROM DS_CHANGE_LOG';
  
    BEGIN
    
      EXECUTE IMMEDIATE Ls_Sqlstring;
    
    EXCEPTION
      WHEN OTHERS THEN
        RAISE;
    END;
  
    Ls_Sqlstring := 'CREATE TABLE DS_SS_CL_C_' || Ls_Table_Stamp;
    Ls_Sqlstring := Ls_Sqlstring || ' AS SELECT * FROM DS_CHANGE_LOG_C';
  
    BEGIN
    
      EXECUTE IMMEDIATE Ls_Sqlstring;
    
    EXCEPTION
      WHEN OTHERS THEN
        RAISE;
    END;
    Ls_Sqlstring := 'CREATE TABLE DS_SS_LUKV_' || Ls_Table_Stamp;
    Ls_Sqlstring := Ls_Sqlstring || ' AS SELECT * FROM DS_LOOKUP_KEYVALS';
  
    BEGIN
    
      EXECUTE IMMEDIATE Ls_Sqlstring;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE;
    END;
  
    Ls_Sqlstring := 'CREATE TABLE DS_SS_LUKV_C_' || Ls_Table_Stamp;
    Ls_Sqlstring := Ls_Sqlstring || ' AS SELECT * FROM DS_LOOKUP_KEYVALS_C';
  
    BEGIN
    
      EXECUTE IMMEDIATE Ls_Sqlstring;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE;
    END;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
    
  END p_Snapshot_Changelogs;

  PROCEDURE p_Init_Jobruns_History(p_Jobid           IN Ds_Jobruns_History.Job_Id%TYPE, -- this JOB RUN instance
                                   p_Ora_Dbms_Job_Id IN Ds_Jobruns_History.Ora_Dbms_Job_Id%TYPE, -- this scheduled JOB ID
                                   p_Jobstatus       IN Ds_Jobruns_History.Job_Status%TYPE, -- the job STATUS CODE (2 CHARS)
                                   p_Statmsg         IN Ds_Jobruns_History.Remarks%TYPE) -- REMARKS (255 CHARS)
   IS
  BEGIN
    -- NB: Job_ProcessingID is NOT inserted
    INSERT INTO Ds_Jobruns_History
      (Job_Id,
       Ora_Dbms_Job_Id,
       Job_Start_Time,
       Job_End_Time,
       Job_Status,
       Job_Userid,
       Remarks)
    VALUES
      (p_Jobid,
       Nvl(p_Ora_Dbms_Job_Id, '9999'),
       SYSDATE,
       SYSDATE,
       p_Jobstatus,
       USER,
       Nvl(p_Statmsg, '*'));
  
    COMMIT; -- so the triggers see it immediately
    p_Log(p_Jobid,
          'Inserted Job ID ' || p_Jobid || ' into Job Runs History Table');
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        ROLLBACK;
        RAISE;
      END;
  END p_Init_Jobruns_History;

  PROCEDURE p_Update_Jobruns_History(p_Jobid     IN Ds_Jobruns_History.Job_Id%TYPE,
                                     p_Jobstatus IN Ds_Jobruns_History.Job_Status%TYPE,
                                     p_Statmsg   IN Ds_Jobruns_History.Remarks%TYPE) IS
  BEGIN
    NULL;
  END p_Update_Jobruns_History;

  -- UPDATE (as opposed to INSERT) a message already in the ds_message_log
  /* Usage:
  
  Call p_log_last( s, s ) when you want to write ONE message to the log file,
  but you want to be able to UPDATE that message. The original application of
  p_log_last() was logging progress as ksbms_apply_changes.f_update_pontis()
  runs -- if there are a lot of updates, then the process can go a long time.
  Rather than fill the log with zillons of entries, or letting the developer
  just worry that the process is stuck... p_log_last allows you to update ONE
  message.
  
  It works by having two parts to the message. The first part is the invariant
  part, that does not vary between calls. The second part DOES vary. The usage
  makes this clear:
  
      -- Log progress so the programmer doesn't think the process is hung!
      li_num_updated := li_num_updated + 1;
      p_log_last( 'Number of records updated: ', to_char( li_num_updated ) );
  
  The first time p_log_last() is found, it looks for the invariant part, e.g.
  it looks for the LAST instance like 'Number of records updated: %' (note
  the %) in ds_message_log.msg_body. If the invariant part is NOT found (which
  it won't be the first time p_log_last() is called), then the whole message
  is simply routed to p_log().
  
  Subsequently, the invariant part will be found, and that row in the message
  log will be updated so the msg_body contains the new message, e.g.
  
      Number of records updated: 45
  
  Thus, the developer can see the progress as the process runs.
  
  Note that the SQL that searches for the invariant part of the message applies
  the job_id, which is stashed in a global the first time you call p_log. So the
  usage is:
  
     ls_job_id := f_get_entry_id;
     p_log( ls_job_id, 'Started logging ' || ls_context || ' at ' || f_now );
  
     ...
  
     p_log( 'This message is always an insert' );
  
     ...
  
     p_log_last( 'This message will only be inserted ONCE ', 'And updated thereafter' );
  
  There's no need to call p_log( s ) before p_log_last(), however. You just need to
  call p_log( s, s ) [ passing the job id ] before calling p_log_last(). This is
  necessary because otherwise p_log_last() might find an old instance of the
  invariant part, e.g. the message from yesterday's run. The job_id means that the
  SQL searching for the invariant part only selects from the current job's rows.
  
  Do NOT call p_bug() in this function -- it's circular because p_bug() calls p_log()!
  */

  PROCEDURE p_Clean_Jobruns_History IS
  BEGIN
    p_Clean_Jobruns_History(c_Synch_Dummy_Jobid);
  END p_Clean_Jobruns_History; -- use default

  PROCEDURE p_Clean_Jobruns_History(Psi_Ora_Dbms_Jobid IN Ds_Jobruns_History.Ora_Dbms_Job_Id%TYPE) -- delete explicitly
   IS
  BEGIN
    DELETE FROM Ds_Jobruns_History
     WHERE Ds_Jobruns_History.Ora_Dbms_Job_Id = Psi_Ora_Dbms_Jobid;
    COMMIT;
  
  END p_Clean_Jobruns_History;

  PROCEDURE p_Log_Last(Psi_Fixed_Part   IN VARCHAR2,
                       Psi_Variant_Part IN VARCHAR2) IS
  
    Ls_Msg         VARCHAR2(4000); -- Not ds_message_log.msg_body%type because it might be longer
    Ls_Remainder   VARCHAR2(4000);
    Ll_Length      PLS_INTEGER;
    Lrid_Last      ROWID;
    Ll_Seqnum      PLS_INTEGER; -- value of ds_message_log.msg_seqnum, used only for SQL below to retrieve ROWID
    Ls_Like_String VARCHAR2(4000);
    Ll_Nrows       PLS_INTEGER;
  
    PRAGMA AUTONOMOUS_TRANSACTION; -- So we can commit JUST THIS db operation
  BEGIN
    -- We need g_job_id
    IF g_Job_Id = g_Uninitialized THEN
      Pl('p_log_last() requires that you call p_log( job_id, message ) first!');
      RETURN;
    END IF;
  
    -- Build the complete message
    Ls_Msg := Psi_Fixed_Part || Psi_Variant_Part;
  
    -- Clean up the message
    IF f_Clean_Up_Nl_Cr(Ls_Msg) THEN
      Pl('f_clean_up_nl_cr() failed with message ''' || Ls_Msg || '''');
    END IF;
  
    -- Both parts have to be there
    IF f_Ns(Psi_Fixed_Part) OR f_Ns(Psi_Variant_Part) THEN
      IF f_Ns(Ls_Msg) THEN
        Ls_Msg := 'NULL or empty message (both FIXED and VARIANT parts!) passed to p_log_last()!'; -- Both pieces
      ELSIF f_Ns(Psi_Fixed_Part) THEN
        Ls_Msg := 'NULL or empty FIXED PART passed to p_log_last()! Variant: ' ||
                  Psi_Variant_Part;
      ELSIF f_Ns(Psi_Variant_Part) THEN
        Ls_Msg := 'NULL or empty VARIANT PART passed to p_log_last() Fixed: ' ||
                  Psi_Fixed_Part;
      END IF;
    
      -- Just log it and we're done
      p_Log(Ls_Msg);
      RETURN;
    END IF;
  
    -- If the message is longer than 4000, then we are screwed,
    -- because it all has to be on one line
    IF Length(Ls_Msg) > 4000 THEN
      Pl('p_log_last() encountered a message longer than 4000! Redirecting to p_log!');
      p_Log(Ls_Msg);
      RETURN;
    END IF;
  
    -- Find the last instance of the fixed part
    BEGIN
      Ls_Like_String := Psi_Fixed_Part || '%';
    
      --createdatetime = (select max (createdatetime)
      --                       from ds_message_log
      --                     where msg_body like ls_like_string);
    
      -- aliases a and b
      SELECT MAX(a.Rowid), MAX(a.Msg_Seqnum)
        INTO Lrid_Last, Ll_Seqnum
        FROM Ds_Message_Log a
       WHERE a.Job_Id = g_Job_Id
         AND a.Msg_Body LIKE Ls_Like_String
         AND a.Msg_Seqnum = (SELECT MAX(b.Msg_Seqnum)
                               FROM Ds_Message_Log b
                              WHERE a.Job_Id = b.Job_Id
                                AND a.Rowid = b.Rowid); -- Added by Allen Marshall, CS - 2003.04.14 - need this
      -- because this message entry may well NOT be the most recent row, since other messages
      -- may go in after this first happens.  Now, the set of records will match anywhere in the message stream.
      -- value of ds_message_log.msg_seqnum returned here is used only for ths SQL to retrieve ROWID
    EXCEPTION
      WHEN No_Data_Found THEN
        -- Assume that this is the first call of many to be repeated
        p_Log(Ls_Msg);
        RETURN;
      WHEN OTHERS THEN
        -- Do not call routine error-handlers, 
        -- or there's danger of getting in an infinite loop if
        -- the function continues to fail....
        Pl('p_log_last() failed while SELECTING the fixed part: ' ||
           Psi_Fixed_Part);
        RETURN;
    END;
  
    -- Update the row just found in the message log
    BEGIN
      IF Lrid_Last IS NOT NULL THEN
        UPDATE Ds_Message_Log
           SET Msg_Body = Ls_Msg
         WHERE ROWID = Lrid_Last;
      
        IF SQL%ROWCOUNT = 0 THEN
          Pl('Failed to update msg_box using ROWID in p_log_last()');
        END IF;
      
        -- Commit so the log is there even if the code hangs
        COMMIT;
        -- No p_sql_error() calls, to avoid infinite loops!
      
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        -- Do not call routine error-handlers, 
        -- or there's danger of getting in an infinite loop if
        -- the function continues to fail....
        Pl('p_log_last( s, s ) failed to UPDATE last message row: ' ||
           Ls_Msg);
        Pl('p_log_last( s, s ) SQL Error: ' || SQLERRM);
        ROLLBACK;
    END;
  END p_Log_Last;

  -- Append the passed context to the global string (with a separator)
  PROCEDURE p_Push(Psi_Context IN Context_String_Type) IS
    Ls_Catch_Overflow VARCHAR2(32767);
  BEGIN
    -- Allen Marshall, CS - 1/17/2003 - lots of changes
    -- use a temp var to try and catch the incoming string + existing stack <= 32767
    -- uses globals gl_stacksize and g_stack in this package 
    -- clean off blanks
    -- Allen Marshall, CS - 01/30/2003 add ' '' after TRAILING
    Ls_Catch_Overflow := TRIM(Trailing ' ' FROM
                              Nvl(g_Stack, '') || '`' || Lower(Psi_Context));
  
    -- if too long, substring it           
    IF Length(Ls_Catch_Overflow) > Gl_Stacksize -- length for  context string type
     THEN
      Ls_Catch_Overflow := Substr(Ls_Catch_Overflow, 1, Gl_Stacksize);
    END IF;
  
    -- update stack
    g_Stack := Ls_Catch_Overflow;
  END p_Push;

  -- Remove the passed context FROM the global string
  PROCEDURE p_Pop(Psi_Context IN Context_String_Type) IS
    Ll_Start          PLS_INTEGER := 0;
    Ll_Last           PLS_INTEGER := 0;
    Ls_Popped_Context Context_String_Type;
  BEGIN
    -- If the stack or context are NULL, return
    IF g_Stack IS NULL THEN
      RETURN;
    END IF;
  
    IF Psi_Context IS NULL THEN
      RETURN;
    END IF;
  
    -- Loop until the last instance of the context is found
    WHILE TRUE LOOP
      Ll_Start := Instr(g_Stack, Psi_Context, Ll_Start + 1);
    
      IF Ll_Start = 0 THEN
        EXIT;
      END IF;
    
      -- Remember the last 'found' instance of the context
      Ll_Last := Ll_Start;
    END LOOP;
  
    -- If we didn't find it, register the error
    IF Ll_Last = 0 THEN
      p_Bug('p_pop() failed to find context ''' || Psi_Context || '''');
      RETURN;
    END IF;
  
    -- Is there an unpopped location?
    -- context strings can be up to gl_context_string_size (255 as of 1/17/2003);
    Ls_Popped_Context := Substr(g_Stack, Ll_Last, Gl_Context_String_Size);
  
    IF Instr(Ls_Popped_Context, '`', 1) <> 0 THEN
      p_Bug('Unpopped contexts found: popping ''' || Psi_Context ||
            ''' found context ''' || Ls_Popped_Context || '''');
    END IF;
  
    -- Pop the context off the stack
    g_Stack := Substr(g_Stack, 1, Ll_Last - 2); -- -2 to remove the stack separator
  END p_Pop;

  -- Return the context that was most recently added to the global string
  FUNCTION f_Context RETURN VARCHAR2
  --ARM Made changes here to avoid failures of p_log when context is empty...
   IS
    Ll_Start PLS_INTEGER := 0;
    Ll_Last  PLS_INTEGER := 0;
    --     ls_most_recent_context   varchar2 (100);
    Ls_Missing_Context VARCHAR2(32) := 'Context Unavailable';
    Ls_Result          VARCHAR2(100);
  BEGIN
    Ls_Result := Ls_Missing_Context;
  
    -- If the stack is NULL or empty, return 's_missing_context
    IF NOT f_Ns(g_Stack) THEN
      -- get context from stack
    
      -- Loop until the last context separator is found
      WHILE TRUE LOOP
        Ll_Start := Instr(g_Stack, '`', Ll_Start + 1);
      
        IF Ll_Start = 0 THEN
          EXIT;
        END IF;
      
        -- Remember the last 'found' instance of the context
        Ll_Last := Ll_Start;
      END LOOP;
    
      -- If we didn't find it, then return the whole stack
      IF Ll_Last = 0 THEN
        Ls_Result := g_Stack;
      ELSE
        -- Get the most-recently added context off the stack
        Ls_Result := Substr(g_Stack, Ll_Last + 1, 100);
      END IF;
    END IF;
  
    -- now single return point 
    RETURN Ls_Result;
  END f_Context;

  -- This returns the entire stack
  FUNCTION f_Stack RETURN VARCHAR2 IS
  BEGIN
    RETURN g_Stack;
  END f_Stack;

  -- Get the value used for ds_change_log.entry_id and ds_lookup_keyvals.entry_id
  FUNCTION f_Get_Entry_Id RETURN VARCHAR2 IS
    RESULT VARCHAR2(32);
  BEGIN
    -- Get the 32-character string provided by sys_guid()
    SELECT Sys_Guid() INTO RESULT FROM Dual;
  
    -- Return the unique string
    RETURN(RESULT);
  EXCEPTION
    WHEN OTHERS THEN
      p_Sql_Error('Selecting sys_guid() from dual!');
  END f_Get_Entry_Id;

  FUNCTION f_Get_Change_Log_Seqnum RETURN PLS_INTEGER IS
    Ll_Result PLS_INTEGER;
  BEGIN
    -- Get the next  ds_change_log_seqnum.nextval  via dual
    SELECT Ds_Change_Log_Seqnum.Nextval INTO Ll_Result FROM Dual;
  
    -- Return the unique string
    RETURN(Ll_Result);
  EXCEPTION
    WHEN OTHERS THEN
      p_Sql_Error('SELECT ds_change_log_seqnum.nextval!');
  END f_Get_Change_Log_Seqnum;

  -- Returns TRUE if the passed varchar2 is NULL or (after trimming) has length zero
  -- The 'ns' in 'f_ns' stands for 'Not String'.
  FUNCTION f_Ns(Psi_String IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF Psi_String IS NULL THEN
      RETURN TRUE; -- It is NOT a string
    END IF;
  
    IF Length(TRIM(Psi_String)) = 0 THEN
      RETURN TRUE; -- It is NOT a string again
    END IF;
  
    -- It isn't NULL, and it has at least one non-blank, so it's a string
    RETURN FALSE;
  END f_Ns;

  FUNCTION f_Numbers_Differ(Oldnum1           IN NUMBER,
                            Newnum2           IN NUMBER,
                            Precision_Limit   IN DOUBLE PRECISION := NULL,
                            Notify_On_Missing IN BOOLEAN := TRUE)
    RETURN BOOLEAN IS
  
    --    Created 8/13/2014 by ARMarshall, Allen R. Marshall Consulting LLC -
    --    http://allenrmarshall-consulting-llc.com
    --    mailto://armarshall@allenrmarshall-consulting-llc.com
    --    added
    --    This function accepts 4 arguments, the 3rd of which defaults to NULL (0) and the 4th defaults to TRUE (always notify if new value goes to missing).
    --    If the two test values differ enough by pct., or absolutely if the new one is 0( more than the precision_limit) the function returns TRUE, FALSE otherwise.
    --    This can be used anywhere we want to determine if two numbers are different and we want to set the precision for each situation.  
    --    Updated:
    --    ARMarshall, 20180819 - added protection for divide by zero and also now willOPTIONALLY notify if the new value goes to NULL or the magic -1 BrM missing value
  
    Lf_Difference DOUBLE PRECISION := 0.0;
    Invalid_Args EXCEPTION;
    Invalid_Args_Val PLS_INTEGER := -20000;-- was erroring out at -21500...changed to -20000
    Divide_By_Zero EXCEPTION;
    PRAGMA EXCEPTION_INIT(Invalid_Args, -20000);-- was erroring out at -21500...changed to -20000
    PRAGMA EXCEPTION_INIT(Divide_By_Zero, -1476);
  
  BEGIN
    IF (Notify_On_Missing) THEN
      IF Newnum2 IS NULL OR Newnum2 = -1 -- if it quacks like a duck, quack back.  Probably has gone missing
       THEN
        RETURN TRUE;
      END IF;
    END IF;
  
    -- assert no null arguments have gotten here.
    IF (Oldnum1 IS NULL OR Newnum2 IS NULL) THEN
      Raise_Application_Error(Invalid_Args_Val,
                              'one or both of the OLD and NEW VALUE arguments to the function f_numbers_differ is NULL.  NULL is not the same as 0.  Comparison has failed.');
    END IF;
  
    -- assert all arguments are numbers
    IF NOT
        (Ksbms_Util.f_Isnumber(Oldnum1) AND Ksbms_Util.f_Isnumber(Newnum2)) THEN
      Raise_Application_Error(Invalid_Args_Val,
                              'one or both of the OLD and NEW VALUE arguments to the function f_numbers_differ is not a number!');
    END IF;
  
    IF (Nvl(Precision_Limit, 0) < 0) THEN
      Raise_Application_Error(Invalid_Args_Val,
                              'PRECISION_LIMIT arguments to the function f_numbers_differ IS NEGATIVE');
    END IF;
  
    -- try to see if the percentage change is > than the limit but only do this if the divisor is non-zero
    IF (Newnum2 <> 0) THEN
      Lf_Difference := Abs(1.0 - (Oldnum1 / Newnum2));
    ELSE
      -- otherwise just look at the absolute change
      Lf_Difference := Abs(Nvl(Oldnum1, 0) - Nvl(Newnum2, 0));
    END IF;
  
    RETURN Lf_Difference > Nvl(Precision_Limit, 0);
  
  EXCEPTION
    WHEN Divide_By_Zero THEN
      RETURN TRUE;
    WHEN OTHERS THEN
      RAISE;
  END f_Numbers_Differ;

  -- Get the data type of a table.column, returned in uppercase
  FUNCTION f_Get_Column_Data_Type(Psi_Table_Name  IN Sys.All_Tab_Columns.Table_Name%TYPE,
                                  Psi_Column_Name IN Sys.All_Tab_Columns.Column_Name%TYPE)
    RETURN Sys.All_Tab_Columns.Data_Type%TYPE IS
    Ls_Result Sys.All_Tab_Columns.Data_Type%TYPE;
  BEGIN
    SELECT Data_Type
      INTO Ls_Result
      FROM Sys.All_Tab_Columns
     WHERE Upper(Table_Name) = TRIM(Upper(Psi_Table_Name))
       AND TRIM(Upper(Column_Name)) = TRIM(Upper(Psi_Column_Name));
  
    RETURN Upper(Ls_Result);
  EXCEPTION
    WHEN OTHERS THEN
      p_Add_Msg('f_get_column_data_type() failed to find table.column ' ||
                Upper(Psi_Table_Name) || '.' || Upper(Psi_Column_Name) ||
                ' in all_tab_columns.');
      RETURN NULL;
  END;

  -- Do we need apostrophes around a data value, when we use it in an update? 
  -- Date conversion? Check the data type and munge the value.
  -- If the function fails, e.g. because it's data type cannot be determined,
  -- then the original column value is returned unchanged. If it succeeds,
  -- then the column value is returned CHANGED as needed, e.g. surrounded
  -- by apostrophes or embedded in a to_date() call.
  --
  -- Returns TRUE on failure. The "work" is performed by an in-out variable.
  FUNCTION f_Wrap_Data_Value(Psi_Table_Name    IN Sys.All_Tab_Columns.Table_Name%TYPE,
                             Psi_Column_Name   IN Sys.All_Tab_Columns.Column_Name%TYPE,
                             Psio_Column_Value IN OUT VARCHAR2)
    RETURN BOOLEAN IS
    Lb_Failed    BOOLEAN := TRUE;
    Ls_Data_Type Sys.All_Tab_Columns.Data_Type%TYPE;
    Ls_Context CONSTANT Context_String_Type := 'f_wrap_data_value()';
  BEGIN
    LOOP
      p_Push(Ls_Context);
      Ls_Data_Type := f_Get_Column_Data_Type(Psi_Table_Name,
                                             Psi_Column_Name);
    
      IF f_Ns(Ls_Data_Type) THEN
        -- Hoyt 08/07/2002 ENHANCEMENT Register a bug?!
        EXIT;
      END IF;
    
      -- Hoyt 08/07/2002 If the value is NULL, then return that magic string
      IF f_Ns(Psio_Column_Value) THEN
        Psio_Column_Value := 'NULL';
        Lb_Failed         := FALSE; -- Treat as success
        EXIT; -- Done
      END IF;
    
      -- Wrap string values
      IF Instr('|CHAR|VARCHAR2|', '|' || Ls_Data_Type || '|') <> 0 THEN
        -- Hoyt 02/27/2002 "Escape" any single-quotes!
        -- The following finds one single-quote and replaces it with two,
        -- so the string "Joe's" becomes "Joe''s", 
        -- so it doesn't break SQL "where barname = 'Joe''s' and..."
        Psio_Column_Value := f_Substr(Psio_Column_Value, '''', '''''');
        Psio_Column_Value := '''' || Psio_Column_Value || '''';
        -- For dates, we need to wrap the date in a literal conversion
      ELSIF Ls_Data_Type = 'DATE' THEN
        -- ENHANCEMENT: How are in-coming dates 'formatted'?
        -- Going for: to_date( '1901-01-26 12:23:34', 'YYYY-MM-DD HH24:MI:SS' )
        Psio_Column_Value := 'to_date( ''' || Psio_Column_Value ||
                             ''', ''YYYY-MM-DD HH24:MI:SS'' )';
      END IF;
    
      -- Success!
      Lb_Failed := FALSE;
      EXIT;
    END LOOP;
  
    -- On error, we simply note that fact
    IF Lb_Failed THEN
      p_Bug('f_wrap_data_value() didn''t wrap table.column ' ||
            Upper(Psi_Table_Name) || '.' || Upper(Psi_Column_Name));
    END IF;
  
    p_Pop(Ls_Context);
    RETURN Lb_Failed;
  END f_Wrap_Data_Value;

  -- Given a brkey, column name, and value, updates BRIDGE to set the column to the value
  FUNCTION f_Set_Bridge_Value(Psi_Brkey        IN Bridge.Brkey%TYPE,
                              Psi_Column_Name  IN VARCHAR2,
                              Psi_Column_Value IN VARCHAR2) RETURN BOOLEAN -- function returns FALSE on success, TRUE on FAILURE
   IS
    Lb_Failed       BOOLEAN := TRUE; -- Assume failure
    Ls_Column_Value VARCHAR2(2000);
    Ls_Sql          VARCHAR2(2000);
  BEGIN
    LOOP
      NULL;
      -- Do we need apostrophes or date conversion? Fix the literal based on its data type.
      Ls_Column_Value := Psi_Column_Value;
    
      IF Ksbms_Util.f_Wrap_Data_Value('BRIDGE',
                                      Psi_Column_Name,
                                      Ls_Column_Value) THEN
        EXIT;
      END IF;
    
      BEGIN
        Ls_Sql := 'update bridge set ' || Psi_Column_Name || ' = ' ||
                  Ls_Column_Value || ' where brkey = ' || Upper(Psi_Brkey);
        EXECUTE IMMEDIATE Ls_Sql;
      EXCEPTION
        WHEN OTHERS THEN
          Ksbms_Util.p_Sql_Error('Updating BRIDGE column ' ||
                                 Psi_Column_Name || ' to ' ||
                                 Ls_Column_Value);
      END;
    
      -- success!
      Lb_Failed := FALSE;
      EXIT WHEN TRUE;
    END LOOP;
    -- This catches the exception triggered by p_sql_error() above
  EXCEPTION
    WHEN OTHERS THEN
      NULL; -- Continue
      RETURN Lb_Failed;
  END f_Set_Bridge_Value;

  -- Replace all of a string's instances of one token with another token, ignoring case.
  -- On error, such as a NULL old token, f_substr() does a p_add_msg() and returns the
  -- original string.
  -- (Named confusingly for historical reasons -- is not "substring", it's "substitute string".)
  /* ARM 3/6/2002 replaced all this hand coding with call to SQL REPLACE FUNCTION  */
  FUNCTION f_Substr(The_String    IN VARCHAR2,
                    The_Old_Token IN VARCHAR2,
                    The_New_Token IN VARCHAR2) RETURN VARCHAR2 IS
    --ll_pos                pls_integer;
    --ll_old_token_length   pls_integer;
    --ll_new_token_length   pls_integer;
    Ls_New_String VARCHAR2(32767);
    --ls_new_token          varchar2 (32767);
  BEGIN
    -- The target string cannot be null or empty (but it CAN be blank, so no trim()!)
    --init
    Ls_New_String := NULL;
  
    <<do_Once>>
    LOOP
      /*ONCE */
      IF The_String IS NULL THEN
        p_Bug('NULL passed as ''the_string'' to f_substr()');
        --return the_string;
        EXIT; -- ARM 3/6/2002
      END IF;
    
      IF Length(The_String) = 0 THEN
        p_Bug('Zero-length string passed as ''the_string'' to f_substr()');
        EXIT; -- effectively returns null ARM 3/6/2002
      END IF;
    
      -- Notify if the_string is longer than the max allowed (is this possible?)
      IF Length(The_String) > Length(Ls_New_String) THEN
        p_Bug('The input string is longer than 32767!! ' ||
              Substr(The_String, 1, 255) || '...');
        -- ARM 3/6/2002      
        -- THIS IS AN ERROR, NOT ALLOWED       
        --return the_string;
        Ls_New_String := The_String;
        EXIT; -- ARM 3/6/2002
      END IF;
    
      -- ENHANCEMENT: the_string could be "in out" and we could operate on it directly,
      -- which might overcome the 32767 limit, only where would the longer string
      -- come from?
    
      -- The old token must be a string
      IF The_Old_Token IS NULL THEN
        p_Bug('NULL passed as ''the_old_token'' to f_substr()');
        Ls_New_String := The_String;
        EXIT; -- ARM 3/6/2002
      END IF;
    
      IF Length(The_Old_Token) = 0 THEN
        p_Bug('Zero-length string passed as ''the_old_token'' to f_substr()');
        Ls_New_String := The_String;
        EXIT; -- ARM 3/6/2002
      END IF;
    
      -- The new token may be missing, 
      -- in which case it is treated as the empty string,
      -- which has the effect of _removing_ the_old_token
      -- ls_new_token := the_new_token;  /* ARM 3/6/2002 - do not need to do this for REPLACE function*/
    
      IF The_New_Token IS NULL THEN
        Ls_New_String := REPLACE(The_String, The_Old_Token);
      ELSE
        Ls_New_String := REPLACE(The_String, The_Old_Token, The_New_Token);
      END IF;
    
      EXIT;
    END LOOP Do_Once;
  
    /* ARM 3/6/2002 use SQL REPLACE FUNCTION INSTEAD OF ALL THIS HAND CODE D VERSION*/
    RETURN Ls_New_String;
    /*
    -- Initialize
    ll_pos := 0;
    ls_new_string := the_string;
    ll_old_token_length := nvl (length (the_old_token), 0);
    ll_new_token_length := nvl (length (ls_new_token), 0);
    
    
    -- Loop until all the
    loop
       -- Is there another token to replace?
       ll_pos := instr (upper (ls_new_string), upper (the_old_token),   ll_pos
                                                                      + 1);
    
       -- ll_pos might be null, if the new token is the empty string?!
       if    ll_pos = 0
          or ll_pos is null -- Nope, we done
       then
          exit;
       end if;
    
       -- Replace the old token
       ls_new_string :=    substr (ls_new_string, 1,   ll_pos
                                                     - 1)
                        || ls_new_token
                        || substr (ls_new_string,   ll_pos
                                                  + ll_old_token_length, 99999);
       -- Advance the position pointer to beyond the just-inserted new token
       ll_pos :=   ll_pos
                 + ll_new_token_length
                 - 1;
    end loop;
    return ls_new_string;
    */
  END f_Substr;

  -- Returns a format string for display just a date
  -- Usage: p_bug( 'Date is ' || to_char( sysdate, f_display_date_format() ) );
  --        (see f_to_date() for simpler means to convert a date to a string)
  -- Yields: 2002-02-22    (if it is February 22, 2002)
  FUNCTION f_Display_Date_Format RETURN VARCHAR2 IS
  BEGIN
    RETURN 'YYYY-MM-DD';
  END f_Display_Date_Format;

  -- Returns a format string for display just a date
  -- Usage: p_bug( 'DateTime is ' || to_char( sysdate, f_display_datetime_format() ) );
  --        (see f_to_datetime() for simpler means to convert a date to a string)
  -- Yields: 2002-02-22 14:46:22   (if it is 2:46 PM (and 22 seconds) on February 22, 2002)
  FUNCTION f_Display_Datetime_Format RETURN VARCHAR2 IS
  BEGIN
    RETURN 'YYYY-MM-DD HH24:MI:SS';
  END f_Display_Datetime_Format;

  -- Returns a date formatted as a string
  -- Usage: p_bug( 'Date is ' || f_to_date( sysdate ) );
  -- Yields: 2002-02-22    (if it is February 22, 2002)
  FUNCTION f_To_Date(Pdti_Date IN DATE) RETURN VARCHAR2 IS
  BEGIN
    -- Return NULL if a NULL date is passed
    IF Pdti_Date IS NULL THEN
      RETURN NULL;
    END IF;
  
    RETURN To_Char(Pdti_Date, f_Display_Date_Format);
  END f_To_Date;

  -- Returns a datetime formatted as a string
  -- Usage: p_bug( 'Date is ' || f_to_datetime( sysdate ) );
  -- Yields: 2002-02-22 14:46:22   (if it is 2:46 PM (and 22 seconds) on February 22, 2002)
  FUNCTION f_To_Datetime(Pdti_Date IN DATE) RETURN VARCHAR2 IS
  BEGIN
    -- Return NULL if a NULL date is passed
    IF Pdti_Date IS NULL THEN
      RETURN NULL;
    END IF;
  
    RETURN To_Char(Pdti_Date, f_Display_Datetime_Format);
  END f_To_Datetime;

  -- Returns a datetime formatted as a string you can use to insert the date into SQL.
  -- Usage: ls_sql := 'where createdate > ' || f_to_datetime_string( sysdate );
  -- Yields: to_date( '2002-02-22 07:01:35', 'YYYY-MM-DD HH24:MI:SS' )
  -- The 'form' of the date is determined by f_display_datetime_format().
  FUNCTION f_To_Datetime_String(Pdti_Date IN DATE) RETURN VARCHAR2 IS
    Ls_String VARCHAR2(200);
  BEGIN
    -- Return NULL if a NULL date is passed
    IF Pdti_Date IS NULL THEN
      RETURN NULL;
    END IF;
  
    -- Build the string (using 'datetime', not 'date' versions)
    Ls_String := 'to_date( ''' || f_To_Datetime(Pdti_Date) || ''', ''' ||
                 f_Display_Datetime_Format || ''' )';
    RETURN Ls_String;
  END f_To_Datetime_String;

  -- Returns a date (w/o HH24:MI:SS) formatted as a string you can use to insert the date into SQL.
  -- Usage: ls_sql := 'where createdate > ' || f_to_date_string( sysdate );
  -- Yields: to_date( '2002-02-22', 'YYYY-MM-DD' ) 
  -- The 'form' of the date is determined by f_display_date_format().
  FUNCTION f_To_Date_String(Pdti_Date IN DATE) RETURN VARCHAR2 IS
    Ls_String VARCHAR2(200);
  BEGIN
    -- Return NULL if a NULL date is passed
    IF Pdti_Date IS NULL THEN
      RETURN NULL;
    END IF;
  
    -- Build the string (using 'date', not 'datetime' versions)
    Ls_String := 'to_date( ''' || f_To_Date(Pdti_Date) || ''', ''' ||
                 f_Display_Date_Format || ''' )';
    RETURN Ls_String;
  END f_To_Date_String;

  FUNCTION f_Commit_Or_Rollback(Pbi_Failed  BOOLEAN,
                                Psi_Context Context_String_Type)
    RETURN BOOLEAN
  /* Pass this function the value of lb_failed (which is TRUE if the
       calling function failed), along with the context of the calling
       function, and f_commit_or_rollback() will COMMIT or ROLLBACK!
    
      f_commit_or_rollback() also does a 'f_whatever() failed' p_bug()
      message, to "indicate the stack" of failures.
    
    Usage:
    
    This shows how you can 'return' this function, to return lb_failed
    to the calling routine:
    
            -- f_whatever() returns TRUE on failure
            ls_context context_string_type = 'f_whatever()';
            lb_failed boolean := true; -- Until we succeed
            ...
            <<do_onced>
            loop
    
               ...
    
               lb_failed = false;
            end loop do_once;
    
            -- Commit or rollback changes and return failure indicator
            return f_commit_or_rollback( lb_failed, ls_context );
    
          end f_whatever;
    
    In a procedure, you cannot return the value, so:
    
       lb_failed := f_commit_or_rollback( lb_failed, ls_context );
    
    The function f_commit_or_rollback() always returns lb_failed EXCEPT
    when lb_failed is FALSE (meaning success) and the COMMIT fails, in
    which case TRUE is returned by f_commit_or_rollback().
    
    */
   IS
    Lb_Failed BOOLEAN;
  BEGIN
    -- So we can reset it if necessary
    Lb_Failed := Pbi_Failed;
  
    -- If the calling routine failed, then rollback
    IF Lb_Failed THEN
      -- ROLLBACK changes
      BEGIN
        BEGIN
          ROLLBACK;
          p_Log(Psi_Context || ' ROLLED BACK changes!');
        EXCEPTION
          WHEN OTHERS THEN
            -- NB: Variant 2 does NOT raise the exception
            p_Sql_Error2(Psi_Context ||
                         ' called f_commit_or_rollback() which could not ROLLBACK!');
        END;
      END;
    ELSE
      -- COMMIT changes
      BEGIN
        COMMIT;
        p_Log(Psi_Context || ' COMMITed changes!');
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            -- NB: Variant 2 does NOT raise the exception
            Lb_Failed := TRUE;
            p_Sql_Error2(Psi_Context ||
                         ' called f_commit_or_rollback() which could not COMMIT!');
          END;
      END;
    END IF;
  
    -- Note the failure
    IF Lb_Failed THEN
      p_Bug(Psi_Context || ' failed');
    END IF;
  
    -- In any event, we return the pbi_failed argument
    RETURN Lb_Failed;
  END f_Commit_Or_Rollback;

  -- This removes any "wrong" newline and carriage returns
  -- characters that would otherwise display as square boxes
  -- in PowerBuilder.
  FUNCTION f_Clean_Up_Nl_Cr(Psio_String IN OUT VARCHAR2) RETURN BOOLEAN IS
    Ls_Context Context_String_Type := 'f_clean_up_nl_cr()';
    Ls_String  VARCHAR2(32767); -- Big as it gets?!
  BEGIN
    -- Make sure the string is there
    IF f_Ns(Psio_String) THEN
      p_Bug('NULL or empty string passed to ' || Ls_Context);
      RETURN TRUE; -- Failed
    END IF;
  
    -- "Capture" the "good" pairs
    Ls_String := f_Substr(Psio_String, Chr(13) || Chr(10), '<CRNL>');
    -- If it's backwards, make it forwards
    Ls_String := f_Substr(Ls_String, Chr(10) || Chr(13), '<CRNL>');
    -- Remove any remaining "singletons"
    Ls_String := Nvl(f_Substr(Ls_String, Chr(13), ''), ' '); -- A single space if NULL
    Ls_String := Nvl(f_Substr(Ls_String, Chr(10), ''), ' ');
    -- Let's avoid more than two empty lines consecutively 
    Ls_String := Nvl(f_Substr2(Ls_String,
                               '<CRNL><CRNL><CRNL>',
                               '<CRNL><CRNL>'),
                     ' ');
    -- Restore the "good" pairs
    Ls_String := Nvl(f_Substr(Ls_String, '<CRNL>', Chr(13) || Chr(10)), ' ');
  
    -- In case we didn't catch it
    IF Ls_String IS NULL THEN
      Pl('NULL string generated in f_clean_up_nl_cr()!');
    END IF;
  
    -- Set the fixed string
    Psio_String := Ls_String;
    -- Success!
    RETURN FALSE;
  END;

  -- Variant removes ALL the instances of the old token.
  -- f_substr( str, '  ', ' ') would replace each pair of blanks
  -- with a single blank, so four blanks would be replaced with two.
  -- The variant f_substr2( str, '  ', ' ' ) would replace the two
  -- blanks with one, then search for the NEXT set of two blanks
  -- at the same place... so ultimately four blanks would be reduced
  -- to just ONE. 
  -- Replace all of a string's instances of one token with another token, ignoring case.
  -- On error, such as a NULL old token, f_substr() does a p_add_msg() and returns the
  -- original string.
  -- (Named confusingly for historical reasons -- is not "substring", it's "substitute string".)
  FUNCTION f_Substr2(The_String    IN VARCHAR2,
                     The_Old_Token IN VARCHAR2,
                     The_New_Token IN VARCHAR2) RETURN VARCHAR2 IS
    --ll_pos                pls_integer;
    --ll_old_token_length   pls_integer;
    --ll_new_token_length   pls_integer;
    Ls_New_String VARCHAR2(32767);
    --ls_new_token          varchar2 (32767);
  
    /*
    ARM 3/6/2002 fixed this to just use the ORACLE REPLACE built-in function, kept shrouding stuff
    at start
    */
  BEGIN
    Ls_New_String := NULL;
  
    <<do_Once>>
    LOOP
      -- The target string cannot be null or empty (but it CAN be blank, so no trim()!)
      IF The_String IS NULL THEN
        p_Bug('NULL passed as ''the_string'' to f_substr2()');
        EXIT;
      END IF;
    
      IF Length(The_String) = 0 THEN
        p_Bug('Zero-length string passed as ''the_string'' to f_substr2()');
        EXIT;
      END IF;
    
      -- Notify if the_string is longer than the max allowed (is this possible?)
      IF Length(The_String) > Length(Ls_New_String) THEN
        p_Bug('The input string is longer than 32767!! ' ||
              Substr(The_String, 1, 255) || '...');
        Ls_New_String := The_String;
        EXIT;
      END IF;
    
      -- ENHANCEMENT: the_string could be "in out" and we could operate on it directly,
      -- which might overcome the 32767 limit, only where would the longer string
      -- come from?
    
      -- The old token must be a string
      IF The_Old_Token IS NULL THEN
        p_Bug('NULL passed as ''the_old_token'' to f_substr2()');
        Ls_New_String := The_String;
        EXIT; --return the_string;
      END IF;
    
      IF Length(The_Old_Token) = 0 THEN
        p_Bug('Zero-length string passed as ''the_old_token'' to f_substr2()');
        Ls_New_String := The_String;
        EXIT;
        --return the_string;
      END IF;
    
      -- The new token may be missing, 
      -- in which case it is treated as the empty string,
      -- which has the effect of _removing_ the_old_token
      /* ls_new_token := the_new_token;
      
      if ls_new_token is null
      then
         ls_new_token := '';
      end if;*/
    
      -- Variant 2 difference: the new token CANNOT include the old token,
      -- or we have an infinite look
      IF Instr(Upper(The_New_Token), Upper(The_Old_Token)) <> 0 THEN
        p_Bug('New token contains the old token (infinite loop time!) in f_substr2()');
        Ls_New_String := The_String;
        EXIT; --return the_string;
      END IF;
    
      IF The_New_Token IS NULL THEN
        Ls_New_String := REPLACE(The_String, The_Old_Token);
      ELSE
        Ls_New_String := REPLACE(The_String, The_Old_Token, The_New_Token);
      END IF;
    
      EXIT;
    END LOOP Do_Once;
  
    RETURN Ls_New_String;
    /*
    ARM 3/6/2002 rest is commented out.  fixed this to just use the ORACLE REPLACE built-in function, kept shrouding stuff
    at start
    */
    /*
    -- Initialize
    ll_pos := 0;
    ls_new_string := the_string;
    ll_old_token_length := nvl (length (the_old_token), 0);
    ll_new_token_length := nvl (length (ls_new_token), 0);
    -- Loop until all the
    loop
       -- Is there another token to replace?
       ll_pos := instr (upper (ls_new_string), upper (the_old_token));
    
       -- ll_pos might be null, if the new token is the empty string?!
       if    ll_pos = 0
          or ll_pos is null -- Nope, we done
       then
          exit;
       end if;
    
       -- Replace the old token
       ls_new_string :=    substr (ls_new_string, 1,   ll_pos
                                                     - 1)
                        || ls_new_token
                        || substr (ls_new_string,   ll_pos
                                                  + ll_old_token_length, 99999);
    end loop;
    return ls_new_string;*/
  END f_Substr2;

  FUNCTION f_Make_Oracle_Error_4_Testing RETURN BOOLEAN IS
    Lb_Failed  BOOLEAN := TRUE; -- Until we succeed
    Ls_Context Context_String_Type := 'f_make_oracle_error_4_testing()';
    Ls_Sql     VARCHAR2(2000);
  BEGIN
    Ksbms_Util.p_Push(Ls_Context);
  
    <<outer_Exception_Block>>
    BEGIN
    
      <<do_Once>>
      LOOP
        Ls_Sql := 'select count(*) from bridges where brkey like ''J%''';
      
        BEGIN
          EXECUTE IMMEDIATE Ls_Sql;
        EXCEPTION
          WHEN OTHERS THEN
            p_Sql_Error('Executing SQL: ' || Ls_Sql);
        END;
      
        -------------------
        -- Success exit
        -------------------
      
        Lb_Failed := FALSE;
        EXIT Do_Once; -- Done!
      END LOOP Do_Once;
      -----------------------------------------------------------------          
      -- This exception handler surrounds ALL the code in this function
      -----------------------------------------------------------------          
    EXCEPTION
      WHEN OTHERS THEN
        Lb_Failed := TRUE; -- Just to be sure
        Ksbms_Util.p_Clean_Up_After_Raise_Error(Ls_Context);
    END Outer_Exception_Block; -- This ends the anonymous block created just to have the error handler
  
    -----------------------------------------------------------------          
    -- Put any clean-up code that munges on the database here
    -----------------------------------------------------------------          
  
    Ksbms_Util.p_Pop(Ls_Context);
    -- Save the changes (or not)
    RETURN Ksbms_Util.f_Commit_Or_Rollback(Lb_Failed, Ls_Context);
  END f_Make_Oracle_Error_4_Testing;

  -- Add comma-space to the passed string, if it does already end with comma-string
  -- e.g. "string" would be changed to "string, "
  -- but  "another, " would NOT be changed.
  FUNCTION f_Add_Comma(Psi_String IN VARCHAR2) RETURN VARCHAR2 IS
    Ls_Working_String VARCHAR2(4000);
  BEGIN
    Ls_Working_String := Psi_String;
  
    IF Substr(Psi_String, Length(Psi_String) - 2, 2) <> ', ' THEN
      Ls_Working_String := Ls_Working_String || ', ';
    END IF;
  
    RETURN Ls_Working_String;
  END;

  -- Send an e-mail with the results 
  FUNCTION f_Send_Notification(The_Ds_Job_Id_In IN VARCHAR2,
                               The_Ora_Job_Id   IN PLS_INTEGER)
    RETURN BOOLEAN -- Returns TRUE if the e-mail fails (i.e. it is NOT sent for any reason)
   IS
    Ls_Option  Ds_Config_Options.Optionvalue%TYPE;
    Ls_Subject VARCHAR2(1000);
  BEGIN
    -- Are we e-mailing results? Default to yes ('ON')
    Ls_Option := Nvl(Ksbms_Util.f_Get_Coption_Value('EMAILNOTIFICATION'),
                     'ON');
  
    IF Ls_Option <> 'ON' THEN
      p_Log('EMAILNOTIFICATION is turned off (the option is ' || Ls_Option || ')');
      p_Log('This email message was not sent: ' || Gs_Email_Msg);
      RETURN TRUE; -- Did NOT send mail
    END IF;
  
    -- Get the e-mail distribution list If not specified, then we don't send mail
    Ls_Option := Nvl(Ksbms_Util.f_Get_Coption_Value('EMAIL_NOTIFICATION_LIST'),
                     'NONE');
  
    IF Ls_Option = 'NONE' THEN
      p_Log('The EMAIL_NOTIFICATION_LIST option is not specified)');
      p_Log('This email message was not sent: ' || Gs_Email_Msg);
      RETURN TRUE; -- Did NOT send mail
    END IF;
  
    -- The subject line
    Ls_Subject := 'DS SCHEDULED JOB ' || To_Char(The_Ora_Job_Id) ||
                  ' [ DS JOB ID = ' || The_Ds_Job_Id_In ||
                  ' ] returned SQLCODE ' || To_Char(Gi_Sqlcode) || ' at ' ||
                  f_Now;
  
    -- Send the e-mail
    IF Ksbms_Util.f_Email(Ls_Option, Gs_Email_Msg, Ls_Subject) THEN
      p_Log('This email message was not sent: ' || Gs_Email_Msg);
      RETURN TRUE; -- Did NOT send mail
    END IF;
  
    -- Note success
    p_Log('E-mail subject: "' || Ls_Subject || '" sent to "' || Ls_Option || '"');
    p_Log('E-mail contents: ' || Gs_Email_Msg);
    -- This means this function succeeded
    RETURN FALSE;
  END f_Send_Notification;

  FUNCTION f_Is_Brkey(Psi_Brkey IN Bridge.Brkey%TYPE)
  -- Returns TRUE if the passed string is a valid BRKEY
   RETURN BOOLEAN IS
    Lb_Failed       BOOLEAN := TRUE; -- Until we succeed
    Ls_Context      Context_String_Type := 'f_is_brkey()';
    Li_Record_Count PLS_INTEGER := 0;
  BEGIN
  
    <<outer_Exception_Block>>
    BEGIN
    
      <<do_Once>>
      LOOP
        -- Select to see if there is a BRIDGE record
        -- Allen Marshall, CS - 2003-03-06
        -- fixed to select 1 record, exit immediately (FETCH 1 time)
        -- WAY more efficient than SELECT COUNT(*)
        -- NOTE - THIS DOES NOT TELL US THAT ONLY 1 BRIDGE EXISTS, JUST ANY
        BEGIN
          FOR Irec IN (SELECT Brkey FROM Bridge WHERE Brkey = Psi_Brkey) LOOP
          
            Li_Record_Count := SQL%ROWCOUNT;
            EXIT;
          END LOOP;
          RETURN(Li_Record_Count > 0);
        
        EXCEPTION
          WHEN No_Data_Found THEN
            RETURN FALSE; -- It is NOT valid
          WHEN OTHERS THEN
            p_Sql_Error('Fetching first row for BRKEY = ' || Psi_Brkey);
        END;
      
        -------------------
        -- Success exit
        -------------------
      
        Lb_Failed := FALSE;
        EXIT Do_Once; -- Done!
      END LOOP Do_Once;
      -----------------------------------------------------------------          
      -- This exception handler surrounds ALL the code in this function
      -----------------------------------------------------------------          
    EXCEPTION
      WHEN OTHERS THEN
        Lb_Failed := TRUE; -- Just to be sure
        Ksbms_Util.p_Clean_Up_After_Raise_Error(Ls_Context);
    END Outer_Exception_Block; -- This ends the anonymous block created just to have the error handler
  
    -----------------------------------------------------------------          
    -- Put any clean-up code that munges on the database here
    -----------------------------------------------------------------          
  
    -- Save the changes (or not)
  
    RETURN Ksbms_Util.f_Commit_Or_Rollback(Lb_Failed, Ls_Context);
  END f_Is_Brkey;

  FUNCTION f_Get_Dummy_Ora_Dbms_Jobid(The_Ora_Dbms_Jobid OUT Ds_Jobruns_History.Ora_Dbms_Job_Id%TYPE)
    RETURN BOOLEAN
  
   IS
    Lb_Failed  BOOLEAN := TRUE; -- Until we succeed
    Ls_Context Context_String_Type := 'f_template()';
  BEGIN
  
    <<outer_Exception_Block>>
    BEGIN
    
      <<do_Once>>
      LOOP
      
        The_Ora_Dbms_Jobid := c_Synch_Dummy_Jobid;
      
        -------------------
        -- Success exit
        -------------------
      
        Lb_Failed := FALSE;
        EXIT Do_Once; -- Done!
      END LOOP Do_Once;
      -----------------------------------------------------------------          
      -- This exception handler surrounds ALL the code in this function
      -----------------------------------------------------------------          
    EXCEPTION
      WHEN OTHERS THEN
        The_Ora_Dbms_Jobid := NULL;
        Lb_Failed          := TRUE; -- Just to be sure
        Ksbms_Util.p_Clean_Up_After_Raise_Error(Ls_Context);
      
    END Outer_Exception_Block; -- This ends the anonymous block created just to have the error handler
  
    -----------------------------------------------------------------          
    -- Put any clean-up code that munges on the database here
    -----------------------------------------------------------------          
  
    -- Save the changes (or not)
  
    RETURN Ksbms_Util.f_Commit_Or_Rollback(Lb_Failed, Ls_Context);
  
  END f_Get_Dummy_Ora_Dbms_Jobid;

  FUNCTION f_Template RETURN BOOLEAN IS
    Lb_Failed  BOOLEAN := TRUE; -- Until we succeed
    Ls_Context Context_String_Type := 'f_template()';
  BEGIN
  
    <<outer_Exception_Block>>
    BEGIN
    
      <<do_Once>>
      LOOP
        -------------------
        -- Success exit
        -------------------
      
        Lb_Failed := FALSE;
        EXIT Do_Once; -- Done!
      END LOOP Do_Once;
      -----------------------------------------------------------------          
      -- This exception handler surrounds ALL the code in this function
      -----------------------------------------------------------------          
    EXCEPTION
      WHEN OTHERS THEN
        Lb_Failed := TRUE; -- Just to be sure
        Ksbms_Util.p_Clean_Up_After_Raise_Error(Ls_Context);
    END Outer_Exception_Block; -- This ends the anonymous block created just to have the error handler
  
    -----------------------------------------------------------------          
    -- Put any clean-up code that munges on the database here
    -----------------------------------------------------------------          
  
    -- Save the changes (or not)
  
    RETURN Ksbms_Util.f_Commit_Or_Rollback(Lb_Failed, Ls_Context);
  END f_Template;
  /*
     CVS LOG
     -- $Log: ksbms_util.pck,v $
     -- Revision 1.15  2003/04/14 17:21:02  arm
     -- Allen Marshall, CS - 2003.04.14 - updates to p_log_last - not finalized - disabled call to this function in ksbms_apply_changes......
     --
     -- Revision 1.13  2003/04/12 23:43:43  arm
     -- Allen Marshall, CS - 2003.04.12 - fixed status message email body contents - was ignoring messages driven from KSBMS_DATA_SYNC
     --
  */
  PROCEDURE Documentation IS
  BEGIN
    Pl('PACKAGE KDOT_BLP_UTIL DOCUMENTATION');
    Pl('-------------------------------------------------------------------------------------------------------------------');
    Pl('Copyright: Cambridge Systematics, Inc. - 2001, 2002, 2003  - no redistribution without express permission');
    Pl('-------------------------------------------------------------------------------------------------------------------');
  
    Pl('This package provides a set of reusable utility procedures.  Calls functions in KSBMS_ERR, KSBMS_MSGINFO, KSBMS_EXC');
    Pl('-------------------------------------------------------------------------------------------------------------------');
    Pl('Allen Marshall, CS - 03/31/2003 - added func f_is_view() and f_get_view_owner for istableorview - need to find  view ds_change_log_c');
    Pl('Allen Marshall, CS - 03/31/2003 - changed count_rows_for_table to use istableorview because of ds_change_log_c');
    Pl('Allen Marshall, CS - 03/31/2003 - REmoved PRAGMA AUTONOMOUS_TRANSACTION From p_add_msg() not needed');
    Pl(' Allen Marshall, CS - 03/31/2003 - in p_log(job_id,msg) , upgraded WHEN OTHERS error handler to ROLLBACK first, then print error line in a BEGIN END block');
  
    Pl('Allen Marshall, CS - 03/06/2003 -  Update p_add_msg slightly to trim incoming messages etc.');
  
    Pl('Allen Marshall, CS - 03/06/2003 -  Added p_sql_error3 which is the same as p_sql_error2 excep that the global sql error string gs_SQL_error is not updated with the SQL error - only for bening SQL errors');
  
    Pl('Allen Marshall, CS - 03/06/2003 -  changed f_is_brkey to NOT use SELECT COUNT(*) - Instead, fetches 1 time for brkey and if any rows indicates success');
  
    Pl('Allen Marshall, CS - 01/31/2003 -  changed p_log messages from f_log to use ls_context');
    Pl('Allen Marshall, CS - 01/30/2003 -  in p_push, ls_catch_overflow  :=   ');
    Pl('func: get_object_owner - returns owner of any object passed as a string');
    Pl('func: display_zero_as_label  for a zero value, allows a nice string to be displayed e.g. NO RECORDS');
    Pl('func: sq - enquotes an argument with single quotes');
    Pl('func: dq - enquotes an argument with double quotes');
    Pl('func: f_set_msg_level - sets default message level to allow suppression of spurious messages from system');
    Pl('func: f_get_verbose - determines if verbose tracing messages are desired - default FALSE');
    Pl('func: f_get_coption_value - gets a COPTION value from named table, by name, returns TRUE on failure');
    Pl('func: f_set_coption_value - sets a COPTION value from named table, by name, returns TRUE on failure');
    Pl('func: f_insert_coption - inserts a record for a COPTION value into named option table, by name, returns TRUE on failure');
    Pl('func: f_parse_mailing_list - parses a list of comma separated values to generate a mailing list array ');
    Pl('proc: gen_mail_header - generates a nice mail header for an e-mail being constructed....');
    Pl('func: f_sendmail - performs low-level work of transmitting an e-mail by ORACLE SMTP/TCP/IP routines');
    Pl('func: f_email - sends an e-mail message using a string body...');
    Pl('func: f_xmlemail - place holder for future email using XML body...Not implemented');
    Pl('func: f_get_table_owner - returns SCHEMA name owning a particular table - assumes unique names....');
    Pl('func: f_is_table - is this a table defined in ORACLE for this instance?');
    Pl('func: f_get_object_owner - returns SCHEMA name owning a particular object - assumes unique names across users....');
    Pl('func: f_get_msg_level - returns messaging trace level');
    Pl('func: iscolumn - is this a column in the database');
    Pl('func: istable - is this a table in the database');
    Pl('func: istableorview - is this a table or a view in the database?');
    Pl('proc: p_add_msg: ');
    Pl('proc: p_sql_error: ');
    Pl('proc: p_sql_error2: ');
    Pl('proc: p_clean_up_after_raise_error (psi_context in context_string_type)');
    Pl('proc: p_clean_up_after_raise_error2 (psi_context in context_string_type)');
    Pl('func: f_get_config_option2 (psi_optionname IN VARCHAR2)' ||
       '-- Hoyt 01/06/2002 -- Variant returns string so it can be called in line;' ||
       ' -- the magic string ''ls_return_failure'' indicates a failure.' ||
       'RETURN VARCHAR2');
    Pl('func: f_is_yes (pis_yes_candidate IN VARCHAR2)' ||
       ' -- Hoyt 01/06/2001' ||
       ' -- Returns TRUE if the passed string is any of |on|ok|o|y|yes|t|true|1|' ||
       ' RETURN BOOLEAN  ');
    Pl('func: f_get_email_msg:');
    Pl('func: f_get_sql_error:');
    Pl('proc: p_clear_email_msg: empties out email message so another can be generated');
    Pl('func: f_clear_sql_error:');
    Pl('procedure pl: wrapper for dbms_output.put_line - formats and word wraps string arg');
    Pl('func: random - returns a random numnber.  Variant returns a random number of the # digits desired');
    Pl('func: f_rowcount - returns rowcount for any table - uses proc: COUNT_ROWS_FOR_TABLE');
    Pl('func: f_any_rows_exist - returns TRUE if table has any rows - uses proc: COUNT_ROWS_FOR_TABLE');
    Pl('proc: count_rows_for_table ( ' ||
       'the_string_in      IN       VARCHAR2,' ||
       'the_where_clause   IN       VARCHAR2,' ||
       'the_mode           IN       VARCHAR2,' ||
       'the_count          OUT      PLS_INTEGER,' ||
       'the_error          OUT      BOOLEAN');
    Pl('proc: documentation - exec to print out synopsis of package functions and procedures.');
    -- Hoyt 01/08/2002 Added these functions
    Pl('func: f_now: returns SYSDATE formatted as string using ''YYYY-MM-DD HH24:MM:SS:HH''');
    Pl('func: f_get_entry_id: Returns sys_guid(), a 32-character string used as a unique key');
    Pl('func: f_ns: Returns TRUE if the passed string is NULL or (trimmed) has zero length');
    Pl('func: f_get_column_data_type: Returns ''DATE'' (etc) from all_tab_columns');
    Pl('func: f_wrap_data_value: Adds apostrophes or to_date() to data literals');
    -- End: Hoyt 01/08/2002
    Pl('-----REVISION HISTORY -------');
    -- Add changes in reverse chronological order, please
    Pl('ARM, CS - 01/17/2003 - All Stack Trace calls to p_push and p_pop (passing ls_context or argument psi_context) now use the anchored context_string_type from ksbms_util.  Prevent too small buffer problem');
    Pl('ARM, CS - 01/17/2003 - made context string a global type , changed p_push and p_pop to use the type as argument ');
    Pl('ARM, CS - 01/16/2003 -  slight message change to  p_clean_up_after_raise_error2');
    Pl('ARM, CS - 01/16/2003 -Moved the DOCUMENTATION procedure to the end of the package');
    Pl('ARMarshall, CS, 1/8/2001. Converted procedure to centralized utility package.  Shared by Pontis and ROBOT');
    Pl(' In order to use this, execute privileges must be granted for a user, and a public (or private) synonym must be created in ' ||
       'that user.  Also, table privileges must be granted on all support tables involved with this utility.');
    Pl('-----');
    Pl('ARMarshall, CS, 1/8/2001. Changed PL procedure, improved word wrap behavior.  Use reasonable input lines');
    Pl('ARMarshall, CS, 1/15/2001. Changed sq and dq functions to have 4K string buffers, max for VARCHAR2 variables');
    -- Allen 2002-11-07
    Pl(' ARMarshall, CS, 11/07/2002  forced anchored types in f_get_config_option2  for optionname and optionvalue');
    Pl('     viz. function f_get_config_option2 ( psi_optionname in ds_config_options.optionname%TYPE ) ');
    Pl('     RETURN ds_config_options.optionvalue%type;');
    Pl(' updated p_clean_up_after_raise_error and p_clean_up_after_raise_error2 so that they handle Oracle-generated exceptions out of ');
    Pl(' the allowable range for the raise_application_error procedure they use ');
    /*
      -- these en-commented lines should not be edited - they force CVS to stick all these expanded keywords in to the source code automatically on check-in
     $ID$
     $Source: /repository/kansas/ksbms/ksbms_util.pck,v $
     $Log: ksbms_util.pck,v $
     Revision 1.15  2003/04/14 17:21:02  arm
     Allen Marshall, CS - 2003.04.14 - updates to p_log_last - not finalized - disabled call to this function in ksbms_apply_changes......
    
     Revision 1.13  2003/04/12 23:43:43  arm
     Allen Marshall, CS - 2003.04.12 - fixed status message email body contents - was ignoring messages driven from KSBMS_DATA_SYNC
    
    */
  END;
BEGIN
  -- Initialization
  /* Hoyt 01/11/2002 f_random_float() and f_random_integer */
  /* Generate an initial seed "a" based on system date     */
  /* (Must be connected to database.)                      */
  The_Date := SYSDATE;
  Days     := To_Number(To_Char(The_Date, 'J'));
  Secs     := To_Number(To_Char(The_Date, 'SSSSS'));
  a        := Days * 24 * 3600 + Secs;

  IF g_Notify_List IS NULL THEN
    g_Notify_List := f_Parse_Mailing_List(f_Get_Coption_Value('EMAIL_NOTIFICATION_LIST'));
  END IF;

  IF g_Alert_List IS NULL THEN
    g_Alert_List := f_Parse_Mailing_List(f_Get_Coption_Value('EMAIL_ALERT_LIST'));
  END IF;

  IF Verbose IS NULL THEN
    Verbose := f_Set_Msg_Level('TERSE');
  END IF;

  IF Msglvl_Cutoff IS NULL THEN
    Msglvl_Cutoff := Msglvl_Info; -- only messages level 0-1 will be shown
  END IF;
END Ksbms_Util;
/