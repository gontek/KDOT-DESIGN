CREATE OR REPLACE FORCE VIEW pontis.v_kta_inspection_list (bridge_id,brkey,strtype,adminarea,yearbuilt,roadwidth,rte,bridge_length,"REF",featint,last_routine_insp,last_fc_insp,last_uw_insp,freq,next_routine_insp,kta_no,kta_id,n_s,deck_hi,sup_hi,sub_hi,culv_hi,avg_hi) AS
SELECT b.bridge_id,
         b.brkey as brkey,
         f_structuretype_main(b.brkey) strtype,
         b.adminarea,
         b.yearbuilt,
         f_get_bif_roadway_item(b.brkey,'roadwidth') as roadwidth,
         bif.f_get_bif_route(b.brkey) Rte,
         round(b.length/.3048,1) as bridge_length,
         ub.design_ref_post Ref,
         b.featint,
         i.inspdate last_Routine_insp,
         i.fclastinsp last_FC_insp,
         i.uwlastinsp last_UW_insp,
         us.brinspfreq_kdot as freq,
         extract(year from i.nextinsp) Next_Routine_Insp,
         ub.kta_no,
         ub.kta_id,
         decode(kta_insp,'1','N','0','S','') as N_S,
         us.deck_comp_hi deck_hi,
         us.super_comp_hi sup_hi,
         us.sub_comp_hi sub_hi,
         us.culv_comp_hi culv_hi,
         ub.avg_hi
    FROM bridge b,
         inspevnt i,
         userinsp us,
         userbrdg ub,
         mv_latest_inspection mv
    WHERE ub.brkey = b.brkey and
         i.brkey = b.brkey and
         us.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         us.inspkey = mv.inspkey and
         kta_insp in ('0','1') and
         b.district <> '9'
ORDER BY to_number(bif.f_get_bif_route(b.brkey)) ASC, ub.design_ref_post ASC

 ;