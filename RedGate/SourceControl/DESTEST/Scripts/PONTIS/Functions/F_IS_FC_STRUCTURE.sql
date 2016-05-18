CREATE OR REPLACE FUNCTION pontis.f_Is_Fc_Structure(p_Brkey IN Bridge.Brkey%TYPE)
  RETURN PLS_INTEGER IS
  RESULT PLS_INTEGER;
BEGIN

  -- if slowpoke - see if the bridge exists.
  IF Ksbms_Pontis_Util.f_Get_Bridge_Id_From_Brkey(p_Brkey) IS NULL THEN
    Raise_Application_Error(-20999,
                            q'[Bridge ]' || p_Brkey || q'[ not found!]');
  END IF;

  SELECT COUNT(Usu.Strunitkey)
    INTO RESULT
    FROM Userstrunit Usu
   WHERE /* Usu.Brkey = '018010' --p_Brkey
                   AND*/
   Usu.Brkey = p_Brkey
   AND (Usu.Crit_Note_Sup_1 = '1' OR Usu.Crit_Note_Sup_2 = '1' OR
   Usu.Crit_Note_Sup_3 = '1' OR Usu.Crit_Note_Sup_4 = '1' OR
   Usu.Crit_Note_Sup_5 = '1')
   GROUP BY Usu.Brkey;

  RETURN(RESULT);
EXCEPTION
  WHEN No_Data_Found THEN
    RETURN 0; -- no fc crit notes
  WHEN OTHERS THEN
    RAISE;
END f_Is_Fc_Structure;
/