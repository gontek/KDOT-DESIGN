CREATE TABLE pontis.pon_formulas (
  formula_id NUMBER(38) NOT NULL,
  formula_name VARCHAR2(32 BYTE) NOT NULL,
  formula_string VARCHAR2(2000 BYTE),
  description VARCHAR2(2000 BYTE),
  create_date VARCHAR2(32 BYTE),
  create_userkey VARCHAR2(4 BYTE),
  mod_date VARCHAR2(32 BYTE),
  mod_userkey VARCHAR2(4 BYTE),
  CONSTRAINT pon_formulas_pk PRIMARY KEY (formula_id)
);