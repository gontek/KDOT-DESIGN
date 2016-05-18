CREATE TABLE pontis.pon_layouts_fields (
  layoutkey NUMBER(38) NOT NULL,
  table_name VARCHAR2(50 BYTE) NOT NULL,
  field_name VARCHAR2(50 BYTE) NOT NULL,
  display_order NUMBER(38),
  header_text VARCHAR2(50 BYTE),
  use_parms VARCHAR2(5 BYTE) DEFAULT 'F' NOT NULL,
  CONSTRAINT pon_layouts_fields_pk PRIMARY KEY (layoutkey,table_name,field_name) DISABLE NOVALIDATE
);