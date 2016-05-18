CREATE TABLE pontis.pon_elem_defs (
  elem_key NUMBER(4) NOT NULL,
  elem_nbe_stat CHAR NOT NULL,
  elem_protect_sys CHAR NOT NULL,
  elem_smart_flag CHAR NOT NULL,
  elem_cat_key CHAR NOT NULL,
  elem_type_key VARCHAR2(2 BYTE) NOT NULL,
  elem_mat_key CHAR NOT NULL,
  elem_paircode NUMBER(2) NOT NULL,
  elem_model CHAR DEFAULT 'Y',
  elem_shortname VARCHAR2(32 BYTE),
  elem_longname VARCHAR2(64 BYTE),
  elem_scaleshort VARCHAR2(10 BYTE),
  elem_scaleunit VARCHAR2(10 BYTE),
  elem_weight NUMBER(4),
  elem_createdatetime DATE DEFAULT SYSDATE,
  elem_createuserkey VARCHAR2(4 BYTE),
  elem_modtime DATE DEFAULT SYSDATE,
  elem_moduserkey VARCHAR2(4 BYTE),
  elem_docrefkey VARCHAR2(255 BYTE),
  elem_notes VARCHAR2(2000 BYTE),
  elem_subset_key NUMBER(4),
  elem_rel_weight NUMBER(9),
  fhwa_reported CHAR,
  CONSTRAINT pon_elem_defs_pk PRIMARY KEY (elem_key) DISABLE NOVALIDATE,
  CONSTRAINT fk_pon_elem_defs_eltypdfs FOREIGN KEY (elem_cat_key,elem_type_key) REFERENCES pontis.eltypdfs (ecatkey,etypkey) ON DELETE CASCADE DISABLE NOVALIDATE,
  CONSTRAINT fk_pon_elem_defs_matdefs FOREIGN KEY (elem_mat_key) REFERENCES pontis.matdefs (matlkey) ON DELETE CASCADE DISABLE NOVALIDATE
);