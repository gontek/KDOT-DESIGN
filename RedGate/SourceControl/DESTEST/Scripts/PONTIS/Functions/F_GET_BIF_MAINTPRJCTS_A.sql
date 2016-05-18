CREATE OR REPLACE function pontis.f_get_bif_maintprjcts_a(v_brkey v_maintenance_costs_activity.brkey%type)
    return varchar2 is
    retval varchar2(4000);
  
  begin
  
    select ltrim(replace(sys_connect_by_path(acct_date, '*'), '*', chr(10)),
                 chr(10))
      into retval
      from (select distinct acct_date,
                            brkey,
                            count(*) over(partition by brkey) cnt,
                            row_number() over(partition by brkey order by acct_date desc) seq
              from pontis.v_maintenance_costs_activity)
     where seq = cnt
       and brkey = v_brkey
     start with seq = 1
    connect by prior seq + 1 = seq
           and prior brkey = brkey;
  
    return retval;
  end f_get_bif_maintprjcts_a;

 
/