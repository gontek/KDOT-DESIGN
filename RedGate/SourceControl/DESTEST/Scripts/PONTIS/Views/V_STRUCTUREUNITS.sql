CREATE OR REPLACE FORCE VIEW pontis.v_structureunits (brkey,totalrows) AS
select userstrunit.brkey, count(brkey) as totalrows
from userstrunit
group by userstrunit.brkey

 ;