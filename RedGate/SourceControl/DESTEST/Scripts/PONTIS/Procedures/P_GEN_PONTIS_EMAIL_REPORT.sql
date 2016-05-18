CREATE OR REPLACE PROCEDURE pontis.P_GEN_PONTIS_EMAIL_REPORT(pTable_in         IN VARCHAR2,
                                                      pColumn_list      IN VARCHAR2,
                                                      pWhere_in         IN VARCHAR2 ,
                                                      pOutputTarget     IN PLS_INTEGER ,
                                                      pEmailTitle       IN VARCHAR2,
                                                      pEmailRecipient   IN VARCHAR2,
                                                      pEmailSender      IN VARCHAR2,
                                                      pEmailcc          IN VARCHAR2,
                                                      pEmailbcc         IN VARCHAR2,
                                                      pString_length_in IN INTEGER := 20,
                                                      pDate_format_in   IN VARCHAR2 := 'MM/DD/YYYY HH24:MI:SS') IS
  /* -------------------------------------------------------------------------------------------
  Cambridge Systematics, 6/29/2005.
  -- CHANGE HISTORY
  ARMarshall, CS - 2005-11-21 - added CHANGE HISTORY section
  ARMarshall, CS - 2005-11-21 - changed all date formats to use a variable ls_DefaultDateFormat := "DD-MM-YYYY HH24:MI:SS"
  ARMarshall, CS - 2005-11-21 - forced a space in front of the words WHERE and ORDER BY to avoid a parse error
  ARMarshall, CS - 2005-11-21 - addeed an exception for a column count mismatch when parsing out a SQL statement in the case wher * is NOT passed

  -- END CHANGE HISTORY

  This procedure takes a result of a SELECT query and sends the result in a columnar report format via email.

  P_GEN_PONTIS_EMAIL_REPORT (
      pTable_in => Table or view name, REQUIRED.

      pColumn_list => Column list separated by comma, or enter * (default) to return all columns; OPTIONAL.

      pWhere_in => WHERE clause, OPTIONAL;  If not specified, all rows are retrieved.
                  ORDER BY and HAVING clauses can be passed in.

      pOutputTarget => Enter 1 for email (default); if not, SERVEROUTPUT is used and email is not sent,

      pEmailTitle => Email title.

      pEmailRecipient => Recipient's email address.

      pEmailSender => Sender's email address.

      pString_length_in => Maximum length of string displayed, OPTIONAL.

      pDate_format_in => Date format for display, OPTIONAL.
  )

  This procedure uses the following definitions from the KSBMS_UTIL package:
       TYPE generic_list_type
       p_parse_list()
       f_get_coption_value()
       f_tcp_connect()

  ------------------------------------------------------------------------------------------- */
 

 CURSOR col_cur(owner_nm IN VARCHAR2, pTable_in IN VARCHAR2, column_in IN VARCHAR2) IS
    SELECT column_name, data_type, data_length, data_precision, data_scale
      FROM all_tab_columns
     WHERE owner = upper(owner_nm)
       AND table_name = upper(pTable_in)
       AND column_name = upper(column_in);

  CURSOR col_star_cur(owner_nm IN VARCHAR2, pTable_in IN VARCHAR2) IS
    SELECT column_name, data_type, data_length, data_precision, data_scale
      FROM all_tab_columns
     WHERE owner = upper(owner_nm)
       AND table_name = upper(pTable_in);

  TYPE string_tab IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;

  TYPE integer_tab IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

  colname string_tab;
  coltype string_tab;
  collen  integer_tab;

  owner_nm     VARCHAR2(100) := USER;
  table_nm     VARCHAR2(100) := UPPER(pTable_in);
  where_clause VARCHAR2(1000) := LTRIM(UPPER(pWhere_in));

  cur  INTEGER := DBMS_SQL.OPEN_CURSOR;
  fdbk INTEGER := 0;

  string_value VARCHAR2(2000);
  number_value NUMBER;
  date_value   DATE;

  dot_loc INTEGER;

  col_count          INTEGER := 0;
  col_border         VARCHAR2(200);
  col_default_border VARCHAR2(200);
  col_header         VARCHAR2(200);
  col_line           VARCHAR2(200);
  col_list           VARCHAR2(200);

  line_length INTEGER := 0;
  v_length    INTEGER;

  lv_parse_result      KSBMS_UTIL.generic_list_type := KSBMS_UTIL.generic_list_type(); -- initialize to EMPTY ( not null );
  lv_colAlias          KSBMS_UTIL.generic_list_type := KSBMS_UTIL.generic_list_type();
  ll_column_list_count PLS_INTEGER := 0;
  ll_pos               PLS_INTEGER := 0;
  ls_column_list       VARCHAR2(2000);
  ll_recordCount       PLS_INTEGER := 0;
  ls_PrintDate         VARCHAR2(40);
  -- ARMarshall, CS - 2005-11-21 - begin change
  ls_DefaultDateFormat VARCHAR2(26) := 'DD-MM-YYYY HH24:MI:SS CST'; -- used below to force a default if format bogosity is encountered
  -- ARMarshall, CS - 2005-11-21 - end change
  ls_header            VARCHAR2(8192);
 --crlf                 VARCHAR2(2) := CHR(13)|| CHR(10);
  ls_message_line      VARCHAR2(400);
  ll_linewidth         PLS_INTEGER := 100;
  lb_parseError     BOOLEAN := FALSE;
  ls_emailSender    VARCHAR2(400);
  ls_emailRecipient VARCHAR2(400);
  ls_emailCC        VARCHAR2(400);
  ls_emailBCC       VARCHAR2(400);
  ls_emailTitle     VARCHAR2(400);
  ls_SysAdminEmail  VARCHAR2(400);
  ls_parseErrorMsg  VARCHAR2(400);
  ls_query          VARCHAR2(2000);
  ll_OutputTarget   PLS_INTEGER;
  -- for mail
  mailer_connect UTL_SMTP.CONNECTION;
  mailhost       COPTIONS.OPTIONVAL%TYPE;
  -- ARMarshall, CS - 2005-11-21 - begin change - trap situatioin where bogus or obsolete column name is passed
  exc_column_count_mismatch EXCEPTION;
  ls_rest          coptions.optionval%TYPE;

  FUNCTION is_string(row_in IN INTEGER) RETURN BOOLEAN IS
  BEGIN
    RETURN(coltype(row_in) IN ('CHAR', 'VARCHAR2'));
  END;

  FUNCTION is_number(row_in IN INTEGER) RETURN BOOLEAN IS
  BEGIN
    RETURN(coltype(row_in) = 'NUMBER');
  END;

  FUNCTION is_date(row_in IN INTEGER) RETURN BOOLEAN IS
  BEGIN
    RETURN(coltype(row_in) = 'DATE');
  END;

  FUNCTION centered_string(string_in IN VARCHAR2, length_in IN INTEGER)
    RETURN VARCHAR2 IS
    len_string INTEGER := LENGTH(string_in);
  BEGIN
    IF len_string IS NULL OR length_in <= 0 THEN
      RETURN NULL;
    ELSE
      RETURN RPAD('_', (length_in - len_string) / 2 - 1) || LTRIM(RTRIM(string_in));
    END IF;
  END;

