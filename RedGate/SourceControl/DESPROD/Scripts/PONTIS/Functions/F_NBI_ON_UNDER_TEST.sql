CREATE OR REPLACE function pontis.f_nbi_on_under_test(v_nbi_8 pontis.bridge.struct_num%type,v_tablename in varchar2)
return varchar2 is
  retval varchar2(2);
  sqlString varchar2(8000);
begin

SQLString := 'select ' || 'min(nbi_5a) from ' ||
             v_tablename ||
             ' where nbi_8 = :vo ' ||
             ' group by nbi_8 ';
             
execute immediate sqlString
into retval
using v_nbi_8;

return retval;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --PROBABLY BONKED
    return '-1';
    
when others then
  raise; -- something bad happened, report it.


/*select min(nbi_5a)
       into retval from nbip14 ni
        where ni.nbi_8 = v_nbi_8
        group by nbi_8;*/

end f_nbi_on_under_test;
/