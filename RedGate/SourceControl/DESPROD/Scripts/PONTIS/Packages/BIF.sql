CREATE OR REPLACE package pontis.BIF is
  ----------------------------------------------------------------------------------------------
  -- Author  : DEB
  -- Created : 5/30/2013 8:51:47 AM
  -- Purpose : Placeholder for BIF Report functions

  -- Public type declarations
  ----------------------------------------------------------------------------------------------

  function f_get_bif_loadrtng(v_brkey        userbrdg.brkey%type,
                              p_field_name_1 in varchar2,
                              p_field_name_2 in varchar2,
                              p_field_name_3 in varchar2) return number;
  ----------------------------------------------------------------------------------------------  

  function f_get_bif_full_route(v_brkey bridge.brkey%type) return varchar2;
  ----------------------------------------------------------------------------------------------

  function f_get_bif_spanlist(v_brkey bridge.brkey%type) return varchar2;
  ----------------------------------------------------------------------------------------------
  function f_get_bif_route(v_brkey bridge.brkey%type) return number;
  ----------------------------------------------------------------------------------------------

  function f_get_bif_insp_intrvl(v_brkey bridge.brkey%type) return number;
  ----------------------------------------------------------------------------------------------
  function f_get_bif_orload_lbl(v_brkey        userbrdg.brkey%type,
                                p_field_name_1 in varchar2,
                                p_field_name_2 in varchar2,
                                p_field_name_3 in varchar2) return varchar2;
  ------------------------------------------------------------------------------------------------
  function f_get_bif_irload_lbl(v_brkey        userbrdg.brkey%type,
                                p_field_name_1 in varchar2,
                                p_field_name_2 in varchar2,
                                p_field_name_3 in varchar2) return varchar2;
  -------------------------------------------------------------------------------------------------                              

  function f_get_bif_totalunits(v_brkey structure_unit.brkey%type)
    return varchar2;

  --------------------------------------------------------------------------------------------------

  function f_meters_to_feet(UNITSIN IN NUMBER) RETURN VARCHAR2;
  -------------------------------------------------------------------------------------------------------

  function f_get_bif_insp_item(v_brkey        bridge.brkey%type,
                               p_field_name_1 in varchar2) return varchar2;
  ------------------------------------------------------------------------------------------------------------

  function f_get_bif_userstr_item_main(v_brkey        userstrunit.brkey%type,
                                       p_field_name_1 in varchar2)
    return varchar2;
  -----------------------------------------------------------------------------------------------------------                             
  function f_get_bif_inspecdata(v_brkey       inspevnt.brkey%type,
                                tablename_in  varchar2,
                                columnname_in varchar2) return varchar2;
  --------------------------------------------------------------------------------------------------------------

  function f_get_bif_cansysprjs(v_brkey       v_bif_capital_prj.brkey%type,
                                columnname_in varchar2) return varchar2;
  ---------------------------------------------------------------------------------------------------
  function f_get_bif_rdwydata(v_brkey       roadway.brkey%type,
                              v_on_under    roadway.on_under%type,
                              tablename_in  varchar2,
                              columnname_in varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------------- 
  function f_get_bif_elemdata(v_brkey       eleminsp.brkey%type,
                              v_strunitkey  eleminsp.strunitkey%type,
                              columnname_in varchar2,
                              v_elemtype    char) return varchar2;
  -------------------------------------------------------------------------------------------------------------
  function f_get_bif_dkrate(v_brkey  inspevnt.brkey%type,
                            v_rownum in varchar2) return varchar2;
  -------------------------------------------------------------------------------------------------------- 
  function f_get_bif_inspdate(v_brkey  inspevnt.brkey%type,
                              v_rownum in varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------------
  function f_get_bif_suprate(v_brkey  inspevnt.brkey%type,
                             v_rownum in varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------------   
  function f_get_bif_subrate(v_brkey  inspevnt.brkey%type,
                             v_rownum in varchar2) return varchar2;
  ------------------------------------------------------------------------------------------------------
  function f_get_bif_culvrate(v_brkey  inspevnt.brkey%type,
                              v_rownum in varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  function f_get_bif_appralign(v_brkey  inspevnt.brkey%type,
                               v_rownum in varchar2) return varchar2;
  -------------------------------------------------------------------------------------------------------
  function f_get_bif_chanrating(v_brkey  inspevnt.brkey%type,
                                v_rownum in varchar2) return varchar2;
  -----------------------------------------------------------------------------------------------------
  function f_get_bif_wateradeq(v_brkey  inspevnt.brkey%type,
                               v_rownum in varchar2) return varchar2;
  ------------------------------------------------------------------------------------------------------
  function f_get_bif_bromsprjs(v_brkey       mv_broms_query.brkey%type,
                               columnname_in varchar2) return varchar2;
  --------------------------------------------------------------------------------------------------------
  function f_get_bif_inspecdate(v_brkey       inspevnt.brkey%type,
                                tablename_in  varchar2,
                                columnname_in varchar2) return varchar2;
  ------------------------------------------------------------------------------------------------------                               
  function f_get_bif_brdgdata(v_brkey       bridge.brkey%type,
                              tablename_in  varchar2,
                              columnname_in varchar2) return varchar2;
  ---------------------------------------------------------------------------------------------------------

  function f_get_bif_kta_no(v_brkey userbrdg.brkey%type) return varchar2;
  ---------------------------------------------------------------------------------------------------------
end BIF;

 
/