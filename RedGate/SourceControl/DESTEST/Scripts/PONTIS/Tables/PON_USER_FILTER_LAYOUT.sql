CREATE TABLE pontis.pon_user_filter_layout (
  userkey VARCHAR2(4 BYTE) NOT NULL,
  "CONTEXT" VARCHAR2(32 BYTE) NOT NULL,
  filterkey NUMBER(38) NOT NULL DISABLE,
  layoutkey NUMBER(38) NOT NULL DISABLE,
  CONSTRAINT pon_user_filter_layout_pk PRIMARY KEY (userkey,"CONTEXT") DISABLE NOVALIDATE
);