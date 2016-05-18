CREATE OR REPLACE function pontis.f_get_main_spans( v_brkey bridge.brkey%type
)

return varchar2 is
v_totspans varchar2(3);

v_mainunitkey structure_unit.strunitkey%type;
l_unitmat userstrunit.unit_material%type;
l_unittype userstrunit.unit_type%type;
l_superdesty userstrunit.super_design_ty%type;

begin

select S.strunitkey
into  v_mainunitkey
from structure_unit s
where s.brkey = v_brkey and
      s.strunittype = '1'; -- main unit for each bridge
      
select u.unit_material, u.unit_type, u.super_design_ty
into l_unitmat, l_unittype, l_superdesty
from userstrunit u
where u.brkey = v_brkey and
      u.strunitkey = v_mainunitkey;
      

select sum(tot_num_spans) into 
  v_totspans
from userstrunit u
where u.brkey = v_brkey and
      u.unit_material = l_unitmat and
      u.unit_type = l_unittype and
      u.super_design_ty = l_superdesty
group by u.brkey;

RETURN v_totspans;        
EXCEPTION
	when no_data_found then 
	v_totspans := '-1';
RETURN v_totspans;
end f_get_main_spans;

 
/