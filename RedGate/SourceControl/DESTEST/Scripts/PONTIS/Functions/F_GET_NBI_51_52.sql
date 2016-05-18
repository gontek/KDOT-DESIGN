CREATE OR REPLACE function pontis.f_get_nbi_51_52( v_brkey roadway.brkey%type
)

return varchar2 is
retval varchar(8);
item5152 varchar(8);
l_item51 number(4);
l_item52 number(4);
l_designmain bridge.designmain%type;
l_skew number;
l_rw_width number;
l_flow number;
begin

select round(r.roadwidth*10)
into l_item51
from roadway r
where r.brkey = v_brkey and
      r.on_under = '1';
      
select round(b.deckwidth*10)
into l_item52
from bridge b
where b.brkey = v_brkey;

item5152:= LTRIM(TO_CHAR(L_ITEM51,'0000'))||LTRIM(TO_CHAR(L_ITEM52,'0000'));


      
select b.designmain
into l_designmain
from bridge b
where b.brkey = v_brkey;

if l_designmain = '19' then

select nvl(b.skew,0)
into l_skew
from bridge b
where b.brkey = v_brkey;

select least(r.aroadwidth_near, r.aroadwidth_far)
into l_rw_width
from userrway r
where r.brkey = v_brkey and
      r.on_under = '1'; 
      
select b.deckwidth into
l_item52
from bridge b
where b.brkey = v_brkey;
      
l_flow:=COS(l_skew* 3.14159265359/180)*(l_item52)+4;

if l_flow>l_rw_width then
retval:= '00000000';

ELSE
  retval := item5152;


END IF;
ELSE
 retval := item5152;

END IF;

return retval; 
 
EXCEPTION WHEN OTHERS THEN
retval:=-1;
RETURN retval;

END f_get_nbi_51_52;




      

 
/