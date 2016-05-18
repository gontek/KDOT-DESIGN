CREATE OR REPLACE FORCE VIEW pontis.v_elem_value (elemkey,envkey,ecatkey,matlkey,elem_fail,elem_weight,s2factor,s3factor,s4factor) AS
select elemdefs.elemkey as elemkey,
condumdl.envkey as envkey,
elemdefs.ecatkey as ecatkey,
elemdefs.matlkey as matlkey,
condumdl.failagcyco as elem_fail,
round(elemdefs.elemweight*(select max(unitcost) from expactc where expactc.elemkey = elemdefs.elemkey and
 expactc.envkey = condumdl.envkey and
 condumdl.mokey = '00'),2) as elem_weight,
case when elemdefs.statecnt = 5 then(3.0/4.0)
  else case when elemdefs.statecnt = 4 then(2.0/3.0) else(1.0/2.0) end
end as s2factor,
case when elemdefs.statecnt = 5 then(2.0/4.0) else
case when elemdefs.statecnt = 4 then(1.0/3.0) else 0.0 end
end as s3factor,
case when elemdefs.statecnt = 5 then(1.0/4.0) else 0.0 end as s4factor
from elemdefs, condumdl where condumdl.elemkey = elemdefs.elemkey and
                              condumdl.mokey = '00'

 ;