BEGIN
  -------------------------------------------------------------------
  -- if there's an error with SQL, notification email gets sent to sys admin's email address
  -- ARMarshall, CS - 2005-11-21 - begin change - set this to DEB@KSDOT.ORG
  -- RESET TO a CS address for testing
  ls_SysAdminEmail := 'deb@ksdot.org'; --'shwang@camsys.com'; --'Deb@ksdot.org';
  -- ARMarshall, CS - 2005-11-21 - end  change

  ls_emailSender     := pEmailSender;
  ls_emailRecipient  := pEmailRecipient;
  ls_emailcc         := pEmailcc; -- added by dk 3/5/2012...does this work?
  ls_emailbcc        := pEmailbcc; -- added by dk 3/5/2012...does this work?
  ls_emailTitle      := pEmailTitle;
  col_default_border := RPAD('-', 72, '-');

  ll_OutputTarget := NVL(pOutputTarget, 1);

  dot_loc := INSTR(table_nm, '.');
  IF dot_loc > 0 THEN
    owner_nm := SUBSTR(table_nm, 1, dot_loc - 1);
    table_nm := SUBSTR(table_nm, dot_loc + 1);
  END IF;

  ls_column_list := NVL(trim(upper(pColumn_list)), '*');

  If ls_column_list = '*' Then
    FOR col_rec IN col_star_cur(owner_nm, table_nm) LOOP
      col_list := col_list || ', ' || col_rec.column_name;

      /* Save datatype and length for define column calls. */
      col_count := col_count + 1;
      colname(col_count) := col_rec.column_name;
      coltype(col_count) := col_rec.data_type;

      IF is_string(col_count) THEN
        v_length := GREATEST(LEAST(col_rec.data_length,
                                   NVL(pString_length_in, 20)),
                             LENGTH(col_rec.column_name));

      ELSIF is_date(col_count) THEN
        -- ARMarshall, CS - 2005-11-21 - begin change
       --'MM/DD/YYYY HH24:MI:SS')),
        v_length := GREATEST(LENGTH(NVL(pDate_format_in, ls_DefaultDateFormat)),
                             LENGTH(col_rec.column_name));
       -- ARMarshall, CS - 2005-11-21 - end change

      ELSIF is_number(col_count) THEN
        v_length := GREATEST(NVL(col_rec.data_precision,
                                 col_rec.data_length),
                             LENGTH(col_rec.column_name));
      END IF;

      collen(col_count) := v_length;
      line_length := line_length + v_length + 1;

      /* Construct column header line. */
      col_header := col_header || ' ' ||
                    RPAD(col_rec.column_name, v_length);
    END LOOP;

  Else

    -- ls_column_list contains individual column names, not *
    -- ARMarshall, CS - 2005-11-21 - only 500 columns allowed here - is that enough???
    KSBMS_UTIL.p_parse_list(ls_column_list, ',', 500, lv_parse_result);
    ll_column_list_count := lv_parse_result.COUNT;
    FOR i in 1 .. ll_column_list_count LOOP
      lv_colAlias.extend;
      ll_pos := instr(upper(lv_parse_result(i)), ' AS ');
      if ll_pos > 0 then
        lv_colAlias(i) := trim(substr(lv_parse_result(i),
                                      ll_pos + 4,
                                      length(lv_parse_result(i))));
        lv_parse_result(i) := substr(lv_parse_result(i), 1, ll_pos);
      else
        lv_colAlias(i) := lv_parse_result(i);
      end if;
      lv_parse_result(i) := trim(upper(lv_parse_result(i)));
    END LOOP;

    -------------------------------------------------------------------
    -- COLUMN CURSOR ---------------------------------------------------


    For i in 1 .. ll_column_list_count LOOP
      FOR col_rec IN col_cur(owner_nm, table_nm, lv_parse_result(i)) LOOP
        col_list := col_list || ', ' || col_rec.column_name;

        /* Save datatype and length for define column calls. */
        col_count := col_count + 1; -- how many have we processed?
        colname(col_count) := col_rec.column_name;
        coltype(col_count) := col_rec.data_type;

        -- col_rec.column_name = lv_colAlias(i)
        IF is_string(col_count) THEN

          v_length := GREATEST(LEAST(col_rec.data_length,
                                     NVL(pString_length_in, 20)),
                               LENGTH(lv_colAlias(i)));

        ELSIF is_date(col_count) THEN
          -- ARMarshall, CS - 2005-11-21 - begin change
          v_length := GREATEST(LENGTH(NVL(pDate_format_in,
                                          ls_DefaultDateFormat)),
                               LENGTH(lv_colAlias(i)));

        ELSIF is_number(col_count) THEN
          v_length := GREATEST(NVL(col_rec.data_precision,
                                   col_rec.data_length),
                               LENGTH(lv_colAlias(i)));
        END IF;

        collen(col_count) := v_length;
        line_length := line_length + v_length + 1;

        /* Construct column header line. */
        col_header := col_header || ' ' || RPAD(lv_colAlias(i), v_length);
      END LOOP;
    End Loop;

    <<VerifyColumnCount>>
    BEGIN

    -- ARMarshall, CS - 2005-11-21 - begin change
    if ll_column_list_count <> col_count then
       -- column counts for parsed out columns do not match # in original select -
       -- columns were skipped
       -- raise exception - means some columns were invalid or table definition has changed!!
       RAISE exc_column_count_mismatch;
    end if;

    EXCEPTION
    -- ARMarshall, CS - 2005-11-21 - end change
     -- ARMarshall, CS - 2005-11-21 - begin change - trap bogus/missing columns in SQL argument
    WHEN exc_column_count_mismatch then
      lb_parseError     := TRUE;
      ls_emailSender    := 'ksbms_robot@ksdot.org';
      ls_emailRecipient := ls_SysAdminEmail;
      -- ARMarshall, CS - 2005-11-21 - begin change
      ls_emailTitle     := 'Error parsing query passed to stored procedure - column count mismatch';
      ls_parseErrorMsg  := 'A column count mismatch was encountered - this means some columns were in the SQL may have been invalid for the report source table.';
      DBMS_OUTPUT.PUT_LINE(ls_parseErrorMsg);
      DBMS_OUTPUT.PUT_LINE('Table is: ' || pTable_in || ' and columns are: ' || pColumn_list );
      -- ARMarshall, CS - 2005-11-21 - end change

     END VerifyColumnCount;

  End If; -- If ls_column_list = '*' Then

  if not lb_parseError THEN -- looks OK, column count matches, try to make the SQL now
      col_list   := RTRIM(LTRIM(col_list, ', '), ', ');
      col_header := LTRIM(col_header);
      col_border := RPAD('-', line_length, '-');

      IF where_clause IS NOT NULL THEN
        IF (where_clause NOT LIKE 'GROUP BY%' AND
           where_clause NOT LIKE 'ORDER BY%') THEN
          -- ARMarshall, CS - 2005-11-21 - begin change - force a space in front of the word WHERE to avoid a PARSE error
          where_clause := ' WHERE ' || LTRIM(where_clause, 'WHERE');
        END IF;
         -- ARMarshall, CS - 2005-11-21 - begin change - force a space in front of the words ORDER BY
         -- make upper case
          where_clause := REPLACE(where_Clause, 'order by', 'ORDER BY');
          where_clause := REPLACE(where_Clause, 'ORDER BY', ' ORDER BY');

      END IF;


      If col_list is null Then
        -- table name was entered incorrectly
        -- error (ORA-00942: Table or view does not exist) will be catched below
        col_list   := '*';
        col_border := RPAD('-', 74, '-');
      End If;

      Begin
        ls_query := 'SELECT ' || col_list || ' FROM ' || pTable_in || ' ' ||
                    where_clause;
        DBMS_SQL.PARSE(cur, ls_query, DBMS_SQL.V7);

      EXCEPTION


        WHEN OTHERS THEN
          lb_parseError     := TRUE;
          ls_emailSender    := '';
          ls_emailRecipient := ls_SysAdminEmail;
          -- ARMarshall, CS - 2005-11-21 - begin change
          ls_emailTitle     := 'Error parsing query passed to stored procedure';
           -- ARMarshall, CS - 2005-11-21 - end change
          ls_parseErrorMsg  := 'Error parsing query: ORA' ||
                               TO_CHAR(SQLCODE, '99990') || ' at position ' ||
                               TO_CHAR(DBMS_SQL.last_error_position);
          DBMS_OUTPUT.PUT_LINE(ls_parseErrorMsg);
          -- ARMarshall, CS - 2005-11-21 - begin change
          DBMS_OUTPUT.PUT_LINE('SQL string (first 255 characters): ' || substr(ls_query, 255));
          -- ARMarshall, CS - 2005-11-21 - end change
      End;

  end if; -- attempted to make the SQL...


  If lb_parseError = FALSE Then
    FOR col_ind IN 1 .. col_count LOOP
      IF is_string(col_ind) THEN
        DBMS_SQL.DEFINE_COLUMN(cur, col_ind, string_value, collen(col_ind));

      ELSIF is_number(col_ind) THEN
        DBMS_SQL.DEFINE_COLUMN(cur, col_ind, number_value);

      ELSIF is_date(col_ind) THEN
        DBMS_SQL.DEFINE_COLUMN(cur, col_ind, date_value);
      END IF;
    END LOOP;

    fdbk := DBMS_SQL.EXECUTE(cur);
  End If;

  --WRITE TO EMAIL--------------------------------------------
  <<CONTROL_LOOP>>
  LOOP
    BEGIN
      -- ARMarshall, CS - 2005-11-21 - begin change - month first
      SELECT TO_CHAR(SYSDATE, 'DY, MON DD, YYYY HH24:MI:SS ') ||
             NVL(KSBMS_UTIL.f_get_coption_value('TIMEZONE'), 'CST')
        INTO ls_PrintDate
        FROM DUAL;

      IF ll_OutputTarget = 1 THEN
        -- initiate email conversation
        -- if email is the target (1)
        BEGIN
          IF KSBMS_UTIL.f_tcp_connect(mailer_connect, mailhost) THEN
            -- true means failed!
            EXIT Control_Loop;
          END IF;

          -- initiate conversation
          UTL_SMTP.helo(mailer_connect, mailhost);
          UTL_SMTP.mail(mailer_connect, ls_emailSender);
          UTL_SMTP.rcpt(mailer_connect, ls_emailRecipient);
          UTL_SMTP.rcpt(mailer_connect, ls_emailCC); --added by dk 3/5/2012...does this work?
          UTL_SMTP.rcpt(mailer_connect, ls_emailBCC); --added by dk 3/5/2012...does this work?

        EXCEPTION
          WHEN OTHERS THEN
            RAISE;
        END;

        -- start the message ...
        UTL_SMTP.Open_Data(mailer_connect);

        ls_header := 'Date:  ' || ls_PrintDate;
        UTL_SMTP.Write_Data(mailer_connect, ls_header || UTL_TCP.crlf);

        ls_header := 'From:  ' || NVL(ls_emailSender, 'nobody');
        UTL_SMTP.Write_Data(mailer_connect, ls_header || UTL_TCP.crlf);

        ls_header := 'To:  ' || NVL(ls_emailRecipient, 'nobody');
        UTL_SMTP.Write_Data(mailer_connect, ls_header || UTL_TCP.crlf);

        ls_header := 'Subject:  ' || NVL(ls_emailTitle, '<No Subject>');
        UTL_SMTP.Write_Data(mailer_connect, ls_header || UTL_TCP.crlf);

        ls_header := 'CC:' || NVL(ls_emailcc, 'nobody');
        UTL_SMTP.Write_Data(mailer_connect, ls_header || UTL_TCP.crlf);

        ls_header := 'BCC:' || NVL(ls_emailbcc,'nobody');
        UTL_SMTP.Write_Data(mailer_connect, ls_header || UTL_TCP.crlf);
        
        ls_header := col_default_border;
        UTL_SMTP.Write_Data(mailer_connect, ls_header || UTL_TCP.crlf);
        /*
        ls_message_line := 'TO ALL RECIPIENTS: PLEASE DO NOT REPLY TO THIS MESSAGE.';
        UTL_SMTP.Write_Data(mailer_connect, ls_message_line || UTL_TCP.crlf);
        
        ls_message_line := 'It was auto-generated by the KDOT KSBMS Pontis System.';
        UTL_SMTP.Write_Data(mailer_connect, ls_message_line || UTL_TCP.crlf);
        ls_message_line := 'You may contact Bridge Management at KDOT';
        UTL_SMTP.Write_Data(mailer_connect, ls_message_line || UTL_TCP.crlf);
        ls_message_line := 'for further information about this report.';
        UTL_SMTP.Write_Data(mailer_connect, ls_message_line || UTL_TCP.crlf);
*/
--start message with a blank line.     
 UTL_SMTP.Write_Data(mailer_connect,UTL_TCP.CRLF);
      
      ls_message_line := RPAD('=', ll_linewidth, '=');
      --  UTL_SMTP.Write_Data(mailer_connect, col_default_border || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(mailer_connect, ls_message_line || UTL_TCP.CRLF);
        UTL_SMTP.Write_Data(mailer_connect, ls_message_line || UTL_TCP.CRLF);
        
      ls_message_line := nvl(ksbms_util.f_get_coption_value ('KSBMS_ROBOT_EMAIL_DONOTREPLY'),
                        'Please do not reply to this message.  It was auto-generated by the Pontis system.');
      ls_message_line :=  KSBMS_UTIL.f_wordwrap(ls_message_line,
                                                80,
                                                ls_rest); 
 UTL_SMTP.Write_Data(mailer_connect, ls_message_line || UTL_TCP.CRLF);                
 
   -- Loop until the do not reply message is fully printed
 WHILE TRUE LOOP
   ls_message_line := KSBMS_UTIL.f_wordwrap(ls_rest,
                                            80,
                                            ls_rest);
   UTL_SMTP.Write_Data(mailer_connect, ls_message_line || UTL_TCP.CRLF);
   
   If ls_rest is null or ls_message_line is null THEN
     EXIT;
    END IF;
    END LOOP;
   ls_message_line := RPAD('=',ll_linewidth,'=');
                                             
   UTL_SMTP.Write_data(mailer_connect, ls_message_line || UTL_TCP.CRLF);
   UTL_SMTP.Write_Data(mailer_connect, ls_message_line || UTL_TCP.CRLF);
   
        UTL_SMTP.Write_Data(mailer_connect,
                            rpad('Report Run Date    :', 20, ' ') || ' ' ||
                            ls_PrintDate || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(mailer_connect, ' ' || UTL_TCP.crlf);
      END IF; -- IF ll_OutputTarget = 1 THEN

      If lb_parseError = FALSE Then
        ---BEGIN: RECORD LOOP -------------------------------------------------------------------
        ll_recordCount := 0;
        LOOP
          fdbk := DBMS_SQL.FETCH_ROWS(cur);
          EXIT WHEN fdbk = 0;

          ll_recordCount := ll_recordCount + 1;
          IF DBMS_SQL.LAST_ROW_COUNT = 1 THEN
            if ll_OutputTarget = 1 then
              UTL_SMTP.Write_Data(mailer_connect, col_border || UTL_TCP.crlf);
              UTL_SMTP.Write_Data(mailer_connect, col_header || UTL_TCP.crlf);
              UTL_SMTP.Write_Data(mailer_connect, col_border || UTL_TCP.crlf);
            else
              DBMS_OUTPUT.PUT_LINE(col_border);
              DBMS_OUTPUT.PUT_LINE(col_header);
              DBMS_OUTPUT.PUT_LINE(col_border);
            end if;
          END IF;

          col_line := NULL;
          FOR col_ind IN 1 .. col_count LOOP
            IF is_string(col_ind) THEN
              DBMS_SQL.COLUMN_VALUE(cur, col_ind, string_value);

            ELSIF is_number(col_ind) THEN
              DBMS_SQL.COLUMN_VALUE(cur, col_ind, number_value);
              string_value := TO_CHAR(number_value);

            ELSIF is_date(col_ind) THEN
              DBMS_SQL.COLUMN_VALUE(cur, col_ind, date_value);
              string_value := TO_CHAR(date_value, pDate_format_in);
            END IF;

            col_line := col_line || ' ' ||
                        RPAD(NVL(string_value, ' '), collen(col_ind));
          END LOOP;

          if ll_OutputTarget = 1 then
            UTL_SMTP.Write_Data(mailer_connect, col_line || UTL_TCP.crlf);
          else
            DBMS_OUTPUT.PUT_LINE(col_line);
          end if;
        END LOOP;
        ---END: RECORD LOOP -------------------------------------------------------------------

      end if;

      If ll_OutputTarget = 1 then
        -- All done, send the email
        -- Add total count of records
        UTL_SMTP.Write_Data(mailer_connect, ' ' || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(mailer_connect, col_border || UTL_TCP.crlf);

        If lb_parseError = FALSE Then
          UTL_SMTP.Write_Data(mailer_connect,
                              'Number of Records: ' ||
                              to_char(ll_recordCount, '999,990') || UTL_TCP.crlf);
        Else
          UTL_SMTP.Write_Data(mailer_connect, col_line || UTL_TCP.crlf);
          UTL_SMTP.Write_Data(mailer_connect,
                              'Error message: ' || ls_parseErrorMsg || UTL_TCP.crlf);
          UTL_SMTP.Write_Data(mailer_connect,
                              'SQL string   : ' || ls_query || UTL_TCP.crlf);
        End if;
        UTL_SMTP.Write_Data(mailer_connect, col_border || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(mailer_connect, ' ' || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(mailer_connect, ' ' || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(mailer_connect, col_border || UTL_TCP.crlf);
        UTL_SMTP.close_data(mailer_connect);
        UTL_SMTP.quit(mailer_connect); -- close email, send
        EXIT Control_Loop;
      else
        DBMS_OUTPUT.PUT_LINE('Number of Records: ' || to_Char( ll_recordCount, '999,990')  ) ;
        EXIT Control_Loop;
      end if;

    EXCEPTION
      WHEN OTHERS THEN
        RAISE;
        EXIT Control_Loop;

    End;

  END LOOP Control_Loop;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END; -- P_GEN_PONTIS_EMAIL_REPORT

 
/