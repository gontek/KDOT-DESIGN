CREATE TABLE pontis.pon_context (
  context_id NUMBER(38) NOT NULL DISABLE,
  "CONTEXT" VARCHAR2(32 BYTE) NOT NULL DISABLE,
  context_key VARCHAR2(2000 BYTE),
  default_filterkey NUMBER(38),
  default_layoutkey NUMBER(38),
  context_type VARCHAR2(32 BYTE),
  display_name VARCHAR2(32 BYTE),
  context_orderby VARCHAR2(32 BYTE),
  CONSTRAINT pon_context_pk PRIMARY KEY (context_id) DISABLE NOVALIDATE
);