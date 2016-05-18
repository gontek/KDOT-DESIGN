CREATE OR REPLACE PROCEDURE pontis.p_Do_Mar_Compliance_Review(p_Brkey     IN Bridge.Brkey%TYPE,
                                                       p_Userkey   IN Pon_App_Users.Userkey%TYPE,
                                                       p_Reportall IN BOOLEAN := FALSE) IS

  -- ARMarshall, ARM LLC 20150617 - procedure to perform MAR compliance checks on 1 bridge 
  -- calls separate local procedures for each check.
  -- arguments
  -- p_brkey - the bridge to evaluate
  -- p_usekey - the perpetrator
  -- p_Reportall will not report compliant by default

  Mar6_Flag  NUMBER(1) := 0; -- Indicates MAR 6 issue for the bridge.
  Mar7_Flag  NUMBER(1) := 0; -- Indicates MAR 7 issue for the bridge.
  Mar8_Flag  NUMBER(1) := 0; -- Indicates MAR 8 issue for the bridge.
  Mar9_Flag  NUMBER(1) := 0; -- Indicates MAR 9 issue for the bridge.
  Mar10_Flag NUMBER(1) := 0; -- Indicates MAR 10 issue for the bridge.
  Mar13_Flag NUMBER(1) := 0; -- Indicates MAR 13 issue for the bridge.
  Mar14_Flag NUMBER(1) := 0; -- Indicates MAR 14 issue for the bridge.
  Mar18_Flag NUMBER(1) := 0; -- Indicates MAR 18 issue for the bridge.
  RESULT     VARCHAR2(4000);

  New_Mar_Cr_Key          Kdot_Mar_Cr_Eventlog.Mar_Cr_Key%TYPE := Sys_Guid();
  New_Review_Status_Value Kdot_Mar_Cr_Review_Lookup.Mar_Cr_Kdot_Review_Status_Flag%TYPE;

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
       New_Review_Status_Value, -- reported!
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
  PROCEDURE Calc_Mar6 /*(p_Brkey IN Bridge.Brkey%TYPE) */
   IS
  
    My_Mar_Cr_Type       Kdot_Mar_Cr_Issues.Mar_Cr_Type%TYPE;
    My_Mar_Cr_Type_Level Kdot_Mar_Cr_Issues.Mar_Cr_Kdot_Review_Status_Flag%TYPE;
    My_Months_Overdue    PLS_INTEGER := 0;
  BEGIN
    My_Mar_Cr_Type := 6000;
  
    My_Mar_Cr_Type_Level := 1; -- i.e. SUBSTANTIALLY COMPLIANT
  
    SELECT Months_Overdue
      INTO My_Months_Overdue
      FROM v_Compliance_Mar6 v
     WHERE v.Brkey = p_Brkey;
  
    My_Mar_Cr_Type_Level := CASE
                              WHEN My_Months_Overdue <= 1 THEN
                               1 -- substantially compliant
                              ELSE
                               CASE
                                 WHEN My_Months_Overdue BETWEEN 1 AND 6 THEN
                                  2 -- not compliant
                                 ELSE
                                  3 -- really not compliant
                               END
                            END;
  
    IF (p_Reportall OR My_Months_Overdue > 1) THEN
      Mar6_Flag := 1;
      Insert_New_Cr_Issue(My_Mar_Cr_Type,
                          My_Mar_Cr_Type_Level,
                          My_Months_Overdue || q'[ months overdue]');
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END Calc_Mar6;

  PROCEDURE Calc_Mar7 /*(p_Brkey IN Bridge.Brkey%TYPE,
                                                                              Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE)*/
   IS
  BEGIN
    RETURN;
  END Calc_Mar7;

  PROCEDURE Calc_Mar8 /*(p_Brkey IN Bridge.Brkey%TYPE,
                                                                              Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE)*/
   IS
  BEGIN
    RETURN;
  END Calc_Mar8;

  PROCEDURE Calc_Mar9 /*(p_Brkey IN Bridge.Brkey%TYPE,
                                                                              Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE)*/
   IS
  BEGIN
    RETURN;
  END Calc_Mar9;

  PROCEDURE Calc_Mar10 /*(p_Brkey IN Bridge.Brkey%TYPE,
                                                                               Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE)*/
   IS
  BEGIN
    RETURN;
  END Calc_Mar10;

  PROCEDURE Calc_Mar13 /*(p_Brkey IN Bridge.Brkey%TYPE,
                                                                               Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE)*/
   IS
  BEGIN
    RETURN;
  END Calc_Mar13;

  PROCEDURE Calc_Mar14 /*(p_Brkey IN Bridge.Brkey%TYPE,
                                                                               Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE)*/
   IS
  BEGIN
    RETURN;
  END Calc_Mar14;

  PROCEDURE Calc_Mar18 /*(p_Brkey IN Bridge.Brkey%TYPE,
                                                                               Presult OUT Kdot_Mar_Cr_Issues.Mar_Cr_Assessment_Findings%TYPE) */
   IS
  BEGIN
    RETURN;
  END Calc_Mar18;

BEGIN

  BEGIN
  
    SELECT k.Mar_Cr_Kdot_Review_Status_Flag
      INTO New_Review_Status_Value
      FROM Kdot_Mar_Cr_Review_Lookup k
     WHERE k.Mar_Default_Status = 1
       AND Rownum() = 1;
  
  EXCEPTION
    WHEN No_Data_Found THEN
      New_Review_Status_Value := 1;
    WHEN OTHERS THEN
      RAISE;
  END;

  Insert_New_Cr_Event(); -- put in the tracker record

  RESULT := NULL;

  Calc_Mar6();

  Calc_Mar7();
  Calc_Mar8();
  Calc_Mar9();
  Calc_Mar10();
  Calc_Mar13();
  Calc_Mar14();
  Calc_Mar18();

EXCEPTION
  WHEN OTHERS THEN
    RAISE;
    RETURN;
  
END p_Do_Mar_Compliance_Review;
/