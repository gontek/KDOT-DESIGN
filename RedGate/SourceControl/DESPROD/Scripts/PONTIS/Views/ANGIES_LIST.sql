CREATE OR REPLACE FORCE VIEW pontis.angies_list (brkey,nbi_rating) AS
select i1.brkey, i1.nbi_rating
from inspevnt i1
where substr(brkey,4,1) <> '5' and
   I1.INSPKEY = (SELECT MAX( I2.INSPKEY ) FROM INSPEVNT I2 WHERE  I2.BRKEY = I1.BRKEY AND I2.INSPDATE = (SELECT MAX(I3.INSPDATE) FROM INSPEVNT I3  WHERE I3.BRKEY = I1.BRKEY ) )
;