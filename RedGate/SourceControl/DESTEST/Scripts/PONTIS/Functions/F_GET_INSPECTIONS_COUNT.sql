CREATE OR REPLACE function pontis.f_get_inspections_count(datecolumn_in varchar2,
                                                   columnname_in varchar2,
                                                   v_year varchar2,
                                                   v_userkey varchar2) return number is
    retval    number;
    sqlString varchar2(8000);
    quote     char(1) := chr(39); -- uses ASCII code for single quote which is CHR(39)
  
  begin
  
    -- create a big sql string which will dynamically include the tablename and column name you have passed.
  
    sqlString := ' select count('|| quote || '*' || quote ||')'||
                 ' from userinsp us , inspevnt i , mv_latest_inspection mv ' ||
                 ' where us.brkey = mv.brkey '||
                 ' and i.brkey = mv.brkey  ' ||
                 ' and us.inspkey = mv.inspkey ' ||
                 ' and i.inspkey = mv.inspkey  ' ||
                 ' and extract(year from ' ||
                   datecolumn_in||') = :yr and '||
                   columnname_in||' = :us ' ;
 
  
    -- execute the dynamic SQL string - supply v_brkey as bind variable :br 
    -- return result into retval
  
    execute immediate sqlString
      into retval
      using v_year,v_userkey; --see :br above
  
    return retval;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      --- sql did not find any data, so return a NULL
      return NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.
  
  end f_get_inspections_count;

 
/