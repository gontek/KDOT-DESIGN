CREATE TABLE pontis.pon_benefit_elements (
  benefit_group_id NUMBER(38) NOT NULL,
  elem_key NUMBER(4) NOT NULL,
  origin_state VARCHAR2(4 BYTE) NOT NULL,
  cs1 FLOAT(53),
  cs2 FLOAT(53),
  cs3 FLOAT(53),
  cs4 FLOAT(53),
  create_date VARCHAR2(32 BYTE),
  create_userkey VARCHAR2(4 BYTE),
  mod_date VARCHAR2(32 BYTE),
  mod_userkey VARCHAR2(4 BYTE),
  elem_parent_key NUMBER(4) DEFAULT 0 NOT NULL,
  elem_grandparent_key NUMBER(4) DEFAULT 0 NOT NULL,
  CONSTRAINT pon_benefit_elements_pk PRIMARY KEY (benefit_group_id,elem_key,origin_state,elem_parent_key,elem_grandparent_key),
  CONSTRAINT fk_pon_ben_elems_id FOREIGN KEY (benefit_group_id) REFERENCES pontis.pon_benefit_groups (benefit_group_id)
);