CREATE OR REPLACE function pontis.f_get_bif_cansysprjs(v_brkey v_bif_capital_prj.brkey%type,
                                                  columnname_in varchar2)  return varchar2 is
    retval varchar2(2000);
    sqlString varchar2(8000);
    quote     char(1) := chr(39); -- uses ASCII code for single quote which is CHR(39)
  
  begin
    
  sqlString := 'select ltrim(substr(replace(sys_connect_by_path(' ||
                columnname_in || ', ' || quote || '*' || quote || '),' ||
                quote || '*' || quote || ', ' || 'CHR(13)' ||
                '   ),  2 ) ) '||
                ' from (select distinct ' || columnname_in || ',
                            brkey,
                            count(*) over(partition by brkey) cnt,
                            row_number() over(partition by brkey order by actvdate' ||
                 ' ) seq ' || ' from pontis.v_bif_capital_prj) ' ||
                 ' where seq = cnt ' || ' and brkey = :br ' ||
                 ' start with seq = 1 ' ||
                 ' connect by prior seq + 1 = seq ' ||
                 ' and prior brkey = brkey ';
  
  execute immediate sqlString
  into retval
  using v_brkey;
  
  return retval;
  
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        return NULL;
        
   WHEN OTHERS THEN
     RAISE;
     
  end f_get_bif_cansysprjs;

 
/