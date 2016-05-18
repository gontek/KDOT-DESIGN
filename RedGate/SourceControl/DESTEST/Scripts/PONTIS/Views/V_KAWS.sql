CREATE OR REPLACE FORCE VIEW pontis.v_kaws (co_ser,district,area,subarea,route,latitude,longitude) AS
(

select co_ser, district, area, subarea, route_prefix||'-'||route as route,
latitude, longitude from kaws_structures)

 ;