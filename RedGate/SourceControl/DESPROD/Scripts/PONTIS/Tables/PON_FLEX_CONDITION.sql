CREATE TABLE pontis.pon_flex_condition (
  flexkey VARCHAR2(8 BYTE) NOT NULL,
  elemkey NUMBER(4) NOT NULL,
  skey1 NUMBER(1),
  skey2 NUMBER(1),
  skey3 NUMBER(1),
  skey4 NUMBER(1),
  akey1 NUMBER(1),
  akey2 NUMBER(1),
  akey3 NUMBER(1),
  akey4 NUMBER(1),
  warrant_formula VARCHAR2(2000 BYTE),
  effect_formula VARCHAR2(2000 BYTE),
  CONSTRAINT pon_flex_condition_pk PRIMARY KEY (flexkey,elemkey),
  CONSTRAINT fk_pon_flex_con_key1 FOREIGN KEY (elemkey,skey1,akey1) REFERENCES pontis.pon_mrr_action_defs (elem_key,elem_state_key,elem_action_key),
  CONSTRAINT fk_pon_flex_con_key2 FOREIGN KEY (elemkey,skey2,akey2) REFERENCES pontis.pon_mrr_action_defs (elem_key,elem_state_key,elem_action_key),
  CONSTRAINT fk_pon_flex_con_key3 FOREIGN KEY (elemkey,skey3,akey3) REFERENCES pontis.pon_mrr_action_defs (elem_key,elem_state_key,elem_action_key),
  CONSTRAINT fk_pon_flex_con_key4 FOREIGN KEY (elemkey,skey4,akey4) REFERENCES pontis.pon_mrr_action_defs (elem_key,elem_state_key,elem_action_key)
);