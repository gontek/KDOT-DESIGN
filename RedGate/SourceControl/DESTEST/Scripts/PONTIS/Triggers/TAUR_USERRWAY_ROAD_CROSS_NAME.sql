CREATE OR REPLACE TRIGGER pontis.TAUR_USERRWAY_ROAD_CROSS_NAME
  after insert or update of road_cross_name on pontis.userrway  
  for each row
  
--2003-03-14 KDOT-- created to move userrway.road_cross_name  
-- to roadway.roadway_name, so they don't have  
-- to be entered twice.


declare
  -- local variables here
  v_roadway_name userrway.road_cross_name%type;

BEGIN

v_roadway_name := trim(upper(:new.road_cross_name));
    
-- place userrway.road_cross_name into roadway.roadway_name

UPDATE ROADWAY
  SET ROADWAY_NAME = v_roadway_name
  WHERE ROADWAY.BRKEY = :OLD.BRKEY
  AND ROADWAY.ON_UNDER = :OLD.ON_UNDER;


  
end TAUR_USERRWAY_ROAD_CROSS_NAME;
/