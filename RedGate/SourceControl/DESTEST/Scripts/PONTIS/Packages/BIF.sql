CREATE OR REPLACE PACKAGE pontis.Bif IS
  ----------------------------------------------------------------------------------------------
  -- Author  : DEB
  -- Created : 5/30/2013 8:51:47 AM
  -- Purpose : Placeholder for BIF Report functions

  -- Public type declarations
  ----------------------------------------------------------------------------------------------

  FUNCTION f_Get_Bif_Loadrtng(v_Brkey        Userbrdg.Brkey%TYPE,
                              p_Field_Name_1 IN VARCHAR2,
                              p_Field_Name_2 IN VARCHAR2,
                              p_Field_Name_3 IN VARCHAR2) RETURN NUMBER;
  ----------------------------------------------------------------------------------------------  

  FUNCTION f_Get_Bif_Full_Route(v_Brkey Bridge.Brkey%TYPE) RETURN VARCHAR2;
  ----------------------------------------------------------------------------------------------

  FUNCTION f_Get_Bif_Spanlist(v_Brkey Bridge.Brkey%TYPE) RETURN VARCHAR2;
  ----------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Route(v_Brkey Bridge.Brkey%TYPE) RETURN NUMBER;
  ----------------------------------------------------------------------------------------------

  FUNCTION f_Get_Bif_Insp_Intrvl(v_Brkey Bridge.Brkey%TYPE) RETURN NUMBER;
  ----------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Orload_Lbl(v_Brkey        Userbrdg.Brkey%TYPE,
                                p_Field_Name_1 IN VARCHAR2,
                                p_Field_Name_2 IN VARCHAR2,
                                p_Field_Name_3 IN VARCHAR2) RETURN VARCHAR2;
  ------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Irload_Lbl(v_Brkey        Userbrdg.Brkey%TYPE,
                                p_Field_Name_1 IN VARCHAR2,
                                p_Field_Name_2 IN VARCHAR2,
                                p_Field_Name_3 IN VARCHAR2) RETURN VARCHAR2;
  -------------------------------------------------------------------------------------------------                              

  FUNCTION f_Get_Bif_Totalunits(v_Brkey Structure_Unit.Brkey%TYPE)
    RETURN VARCHAR2;

  --------------------------------------------------------------------------------------------------

  FUNCTION f_Meters_To_Feet(Unitsin IN NUMBER) RETURN VARCHAR2;
  -------------------------------------------------------------------------------------------------------

  FUNCTION f_Get_Bif_Insp_Item(v_Brkey        Bridge.Brkey%TYPE,
                               p_Field_Name_1 IN VARCHAR2) RETURN VARCHAR2;
  ------------------------------------------------------------------------------------------------------------

  FUNCTION f_Get_Bif_Userstr_Item_Main(v_Brkey        Userstrunit.Brkey%TYPE,
                                       p_Field_Name_1 IN VARCHAR2)
    RETURN VARCHAR2;
  -----------------------------------------------------------------------------------------------------------                             
  FUNCTION f_Get_Bif_Inspecdatax(v_Brkey       Inspevnt.Brkey%TYPE,
                                 Tablename_In  VARCHAR2,
                                 Columnname_In VARCHAR2) RETURN VARCHAR2;
  --------------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Inspecdata(v_Brkey IN Inspevnt.Brkey%TYPE,
                                Ptab    IN User_Tab_Cols.Table_Name%TYPE,
                                Pcol    IN User_Tab_Cols.Column_Name%TYPE)
    RETURN VARCHAR2;
  --------------------------------------------------------------------------------------------------------------                                
  FUNCTION f_Get_Bif_Cansysprjs(v_Brkey       v_Bif_Capital_Prj.Brkey%TYPE,
                                Columnname_In VARCHAR2) RETURN VARCHAR2;
  ---------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Rdwydata(v_Brkey       Roadway.Brkey%TYPE,
                              v_On_Under    Roadway.On_Under%TYPE,
                              Tablename_In  VARCHAR2,
                              Columnname_In VARCHAR2) RETURN VARCHAR2;
  ----------------------------------------------------------------------------------------------------------- 
  FUNCTION f_Get_Bif_Elemdata(v_Brkey       Eleminsp.Brkey%TYPE,
                              v_Strunitkey  Eleminsp.Strunitkey%TYPE,
                              Columnname_In VARCHAR2,
                              v_Elemtype    CHAR) RETURN VARCHAR2;
  -------------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Dkrate(v_Brkey  Inspevnt.Brkey%TYPE,
                            v_Rownum IN VARCHAR2) RETURN VARCHAR2;
  -------------------------------------------------------------------------------------------------------- 
  FUNCTION f_Get_Bif_Inspdate(v_Brkey  Inspevnt.Brkey%TYPE,
                              v_Rownum IN VARCHAR2) RETURN VARCHAR2;
  ----------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Suprate(v_Brkey  Inspevnt.Brkey%TYPE,
                             v_Rownum IN VARCHAR2) RETURN VARCHAR2;
  ----------------------------------------------------------------------------------------------------------   
  FUNCTION f_Get_Bif_Subrate(v_Brkey  Inspevnt.Brkey%TYPE,
                             v_Rownum IN VARCHAR2) RETURN VARCHAR2;
  ------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Culvrate(v_Brkey  Inspevnt.Brkey%TYPE,
                              v_Rownum IN VARCHAR2) RETURN VARCHAR2;
  ----------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Appralign(v_Brkey  Inspevnt.Brkey%TYPE,
                               v_Rownum IN VARCHAR2) RETURN VARCHAR2;
  -------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Chanrating(v_Brkey  Inspevnt.Brkey%TYPE,
                                v_Rownum IN VARCHAR2) RETURN VARCHAR2;
  -----------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Wateradeq(v_Brkey  Inspevnt.Brkey%TYPE,
                               v_Rownum IN VARCHAR2) RETURN VARCHAR2;
  ------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Bromsprjs(v_Brkey       Mv_Broms_Query.Brkey%TYPE,
                               Columnname_In VARCHAR2) RETURN VARCHAR2;
  --------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Inspecdate(v_Brkey       Inspevnt.Brkey%TYPE,
                                Tablename_In  VARCHAR2,
                                Columnname_In VARCHAR2) RETURN VARCHAR2;
  ------------------------------------------------------------------------------------------------------                               
  FUNCTION f_Get_Bif_Brdgdata(v_Brkey       Bridge.Brkey%TYPE,
                              Tablename_In  VARCHAR2,
                              Columnname_In VARCHAR2) RETURN VARCHAR2;
  ------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Kta_No(v_Brkey Userbrdg.Brkey%TYPE) RETURN VARCHAR2;
  -------------------------------------------------------------------------------------------------------

END Bif;
/