CREATE OR REPLACE function pontis.f_spangroups(v_brkey pontis.userstrunit.brkey%type,v_strunitkey pontis.userstrunit.strunitkey%type)
return varchar2 is
  retval varchar2(200);
  --v_spangroups varchar2(200);
  
begin

select 
CASE
  when num_spans_grp_10 is not null
    then 
       num_spans_grp_1||' @ '||round(len_span_grp_1/.3048)||', '||
       num_spans_grp_2||' @ '||round(len_span_grp_2/.3048)||', '||
       num_spans_grp_3||' @ '||round(len_span_grp_3/.3048)||', '||
       num_spans_grp_4||' @ '||round(len_span_grp_4/.3048)||', '||
       num_spans_grp_5||' @ '||round(len_span_grp_5/.3048)||', '||
       num_spans_grp_6||' @ '||round(len_span_grp_6/.3048)||', '||
       num_spans_grp_7||' @ '||round(len_span_grp_7/.3048)||', '||
       num_spans_grp_8||' @ '||round(len_span_grp_8/.3048)||', '||
       num_spans_grp_9||' @ '||round(len_span_grp_9/.3048)||', '||
       num_spans_grp_10||' @ '||round(len_span_grp_10/.3048)
 when num_spans_grp_9 is not null and num_spans_grp_10 is null or num_spans_grp_10 = -1
    then 
       num_spans_grp_1||' @ '||round(len_span_grp_1/.3048)||', '||
       num_spans_grp_2||' @ '||round(len_span_grp_2/.3048)||', '||
       num_spans_grp_3||' @ '||round(len_span_grp_3/.3048)||', '||
       num_spans_grp_4||' @ '||round(len_span_grp_4/.3048)||', '||
       num_spans_grp_5||' @ '||round(len_span_grp_5/.3048)||', '||
       num_spans_grp_6||' @ '||round(len_span_grp_6/.3048)||', '||
       num_spans_grp_7||' @ '||round(len_span_grp_7/.3048)||', '||
       num_spans_grp_8||' @ '||round(len_span_grp_8/.3048)||', '||
       num_spans_grp_9||' @ '||round(len_span_grp_9/.3048)
when num_spans_grp_8 is not null and num_spans_grp_9 is null or num_spans_grp_9 = -1
    then 
       num_spans_grp_1||' @ '||round(len_span_grp_1/.3048)||', '||
       num_spans_grp_2||' @ '||round(len_span_grp_2/.3048)||', '||
       num_spans_grp_3||' @ '||round(len_span_grp_3/.3048)||', '||
       num_spans_grp_4||' @ '||round(len_span_grp_4/.3048)||', '||
       num_spans_grp_5||' @ '||round(len_span_grp_5/.3048)||', '||
       num_spans_grp_6||' @ '||round(len_span_grp_6/.3048)||', '||
       num_spans_grp_7||' @ '||round(len_span_grp_7/.3048)||', '||
       num_spans_grp_8||' @ '||round(len_span_grp_8/.3048)
 when num_spans_grp_7 is not null and num_spans_grp_8 is null or num_spans_grp_8 = -1
    then  
       num_spans_grp_1||' @ '||round(len_span_grp_1/.3048)||', '||
       num_spans_grp_2||' @ '||round(len_span_grp_2/.3048)||', '||
       num_spans_grp_3||' @ '||round(len_span_grp_3/.3048)||', '||
       num_spans_grp_4||' @ '||round(len_span_grp_4/.3048)||', '||
       num_spans_grp_5||' @ '||round(len_span_grp_5/.3048)||', '||
       num_spans_grp_6||' @ '||round(len_span_grp_6/.3048)||', '||
       num_spans_grp_7||' @ '||round(len_span_grp_7/.3048)
when num_spans_grp_6 is not null and num_spans_grp_7 is null or num_spans_grp_7 = -1
    then  
       num_spans_grp_1||' @ '||round(len_span_grp_1/.3048)||', '||
       num_spans_grp_2||' @ '||round(len_span_grp_2/.3048)||', '||
       num_spans_grp_3||' @ '||round(len_span_grp_3/.3048)||', '||
       num_spans_grp_4||' @ '||round(len_span_grp_4/.3048)||', '||
       num_spans_grp_5||' @ '||round(len_span_grp_5/.3048)||', '||
       num_spans_grp_6||' @ '||round(len_span_grp_6/.3048)
when num_spans_grp_5 is not null and num_spans_grp_6 is null or num_spans_grp_6 = -1
    then 
       num_spans_grp_1||' @ '||round(len_span_grp_1/.3048)||', '||
       num_spans_grp_2||' @ '||round(len_span_grp_2/.3048)||', '||
       num_spans_grp_3||' @ '||round(len_span_grp_3/.3048)||', '||
       num_spans_grp_4||' @ '||round(len_span_grp_4/.3048)||', '||
       num_spans_grp_5||' @ '||round(len_span_grp_5/.3048)
when num_spans_grp_4 is not null and num_spans_grp_5 is null or num_spans_grp_5 = -1
    then 
       num_spans_grp_1||' @ '||round(len_span_grp_1/.3048)||', '||
       num_spans_grp_2||' @ '||round(len_span_grp_2/.3048)||', '||
       num_spans_grp_3||' @ '||round(len_span_grp_3/.3048)||', '||
       num_spans_grp_4||' @ '||round(len_span_grp_4/.3048)
when num_spans_grp_3 is not null and num_spans_grp_4 is null or num_spans_grp_4 = -1
    then 
       num_spans_grp_1||' @ '||round(len_span_grp_1/.3048)||', '||
       num_spans_grp_2||' @ '||round(len_span_grp_2/.3048)||', '||
       num_spans_grp_3||' @ '||round(len_span_grp_3/.3048)
when num_spans_grp_2 is not null and num_spans_grp_3 is null or num_spans_grp_4 = -1
    then 
       num_spans_grp_1||' @ '||round(len_span_grp_1/.3048)||', '||
       num_spans_grp_2||' @ '||round(len_span_grp_2/.3048)
else num_spans_grp_1||' @ '||round(len_span_grp_1/.3048)
  end as retval
  into retval
from userstrunit u
where u.brkey = v_brkey and
      u.strunitkey = v_strunitkey;


return retval;
end f_spangroups;

 
/