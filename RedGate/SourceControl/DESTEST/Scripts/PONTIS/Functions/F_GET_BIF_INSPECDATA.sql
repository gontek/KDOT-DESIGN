CREATE OR REPLACE function pontis.f_get_bif_inspecdata(v_brkey inspevnt.brkey%type,
                                                 tablename_in varchar2,columnname_in varchar2)
  return varchar2 is
  retval    varchar2(2000);
  sqlString varchar2(8000);
 -- quote     char(1) := chr(39); -- use the ASCII code for sinqle quote which is CHR(39)        
  

begin

  -- creates a big sql string which will dynamically include the column name you have passed.
  -- be very careful about single quotes etc.  In this case, have declared a variable that is nothing but a single quote and used that wherever a single quote literal should
  -- appear in the sql e.g. '*' is quote|| '*' || quote which becomes '*' when concatenated.
  -- the variable columnname_in will become the literal column name in the concatenated sql string
  -- CHR(13) means linefeed (carriage return) and will display all the numbers in column when reported.
  -- TEST SCRIPT
  /*
  
  
  */
  

  sqlString := 'select '||
                tablename_in||'.'||
                 columnname_in ||
              ' from userinsp , inspevnt , mv_latest_inspection '||
              ' where userinsp.brkey = :br '||
              ' and mv_latest_inspection.brkey = userinsp.brkey '||
              ' and inspevnt.brkey = userinsp.brkey ' ||
              ' and userinsp.inspkey = mv_latest_inspection.inspkey ' ||
              ' and inspevnt.inspkey = mv_latest_inspection.inspkey ';

  -- execute the dynamic SQL string - supply v_brkey as bind variable :br and v_strunitkey as bind variable :su
  -- return result into retval

  execute immediate sqlString
    into retval
    using v_brkey; -- these are determined by position in the string (see :br and :su above)

  return retval;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --- sql did not find any data, so return a NULL
    return NULL;
  
  WHEN OTHERS THEN
    RAISE; -- something bad happened, report it.

end f_get_bif_inspecdata;

 
/