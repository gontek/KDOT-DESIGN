CREATE OR REPLACE function pontis.f_jurisdiction_rpt_owner(v_nbi_22 varchar2)
  return varchar2 is
  retvala varchar2(25);
  retvalb varchar2(25);
begin

  retvala := v_nbi_22;
  if retvala is null then
    retvala := 'State';
  elsif retvala in ('04', '12') then
    retvala := 'City';
  elsif retvala in ('01', '11') then
    retvala := 'State';
  elsif retvala in ('21') then
    retvala := 'State';
  elsif retvala in ('31') then
    retvala := 'KTA';
  elsif retvala in ('02', '03') then
    retvala := 'County';
   elsif retvala in ('27') then
   retvala := 'RR';
    elsif retvala in ('26') then
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