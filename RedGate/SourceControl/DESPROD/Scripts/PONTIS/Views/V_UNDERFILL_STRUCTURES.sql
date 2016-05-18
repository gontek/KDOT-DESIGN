CREATE OR REPLACE FORCE VIEW pontis.v_underfill_structures (brkey,strtype,wateradeq,tot_num_spans,"LENGTH",box_height_culv,culv_fill_depth,skew,skew_direction) AS
(

SELECT  pontis.BRIDGE.BRKEY,
         f_get_paramtrs_equiv_long('USERSTRUNIT','UNIT_MATERIAL',userstrunit.unit_material)||
         f_get_paramtrs_equiv_long('USERSTRUNIT','UNIT_TYPE',userstrunit.unit_type)||
         f_get_paramtrs_equiv_long('USERSTRUNIT','SUPER_DESIGN_TY',userstrunit.super_design_ty)
         as strtype,
         pontis.INSPEVNT.WATERADEQ,
         pontis.USERSTRUNIT.TOT_NUM_SPANS,
         pontis.USERSTRUNIT.LENGTH,
         pontis.USERBRDG.BOX_HEIGHT_CULV,
         pontis.USERBRDG.CULV_FILL_DEPTH,
         pontis.BRIDGE.SKEW,
         DECODE(USERBRDG.SKEW_DIRECTION,'1','L','2','R','') as SKEW_DIRECTION
    FROM pontis.BRIDGE,
         pontis.USERBRDG,
         pontis.USERSTRUNIT,
         pontis.INSPEVNT,
         pontis.USERRWAY,
         pontis.ROADWAY,
         pontis.USERINSP,
         pontis.MV_LATEST_INSPECTION,
         pontis.STRUCTURE_UNIT
   WHERE pontis.USERBRDG.brkey = pontis.BRIDGE.brkey and
         pontis.USERRWAY.brkey = pontis.BRIDGE.brkey and
         pontis.USERRWAY.on_under = (select min(on_under) from pontis.USERRWAY r
          where r.brkey = pontis.USERRWAY.brkey) and
      pontis.ROADWAY.brkey = pontis.USERRWAY.brkey and
      pontis.ROADWAY.on_under = pontis.USERRWAY.on_under and
         pontis.USERSTRUNIT.brkey = pontis.BRIDGE.brkey and
         pontis.STRUCTURE_UNIT.brkey = pontis.USERSTRUNIT.brkey and
         pontis.STRUCTURE_UNIT.strunitkey = pontis.USERSTRUNIT.strunitkey and
         pontis.USERINSP.brkey = pontis.BRIDGE.brkey and
         pontis.INSPEVNT.brkey = pontis.BRIDGE.brkey and
         pontis.MV_LATEST_INSPECTION.brkey = pontis.BRIDGE.brkey and
         pontis.USERINSP.inspkey = pontis.INSPEVNT.inspkey and
      pontis.INSPEVNT.inspkey = pontis.MV_LATEST_INSPECTION.inspkey and
      pontis.USERINSP.brinspfreq_kdot not in (99) AND
      pontis.BRIDGE.DISTRICT <> '9' AND
      pontis.USERSTRUNIT.SUPER_DESIGN_TY = '0'
     )

 ;