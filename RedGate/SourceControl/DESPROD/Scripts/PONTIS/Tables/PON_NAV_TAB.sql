CREATE TABLE pontis.pon_nav_tab (
  tab_id NUMBER(38) NOT NULL,
  "NAME" VARCHAR2(32 BYTE) NOT NULL,
  label_caption_id NUMBER(38) NOT NULL,
  order_num NUMBER(38) NOT NULL,
  enabled_ind CHAR NOT NULL,
  visible_ind CHAR NOT NULL,
  read_only_ind CHAR NOT NULL,
  navigate_url VARCHAR2(256 BYTE),
  image_url VARCHAR2(256 BYTE),
  skin_id VARCHAR2(64 BYTE),
  css_class VARCHAR2(64 BYTE),
  tooltip_caption_id NUMBER(38),
  pontis_standard_ind CHAR,
  CONSTRAINT pon_nav_tab_pk PRIMARY KEY (tab_id) DISABLE NOVALIDATE,
  CONSTRAINT fk_nav_tab_to_caption FOREIGN KEY (label_caption_id) REFERENCES pontis.pon_app_caption (caption_id) DISABLE NOVALIDATE,
  CONSTRAINT fk_nav_tab_to_caption_two FOREIGN KEY (tooltip_caption_id) REFERENCES pontis.pon_app_caption (caption_id) DISABLE NOVALIDATE
);