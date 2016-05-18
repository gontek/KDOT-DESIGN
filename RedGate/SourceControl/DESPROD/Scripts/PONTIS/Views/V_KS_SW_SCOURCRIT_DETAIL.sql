CREATE OR REPLACE FORCE VIEW pontis.v_ks_sw_scourcrit_detail (brkey,strunitkey,struct_num,"FACILITY",featint,custodian,servtypund,scourcrit,overwater,fed_aid,culvert) AS
Select B1.brkey,
       S1.strunitkey,
       B1.Struct_num,
       B1.facility,
       B1.featint,
       B1.custodian,
       B1.servtypund,
       I1.scourcrit,
case
  when R1.on_under = '22' then 1
  else 0
  end as overwater,
case
  when substr(B1.struct_num,4,1)<>5 then 1
  else 0
  end as fed_aid,
  decode(B1.designmain, 19, 1, 0) as culvert
from bridge B1, roadway R1, inspevnt I1, userinsp I2, structure_unit S1
where
  I2.brinspfreq_kdot not in ('99','0') and
  substr(B1.brkey,4,1) <> '5' and
  S1.brkey = B1.brkey and
  B1.brkey = R1.brkey and
  R1.on_under = '22' and
  I1.brkey = B1.brkey and
  I2.brkey = B1.brkey and
  I2.inspkey = I1.inspkey and
  I1.inspkey = (select IMV2.inspkey from
    mv_latest_inspection IMV2 where IMV2.brkey = B1.brkey)

 ;