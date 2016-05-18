CREATE OR REPLACE function pontis.f_struclog_undr_lft(v_brkey bridge.brkey%type) return float is
  v_undr_lt float;

begin


select min(least(nvl(u.vclr_s,99.9),nvl(u.vclr_w,99.9)))
  into v_undr_lt
  from userrway u
  where u.brkey = v_brkey
  and feat_cross_type in ('10','50','51','70','30')
  group by v_brkey;

if v_undr_lt = 99.9 then
v_undr_lt := null;
 End if;

  return v_undr_lt;
end f_struclog_undr_lft;

 
/