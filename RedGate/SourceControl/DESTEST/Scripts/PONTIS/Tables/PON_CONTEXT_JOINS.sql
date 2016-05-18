CREATE TABLE pontis.pon_context_joins (
  join_id NUMBER(38) NOT NULL,
  join_type VARCHAR2(12 BYTE) NOT NULL,
  CONSTRAINT pon_context_joins_pk PRIMARY KEY (join_id) DISABLE NOVALIDATE
);