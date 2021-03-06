CREATE OR REPLACE FORCE VIEW pontis.v_nlw_41 (brkey,adminarea,vclrover,vclrunder,yearbuilt,yearrecon,dksurftype,unit_material,unit_type,super_design_ty,on_under,maint_rte_num,design_ref_post,designload_type,designload_kdot_eng,culv_fill_depth_eng,box_height_culv_eng,"FACILITY",featint,rdwy,dkrating,suprating,subrating,culvrating,irload_lfd_3_eng,irload_wsd_3_eng,irload_lfd_3_3_eng,irload_wsd_3_3_eng,irload_lfd_3s2_eng,irload_wsd_3s2_eng,irload_lfd_h_eng,irload_wsd_h_eng,irload_lfd_hs_eng,irload_wsd_hs_eng,irload_lfd_t130_eng,irload_wsd_t130_eng,irload_lfd_t170_eng,irload_wsd_t170_eng,orload_lfd_3_eng,orload_wsd_hs_eng,orload_wsd_3_eng,orload_lfd_3_3_eng,orload_wsd_3_3_eng,orload_lfd_3s2_eng,orload_wsd_3s2_eng,orload_lfd_hs_eng,orload_lfd_h_eng,orload_wsd_h_eng,orload_lfd_t130_eng,orload_wsd_t130_eng,orload_lfd_t170_eng,orload_wsd_t170_eng,"LOCATION",rating_comment,ratingdate,cond_index,inspdate,posted_load_a_eng,posted_load_b_eng,posted_load_c_eng) AS
SELECT BRIDGE.BRKEY,
       BRIDGE.ADMINAREA,
       BRIDGE.VCLROVER ,
       BRIDGE.VCLRUNDER,
       BRIDGE.YEARBUILT,
       BRIDGE.YEARRECON,
		 USERSTRUNIT.DKSURFTYPE,
       USERSTRUNIT.UNIT_MATERIAL,
       USERSTRUNIT.UNIT_TYPE,
       USERSTRUNIT.SUPER_DESIGN_TY,               
		 ROADWAY.ON_UNDER,
       USERRWAY.MAINT_RTE_NUM,
       USERBRDG.DESIGN_REF_POST,
       USERBRDG.DESIGNLOAD_TYPE,
       USERBRDG.DESIGNLOAD_KDOT / 0.9072 AS DESIGNLOAD_KDOT_ENG, 
       USERBRDG.CULV_FILL_DEPTH /  0.3048 as CULV_FILL_DEPTH_ENG,
       USERBRDG.BOX_HEIGHT_CULV / 0.9072 AS BOX_HEIGHT_CULV_ENG,
       BRIDGE.FACILITY,
       BRIDGE.FEATINT,
       ROADWAY.ROADWIDTH / .3048 AS RDWY,
         INSPEVNT.DKRATING,
         INSPEVNT.SUPRATING,
         INSPEVNT.SUBRATING,
         INSPEVNT.CULVRATING,
         USERBRDG.IRLOAD_LFD_3 / 0.9072 AS IRLOAD_LFD_3_ENG,
         USERBRDG.IRLOAD_WSD_3 / 0.9072 AS IRLOAD_WSD_3_ENG,   
         USERBRDG.IRLOAD_LFD_3_3 / 0.9072 AS IRLOAD_LFD_3_3_ENG,
         USERBRDG.IRLOAD_WSD_3_3 / 0.9072 AS IRLOAD_WSD_3_3_ENG,
         USERBRDG.IRLOAD_LFD_3S2 / 0.9072 AS IRLOAD_LFD_3S2_ENG,
         USERBRDG.IRLOAD_WSD_3S2 / 0.9072 AS IRLOAD_WSD_3S2_ENG,
         USERBRDG.IRLOAD_LFD_H / 0.9072 AS IRLOAD_LFD_H_ENG,
         USERBRDG.IRLOAD_WSD_H / 0.9072 AS IRLOAD_WSD_H_ENG,
         USERBRDG.IRLOAD_LFD_HS / 0.9072 AS IRLOAD_LFD_HS_ENG,
         USERBRDG.IRLOAD_WSD_HS / 0.9072 AS IRLOAD_WSD_HS_ENG,
         USERBRDG.IRLOAD_LFD_T130 / 0.9072 AS IRLOAD_LFD_T130_ENG, 
         USERBRDG.IRLOAD_WSD_T130 / 0.9072 AS IRLOAD_WSD_T130_ENG, 
         USERBRDG.IRLOAD_LFD_T170 / 0.9072 AS IRLOAD_LFD_T170_ENG,
         USERBRDG.IRLOAD_WSD_T170 / 0.9072 AS IRLOAD_WSD_T170_ENG,
         USERBRDG.ORLOAD_LFD_3 / 0.9072 AS ORLOAD_LFD_3_ENG,
         USERBRDG.ORLOAD_WSD_HS / 0.9072 AS ORLOAD_WSD_HS_ENG,
         USERBRDG.ORLOAD_WSD_3 / 0.9072 AS ORLOAD_WSD_3_ENG,
         USERBRDG.ORLOAD_LFD_3_3 / 0.9072 AS ORLOAD_LFD_3_3_ENG,
         USERBRDG.ORLOAD_WSD_3_3 / 0.9072 AS ORLOAD_WSD_3_3_ENG,  
         USERBRDG.ORLOAD_LFD_3S2 / 0.9072 AS ORLOAD_LFD_3S2_ENG,
         USERBRDG.ORLOAD_WSD_3S2 / 0.9072 AS ORLOAD_WSD_3S2_ENG,
         USERBRDG.ORLOAD_LFD_HS / 0.9072 AS ORLOAD_LFD_HS_ENG,  
         USERBRDG.ORLOAD_LFD_H / 0.9072 AS ORLOAD_LFD_H_ENG,
         USERBRDG.ORLOAD_WSD_H / 0.9072 AS ORLOAD_WSD_H_ENG,
         USERBRDG.ORLOAD_LFD_T130 / 0.9072 AS ORLOAD_LFD_T130_ENG,
         USERBRDG.ORLOAD_WSD_T130 / 0.9072 AS ORLOAD_WSD_T130_ENG,
         USERBRDG.ORLOAD_LFD_T170 / 0.9072 AS ORLOAD_LFD_T170_ENG,
         USERBRDG.ORLOAD_WSD_T170 / 0.9072 AS ORLOAD_WSD_T170_ENG,
         BRIDGE.LOCATION,
         USERBRDG.RATING_COMMENT,
         BRIDGE.RATINGDATE,
         USERINSP.COND_INDEX,
         INSPEVNT.INSPDATE,
         USERBRDG.POSTED_LOAD_A / 0.9072 AS POSTED_LOAD_A_ENG,   
         USERBRDG.POSTED_LOAD_B / 0.9072 AS POSTED_LOAD_B_ENG,   
         USERBRDG.POSTED_LOAD_C / 0.9072 AS POSTED_LOAD_C_ENG
 FROM    pontis.BRIDGE,
         pontis.USERBRDG, 
			pontis.INSPEVNT,
         pontis.USERINSP,
			pontis.ROADWAY,
         pontis.USERSTRUNIT,
         pontis.STRUCTURE_UNIT,
         pontis.USERRWAY,
         pontis.MV_LATEST_INSPECTION
   WHERE USERBRDG.BRKEY = BRIDGE.BRKEY AND
         USERRWAY.BRKEY = BRIDGE.BRKEY AND
         ROADWAY.BRKEY = BRIDGE.BRKEY AND
         ROADWAY.ON_UNDER = USERRWAY.ON_UNDER AND
         ROADWAY.ON_UNDER = (SELECT MIN(ON_UNDER) FROM ROADWAY R
				WHERE R.BRKEY = ROADWAY.BRKEY) and  
         USERINSP.BRKEY = BRIDGE.BRKEY AND
         INSPEVNT.BRKEY = BRIDGE.BRKEY AND
         MV_LATEST_INSPECTION.BRKEY = BRIDGE.BRKEY AND
         INSPEVNT.INSPKEY = USERINSP.INSPKEY AND
			INSPEVNT.INSPKEY = MV_LATEST_INSPECTION.INSPKEY AND
			USERSTRUNIT.BRKEY = BRIDGE.BRKEY AND
      STRUCTURE_UNIT.BRKEY = BRIDGE.BRKEY AND
                  USERSTRUNIT.STRUNITKEY = STRUCTURE_UNIT.STRUNITKEY AND
           STRUCTURE_UNIT.STRUNITTYPE = (SELECT MIN(STRUNITTYPE) FROM STRUCTURE_UNIT T
             WHERE T.BRKEY = USERSTRUNIT.BRKEY) and
 SUBSTR(BRIDGE.BRKEY, 4, 1) <> '5'

 ;