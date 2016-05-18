CREATE TABLE pontis.pon_context_tables (
  context_key NUMBER(38) NOT NULL DISABLE,
  "CONTEXT" VARCHAR2(32 BYTE) NOT NULL DISABLE,
  table_name VARCHAR2(32 BYTE),
  join_order NUMBER(38),
  join_id NUMBER(38),
  join_on VARCHAR2(2000 BYTE),
  CONSTRAINT pon_context_tables_pk PRIMARY KEY (context_key) DISABLE NOVALIDATE,
  CONSTRAINT fk_pon_ctext_tbl_ctext_joins FOREIGN KEY (join_id) REFERENCES pontis.pon_context_joins (join_id) DISABLE NOVALIDATE
);