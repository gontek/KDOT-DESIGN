CREATE TABLE pontis.pon_app_groups (
  groupkey NUMBER(38) NOT NULL,
  groupname VARCHAR2(64 BYTE) NOT NULL,
  status NUMBER(38) DEFAULT 1 NOT NULL,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT pon_app_groups_pk PRIMARY KEY (groupkey) DISABLE NOVALIDATE
);