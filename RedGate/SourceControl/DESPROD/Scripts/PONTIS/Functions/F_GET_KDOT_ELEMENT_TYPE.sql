CREATE OR REPLACE FUNCTION pontis.f_Get_Kdot_Element_Type(p_Brkey      IN Bridge.Brkey%TYPE,
                                                   p_Strunitkey IN Userstrunit.Strunitkey%TYPE,
                                                   p_Elem_Key   IN Pon_Elem_Insp.Elem_Key%TYPE)
  RETURN PLS_INTEGER IS
  RESULT PLS_INTEGER;
  /* Structype VARCHAR2(4);
  Elem      Pon_Elem_Insp.Elem_Key%TYPE;
  Strunit   Pon_Elem_Insp.Strunitkey%TYPE;*/
BEGIN
  /*
  SELECT f_Structuretype(p_Brkey, p_Strunitkey)
    INTO Structype
    FROM Userstrunit Us
   WHERE Us.Brkey = p_Brkey
     AND Us.Strunitkey = p_Strunitkey;*/

  SELECT CASE
           WHEN p_Elem_Key IN (12,
                               13,
                               15,
                               16,
                               28,
                               29,
                               30,
                               31,
                               38,
                               54,
                               60,
                               65,
                               240,
                               241,
                               242,
                               243,
                               244,
                               245,
                               844,
                               300,
                               301,
                               302,
                               303,
                               304,
                               305,
                               306,
                               320,
                               321,
                               330,
                               331,
                               332,
                               333,
                               334,
                               510,
                               858, -- added agency deck cracking (replaced 1130) to this group 1/22/2016 dk
                               1130) AND
                Length(f_Structuretype(Us.Brkey, Us.Strunitkey)) <> 3 THEN
            '1'
           WHEN p_Elem_Key IN (12,
                               13,
                               15,
                               16,
                               28,
                               29,
                               30,
                               31,
                               38,
                               54,
                               60,
                               65,
                               240,
                               241,
                               242,
                               243,
                               244,
                               245,
                               844,
                               300,
                               301,
                               302,
                               303,
                               304,
                               305,
                               306,
                               320,
                               321,
                               330,
                               331,
                               332,
                               333,
                               334,
                               510,
                               858,-- added agency deck cracking (replaced 1130) to this group 1/22/2016 dk
                               861, -- added agency scour (replaced 6000) to this group 1/22/2016 dk
                               1130,
                               6000) AND
                Length(f_Structuretype(Us.Brkey, Us.Strunitkey)) = 3 THEN
            '4'
           WHEN p_Elem_Key IN (102,
                               104,
                               105,
                               106,
                               107,
                               109,
                               110,
                               111,
                               112,
                               113,
                               115,
                               116,
                               117,
                               118,
                               120,
                               135,
                               136,
                               141,
                               142,
                               143,
                               144,
                               145,
                               146,
                               147,
                               148,
                               149,
                               152,
                               154,
                               155,
                               156,
                               157,
                               161,
                               162,
                               310,
                               311,
                               312,
                               313,
                               314,
                               315,
                               316,
                               845,
                               846) AND
                Length(f_Structuretype(Us.Brkey, Us.Strunitkey)) <> 3 THEN
            '2'
           WHEN p_Elem_Key IN (102,
                               104,
                               105,
                               106,
                               107,
                               109,
                               110,
                               111,
                               112,
                               113,
                               115,
                               116,
                               117,
                               118,
                               120,
                               135,
                               136,
                               141,
                               142,
                               143,
                               144,
                               145,
                               146,
                               147,
                               148,
                               149,
                               152,
                               154,
                               155,
                               156,
                               157,
                               161,
                               162,
                               310,
                               311,
                               312,
                               313,
                               314,
                               315,
                               316,
                               845,
                               846,
                               861, -- added agency scour (replaced 6000) to this group 1/22/2016 dk
                               6000) AND
                Length(f_Structuretype(Us.Brkey, Us.Strunitkey)) = 3 THEN
            '4'
           WHEN p_Elem_Key IN (202,
                               203,
                               204,
                               205,
                               206,
                               207,
                               208,
                               210,
                               211,
                               212,
                               213,
                               215,
                               216,
                               217,
                               218,
                               219,
                               220,
                               225,
                               226,
                               227,
                               228,
                               229,
                               231,
                               233,
                               234,
                               235,
                               236,
                               861, -- added agency scour (replaced 6000) to this group 1/22/2016 dk
                               6000) AND
                Length(f_Structuretype(Us.Brkey, Us.Strunitkey)) <> 3 THEN
            '3'
           WHEN p_Elem_Key IN (202,
                               203,
                               204,
                               205,
                               206,
                               207,
                               208,
                               210,
                               211,
                               212,
                               213,
                               215,
                               216,
                               217,
                               218,
                               219,
                               220,
                               225,
                               226,
                               227,
                               228,
                               229,
                               231,
                               233,
                               234,
                               235,
                               236,
                               861, -- added agency scour (replaced 6000) to this group 1/22/2016 dk
                               6000) AND
                Length(f_Structuretype(Us.Brkey, Us.Strunitkey)) = 3 THEN
            '4'
           ELSE
            '-1'
         END
    INTO RESULT
    FROM Bridge b
   INNER JOIN Userstrunit Us
      ON b.Brkey = Us.Brkey
  
   WHERE b.Brkey = p_Brkey
     AND Us.Strunitkey = p_Strunitkey;

  RETURN(RESULT);
EXCEPTION
  WHEN No_Data_Found THEN
    RETURN - 1;
  WHEN OTHERS THEN
    RAISE;
END;
/