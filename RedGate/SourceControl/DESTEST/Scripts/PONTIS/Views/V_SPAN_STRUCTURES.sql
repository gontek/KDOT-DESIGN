CREATE OR REPLACE FORCE VIEW pontis.v_span_structures (brkey,strtype,maxspan,wateradeq,length_eng,skew,skew_direction,adminarea,funcclass,function_class,strunitkey,mainstruc) AS
(

SELECT  pontis.BRIDGE.BRKEY,
         f_get_paramtrs_equiv_long('USERSTRUNIT','UNIT_MATERIAL',userstrunit.unit_material)||
         f_get_paramtrs_equiv_long('USERSTRUNIT','UNIT_TYPE',userstrunit.unit_type)||
        f_get_paramtrs_equiv_long('USERSTRUNIT','SUPER_DESIGN_TY',userstrunit.super_design_ty)
         as strtype,
        pontis.BRIDGE.MAXSPAN,
        pontis.INSPEVNT.WATERADEQ,
        pontis.BRIDGE.length / 0.3048 as length_eng,
        pontis.BRIDGE.SKEW,
               DECODE(USERBRDG.SKEW_DIRECTION,'1','L','2','R','') as SKEW_DIRECTION,
        pontis.BRIDGE.ADMINAREA,
        pontis.ROADWAY.FUNCCLASS,
         DECODE(pontis.ROADWAY.FUNCCLASS,'1','Rural Interstate','2','Rural Other Princ','6','Rural Minor Arterial','7',
         'Rural Mjr Collector','8', 'Rural Min Collector','9','Rural Local','11','Urban Interstate','12','Urban Fwy Expwy','14',
         'Urban Minor Arterial','17','Urban Collector','19','Urban Local','') as FUNCTION_CLASS,
        pontis.STRUCTURE_UNIT.STRUNITKEY,
         case
           when pontis.STRUCTURE_UNIT.STRUNITTYPE = '1'
             THEN 'Y'
               ELSE 'N'
                END AS MAINSTRUC
     FROM pontis.BRIDGE,
         pontis.USERBRDG,
         pontis.ROADWAY,
         pontis.USERRWAY,
         pontis.USERSTRUNIT,
         pontis.INSPEVNT,
         pontis.USERINSP,
         pontis.STRUCTURE_UNIT,
         pontis.MV_LATEST_INSPECTION,
         MV_BROMS_QUERY
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
      substr(bridge.brkey, 4, 1) <> '5' AND
      userstrunit.super_design_ty <> '0' AND
      BRIDGE.BRKEY = MV_BROMS_QUERY.BRKEY(+)
  )

 ;