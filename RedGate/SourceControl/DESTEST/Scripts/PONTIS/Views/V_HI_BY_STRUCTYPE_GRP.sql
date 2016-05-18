CREATE OR REPLACE FORCE VIEW pontis.v_hi_by_structype_grp (brkey,bridge_id,unit_material,unit_type,super_design_ty,deck_comp_hi,super_comp_hi,sub_comp_hi,culv_comp_hi,avg_hi,groupsort) AS
select bridge.brkey,
         bridge.bridge_id,
         userstrunit.unit_material,
         userstrunit.unit_type,
         userstrunit.super_design_ty,
         userinsp.deck_comp_hi,
         userinsp.super_comp_hi,
         userinsp.sub_comp_hi,
         userinsp.culv_comp_hi,
         userbrdg.avg_hi,
case
when unit_material = '3' and unit_type = '1' then 1
when unit_material = '3' and unit_type = '43' then 1
when unit_material = '3' and unit_type = '41' then 1
when unit_material = '3' and unit_type = '42' then 1
when unit_material = '6' and unit_type = '1' then 1
when unit_material = '6' and unit_type = '11' then 1
when unit_material = '6' and unit_type = '3' then 1
when unit_material = '6' and unit_type = '12' then 1
when unit_material = '6' and unit_type = '2' and super_design_ty = '5' then 1
when unit_material = '6' and unit_type = '21' then 1
when unit_material = '6' and unit_type = '4' and super_design_ty = '5' then 1
when unit_material = '6' and unit_type = '4' and super_design_ty = '6' then 1
when unit_material = '6' and unit_type = '32' and super_design_ty = '1' then 1
when unit_material = '6' and unit_type = '33' and super_design_ty = '2' then 2
when unit_material = '6' and unit_type = '51' and super_design_ty = '2' then 2
when unit_material = '6' and unit_type = '51' and super_design_ty = '7' then 2
when unit_material = '6' and unit_type = '51' and super_design_ty = '3' then 2
when unit_material = '6' and unit_type = '51' and super_design_ty = '8' then 2
when unit_material = '6' and unit_type = '51' and super_design_ty = '1' then 2
when unit_material = '6' and unit_type = '31' and super_design_ty = '2' then 2
when unit_material = '6' and unit_type = '31' and super_design_ty = '3' then 2
when unit_material = '6' and unit_type = '31' and super_design_ty = '8' then 2
when unit_material = '6' and unit_type = '31' and super_design_ty = '1' then 2
when unit_material = '6' and unit_type = '52' and super_design_ty = '2' then 2
when unit_material = '6' and unit_type = '53' and super_design_ty = '2' then 2
when unit_material = '6' and unit_type = '53' and super_design_ty = '3' then 2
when unit_material = '7' and unit_type = '38' and super_design_ty = '2' then 3
when unit_material = '7' and unit_type = '38' and super_design_ty = '1' then 3
when unit_material = '7' and unit_type = '31' and super_design_ty = '2' then 3
when unit_material = '7' and unit_type = '31' and super_design_ty = '1' then 3
when unit_material = '7' and unit_type = '89' and super_design_ty = '2' then 3
when unit_material = '7' and unit_type = '89' and super_design_ty = '1' then 3
when unit_material = '7' and unit_type = '53' and super_design_ty = '2' then 3
when unit_material = '1' and unit_type = '83' and super_design_ty = '2' then 4
when unit_material = '1' and unit_type = '33' and super_design_ty = '2' then 4
when unit_material = '1' and unit_type = '38' and super_design_ty = '2' then 4
when unit_material = '1' and unit_type = '38' and super_design_ty = '1' then 4
when unit_material = '1' and unit_type = '61' and super_design_ty = '2' then 4
when unit_material = '1' and unit_type = '61' and super_design_ty = '3' then 4
when unit_material = '1' and unit_type = '61' and super_design_ty = '1' then 4
when unit_material = '1' and unit_type = '84' and super_design_ty = '2' then 4
when unit_material = '1' and unit_type = '34' and super_design_ty = '2' then 4
when unit_material = '1' and unit_type = '62' and super_design_ty = '2' then 4
when unit_material = '1' and unit_type = '63' and super_design_ty = '2' then 4
when unit_material = '1' and unit_type = '63' and super_design_ty = '1' then 4
when unit_material = '1' and unit_type = '88' and super_design_ty = '2' then 4
when unit_material = '1' and unit_type = '88' and super_design_ty = '1' then 4
when unit_material = '1' and unit_type = '86' and super_design_ty = '3' then 4
when unit_material = '1' and unit_type = '21' and super_design_ty = '0' then 4
when unit_material = '1' and unit_type = '21' and super_design_ty = '2' then 4
when unit_material = '1' and unit_type = '21' and super_design_ty = '1' then 4
when unit_material = '1' and unit_type = '36' and super_design_ty = '3' then 4
when unit_material = '1' and unit_type = '36' and super_design_ty = '1' then 4
when unit_material = '1' and unit_type = '85' and super_design_ty = '2' then 4
when unit_material = '1' and unit_type = '85' and super_design_ty = '3' then 4
when unit_material = '1' and unit_type = '35' and super_design_ty = '2' then 4
when unit_material = '1' and unit_type = '35' and super_design_ty = '3' then 4
when unit_material = '1' and unit_type = '35' and super_design_ty = '1' then 4
when unit_material = '1' and unit_type = '4' and super_design_ty = '5' then 4
when unit_material = '1' and unit_type = '4' and super_design_ty = '6' then 4
when unit_material = '1' and unit_type = '87' and super_design_ty = '2' then 4
when unit_material = '1' and unit_type = '87' and super_design_ty = '3' then 4
when unit_material = '1' and unit_type = '37' and super_design_ty = '2' then 4
when unit_material = '1' and unit_type = '37' and super_design_ty = '3' then 4
when unit_material = '1' and unit_type = '37' and super_design_ty = '1' then 4
when unit_material = '2' and unit_type = '83' and super_design_ty = '2' then 5
when unit_material = '2' and unit_type = '38' and super_design_ty = '2' then 5
when unit_material = '2' and unit_type = '88' and super_design_ty = '2' then 5
when unit_material = '2' and unit_type = '88' and super_design_ty = '1' then 5
when unit_material = '2' and unit_type = '21' and super_design_ty = '2' then 5
when unit_material = '2' and unit_type = '35' and super_design_ty = '3' then 5
when unit_material = '2' and unit_type = '87' and super_design_ty = '2' then 5
when unit_material = '2' and unit_type = '87' and super_design_ty = '3' then 5
when unit_material = '2' and unit_type = '87' and super_design_ty = '1' then 5
when unit_material = '2' and unit_Type = '37' and super_design_ty = '2' then 5
when unit_material = '2' and unit_type = '37' and super_design_ty = '3' then 5
when unit_material = '11' and unit_type = '33' and super_design_ty = '2' then 6
when unit_material = '11' and unit_type = '33' and super_design_ty = '1' then 6
when unit_material = '11' and unit_type = '51' and super_design_ty = '3' then 6
when unit_material = '12' and unit_type = '1' then 7
when unit_material = '12' and unit_type = '11' then 7
when unit_material = '12' and unit_type = '12' then 7
when unit_material = '10' and unit_type = '38' and super_design_ty = '1' then 8
else 0
end as groupsort

FROM bridge,
         userstrunit,
         structure_unit,
         inspevnt,
         userinsp,
         userbrdg,
         mv_latest_inspection
   WHERE userbrdg.brkey = bridge.brkey and
         userstrunit.brkey = bridge.brkey and
         structure_unit.brkey = userstrunit.brkey and
         structure_unit.strunitkey = userstrunit.strunitkey and
         structure_unit.strunittype = '1' and
         userinsp.brkey = bridge.brkey and
         inspevnt.brkey = bridge.brkey and
         mv_latest_inspection.brkey = bridge.brkey and
         inspevnt.inspkey = userinsp.inspkey and
			inspevnt.inspkey = mv_latest_inspection.inspkey and
			userbrdg.avg_hi is not null and
      substr(bridge.bridge_id,6,1) = 'B' and
      bridge.district <> '9'
order by brkey

 ;