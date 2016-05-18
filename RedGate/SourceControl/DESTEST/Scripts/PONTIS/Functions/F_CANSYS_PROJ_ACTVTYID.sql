CREATE OR REPLACE function pontis.f_cansys_proj_actvtyid(v_brkey pontis.bridge.brkey%type,v_actvtyid pontis.v_bif_capital_prj.actvtyid%Type)
return varchar2 is
retval varchar2(4);

begin
select actvtyid
into retval
from pontis.v_bif_capital_prj v
where v.brkey = v_brkey and
      v.actvtyid = v_actvtyid
      and actvtydate = (select max(actvtydate)
      from v_bif_capital_prj vi
      where vi.brkey = v_brkey and
            vi.actvtyid = v_actvtyid);


return retval;
end f_cansys_proj_actvtyid;

 
/