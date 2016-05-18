CREATE OR REPLACE function pontis.f_get_elem_500s_data(v_brkey mv_bif_data_elements.brkey%type,v_strunitkey mv_bif_data_elements.strunitkey%type,
                                               v_elem_key mv_bif_data_elements.elem_key%type,columnname_in varchar2) return varchar2 is
    retval    varchar2(2000);
    sqlString varchar2(8000);

  begin

    -- create a big sql string which will dynamically include the tablename and column name you have passed.

    sqlString := 'select ' ||  columnname_in ||
                 ' from mv_bif_data_elements mv ' ||
                 ' where mv.brkey = :br ' ||
                 ' and mv.strunitkey = :st ' ||
                 ' and elem_key = :em ' ;


    -- execute the dynamic SQL string - supply v_brkey as bind variable :br
    -- return result into retval

    execute immediate sqlString
      into retval
      using v_brkey,v_strunitkey,v_elem_key; --see :br above

    return retval;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      --- sql did not find any data, so return a NULL
      return NULL;

    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.

  end f_get_elem_500s_data;

 
/