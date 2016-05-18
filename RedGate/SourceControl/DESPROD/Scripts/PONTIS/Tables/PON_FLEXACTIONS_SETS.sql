CREATE TABLE pontis.pon_flexactions_sets (
  flex_action_key VARCHAR2(8 BYTE) NOT NULL,
  flex_parent_act_key NUMBER(8) DEFAULT 0,
  flex_act_name_short VARCHAR2(32 BYTE),
  flex_act_name_desc VARCHAR2(255 BYTE),
  flex_createdatetime DATE DEFAULT SYSDATE,
  flex_createuserkey NUMBER(38),
  flex_modtime DATE DEFAULT SYSDATE,
  flex_moduserkey NUMBER(38),
  flex_notes VARCHAR2(2000 BYTE),
  flex_sortorder NUMBER(8),
  CONSTRAINT pon_flexactions_sets_pk PRIMARY KEY (flex_action_key)
);