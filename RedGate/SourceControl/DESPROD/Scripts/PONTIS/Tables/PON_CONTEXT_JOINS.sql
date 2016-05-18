CREATE TABLE pontis.pon_context_joins (
  join_id NUMBER(38) NOT NULL DISABLE,
  join_type VARCHAR2(12 BYTE) NOT NULL DISABLE,
  CONSTRAINT pon_context_joins_pk PRIMARY KEY (join_id) DISABLE NOVALIDATE
);