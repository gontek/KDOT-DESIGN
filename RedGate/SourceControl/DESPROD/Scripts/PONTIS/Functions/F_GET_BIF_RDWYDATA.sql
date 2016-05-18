CREATE OR REPLACE function pontis.f_get_bif_rdwydata(v_brkey inspevnt.brkey%type,v_on_under roadway.on_under%type,
                                                 tablename_in varchar2,columnname_in varchar2)
  return varchar2 is
  retval    varchar2(2000);
  sqlString varchar2(8000);


begin

  -- create a big sql string which will dynamically include the tablename and column name you have passed.



  sqlString := 'select '||
                columnname_in ||
              ' from '||
                tablename_in ||
              ' where ' ||
              tablename_in||'.'||
              'brkey  = :br '||
              ' and on_under = :our ';

  -- execute the dynamic SQL string - supply v_brkey as bind variable :br
  -- return result into retval

  execute immediate sqlString
    into retval
    using v_brkey,v_on_under; --see :br above

  return retval;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --- sql did not find any data, so return a NULL
    return NULL;

  WHEN OTHERS THEN
    RAISE; -- something bad happened, report it.

end f_get_bif_rdwydata;

 
/