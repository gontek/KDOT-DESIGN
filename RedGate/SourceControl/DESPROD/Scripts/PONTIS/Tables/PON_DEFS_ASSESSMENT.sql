CREATE TABLE pontis.pon_defs_assessment (
  asmtdefkey NUMBER(6) NOT NULL,
  asmt_name VARCHAR2(30 BYTE) NOT NULL,
  asmt_label VARCHAR2(60 BYTE) NOT NULL,
  auto_gen_flag NUMBER(1),
  manual_entry_flag NUMBER(1),
  manual_check_flag NUMBER(1),
  months_interval NUMBER(3),
  flag_graphic_entry NUMBER(1),
  flag_likelihood NUMBER(1),
  integer_likelihood NUMBER(1),
  max_likelihood NUMBER(7,2),
  min_likelihood NUMBER(7,2),
  flag_consq NUMBER(1),
  integer_consq NUMBER(1),
  max_consq NUMBER(7,2),
  min_consq NUMBER(7,2),
  flag_impact NUMBER(1),
  integer_impact NUMBER(1),
  max_impact NUMBER(7,2),
  min_impact NUMBER(7,2),
  flag_value NUMBER(1),
  integer_value NUMBER(1),
  max_value NUMBER(7,2),
  min_value NUMBER(7,2),
  asmt_formula VARCHAR2(2000 BYTE),
  status NUMBER(38),
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  moduserkey VARCHAR2(4 BYTE),
  docrefkey VARCHAR2(255 BYTE),
  description VARCHAR2(255 BYTE),
  CONSTRAINT pon_defs_assessment_pk PRIMARY KEY (asmtdefkey)
);