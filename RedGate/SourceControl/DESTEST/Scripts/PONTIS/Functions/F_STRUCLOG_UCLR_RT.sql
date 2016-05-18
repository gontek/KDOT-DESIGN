CREATE OR REPLACE function pontis.f_struclog_uclr_rt(v_brkey bridge.brkey%type) return float is
  v_hz_rt float;
  
begin
  

select min(least(nvl(u.hclr_n,99.9),nvl(u.hclr_e,99.9)))
  into v_hz_rt
  from userrway u
  where u.brkey = v_brkey
  and feat_cross_type in ('10','50','51','70','30')
  group by v_brkey;
  
if v_hz_rt = 99.9 then
  v_hz_rt := null;
 END if; 
  return v_hz_rt;
  
end f_struclog_uclr_rt;

 
/