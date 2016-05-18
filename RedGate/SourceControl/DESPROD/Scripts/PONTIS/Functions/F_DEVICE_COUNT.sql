CREATE OR REPLACE function pontis.f_device_count(v_brkey bridge.brkey%type,v_expan_dev_type userstrunit.expan_dev_far%type)
return number is
  retval number;

v_count number;
v_count_near_a number; -- Unit 1's
v_count_far_a number;  -- Unit 1's
v_count_far_b number;  -- > Unit 1's
v_count_far  number; -- total for near
v_count_near number;  -- total for fars

begin
  
select  nvl(v_count,0) 
into v_count
from (select count(*) as
v_count
from userstrunit u
where u.brkey = v_brkey and
u.strunitkey = '1' and
u.expan_dev_near = v_expan_dev_type);
 
v_count_near_a := v_count;


select  nvl(v_count,0)
into v_count from (select count(*) as
v_count
from userstrunit u
where u.brkey = v_brkey and
u.strunitkey = '1' and
u.expan_dev_far = v_expan_dev_type);
 
v_count_far_a := v_count;
      
v_count_near := to_number(v_count_near_a)+to_number(v_count_far_a) ;


select  nvl(v_count_far,0)
into v_count_far from (select count(*) as
v_count_far
from userstrunit u
where u.brkey = v_brkey and
u.strunitkey <> '1' and
u.expan_dev_far = v_expan_dev_type); 

  
retval := v_count_near+v_count_far;



    
return retval;

EXCEPTION WHEN OTHERS THEN
  retval:= -1;
  return retval;

end f_device_count;

 
/