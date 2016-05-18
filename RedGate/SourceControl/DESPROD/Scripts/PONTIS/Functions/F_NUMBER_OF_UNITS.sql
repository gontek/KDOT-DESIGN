CREATE OR REPLACE function pontis.f_number_of_units(v_brkey userstrunit.brkey%type) 
return  varchar2 is
  result varchar2(3);
  
begin
  
  select count(brkey) into result
       from
         structure_unit s
         where s.brkey = v_brkey
         group by brkey;
 
return result;


          
end f_number_of_units;
/