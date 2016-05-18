CREATE OR REPLACE FORCE VIEW pontis.v_r22_setaside_rpt (po_num,brkey,strunitkey,mainstruc,maint_rte_num,maint_rte_prefix,design_ref_post,strtype,crit_note,adminarea,"LOCATION",featint,"FACILITY",length_eng,skew,roadwidth_eng,suff_rate,cond_index,avg_hi,detour_length_eng,truckpct,adttotal,sd_fo,proj_num,prog_cat,work_type,progyear,dkrating,suprating,subrating,culvrating,post_rstr,yearbuilt,design_county_ref,kdot_latitude,kdot_longitude,skew_direction,bridgetotalspans,kta_insp,struct_num,sub_area,design_load,ir_rate,or_rate,load_rate_method,ratingdate,scourcrit,wear_surface,ws_thick,hs_20,adj_hs_20,hl93) AS
(
-- REPAIRED 10/8/2013 ADDED FACILITY, KDOT_LATITUDE, KDOT_LONGITUDE, BRIDGETOTALSPANS - DK

SELECT  NVL(pontis.USERINSP.PRIORITY_OPT,0)*10000 AS PO_NUM,
         pontis.BRIDGE.BRKEY,
         pontis.STRUCTURE_UNIT.STRUNITKEY,
         case
           when pontis.STRUCTURE_UNIT.strunittype = '1'
             THEN 'Y'
               ELSE 'N'
                 END AS MAINSTRUC,
         pontis.USERRWAY.MAINT_RTE_NUM,
         pontis.USERRWAY.MAINT_RTE_PREFIX,
         pontis.USERBRDG.DESIGN_REF_POST,
         CASE
           when pontis.STRUCTURE_UNIT.STRUNITTYPE = '1' then
         f_get_paramtrs_equiv_long('USERSTRUNIT','UNIT_MATERIAL',userstrunit.unit_material)||
         f_get_paramtrs_equiv_long('USERSTRUNIT','UNIT_TYPE',userstrunit.unit_type)||
        f_get_paramtrs_equiv_long('USERSTRUNIT','SUPER_DESIGN_TY',userstrunit.super_design_ty)
        else ''
          End as strtype,
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
                DECODE(BRIDGE.DESIGNLOAD,'1','H 10','2','H 15','3', 'HS 15', '4', 'H 20', '5', 'HS 20', '6','HS 20 + Mod',
                     '7', 'Pedestrian', '8', 'Railroad', '9', 'HS 25', '0', 'Other','-1') as design_load,

         round(irload_lfd_hs/.9072,1)||' Tons' as ir_rate,
         round(orload_lfd_hs/.9072,1)||' Tons' as or_rate
       ,decode(nvl(bridge.ortype,'-1'),'1','Load Factor (LFD)','2','Allowable Stress (ASR)','3','Load & Resist.Factor (LRFR)','4','Load Testing','5','No rating Performed','-1') as Load_Rate_Method
         ,BRIDGE.RATINGDATE
         ,scourcrit
         ,f_get_paramtrs_equiv_long('userstrunit','dksurftype',userstrunit.dksurftype) as Wear_Surface
         ,round(userstrunit.wear_thick / 25.4,1)||' in.' as WS_Thick,
            round(orload_lfd_hs/0.90718474,4) as HS_20,
         round(orload_adj_hs/0.90718474,4) as ADJ_HS_20,
         orload_hl93 as hl93
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
     -- PONTIS.USERBRDG.KTA_INSP NOT IN ('0','1') AND
      pontis.BRIDGE.DISTRICT <> '9' AND
            BRIDGE.BRKEY = MV_BROMS_QUERY.BRKEY(+)
            )
;