CREATE OR REPLACE TRIGGER pontis.TAUR_USERRWAY_ROUTENUM_NBI_5DE
  after insert or update of route_num on pontis.userrway  
  for each row
  
--2003-03-14 KDOT-- created to automatically update NBI_5d in Roadway table


declare
  -- local variables here
  v_route_num roadway.routenum%type;
  v_dirsuffix roadway.dirsuffix%type;
BEGIN

V_route_num := lpad(:NEW.ROUTE_NUM,5,'0');
v_dirsuffix := '0';
    


-- place new route_num into roadway table

UPDATE ROADWAY
  SET ROUTENUM = V_ROUTE_NUM
  WHERE ROADWAY.BRKEY = :OLD.BRKEY
  AND ROADWAY.ON_UNDER = :OLD.ON_UNDER;
  
UPDATE ROADWAY
  SET DIRSUFFIX = v_dirsuffix
  WHERE ROADWAY.BRKEY = :OLD.BRKEY
  AND ROADWAY.ON_UNDER = :OLD.ON_UNDER;


  
end TAUR_USERRWAY_ROUTENUM_NBI_5DE;
/