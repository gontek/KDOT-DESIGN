CREATE TABLE pontis.vc_userbrdg (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  owner_kdot VARCHAR2(2 BYTE),
  maint_area VARCHAR2(2 BYTE),
  sub_area VARCHAR2(2 BYTE),
  custodian_kdot VARCHAR2(2 BYTE),
  attach_type_1 VARCHAR2(2 BYTE),
  attach_desc_1 VARCHAR2(65 BYTE),
  attach_type_2 VARCHAR2(2 BYTE),
  attach_desc_2 VARCHAR2(65 BYTE),
  attach_type_3 VARCHAR2(2 BYTE),
  attach_desc_3 VARCHAR2(65 BYTE),
  box_height_culv FLOAT,
  road_type_sign CHAR,
  rot_direction CHAR,
  rot_angle_deg NUMBER(2),
  rot_angle_min NUMBER(4,1),
  skew_direction CHAR,
  skew_minutes NUMBER(4,1),
  bridgemed_kdot CHAR,
  median_width FLOAT,
  last_paint_supe DATE,
  designload_type CHAR,
  designload_kdot FLOAT,
  design_ref_post NUMBER(7,3),
  design_county_ref NUMBER(7,3),
  drainage_area FLOAT,
  culv_fill_depth FLOAT,
  grail_apr_lt CHAR,
  grail_apr_rt CHAR,
  grail_exit_lt CHAR,
  grail_exit_rt CHAR,
  grail_end_treat VARCHAR2(2 BYTE),
  grail_type VARCHAR2(2 BYTE),
  horiz_undr_sign CHAR,
  rating_comment VARCHAR2(2 BYTE),
  rating_adj CHAR,
  irload_adj_3 FLOAT,
  irload_adj_3_3 FLOAT,
  irload_adj_3s2 FLOAT,
  irload_adj_h FLOAT,
  irload_adj_hs FLOAT,
  irload_adj_t130 FLOAT,
  irload_adj_t170 FLOAT,
  irload_wsd_3 FLOAT,
  irload_wsd_3_3 FLOAT,
  irload_wsd_3s2 FLOAT,
  irload_wsd_h FLOAT,
  irload_wsd_hs FLOAT,
  irload_wsd_t130 FLOAT,
  irload_wsd_t170 FLOAT,
  irload_lfd_3 FLOAT,
  irload_lfd_3_3 FLOAT,
  irload_lfd_3s2 FLOAT,
  irload_lfd_h FLOAT,
  irload_lfd_hs FLOAT,
  irload_lfd_t130 FLOAT,
  irload_lfd_t170 FLOAT,
  orload_adj_3 FLOAT,
  orload_adj_3_3 FLOAT,
  orload_adj_3s2 FLOAT,
  orload_adj_h FLOAT,
  orload_adj_hs FLOAT,
  orload_adj_t130 FLOAT,
  orload_adj_t170 FLOAT,
  orload_wsd_3 FLOAT,
  orload_wsd_3_3 FLOAT,
  orload_wsd_3s2 FLOAT,
  orload_wsd_h FLOAT,
  orload_wsd_hs FLOAT,
  orload_wsd_t130 FLOAT,
  orload_wsd_t170 FLOAT,
  orload_lfd_3 FLOAT,
  orload_lfd_3_3 FLOAT,
  orload_lfd_3s2 FLOAT,
  orload_lfd_h FLOAT,
  orload_lfd_hs FLOAT,
  orload_lfd_t130 FLOAT,
  orload_lfd_t170 FLOAT,
  orientation CHAR,
  posted_sign_type CHAR,
  posted_load_a FLOAT,
  posted_load_b FLOAT,
  posted_load_c FLOAT,
  restrict_load FLOAT,
  sign_type_q1 CHAR,
  sign_type_q2 CHAR,
  sign_type_q3 CHAR,
  sign_type_q4 CHAR,
  stream_sign CHAR,
  function_type VARCHAR2(3 BYTE),
  super_paint_sys VARCHAR2(2 BYTE),
  suprstruct_tos FLOAT,
  vert_clr_sign CHAR,
  vert_undr_sign CHAR,
  culv_wing_type VARCHAR2(2 BYTE),
  avg_hi NUMBER(5,1),
  kdot_latitude FLOAT,
  kdot_longitude FLOAT,
  paint_surf_area FLOAT,
  multi_drainage CHAR,
  reservoir_adj CHAR,
  env_notation_1 VARCHAR2(2 BYTE),
  env_notation_2 VARCHAR2(2 BYTE),
  wateropen FLOAT,
  design_method VARCHAR2(2 BYTE),
  undr_suff_fill CHAR,
  kta_no FLOAT,
  kta_id VARCHAR2(2 BYTE),
  kta_insp CHAR,
  irload_adj_hl93 FLOAT,
  irload_hl93 FLOAT,
  orload_adj_hl93 FLOAT,
  orload_hl93 FLOAT,
  abcdlist_a VARCHAR2(3 BYTE),
  abcdlist_a_notes VARCHAR2(2000 BYTE),
  abcdlist_b VARCHAR2(3 BYTE),
  abcdlist_b_notes VARCHAR2(2000 BYTE),
  abcdlist_c VARCHAR2(3 BYTE),
  abcdlist_c_notes VARCHAR2(2000 BYTE),
  abcdlist_d VARCHAR2(3 BYTE),
  abcdlist_d_notes VARCHAR2(2000 BYTE),
  replc_priority VARCHAR2(4 BYTE),
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE)
);