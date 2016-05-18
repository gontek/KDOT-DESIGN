CREATE TABLE pontis.pon_mrr_action_defs (
  elem_key NUMBER(4) NOT NULL,
  elem_state_key NUMBER(1) NOT NULL,
  elem_action_key NUMBER(1) NOT NULL,
  elem_type_key VARCHAR2(2 BYTE),
  elem_action_desc_short VARCHAR2(16 BYTE),
  elem_action_desc_long VARCHAR2(96 BYTE),
  elem_whole_bridge_act CHAR NOT NULL,
  elem_createdatetime DATE DEFAULT SYSDATE,
  elem_createuserkey VARCHAR2(4 BYTE),
  elem_modtime DATE DEFAULT SYSDATE,
  elem_moduserkey VARCHAR2(4 BYTE),
  elem_notes VARCHAR2(2000 BYTE),
  CONSTRAINT pon_mrr_action_defs_pk PRIMARY KEY (elem_key,elem_state_key,elem_action_key),
  CONSTRAINT fk_pon_mrr_act_defs_actypdfs FOREIGN KEY (elem_type_key) REFERENCES pontis.actypdfs (tkey),
  CONSTRAINT fk_pon_mrr_act_defs_statedfs FOREIGN KEY (elem_key,elem_state_key) REFERENCES pontis.pon_state_defs (elem_key,elem_state_key) ON DELETE CASCADE
);