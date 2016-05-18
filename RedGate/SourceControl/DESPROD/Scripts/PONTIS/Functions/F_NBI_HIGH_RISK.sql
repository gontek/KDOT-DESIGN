CREATE OR REPLACE FUNCTION pontis.f_Nbi_High_Risk(p_Brkey IN Bridge.Brkey%TYPE)
  RETURN PLS_INTEGER IS
  RESULT PLS_INTEGER;
BEGIN
  SELECT 1
    INTO RESULT
    FROM Bridge b
   INNER JOIN Mv_Latest_Inspection Mv
      ON b.Brkey = Mv.Brkey
   INNER JOIN Inspevnt i
      ON b.Brkey = i.Brkey
     AND i.Inspkey = Mv.Inspkey
   INNER JOIN Userinsp Ui
      ON b.Brkey = Ui.Brkey
     AND Ui.Inspkey = Mv.Inspkey
   WHERE b.Brkey = p_Brkey
     AND ((((b.Designmain IS NOT NULL AND i.Suprating IS NOT NULL AND
         i.Subrating IS NOT NULL AND i.Culvrating IS NOT NULL) AND (1 = CASE
           WHEN b.Designmain <> '19' THEN
            CASE
              WHEN i.Suprating NOT IN ('_', 'N') AND i.Suprating < '5' AND
                   i.Subrating NOT IN ('_', 'N') AND i.Subrating < '5' THEN
               1
              ELSE
               0
            END
           ELSE
            CASE
              WHEN i.Culvrating NOT IN ('_', 'N') AND i.Culvrating <= '5' THEN
               1
              ELSE
               0
            END
         END)) -- rating hit
         AND (Ui.Brinspfreq_Kdot IS NOT NULL AND
         Trunc(Ui.Brinspfreq_Kdot * 12) <= 24) AND
         ((b.Posting IS NOT NULL AND b.Ortype IS NOT NULL AND
         i.Oppostcl IS NOT NULL) AND
         (b.Posting < '5' OR (b.Posting = '5' AND b.Ortype = '5' AND
         Upper(i.Oppostcl) IN ('B', 'P', 'R'))))) OR
         i.Scourcrit IN ('0', '1', '2', '3', 'U'));

  RETURN(RESULT);

EXCEPTION
  WHEN No_Data_Found THEN
    RETURN NULL;
  WHEN OTHERS THEN
    RAISE;

END f_Nbi_High_Risk;
/