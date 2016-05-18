CREATE OR REPLACE FORCE VIEW pontis.v_adt_volume_designation (brkey,on_under,adttotal,"VOLUME") AS
select roadway.brkey,
       roadway.on_under,
       roadway.adttotal,
       case when adttotal < 400 then 
            1
            when adttotal >=400 and adttotal < 750 then
            2
            when adttotal >= 750 and adttotal < 1700 then
            3
            when adttotal >= 1700 and adttotal < 3000 then
            4
            when adttotal >= 3000 and adttotal < 5000 then
            5
            else 6
            end as volume
from roadway
where on_under in ('1','2','A','B') and
adttotal > 0

 ;