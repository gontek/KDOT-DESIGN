CREATE OR REPLACE function pontis.f_strtypelist(v_brkey pontis.bridge.brkey%type)
return varchar2 is
  retval varchar2(255);
begin


select 
substr(sys_connect_by_path(strtype, ','),2) into retval
from
(select strtype,
        brkey,
        count(*) over (partition by brkey) cnt,
        row_number () over (partition by brkey order by strtype) seq
        from pontis.v_structuretypes)
        where seq=cnt and
        brkey = v_brkey
        start with
        seq=1
        connect by prior
        seq+1=seq
        and prior brkey = brkey
;

return retval;
end f_strtypelist;

 
/