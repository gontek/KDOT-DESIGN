CREATE TABLE pontis.ui_obj_attr_values (
  app_locale_id VARCHAR2(8 BYTE) NOT NULL,
  obj_inst_id NUMBER(38) NOT NULL,
  obj_class_id NUMBER(38) NOT NULL,
  attr_class_id NUMBER(38) NOT NULL,
  dw_attr_cls_name VARCHAR2(64 BYTE) NOT NULL,
  dw_attr_seq NUMBER(38) NOT NULL,
  attr_inst_val VARCHAR2(512 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  CONSTRAINT ui_obj_attr_values_pk PRIMARY KEY (app_locale_id,obj_inst_id,obj_class_id,attr_class_id,dw_attr_cls_name,dw_attr_seq),
  CONSTRAINT ui_app_obj_map FOREIGN KEY (obj_inst_id) REFERENCES pontis.ui_app_obj_map (obj_inst_id),
  CONSTRAINT ui_obj_attr_classes FOREIGN KEY (obj_class_id,attr_class_id) REFERENCES pontis.ui_obj_attr_classes (obj_class_id,attr_class_id)
);