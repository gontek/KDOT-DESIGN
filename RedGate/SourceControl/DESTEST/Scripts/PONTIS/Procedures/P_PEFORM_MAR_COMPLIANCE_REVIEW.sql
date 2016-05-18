CREATE OR REPLACE PROCEDURE pontis.p_Peform_Mar_Compliance_Review(p_Brkey   IN Bridge.Brkey%TYPE,
                                                           p_Userkey IN Pon_App_Users.Userkey%TYPE) IS

  Mar6_Flag  NUMBER(1) := 0; -- Indicates MAR 6 issue for the bridge.
  Mar7_Flag  NUMBER(1) := 0; -- Indicates MAR 7 issue for the bridge.
  Mar8_Flag  NUMBER(1) := 0; -- Indicates MAR 8 issue for the bridge.
  Mar9_Flag  NUMBER(1) := 0; -- Indicates MAR 9 issue for the bridge.
  Mar10_Flag NUMBER(1) := 0; -- Indicates MAR 10 issue for the bridge.
  Mar13_Flag NUMBER(1) := 0; -- Indicates MAR 13 issue for the bridge.
  Mar14_Flag NUMBER(1) := 0; -- Indicates MAR 14 issue for the bridge.
  Mar18_Flag NUMBER(1) := 0; -- Indicates MAR 18 issue for the bridge.
  RESULT     VARCHAR2(4000);

  New_Mar_Cr_Key Kdot_Mar_Cr_Eventlog.Mar_Cr_Key%TYPE := Sys_Guid();

  PROCEDURE Insert_New_Cr_Event IS
  
  BEGIN
    INSERT INTO Kdot_Mar_Cr_Eventlog
      (Mar_Cr_Key,
       Brkey,
       Compliance_Review_Date,
       Createuserkey,
       Createdatetime)
    VALUES
      (New_Mar_Cr_Key, p_Brkey, SYSDATE, p_Userkey, SYSDATE);
  
  EXCEPTION
    WHEN Dup_Val_On_Index THEN
      Raise_Application_Error(-20999,
                              q'[A duplicate primary key was found!]');
    WHEN OTHERS THEN
      RAISE;
  END Insert_New_Cr_Event;

  PROCEDURE Insert_New_Cr_Issue(p_Mar_Cr_Type             IN Kdot_Mar_Cr_Issues.Mar_Cr_Type%TYPE,
                                p_Mar_Cr_Compliance_Level IN Kdot_Mar_Cr_Issues.Mar_Cr_Compliance_Level%TYPE,
                                p_Findings                IN Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE) IS
  BEGIN
    INSERT INTO Kdot_Mar_Cr_Issues
      ( --Mar_Cr_Issue_Key,  let the trigger do it Luke...
       Mar_Cr_Key,
       Mar_Cr_Type,
       Mar_Cr_Compliance_Level,
       Mar_Cr_Kdot_Review_Status_Flag,
       Createdatetime,
       Createuserkey,
       Mar_Cr_Assessment_Findings)
    VALUES
      (New_Mar_Cr_Key,
       p_Mar_Cr_Type,
       p_Mar_Cr_Compliance_Level,
       1, -- reported!
       SYSDATE,
       p_Userkey,
       p_Findings);
  EXCEPTION
    WHEN Dup_Val_On_Index THEN
      Raise_Application_Error(-20999,
                              q'[A duplicate primary key was found!]');
    WHEN OTHERS THEN
      RAISE;
  END Insert_New_Cr_Issue;

  -- local procedures
  PROCEDURE Calc_Mar6(p_Brkey IN Bridge.Brkey%TYPE,
                      Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE) IS  -- added since line 133 error out on incorrect number of values passed) dk 7/23/2015
  
    My_Mar_Cr_Type       Kdot_Mar_Cr_Issues.Mar_Cr_Type%TYPE;
    My_Mar_Cr_Type_Level Kdot_Mar_Cr_Issues.Mar_Cr_Kdot_Review_Status_Flag%TYPE;
  
  BEGIN
    My_Mar_Cr_Type       := 6000;
    My_Mar_Cr_Type_Level := 1;
    RESULT               := 'Has issues';
    IF (RESULT IS NOT NULL) THEN
      Mar6_Flag := 1;
      Insert_New_Cr_Issue(My_Mar_Cr_Type, My_Mar_Cr_Type_Level, RESULT);
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END Calc_Mar6;

  PROCEDURE Calc_Mar7(p_Brkey IN Bridge.Brkey%TYPE,
                      Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE) IS
  BEGIN
    RETURN;
  END Calc_Mar7;

  PROCEDURE Calc_Mar8(p_Brkey IN Bridge.Brkey%TYPE,
                      Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE) IS
  BEGIN
    RETURN;
  END Calc_Mar8;

  PROCEDURE Calc_Mar9(p_Brkey IN Bridge.Brkey%TYPE,
                      Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE) IS
  BEGIN
    RETURN;
  END Calc_Mar9;

  PROCEDURE Calc_Mar10(p_Brkey IN Bridge.Brkey%TYPE,
                       Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE) IS
  BEGIN
    RETURN;
  END Calc_Mar10;

  PROCEDURE Calc_Mar13(p_Brkey IN Bridge.Brkey%TYPE,
                       Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE) IS
  BEGIN
    RETURN;
  END Calc_Mar13;

  PROCEDURE Calc_Mar14(p_Brkey IN Bridge.Brkey%TYPE,
                       Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE) IS
  BEGIN
    RETURN;
  END Calc_Mar14;

  PROCEDURE Calc_Mar18(p_Brkey IN Bridge.Brkey%TYPE,
                       Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE) IS
  BEGIN
    RETURN;
  END Calc_Mar18;

BEGIN

  Insert_New_Cr_Event(); -- put in the tracker record

  RESULT := NULL;

  Calc_Mar6(p_Brkey, RESULT);

  Calc_Mar7(p_Brkey, RESULT);
  Calc_Mar8(p_Brkey, RESULT);
  Calc_Mar9(p_Brkey, RESULT);
  Calc_Mar10(p_Brkey, RESULT);
  Calc_Mar13(p_Brkey, RESULT);
  Calc_Mar14(p_Brkey, RESULT);
  Calc_Mar18(p_Brkey, RESULT);

EXCEPTION
  WHEN OTHERS THEN
    RAISE;
    RETURN;
  
END p_Peform_Mar_Compliance_Review;
/