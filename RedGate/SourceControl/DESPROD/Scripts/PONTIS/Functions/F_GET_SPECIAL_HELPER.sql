CREATE OR REPLACE function pontis.f_get_Special_helper( v_year varchar2,v_userkey users.userkey%type)


return varchar2 is
v_total number;


begin

select count(*)
into v_total from
userinsp u, inspevnt i
where u.brkey = i.brkey and
u.inspkey = i.inspkey and
((extract(year from fclastinsp) = v_year) or
(extract(year from snoop_last_insp) = v_year) or
(extract(year from oslastinsp) = v_year))
and u.f_inspname_2 = v_userkey;

RETURN v_total;
EXCEPTION
  when no_data_found then
  v_total := '-1';
RETURN v_total;
end f_get_special_helper;

 
/