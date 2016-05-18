CREATE OR REPLACE function pontis.f_get_bif_elemdata(v_brkey       eleminsp.brkey%type,
                                                v_strunitkey   eleminsp.strunitkey%type,
                                                columnname_in varchar2,
                                                v_elemtype char)
  return varchar2 is
  retval    varchar2(2000);
  sqlString varchar2(8000);
  quote     char(1) := chr(39); -- use the ASCII code for sinqle quote which is CHR(39)        
  

begin

  -- create a big sql string which will dynamically include the column name you have passed.
  -- be very careful about single quotes etc.  In this case, have declared a variable that is nothing but a single quote and used that wherever a single quote literal should
  -- appear in the sql e.g. '*' is quote|| '*' || quote which becomes '*' when concatenated.
  -- the variable columnname_in will become the literal column name in the concatenated sql string
  -- CHR(13) means linefeed (carriage return) and will display all the numbers in column when reported.
  -- TEST SCRIPT
  /*
  
  
  */
  

  sqlString := 'select ltrim(substr(replace(sys_connect_by_path(' ||
              columnname_in ||
              ', ' ||
               quote || '*' || quote || '),'|| quote ||'*'|| quote || ', ' || 'CHR(13)' ||
              '   ),  2 ) ) ' ||
              --into retval
               ' from (select distinct ' ||
                columnname_in || 
               ' ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elemkey' ||
               ' ) seq ' ||
               ' from mv_bif_data_elements) ' ||
               '   where seq = cnt  ' || '   and brkey = :br ' ||
               '   and strunitkey = :su ' ||
               '   and elemtype = :ele ' || '   start with seq = 1 ' ||
               '   connect by prior seq + 1 = seq ' ||
               '       and prior brkey = brkey ' ||
               '       and prior strunitkey = strunitkey '||
               '       and prior elemtype = elemtype';

  -- execute the dynamic SQL string - supply v_brkey as bind variable :br and v_strunitkey as bind variable :su
  -- return result into retval

  execute immediate sqlString
    into retval
    using v_brkey, v_strunitkey, v_elemtype; -- these are determined by position in the string (see :br and :su above)

  return retval;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --- sql did not find any data, so return a NULL
    return NULL;
  
  WHEN OTHERS THEN
    RAISE; -- something bad happened, report it.

end f_get_bif_elemdata;

 
/