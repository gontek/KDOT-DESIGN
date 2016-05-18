CREATE OR REPLACE function pontis.f_jurisdiction_rpt_owner(v_nbi_22 varchar2)
  return varchar2 is
  retvala varchar2(3);
  retvalb varchar2(3);
begin

  retvala := v_nbi_22;
  if retvala is null then
    retvala := 'S';
  elsif retvala in ('04', '12') then
    retvala := 'C';
  elsif retvala in ('01', '11') then
    retvala := 'S';
  elsif retvala in ('21') then
    retvala := 'OS';
  elsif retvala in ('31') then
    retvala := 'KTA';
  elsif retvala in ('02', '03') then
    retvala := 'CO';
    elsif retvala in ('27','26') then
      retvala := '-1';
  else
    retvala := null;
  end if;

  retvalb := retvala;

  return retvalb;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --- sql did not find any data, so return a NULL
    return NULL;
  
  WHEN OTHERS THEN
    RAISE; -- something bad happened, report it.

end f_jurisdiction_rpt_owner;
/