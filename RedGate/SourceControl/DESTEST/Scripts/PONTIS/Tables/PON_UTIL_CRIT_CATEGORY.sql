CREATE TABLE pontis.pon_util_crit_category (
  catkey NUMBER(6) NOT NULL,
  catname VARCHAR2(50 BYTE) NOT NULL,
  criteriontype NUMBER(3) DEFAULT 1 NOT NULL,
  min_x NUMBER(6),
  max_x NUMBER(6),
  table_col VARCHAR2(50 BYTE),
  catkey_parent NUMBER(6),
  weight NUMBER(6,2),
  asmtdefkey NUMBER(3),
  elemkey NUMBER(4),
  formula_id NUMBER(38),
  default_collapsed CHAR,
  elem_group VARCHAR2(20 BYTE),
  CONSTRAINT pon_util_crit_category_pk PRIMARY KEY (catkey)
);