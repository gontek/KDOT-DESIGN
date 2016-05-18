CREATE OR REPLACE FORCE VIEW pontis.v_sc06_nhs_ind (brkey,"INDICATOR") AS
SELECT roadway.brkey, sum(decode(roadway.nhs_ind,'0',0,'1',1,'_',0,'',0)) as indicator
FROM roadway
 GROUP BY roadway.brkey
 order by sum(decode(roadway.nhs_ind,'0',0,'1',1,' ',0,'-1',0))

 ;