CREATE OR REPLACE FORCE VIEW pontis.bridge_latitude (brkey,latitude,degrees,minutes,seconds) AS
select brkey, latitude, 
trunc(latitude) as degrees,
trunc(mod(latitude, 1)*60) as minutes,
mod((mod(latitude, 1)*60), 1)*60 as seconds
from bridge

/*trunc(latitude)||trunc(mod(latitude, 1)*60)||mod((mod(latitude, 1)*60), 1)*60 as lat*/

 ;