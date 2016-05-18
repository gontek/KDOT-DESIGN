CREATE OR REPLACE function pontis.f_nextFCinsp_date(v_brkey bridge.brkey%type)

return date is
  retval date;

v_freq userinsp.fcinspfreq_kdot%type;
v_date inspevnt.fclastinsp%type;
v_inspkey inspevnt.inspkey%type;

begin
 
select fclastinsp,nvl(fcinspfreq_kdot,0),i.inspkey
into v_date,v_freq,v_inspkey
from inspevnt i,userinsp u
where i.brkey = v_brkey and
      u.brkey = v_brkey and
      u.inspkey = i.inspkey and
      i.inspkey = (select max(i2.inspkey)
      from inspevnt i2 where i2.brkey = i.brkey and
      i2.inspdate = (select max(inspdate) from inspevnt i3
      where i3.brkey = i.brkey)) ;

if v_date = '01/jan/1901' then
   v_freq := 0;
End if;

if v_freq in (0) then
  v_date := '01/jan/1901';
End if;  

  
select add_months(v_date,v_freq*12)
 into retval
from inspevnt i
where i.brkey = v_brkey and
      i.inspkey = v_inspkey;

  
        
return retval;
end f_nextFCinsp_date;

 
/