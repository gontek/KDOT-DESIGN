CREATE OR REPLACE function pontis.f_juris_sum(v_juris mv_jurisdiction_rpt.juris%type, v_inspec_year mv_jurisdiction_rpt.inspec_year%TYPE)
return varchar is
retval varchar2(25);

begin
select to_char(count(nbi_8))
into retval
from pontis.mv_jurisdiction_rpt v
where juris = v_juris and
      inspec_year = v_inspec_year;


return retval;
end f_juris_sum;
/