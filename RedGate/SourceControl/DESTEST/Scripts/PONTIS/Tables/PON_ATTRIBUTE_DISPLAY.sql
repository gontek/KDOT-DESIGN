CREATE TABLE pontis.pon_attribute_display (
  context_name VARCHAR2(16 BYTE) NOT NULL,
  tab_name VARCHAR2(32 BYTE) NOT NULL,
  table_name VARCHAR2(64 BYTE) NOT NULL,
  col_name VARCHAR2(64 BYTE) NOT NULL,
  ord_num NUMBER(5) NOT NULL,
  prompt_text VARCHAR2(64 BYTE) NOT NULL,
  m2e_coeff FLOAT,
  fmt VARCHAR2(16 BYTE),
  lookup_expression VARCHAR2(64 BYTE),
  tab_order NUMBER(30,6),
  CONSTRAINT pon_attribute_display_pk PRIMARY KEY (context_name,tab_name,table_name,col_name) DISABLE NOVALIDATE
);