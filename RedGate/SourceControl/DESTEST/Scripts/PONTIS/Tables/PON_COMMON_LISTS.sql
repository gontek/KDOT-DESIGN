CREATE TABLE pontis.pon_common_lists (
  listid VARCHAR2(32 BYTE) NOT NULL,
  "NAME" VARCHAR2(64 BYTE),
  sql_query VARCHAR2(2000 BYTE),
  "CONCAT" CHAR,
  CONSTRAINT pon_common_lists_pk PRIMARY KEY (listid) DISABLE NOVALIDATE
);