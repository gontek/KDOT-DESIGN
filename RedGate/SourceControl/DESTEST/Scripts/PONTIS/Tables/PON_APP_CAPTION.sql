CREATE TABLE pontis.pon_app_caption (
  caption_id NUMBER(38) NOT NULL,
  default_caption VARCHAR2(2000 BYTE) NOT NULL,
  caption_keyword VARCHAR2(32 BYTE),
  pontis_standard_ind CHAR,
  CONSTRAINT pon_app_caption_pk PRIMARY KEY (caption_id) DISABLE NOVALIDATE
);