CREATE TABLE pontis.pon_benefit_fields (
  benefit_group_id NUMBER(38) NOT NULL,
  table_name VARCHAR2(255 BYTE) NOT NULL,
  col_name VARCHAR2(255 BYTE) NOT NULL,
  new_value VARCHAR2(255 BYTE),
  modifier VARCHAR2(255 BYTE),
  create_date VARCHAR2(32 BYTE),
  create_userkey VARCHAR2(4 BYTE),
  mod_date VARCHAR2(32 BYTE),
  mod_userkey VARCHAR2(4 BYTE),
  CONSTRAINT pon_benefit_fields_pk PRIMARY KEY (benefit_group_id,table_name,col_name),
  CONSTRAINT fk_pon_ben_fields_id FOREIGN KEY (benefit_group_id) REFERENCES pontis.pon_benefit_groups (benefit_group_id)
);