CREATE OR REPLACE FORCE VIEW pontis.v_sc06_data (brkey,distarea,length_eng,struct_num,adttotal,adtyear,yearbuilt,"LOCATION",br_type,unit_type,super_design_ty,stream_name,sccr_nbi_113,subs_nbi_60,chan_nbi_61,wway_nbi_71,near_abut_footing,pier_ftg,far_abut_footing,insp_freq,uwinsp_freq,drainage_area_eng,maint_rte_prefix,maint_rte_num,design_county_ref,kta_no) AS
SELECT   bridge.brkey,
         bridge.adminarea as DistArea,
         bridge.length / .3048 as length_eng,
         bridge.struct_num,
         roadway.adttotal,
         roadway.adtyear,
         bridge.yearbuilt,
         bridge.location,
         userstrunit.unit_material as Br_Type,
         userstrunit.unit_type,
         userstrunit.super_design_ty,
         bridge.featint as Stream_Name,
         inspevnt.scourcrit as ScCr_NBI_113,
         inspevnt.subrating as SUBS_NBI_60,
         inspevnt.chanrating as CHAN_NBI_61,
         inspevnt.wateradeq as WWAY_NBI_71,
         userstrunit.abut_type_near as Near_Abut_Footing,
         userstrunit.pier_foot_type as Pier_Ftg,
         userstrunit.abut_type_far as Far_Abut_Footing,
         userinsp.brinspfreq_kdot * 12 as Insp_Freq,
         userinsp.uwinspfreq_kdot * 12 as uwinsp_freq,
         userbrdg.drainage_area / 2.5899881 as drainage_area_eng,
         userrway.maint_rte_prefix,
         userrway.maint_rte_num,
         userbrdg.design_county_ref,
         userbrdg.kta_no

    FROM bridge,
         userbrdg,
         userstrunit,
         userinsp,
         inspevnt,
         mv_latest_inspection,
         roadway,
         userrway,
         v_scour_structures
where    bridge.brkey = v_scour_structures.brkey and
         userbrdg.brkey = bridge.brkey and
         userstrunit.brkey = bridge.brkey and
         userstrunit.strunitkey = '1' and
         userrway.brkey = bridge.brkey and
         roadway.brkey = bridge.brkey and
         roadway.on_under = userrway.on_under and
         roadway.on_under = '1' and
         inspevnt.brkey = bridge.brkey and
         userinsp.brkey = bridge.brkey and
         userinsp.inspkey = inspevnt.inspkey and
         mv_latest_inspection.brkey = bridge.brkey and
			inspevnt.inspkey = mv_latest_inspection.inspkey and
         substr(bridge.brkey,4,1) <> '5' and
         userinsp.brinspfreq_kdot not in ('0','99')
order by bridge.brkey

 ;