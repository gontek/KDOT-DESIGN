CREATE OR REPLACE TRIGGER pontis.Trg_Bi_Inspevnt_Datefix_V2
  BEFORE INSERT ON pontis.Inspevnt
  FOR EACH ROW

DECLARE

  -- anchored types always preferable
  -- prev 
  Ld_Uw_Prev Inspevnt.Uwlastinsp%TYPE;
  Ld_Fc_Prev Inspevnt.Fclastinsp%TYPE;
  Ld_Os_Prev Inspevnt.Oslastinsp%TYPE;

  -- next
  Ld_Uw_Next Inspevnt.Uwnextdate%TYPE;
  Ld_Fc_Next Inspevnt.Fcnextdate%TYPE;
  Ld_Os_Next Inspevnt.Osnextdate%TYPE;

  /*ld_nbi_prev DATE;*/
  Ld_Default_Date  DATE := To_Date('1901-01-01', 'YYYY-MM-DD');
  Ls_Prior_Inspkey Inspevnt.Inspkey%TYPE;

BEGIN

  -- find the inspkey from the record with the greatest date PRIOR to this new record.
  SELECT MAX(Inspkey)
    INTO Ls_Prior_Inspkey
    FROM Inspevnt I1
   WHERE I1.Inspkey =
         (SELECT MAX(I2.Inspkey)
            FROM Inspevnt I2
           WHERE I2.Brkey = :New.Brkey
             AND I2.Inspdate =
                 (SELECT MAX(I3.Inspdate)
                    FROM Inspevnt I3
                   WHERE I3.Brkey = :New.Brkey
                     AND I3.Inspdate < :New.Inspdate)); -- should raise NO_DATA_FOUND if there is no prior

  IF (Ls_Prior_Inspkey IS NOT NULL)
  THEN
    <<getuwdate>>
    BEGIN
      SELECT Uwlastinsp, Uwnextdate
        INTO Ld_Uw_Prev, Ld_Uw_Next
        FROM Inspevnt I1
       WHERE Brkey = :New.Brkey
         AND Inspkey = Ls_Prior_Inspkey; -- may be null, a valid previous date, or the missing date value
      Ksbms_Util.p_Log('Reinsert of underwater inspection date successful');
    EXCEPTION
      WHEN No_Data_Found THEN
        Ld_Uw_Prev := Ld_Default_Date;
        Ksbms_Util.p_Log('No date needs to be copied for underwater last inspection');
      
      WHEN OTHERS THEN
        RAISE;
    END Getuwdate;
  
    BEGIN
      <<getfcdate>>
      SELECT Fclastinsp, Fcnextdate
        INTO Ld_Fc_Prev, Ld_Fc_Next
        FROM Inspevnt
       WHERE Brkey = :New.Brkey
         AND Inspkey = Ls_Prior_Inspkey; -- may be null, a valid previous date, or the missing date value
    EXCEPTION
      WHEN No_Data_Found THEN
        Ld_Fc_Prev := Ld_Default_Date;
      WHEN OTHERS THEN
        RAISE;
    END Getfcdate;
  
    BEGIN
      <<getosdate>>
    
      SELECT Oslastinsp, Osnextdate
        INTO Ld_Os_Prev, Ld_Os_Next
        FROM Inspevnt
       WHERE Brkey = :New.Brkey
         AND Inspkey = Ls_Prior_Inspkey; -- may be null, a valid previous date, or the missing date value
    EXCEPTION
      WHEN No_Data_Found THEN
        Ld_Os_Prev := Ld_Default_Date;
      WHEN OTHERS THEN
        RAISE;
    END Getosdate;
  
    /*BEGIN
    <<GetNBIDate>>
    -- this assumes every prior inspection is an NBI inspection.  If that is not  a safe assumption then this WHERE clause needs to be smarter....
    SELECT MAX(INSPDATE) INTO ld_NBI_prev FROM INSPEVNT where BRKEY = :new.BRKEY and INSPKEY <> :new.INSPKEY AND INSPDATE < :new.INSPDATE; -- may be null, a valid previous date, or the missing date value
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    ld_NBI_prev := ld_default_date ;
    WHEN OTHERS THEN RAISE;
    END  GetNBIDate;
    */
    -- UW
    :New.Uwlastinsp := Nvl(Ld_Uw_Prev, Ld_Default_Date); -- NVL is not redundant  because the date may well be NULL in a previous record...
    :New.Uwnextdate := Nvl(Ld_Uw_Next, Ld_Default_Date);
    -- FC
    :New.Fclastinsp := Nvl(Ld_Fc_Prev, Ld_Default_Date);
    :New.Fcnextdate := Nvl(Ld_Fc_Next, Ld_Default_Date);
  
    -- OS
    :New.Oslastinsp := Nvl(Ld_Os_Prev, Ld_Default_Date);
    :New.Osnextdate := Nvl(Ld_Os_Next, Ld_Default_Date);
    /*:new.LASTINSP := NVL(ld_NBI_prev,ld_default_date);
    */
  
    Ksbms_Util.p_Log(q'[Trg_Bi_Inspevnt_Datefix_V2 - Copy-forward of underwater, fracture critical, and other inspection dates successful for bridge: ]' ||
                     :New.Brkey || q'[ - new inspection: ]' ||
                     :New.Inspkey);
  
  END IF; -- must have prior INSPKEY

EXCEPTION
  WHEN No_Data_Found THEN
    -- apparently no prior inspection
    RETURN;
  
  WHEN OTHERS THEN
    RAISE;
  
END Trg_Bi_Inspevnt_Datefix_V2;
/