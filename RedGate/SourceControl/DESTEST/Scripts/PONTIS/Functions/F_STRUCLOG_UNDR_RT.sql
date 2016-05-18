CREATE OR REPLACE function pontis.f_struclog_undr_rt(v_brkey bridge.brkey%type) return float is
  v_undr_rt float;

begin


select min(least(nvl(u.vclr_n,99.9),nvl(u.vclr_e,99.9)))
  into v_undr_rt
  from userrway u
  where u.brkey = v_brkey
  and feat_cross_type in ('10','50','51','70','30')
  group by v_brkey;

if v_undr_rt = 99.9 then
v_undr_rt := null;
 End if;

  return v_undr_rt;
end f_struclog_undr_rt;

 
/