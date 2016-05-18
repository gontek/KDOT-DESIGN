CREATE TABLE pontis.pon_ctrl_elements_prn (
  element_id NUMBER(3) NOT NULL,
  element_nbi_field_id NUMBER(1) NOT NULL,
  element_material_id NUMBER(1) NOT NULL,
  element_type_id NUMBER(1) NOT NULL,
  element_dimension NUMBER(1) NOT NULL,
  element_name VARCHAR2(45 BYTE) NOT NULL,
  element_short_name VARCHAR2(9 BYTE) NOT NULL,
  CONSTRAINT pon_ctrl_elements_prn_pk PRIMARY KEY (element_id)
);