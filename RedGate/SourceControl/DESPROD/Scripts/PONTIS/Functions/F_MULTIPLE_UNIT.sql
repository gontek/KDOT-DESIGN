CREATE OR REPLACE function pontis.f_multiple_unit(v_brkey bridge.brkey%type) 

return char is
retval char;
v_count number;

begin
  
select count(*) 
into v_count
from structure_unit s
where s.brkey = v_brkey
group by brkey;

if v_count = 1 then
   retval := 'S';
   
ELSE
      retval := 'M';
END IF;

Return retval;


end f_multiple_unit;

 
/