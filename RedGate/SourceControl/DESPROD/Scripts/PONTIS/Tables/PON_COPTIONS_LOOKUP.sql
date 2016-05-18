CREATE TABLE pontis.pon_coptions_lookup (
  copt_key NUMBER(38) NOT NULL,
  copt_name VARCHAR2(50 BYTE),
  table_name VARCHAR2(50 BYTE),
  field_name VARCHAR2(50 BYTE),
  CONSTRAINT pon_coptions_lookup_pk PRIMARY KEY (copt_key)
);