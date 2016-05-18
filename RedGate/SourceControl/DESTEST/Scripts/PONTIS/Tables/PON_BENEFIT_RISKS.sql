CREATE TABLE pontis.pon_benefit_risks (
  benefit_group_id NUMBER(38) NOT NULL,
  asmtdefkey NUMBER(6) NOT NULL,
  new_value VARCHAR2(255 BYTE),
  modifier VARCHAR2(255 BYTE),
  create_date VARCHAR2(32 BYTE),
  create_userkey VARCHAR2(4 BYTE),
  mod_date VARCHAR2(32 BYTE),
  mod_userkey VARCHAR2(4 BYTE),
  CONSTRAINT pon_benefit_risks_pk PRIMARY KEY (benefit_group_id,asmtdefkey),
  CONSTRAINT fk_pon_ben_risks_defs FOREIGN KEY (asmtdefkey) REFERENCES pontis.pon_defs_assessment (asmtdefkey),
  CONSTRAINT fk_pon_ben_risks_id FOREIGN KEY (benefit_group_id) REFERENCES pontis.pon_benefit_groups (benefit_group_id)
);