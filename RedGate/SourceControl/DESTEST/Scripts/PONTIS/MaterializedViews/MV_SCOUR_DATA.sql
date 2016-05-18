CREATE MATERIALIZED VIEW pontis.mv_scour_data (brkey,distarea,adttotal,yearbuilt,"LOCATION",strtype,stream_name,sccr_nbi_113,subs_nbi_60,chan_nbi_61,wway_nbi_71,near_abut_footing,pier_ftg,far_abut_footing,insp_freq,uwinsp_freq,drainage_area_eng,maint_rte_prefix,maint_rte_num,design_county_ref,totalspans,length_eng,"INDICATOR",struct_num,"DECODE(ADMINAREA,11,'HORTON',1",latitude,longitude,milepost_no,kta_milepost)
AS SELECT   b.brkey,
         b.adminarea as DISTAREA,
         bif.f_get_bif_rdwydata(b.brkey,'1','roadway','adttotal') as ADTTOTAL,
         b.yearbuilt,
         b.location,
         f_structuretype_main(b.brkey) STRTYPE,
         b.featint as Stream_Name,
         bif.f_get_bif_insp_item(b.brkey,'scourcrit') as ScCr_NBI_113,
         bif.f_get_bif_insp_item(b.brkey,'subrating')as SUBS_NBI_60,
         bif.f_get_bif_insp_item(b.brkey,'chanrating') as CHAN_NBI_61,
         bif.f_get_bif_insp_item(b.brkey,'wateradeq') as WWAY_NBI_71,
         f_get_paramtrs_equiv_long('userstrunit','abut_foot_type',bif.f_get_bif_userstr_item_main(b.brkey,'abut_type_near')) as NEAR_ABUT_FOOTING,
         f_get_paramtrs_equiv_long('userstrunit','pier_foot_type',bif.f_get_bif_userstr_item_main(b.brkey,'pier_foot_type')) as PIER_FTG,
         f_get_paramtrs_equiv_long('userstrunit','abut_foot_type',bif.f_get_bif_userstr_item_main(b.brkey,'abut_type_far')) as FAR_ABUT_FOOTING,
         to_number(bif.f_get_bif_insp_item(b.brkey,'brinspfreq_kdot'))*12 as INSP_FREQ,
         to_number(bif.f_get_bif_insp_item(b.brkey,'uwinspfreq_kdot'))*12 as UWINSP_FREQ,
         ub.drainage_area / 2.5899881 as DRAINAGE_AREA_ENG,
         bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_prefix') as MAINT_RTE_PREFIX,
         to_number(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','maint_rte_num')) as MAINT_RTE_NUM,
         ub.design_county_ref,
         f_get_totalspans(b.brkey) as TOTALSPANS,
         b.length / .3048 as LENGTH_ENG,
         decode(bif.f_get_bif_rdwydata(b.brkey,'1','roadway','nhs_ind'),'1','Y','0','N','') as INDICATOR,
         b.struct_num,
         decode(adminarea,11,'Horton',12,'Osage City',13,'Bonner Springs',14,'Topeka',
         15,'Wamego',16,'Olathe',21,'Clay Center',22,'Mankato',
         23,'Marion',24,'Ellsworth',31,'Phillipsburg',32,'Atwood',33,'Hays',
         34,'Oakley',41,'Iola',42,'Garnett',43,'Independence',44,'Pittsburg',
         51,'Pratt',52,'El Dorado',53,'Winfield',54,'Great Bend',55,'Wichita',
         61,'Syracuse',62,'Ulysses',63,'Dodge City',''),
         ub.kdot_latitude as LATITUDE,
         ub.kdot_longitude as LONGITUDE,
         ub.design_ref_post as MILEPOST_NO,
         kta_no as kta_milepost
    FROM bridge b,
         userbrdg ub,
         v_scour_structures v
where    b.brkey = v.brkey and
         ub.brkey = b.brkey;