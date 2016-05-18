CREATE TABLE pontis.pon_formula_params (
  formula_id NUMBER(38) NOT NULL,
  parameter_seq NUMBER(38) NOT NULL,
  parameter_name VARCHAR2(100 BYTE) NOT NULL,
  table_name VARCHAR2(32 BYTE),
  col_name VARCHAR2(32 BYTE),
  data_type VARCHAR2(32 BYTE),
  def_value NUMBER(18,10),
  create_date VARCHAR2(32 BYTE),
  create_userkey VARCHAR2(4 BYTE),
  mod_date VARCHAR2(32 BYTE),
  mod_userkey VARCHAR2(4 BYTE),
  CONSTRAINT pon_formula_params_pk PRIMARY KEY (formula_id,parameter_seq)
);