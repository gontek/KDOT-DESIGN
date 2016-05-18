CREATE TABLE pontis.pon_nav_control_group (
  tab_id NUMBER(38) NOT NULL,
  task_id NUMBER(38) NOT NULL,
  control_group_id NUMBER(38) NOT NULL,
  "NAME" VARCHAR2(32 BYTE) NOT NULL,
  parent_control_group_id NUMBER(38),
  caption_id NUMBER(38),
  order_num NUMBER(38) NOT NULL,
  control_group_type VARCHAR2(32 BYTE),
  visible_ind CHAR NOT NULL,
  read_only_ind CHAR NOT NULL,
  repeat_columns NUMBER(38),
  repeat_direction VARCHAR2(32 BYTE),
  repeat_layout VARCHAR2(32 BYTE),
  horizontal_alignment VARCHAR2(32 BYTE),
  vertical_alignment VARCHAR2(32 BYTE),
  skin_id VARCHAR2(64 BYTE),
  css_class VARCHAR2(64 BYTE),
  height VARCHAR2(16 BYTE),
  width VARCHAR2(16 BYTE),
  scroll_bars_ind CHAR,
  cell_padding NUMBER(38),
  cell_spacing NUMBER(38),
  span_across_ind CHAR,
  group_gui_resource_id VARCHAR2(256 BYTE),
  desktop_url VARCHAR2(256 BYTE),
  pontis_standard_ind CHAR,
  CONSTRAINT pon_nav_control_group_pk PRIMARY KEY (tab_id,task_id,control_group_id) DISABLE NOVALIDATE,
  CONSTRAINT fk_nav_ctrlgrp_recursive FOREIGN KEY (tab_id,task_id,parent_control_group_id) REFERENCES pontis.pon_nav_control_group (tab_id,task_id,control_group_id) DISABLE NOVALIDATE,
  CONSTRAINT fk_nav_ctrlgrp_to_caption FOREIGN KEY (caption_id) REFERENCES pontis.pon_app_caption (caption_id) DISABLE NOVALIDATE,
  CONSTRAINT fk_nav_ctrlgrp_to_nav_task FOREIGN KEY (tab_id,task_id) REFERENCES pontis.pon_nav_task (tab_id,task_id) DISABLE NOVALIDATE
);