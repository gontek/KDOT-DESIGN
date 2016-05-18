CREATE TABLE pontis.pon_filters (
  filterkey NUMBER(38) NOT NULL,
  "NAME" VARCHAR2(100 BYTE) NOT NULL,
  "CONTEXT" VARCHAR2(32 BYTE) DEFAULT 'inspection' NOT NULL,
  sql_filter VARCHAR2(2000 BYTE),
  filter_type NUMBER(38) DEFAULT -1 NOT NULL,
  userkey NUMBER(38),
  accessfilter NUMBER(38) DEFAULT 0,
  "SHARED" NUMBER(38) DEFAULT 0,
  notes VARCHAR2(2000 BYTE),
  where_clause VARCHAR2(2000 BYTE),
  edited_manually NUMBER(38) DEFAULT 1 NOT NULL,
  pontis_standard_ind CHAR DEFAULT 'F' NOT NULL,
  CONSTRAINT pon_filters_pk PRIMARY KEY (filterkey) DISABLE NOVALIDATE,
  CONSTRAINT fk_pon_filters_515_users FOREIGN KEY (userkey) REFERENCES pontis.pon_app_users (userkey) ON DELETE CASCADE DISABLE NOVALIDATE
);