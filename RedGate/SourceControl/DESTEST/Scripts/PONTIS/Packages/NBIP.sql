CREATE OR REPLACE package pontis.NBIP as

  -- Author  : DEB
  -- Created : 3/29/2010 11:52:28 AM
  -- Purpose : 
  --------------------------------------------------------------------------  
  function f_get_fc_97_98(v_brkey userrway.brkey%type) return varchar2;
  ---------------------------------------------------------------------------
  function F_CHECK_NBI_8(v_brkey bridge.brkey%type) return varchar2;
  --------------------------------------------------------------------------

  Function f_check_nbi_28a_on(v_brkey bridge.brkey%TYPE) RETURN Number;
  --------------------------------------------------------------------------   

  Function f_check_nbi_28B_on(v_brkey bridge.brkey%type) RETURN Number;
  ---------------------------------------------------------------------------
  function f_check_nbi_31(v_brkey userbrdg.brkey%type) return char;
  ---------------------------------------------------------------------------
  Function f_check_nbi_38(v_brkey bridge.brkey%type) RETURN Varchar2;

  ---------------------------------------------------------------------------

  Function f_check_nbi_42a(v_brkey bridge.brkey%type) RETURN Varchar2;

  ---------------------------------------------------------------------------

  Function f_check_nbi_42b(v_brkey bridge.brkey%type) return varchar2;
  ---------------------------------------------------------------------------
  Function f_check_nbi_43(v_brkey bridge.brkey%type) return varchar2;
  --------------------------------------------------------------------------- 
  Function f_check_nbi_44(v_brkey bridge.brkey%type) return varchar2;
  ---------------------------------------------------------------------------
  Function f_check_nbi_45(v_brkey bridge.brkey%type) return varchar2;
  ---------------------------------------------------------------------------

  Function f_check_nbi_46(v_brkey bridge.brkey%type) return varchar2;
  ---------------------------------------------------------------------------
  Function f_check_nbi_47_on(v_brkey roadway.brkey%type) return number;
  ---------------------------------------------------------------------------
  function f_check_nbi_47_undr(v_brkey    userrway.brkey%type,
                               v_on_under userrway.on_under%type)
    return number;
  ---------------------------------------------------------------------------  
  function f_check_nbi_48(v_brkey bridge.brkey%type) return number;
  ---------------------------------------------------------------------------
  function f_check_nbi_51(v_brkey roadway.brkey%type) return number;
  ---------------------------------------------------------------------------
  function f_check_nbi_52(v_brkey roadway.brkey%type) return number;
  ---------------------------------------------------------------------------
  function f_check_nbi_53(v_brkey roadway.brkey%type) return number;
  ---------------------------------------------------------------------------
  function f_check_NBI_54a(v_brkey userrway.brkey%type) return varchar2;
  ---------------------------------------------------------------------------
  function f_check_NBI_54b(v_brkey userrway.brkey%type) return number;
  ---------------------------------------------------------------------------
  function f_check_NBI_55a(v_brkey userrway.brkey%type) return varchar2;
  ---------------------------------------------------------------------------
  function f_check_NBI_55B(v_brkey userrway.brkey%type) return number;
  ---------------------------------------------------------------------------
  function f_check_NBI_56(v_brkey userrway.brkey%type) return number;
  ---------------------------------------------------------------------------
  function f_check_NBI_70_Posting(v_brkey bridge.brkey%type) return number;
  ---------------------------------------------------------------------------
  function f_check_nbi_75a_b(v_brkey roadway.brkey%type) return varchar2;
  ---------------------------------------------------------------------------
  function f_check_nbi_76(v_brkey roadway.brkey%type) return varchar2;
  ---------------------------------------------------------------------------
  function f_check_NBI_92_93(v_brkey bridge.brkey%TYPE) return varchar2;
  ---------------------------------------------------------------------------
  function f_check_nbi_94_95_96_97(v_brkey roadway.brkey%type)
    return varchar2;
  ---------------------------------------------------------------------------
  function F_CHECK_NBI_103(v_brkey bridge.brkey%TYPE) RETURN CHAR;
  --------------------------------------------------------------------------
  function f_check_nbi_109_on(v_brkey roadway.brkey%type) return number;
  ---------------------------------------------------------------------------
  function f_check_nbi_109_undr(v_brkey    roadway.brkey%type,
                                v_on_under roadway.on_under%type)
    return number;
  ---------------------------------------------------------------------------
 end NBIP;

 
/