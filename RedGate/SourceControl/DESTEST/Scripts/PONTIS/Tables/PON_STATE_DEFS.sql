CREATE TABLE pontis.pon_state_defs (
  elem_key NUMBER(4) NOT NULL,
  elem_state_key NUMBER(1) NOT NULL,
  elem_state_name_short VARCHAR2(32 BYTE) NOT NULL,
  elem_state_desc VARCHAR2(2000 BYTE) NOT NULL,
  elem_createdatetime DATE DEFAULT SYSDATE,
  elem_createuserkey VARCHAR2(4 BYTE),
  elem_modtime DATE DEFAULT SYSDATE,
  elem_moduserkey VARCHAR2(4 BYTE),
  elem_docrefkey VARCHAR2(255 BYTE),
  CONSTRAINT pon_state_defs_pk PRIMARY KEY (elem_key,elem_state_key),
  CONSTRAINT fk_pon_state_defs_elemdefs FOREIGN KEY (elem_key) REFERENCES pontis.pon_elem_defs (elem_key) ON DELETE CASCADE DISABLE NOVALIDATE
);