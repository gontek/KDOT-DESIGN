CREATE OR REPLACE FORCE VIEW pontis.v_active_all_structures (po_num,brkey,maint_rte_num,maint_rte_prefix,design_ref_post,strtype,crit_note,adminarea,"LOCATION",featint,"FACILITY",length_eng,skew,roadwidth_eng,suff_rate,cond_index,avg_hi,detour_length_eng,truckpct,adttotal,sd_fo,proj_num,prog_cat,work_type,progyear,dkrating,suprating,subrating,culvrating,post_rstr,yearbuilt,design_county_ref,kdot_latitude,kdot_longitude,skew_direction,bridgetotalspans,kta_insp,struct_num,sub_area,bif_new_ser,proj_status,bridge_id) AS
SELECT  NVL(pontis.USERINSP.PRIORITY_OPT,0)*10000 AS PO_NUM,
         pontis.BRIDGE.BRKEY,
         pontis.USERRWAY.MAINT_RTE_NUM,
         pontis.USERRWAY.MAINT_RTE_PREFIX,
         pontis.USERBRDG.DESIGN_REF_POST,
         F_STRUCTURETYPE(STRUCTURE_UNIT.BRKEY,STRUCTURE_UNIT.STRUNITKEY)as strtype,
         CASE
           WHEN (( pontis.USERSTRUNIT.CRIT_NOTE_SUP_1 = '7') OR
                (pontis.USERSTRUNIT.CRIT_NOTE_SUP_2 = '7') OR
               ( pontis.USERSTRUNIT.CRIT_NOTE_SUP_3 = '7') OR
               ( pontis.USERSTRUNIT.CRIT_NOTE_SUP_4 = '7') OR
               ( pontis.USERSTRUNIT.CRIT_NOTE_SUP_5 = '7'))
               THEN 'Y'
                 ELSE 'N'
                   END AS CRIT_NOTE,
        pontis.BRIDGE.ADMINAREA,
         pontis.BRIDGE.LOCATION,
         pontis.BRIDGE.FEATINT,
         pontis.BRIDGE.FACILITY,
         pontis.BRIDGE.length / 0.3048 as length_eng,
         pontis.BRIDGE.SKEW,
         pontis.ROADWAY.ROADWIDTH/0.3048 as roadwidth_eng,
        pontis.INSPEVNT.SUFF_RATE,
      pontis.USERINSP.COND_INDEX,
      pontis.USERBRDG.AVG_HI,
      ROUND(pontis.ROADWAY.BYPASSLEN /1.609344) AS detour_length_eng,
      pontis.ROADWAY.TRUCKPCT,
         pontis.ROADWAY.ADTTOTAL,
      DECODE(pontis.INSPEVNT.NBI_RATING,'1','SD','2','FO','0','') as SD_FO,
        MV_BROMS_QUERY.proj_num,
         MV_BROMS_QUERY.prog_cat,
         MV_BROMS_QUERY.work_type,
         MV_BROMS_QUERY.progyear,
         pontis.INSPEVNT.DKRATING,
         pontis.INSPEVNT.SUPRATING,
         pontis.INSPEVNT.SUBRATING,
         pontis.INSPEVNT.CULVRATING,
         DECODE(pontis.USERINSP.OPPOSTCL_KDOT,'7','P','8','R','')AS POST_RSTR,
         BRIDGE.YEARBUILT,
         USERBRDG.DESIGN_COUNTY_REF,
         USERBRDG.KDOT_LATITUDE,
         USERBRDG.KDOT_LONGITUDE,
         DECODE(USERBRDG.SKEW_DIRECTION,'1','L','2','R','') as SKEW_DIRECTION,
         F_GET_TOTALSPANS(BRIDGE.BRKEY) AS BRIDGETOTALSPANS,
         kta_insp,
         struct_num,
         USERBRDG.SUB_AREA,
               bif_new_ser,
               proj_status,
               bridge_id
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
         pontis.STRUCTURE_UNIT.STRUNITTYPE = '1' AND
         pontis.USERINSP.brkey = pontis.BRIDGE.brkey and
         pontis.INSPEVNT.brkey = pontis.BRIDGE.brkey and
         pontis.MV_LATEST_INSPECTION.brkey = pontis.BRIDGE.brkey and
         pontis.USERINSP.inspkey = pontis.INSPEVNT.inspkey and
      pontis.INSPEVNT.inspkey = pontis.MV_LATEST_INSPECTION.inspkey and
     -- PONTIS.USERBRDG.KTA_INSP NOT IN ('0','1') AND
      pontis.BRIDGE.DISTRICT <> '9' AND
    --  BRIDGE.BRKEY = '003055' AND
            BRIDGE.BRKEY = MV_BROMS_QUERY.BRKEY(+)
;