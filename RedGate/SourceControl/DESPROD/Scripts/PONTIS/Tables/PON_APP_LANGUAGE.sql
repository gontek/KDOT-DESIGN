CREATE TABLE pontis.pon_app_language (
  language_id NUMBER(38) NOT NULL,
  language_name VARCHAR2(32 BYTE),
  left_to_right_read_ind CHAR DEFAULT 'T' NOT NULL,
  CONSTRAINT pon_app_language_pk PRIMARY KEY (language_id) DISABLE NOVALIDATE
);