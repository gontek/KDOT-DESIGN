CREATE OR REPLACE function pontis.f_get_main_strunitkey( v_brkey structure_unit.brkey%type
)

return varchar2 is
v_strunitkey varchar2(3);

begin

select S.strunitkey
into  v_strunitkey
from structure_unit s
where s.brkey = v_brkey and
      s.strunittype = '1';


RETURN v_strunitkey;

EXCEPTION
  when no_data_found then
  v_strunitkey := '-1';
RETURN v_strunitkey;
end f_get_main_strunitkey;

 
/