CREATE OR REPLACE function pontis.f_struclog_uclr_lft(v_brkey bridge.brkey%type) return float is
  v_hz_lt float;
  
begin
  

select min(least(nvl(u.hclr_s,99.9),nvl(u.hclr_w,99.9)))
  into v_hz_lt
  from userrway u
  where u.brkey = v_brkey
  and feat_cross_type in ('10','50','51','70','30')
  group by v_brkey;
  
if v_hz_lt = 99.9 then
v_hz_lt := null;
 End if;
  
  return v_hz_lt;
end f_struclog_uclr_lft;

 
/