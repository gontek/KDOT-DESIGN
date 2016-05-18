CREATE OR REPLACE function pontis.f_get_deckarea(v_sortorder mv_deckdeter_by_juris_sum.sortorder%type,
                                          v_grporder mv_deckdeter_by_juris_sum.grporder%type,
                                          columnname_in varchar2) return varchar2 is
    retval    varchar2(2000);
    sqlString varchar2(8000);

  begin

    -- create a big sql string which will dynamically include the tablename and column name you have passed.

    sqlString := 'select ' || columnname_in || ' from mv_deckdeter_by_juris_sum ' ||
                 ' where ' || 'sortorder  = :br ' ||
                 ' and grporder = :str ';

    -- execute the dynamic SQL string - supply v_brkey as bind variable :br
    -- return result into retval

    execute immediate sqlString
      into retval
      using v_sortorder,v_grporder; --see :br above

    return retval;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      --- sql did not find any data, so return a NULL
      return NULL;

    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.

  end f_get_deckarea;
/