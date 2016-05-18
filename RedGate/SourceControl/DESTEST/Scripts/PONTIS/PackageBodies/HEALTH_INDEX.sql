CREATE OR REPLACE package body pontis.Health_Index is

  ---------------------------------------------------------------
  function f_get_HI_TEV(v_brkey      eleminsp.brkey%type,
                        v_strunitkey eleminsp.strunitkey%type,
                        v_elemkey    eleminsp.elemkey%type,
                        v_envkey     eleminsp.envkey%type) return number is
  
    retval number;
    t_tev  number;
  begin
    select quantity * elemvalue
      into t_tev
      from eleminsp e, v_elemvalue v, mv_latest_inspection mv
     where e.brkey = v_brkey
       and mv.brkey = v_brkey
       and e.inspkey = mv.inspkey
       and e.elemkey = v_elemkey
       and e.envkey = v_envkey
       and v.envkey = v_envkey
       and v.elemkey = v_elemkey
       and e.strunitkey = v_strunitkey;
  
    retval := t_tev;
  
    return retval;
    
  
  end f_get_HI_TEV;
----------------------------------------------------------------------------------------
function f_get_HI_CEV(v_brkey      eleminsp.brkey%type,
                        v_strunitkey eleminsp.strunitkey%type,
                        v_elemkey    eleminsp.elemkey%type,
                        v_envkey     eleminsp.envkey%type) return number is
  
    retval number;
    t_cev  number;
    
begin    
 select (quantity*elemvalue)*(pctstate1+s2factor*pctstate2+s3factor*pctstate3+s4factor*pctstate4)
  into t_cev
  from eleminsp e, v_elemvalue v, mv_latest_inspection mv
  where e.brkey = v_brkey and
        mv.brkey = v_brkey and
        e.inspkey = mv.inspkey and
        e.elemkey = v_elemkey and
        e.envkey = v_envkey and
        v.envkey = e.envkey and
        v.elemkey = v_elemkey and
        e.strunitkey = v_strunitkey;
  
  retval := t_cev;
  return retval;
  
end f_get_hi_cev;
-------------------------------------------------------------------------------------------------   
    

end Health_Index;
/