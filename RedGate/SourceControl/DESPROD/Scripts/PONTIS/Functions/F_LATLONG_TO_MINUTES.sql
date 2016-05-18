CREATE OR REPLACE function pontis.f_latlong_to_minutes(v_latlong IN NUMBER) return number is
a  VARCHAR2(15);
b  NUMBER;
c  NUMBER;
retval  NUMBER;

BEGIN

  b:=FLOOR(abs(v_latlong)); -- down to the degree
  a:=LTRIM(TO_CHAR(b,'000')); -- pads result of b with '0'
  b:=(abs(v_latlong)-FLOOR(abs(v_latlong)))*60; -- changes remainder to minutes
  a:=a||LTRIM(TO_CHAR(FLOOR(b),'00'));-- takes the minutes and adds them
  b:=(b-FLOOR(b))*60; -- takes whats left and converts to minutes
  a:=a||LTRIM(TO_CHAR(FLOOR(b),'00')); -- adds them on  
  retval:= TO_NUMBER(a)*100; -- makes it a number and multiplies by 100
  
RETURN retval;
EXCEPTION WHEN OTHERS THEN
  retval:=-1;
  RETURN retval;
END f_latlong_to_minutes;

 
/