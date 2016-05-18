CREATE OR REPLACE function pontis.f_abcdlist_routeid(v_brkey pontis.bridge.brkey%type)

return number is
  retval number;
   
begin

select routeid
 into retval      
 from userrway u, tbl_route_id b
 where u.brkey = v_brkey
 and u.on_under = '1' 
 and u.maint_rte_prefix = b.prefix
 and u.maint_rte_num = b.route 
 and    u.maint_rte_suffix = b.suffix 
 and   u.maint_rte_id = b.uniqueid;


     
return retval;
end f_abcdlist_routeid;

 
/