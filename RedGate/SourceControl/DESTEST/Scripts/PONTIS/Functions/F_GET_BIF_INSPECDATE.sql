CREATE OR REPLACE function pontis.f_get_bif_inspecdate(v_brkey       inspevnt.brkey%type,
                                tablename_in  varchar2,
                                columnname_in varchar2) return varchar2 is
    retval    varchar2(20);
    sqlString varchar2(8000);
    quote     char(1) := chr(39);
  
  begin
  
    -- create a big sql string which will dynamically include the tablename and column name you have passed.
  
    sqlString := 'select to_char( ' || tablename_in || '.' || columnname_in ||
                 ' , ' || quote || 'dd/mm/yyyy' || quote || ')' ||
                 ' from userinsp , inspevnt , mv_latest_inspection ' ||
                 ' where userinsp.brkey = :br ' ||
                 ' and mv_latest_inspection.brkey = userinsp.brkey ' ||
                 ' and inspevnt.brkey = userinsp.brkey ' ||
                 ' and userinsp.inspkey = mv_latest_inspection.inspkey ' ||
                 ' and inspevnt.inspkey = mv_latest_inspection.inspkey ';
  
    -- execute the dynamic SQL string - supply v_brkey as bind variable :br 
    -- return result into retval
  
    execute immediate sqlString
      into retval
      using v_brkey; --see :br above
  
    return retval;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      --- sql did not find any data, so return a NULL
      return NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.
  
  end f_get_bif_inspecdate;

 
/