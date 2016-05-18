CREATE OR REPLACE function pontis.F_GET_INSPECTORS_NAME(V_USERKEY USERS.USERKEY%TYPE)
 return varchar2 is
  Result VARCHAR2(35);
  
begin
 
SELECT SUBSTR(FIRST_NAME,1,1)||'. '||LAST_NAME INTO RESULT
FROM USERS U
WHERE U.USERKEY = V_USERKEY;
RETURN RESULT; 

EXCEPTION
   WHEN NO_DATA_FOUND THEN
     RESULT := '_';
RETURN RESULT;

end F_GET_INSPECTORS_NAME;

 
/