CREATE OR REPLACE function pontis.f_get_elem_parent(v_brkey mv_bif_data_elements.brkey%type,v_strunitkey mv_bif_data_elements.strunitkey%type,v_elem_parent_key mv_bif_data_elements.elem_parent_key%type)
 return char is
  retval varchar2(3);


begin


select elem_parent_key
into retval
  from mv_bif_data_elements mv
  where mv.brkey = v_brkey and
  mv.strunitkey = v_strunitkey and
  elem_key = v_elem_parent_key;

return retval;




end f_get_elem_parent;

 
/