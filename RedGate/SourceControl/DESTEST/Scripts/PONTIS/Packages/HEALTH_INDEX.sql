CREATE OR REPLACE package pontis.Health_Index is

  -- Author  : DEB
  -- Created : 9/9/2013 10:55:23 AM
  -- Purpose : Place to store functions used in the build of health indices

  --------------------------------------------------------------------------------------  
  function f_get_HI_TEV(v_brkey      eleminsp.brkey%type,
                        v_strunitkey eleminsp.strunitkey%type,
                        v_elemkey    eleminsp.elemkey%type,
                        v_envkey     eleminsp.elemkey%type) return number;

----------------------------------------------------------------------------------------   

function f_get_HI_CEV(v_brkey      eleminsp.brkey%type,
                        v_strunitkey eleminsp.strunitkey%type,
                        v_elemkey    eleminsp.elemkey%type,
                        v_envkey     eleminsp.elemkey%type) return number;

---------------------------------------------------------------------------------------------

end Health_Index;

 
/