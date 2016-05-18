CREATE TABLE pontis.pon_assessment (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  asmtkey NUMBER(6) NOT NULL,
  asmtdefkey NUMBER(6) NOT NULL,
  asmtdate DATE NOT NULL,
  inspkey VARCHAR2(4 BYTE),
  workflow_status NUMBER(1),
  affected_deck_area NUMBER(6,2),
  affected_aadt NUMBER(6,2),
  hazard_class NUMBER(3),
  likelihood NUMBER(10,2),
  consequences NUMBER(10,2),
  "IMPACT" NUMBER(10,2),
  asmt_value NUMBER(10,2),
  next_asmt_date DATE,
  status NUMBER(38),
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  moduserkey VARCHAR2(4 BYTE),
  docrefkey VARCHAR2(255 BYTE),
  description VARCHAR2(255 BYTE),
  CONSTRAINT pon_assessment_pk PRIMARY KEY (brkey,asmtkey),
  CONSTRAINT fk_pon_assessment_bridge FOREIGN KEY (brkey) REFERENCES pontis.bridge (brkey),
  CONSTRAINT fk_pon_assessment_defs FOREIGN KEY (asmtdefkey) REFERENCES pontis.pon_defs_assessment (asmtdefkey) ON DELETE CASCADE
);