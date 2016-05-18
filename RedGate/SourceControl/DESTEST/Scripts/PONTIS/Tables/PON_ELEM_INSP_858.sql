CREATE TABLE pontis.pon_elem_insp_858 (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  inspkey VARCHAR2(4 BYTE) NOT NULL,
  elem_key CHAR(3 BYTE),
  elem_parent_key CHAR,
  envkey CHAR,
  strunitkey NUMBER(4) NOT NULL,
  elem_grandparent_key NUMBER(4) NOT NULL,
  elem_quantity NUMBER,
  elem_pctstate1 FLOAT NOT NULL,
  elem_pctstate2 FLOAT NOT NULL,
  elem_pctstate3 FLOAT NOT NULL,
  elem_pctstate4 FLOAT NOT NULL,
  elem_qtystate1 FLOAT NOT NULL,
  elem_qtystate2 FLOAT NOT NULL,
  elem_qtystate3 FLOAT NOT NULL,
  elem_qtystate4 FLOAT NOT NULL,
  elem_scale_factor FLOAT,
  elem_desc VARCHAR2(255 BYTE),
  elem_createdatetime DATE,
  elem_createuserkey VARCHAR2(4 BYTE),
  elem_modtime DATE,
  elem_moduserkey VARCHAR2(4 BYTE),
  elem_docrefkey VARCHAR2(255 BYTE),
  elem_notes VARCHAR2(2000 BYTE)
);