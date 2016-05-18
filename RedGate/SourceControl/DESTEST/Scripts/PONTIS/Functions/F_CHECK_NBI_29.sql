CREATE OR REPLACE function pontis.f_check_NBI_29(v_brkey userrway.brkey%type)
return number is
  retval number;
  
begin
  
if bif.f_get_bif_rdwydata(v_brkey,'1','roadway','adttotal')> 100 then
  if bif.f_get_bif_brdgdata(v_brkey,'userbrdg','function_type') in ('10','30') and bif.f_get_bif_rdwydata(v_brkey,'1','userrway','feat_desc_type') in ('0','1','9','10','11') then -- on state system
    retval:= bif.f_get_bif_rdwydata(v_brkey,'1','roadway','adttotal');
    else
      select decode(bif.f_get_bif_rdwydata(v_brkey,'1','roadway','funcclass')
      ,01,28
      ,02,16
      ,06,11
      ,07,8
      ,08,8
      ,09,5
      ,11,10
      ,12,6
      ,14,4
      ,16,3
      ,17,2
      ,19,2
      ,10)
      into retval
      from bridge 
      where brkey = v_brkey;
      end if;
      else -- aadt < 100--
        retval:=NULL;
        end if;
        return retval;
  EXCEPTION WHEN OTHERS THEN
    retval := -1;
    RETURN retval;
    
 end f_check_nbi_29;

 
/