CREATE OR REPLACE function pontis.f_get_uw_main( v_year varchar2,v_userkey users.userkey%type)


return varchar2 is
v_total number;


begin

select count(*)
into v_total from
userinsp u, inspevnt i
where u.brkey = i.brkey and
u.inspkey = i.inspkey and
extract(year from uwlastinsp) = v_year
and u.uw_inspname_1 = v_userkey;

RETURN v_total;
EXCEPTION
  when no_data_found then
  v_total := '-1';
RETURN v_total;
end f_get_uw_main;

 
/