CREATE MATERIALIZED VIEW pontis.mv_map_data (bridge_id,"LENGTH",brkey,owner_kdot,maint_area,sub_area,custodian_kdot,attach_type_1,attach_desc_1,attach_type_2,attach_desc_2,attach_type_3,attach_desc_3,box_height_culv,road_type_sign,rot_direction,rot_angle_deg,rot_angle_min,skew_direction,skew_minutes,bridgemed_kdot,median_width,last_paint_supe,designload_type,designload_kdot,design_ref_post,design_county_ref,drainage_area,culv_fill_depth,grail_apr_lt,grail_apr_rt,grail_exit_lt,grail_exit_rt,grail_end_treat,grail_type,horiz_undr_sign,rating_comment,rating_adj,irload_adj_3,irload_adj_3_3,irload_adj_3s2,irload_adj_h,irload_adj_hs,irload_adj_t130,irload_adj_t170,irload_wsd_3,irload_wsd_3_3,irload_wsd_3s2,irload_wsd_h,irload_wsd_hs,irload_wsd_t130,irload_wsd_t170,irload_lfd_3,irload_lfd_3_3,irload_lfd_3s2,irload_lfd_h,irload_lfd_hs,irload_lfd_t130,irload_lfd_t170,orload_adj_3,orload_adj_3_3,orload_adj_3s2,orload_adj_h,orload_adj_hs,orload_adj_t130,orload_adj_t170,orload_wsd_3,orload_wsd_3_3,orload_wsd_3s2,orload_wsd_h,orload_wsd_hs,orload_wsd_t130,orload_wsd_t170,orload_lfd_3,orload_lfd_3_3,orload_lfd_3s2,orload_lfd_h,orload_lfd_hs,orload_lfd_t130,orload_lfd_t170,orientation,posted_sign_type,posted_load_a,posted_load_b,posted_load_c,restrict_load,sign_type_q1,sign_type_q2,sign_type_q3,sign_type_q4,stream_sign,function_type,super_paint_sys,suprstruct_tos,vert_clr_sign,vert_undr_sign,culv_wing_type,avg_hi,kdot_latitude,kdot_longitude,paint_surf_area,multi_drainage,reservoir_adj,env_notation_1,env_notation_2,wateropen,design_method,undr_suff_fill,kta_no,kta_id,kta_insp,irload_adj_hl93,irload_hl93,orload_adj_hl93,orload_hl93,abcdlist_a,abcdlist_a_notes,abcdlist_b,abcdlist_b_notes,abcdlist_c,abcdlist_c_notes,abcdlist_d,abcdlist_d_notes,createdatetime,createuserkey,modtime,userkey,notes,direction_id)
REFRESH COMPLETE 
AS select b.bridge_id,
  b.length,
  b.brkey             ,
  owner_kdot        ,
  maint_area        ,
  sub_area          ,
  custodian_kdot    ,
  attach_type_1     ,
  attach_desc_1     ,
  attach_type_2     ,
  attach_desc_2     ,
  attach_type_3     ,
  attach_desc_3     ,
  box_height_culv   ,
  road_type_sign    ,
  rot_direction     ,
  cast(rot_angle_deg as float) rot_angle_deg,
  cast(rot_angle_min as float) rot_angle_min,
  skew_direction    ,
  cast(skew_minutes as float) skew_minutes,
  bridgemed_kdot    ,
  median_width      ,
  last_paint_supe  ,
  designload_type   ,
  designload_kdot   ,
  design_ref_post   ,
  design_county_ref ,
  drainage_area     ,
  culv_fill_depth   ,
  grail_apr_lt      ,
  grail_apr_rt      ,
  grail_exit_lt     ,
  grail_exit_rt     ,
  grail_end_treat   ,
  grail_type        ,
  horiz_undr_sign   ,
  rating_comment    ,
  rating_adj        ,
  irload_adj_3      ,
  irload_adj_3_3    ,
  irload_adj_3s2    ,
  irload_adj_h      ,
  irload_adj_hs     ,
  irload_adj_t130   ,
  irload_adj_t170   ,
  irload_wsd_3      ,
  irload_wsd_3_3    ,
  irload_wsd_3s2    ,
  irload_wsd_h      ,
  irload_wsd_hs     ,
  irload_wsd_t130   ,
  irload_wsd_t170   ,
  irload_lfd_3      ,
  irload_lfd_3_3    ,
  irload_lfd_3s2    ,
  irload_lfd_h      ,
  irload_lfd_hs     ,
  irload_lfd_t130   ,
  irload_lfd_t170   ,
  orload_adj_3      ,
  orload_adj_3_3    ,
  orload_adj_3s2    ,
  orload_adj_h      ,
  orload_adj_hs     ,
  orload_adj_t130   ,
  orload_adj_t170   ,
  orload_wsd_3      ,
  orload_wsd_3_3    ,
  orload_wsd_3s2    ,
  orload_wsd_h      ,
  orload_wsd_hs     ,
  orload_wsd_t130   ,
  orload_wsd_t170   ,
  orload_lfd_3      ,
  orload_lfd_3_3    ,
  orload_lfd_3s2    ,
  orload_lfd_h      ,
  orload_lfd_hs     ,
  orload_lfd_t130   ,
  orload_lfd_t170   ,
  orientation       ,
  posted_sign_type  ,
  posted_load_a     ,
  posted_load_b     ,
  posted_load_c     ,
  restrict_load     ,
  sign_type_q1      ,
  sign_type_q2      ,
  sign_type_q3      ,
  sign_type_q4      ,
  stream_sign       ,
  function_type    ,
  super_paint_sys   ,
  suprstruct_tos    ,
  vert_clr_sign     ,
  vert_undr_sign    ,
  culv_wing_type    ,
  avg_hi          ,
  kdot_latitude     ,
  kdot_longitude    ,
  paint_surf_area   ,
  multi_drainage    ,
  reservoir_adj     ,
  env_notation_1    ,
  env_notation_2    ,
  wateropen         ,
  design_method     ,
  undr_suff_fill    ,
  kta_no            ,
  kta_id            ,
  kta_insp          ,
  irload_adj_hl93   ,
  irload_hl93       ,
  orload_adj_hl93   ,
  orload_hl93       ,
  abcdlist_a      ,
  abcdlist_a_notes  ,
  abcdlist_b        ,
  abcdlist_b_notes  ,
  abcdlist_c        ,
  abcdlist_c_notes ,
  abcdlist_d       ,
  abcdlist_d_notes ,
  b.createdatetime   ,
  b.createuserkey    ,
  b.modtime        ,
  b.userkey       ,
  b.notes,
  case when paralstruc in ('L','R') and vclrinv_n is not null
  then 'N'
    when paralstruc in ('L','R') and  vclrinv_s is not null
      then 'S'
        when paralstruc in ('L','R') and vclrinv_e is not null
          then 'E'
            when paralstruc in ('L','R') and vclrinv_w is not null
              then 'W'
                else null
                  end as direction_id
from userbrdg u, bridge b,userrway us
where u.brkey = b.brkey and
      us.brkey = b.brkey and
      us.on_under = '1';