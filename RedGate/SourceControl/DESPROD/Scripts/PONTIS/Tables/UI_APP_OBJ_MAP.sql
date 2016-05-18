CREATE TABLE pontis.ui_app_obj_map (
  obj_inst_id NUMBER(38) NOT NULL,
  obj_inst_name VARCHAR2(255 BYTE),
  parent_obj_inst_id NUMBER(38),
  parent_obj_inst_name VARCHAR2(255 BYTE),
  obj_class_id NUMBER(38),
  app_id VARCHAR2(64 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT ui_app_obj_map_pk PRIMARY KEY (obj_inst_id),
  CONSTRAINT ui_obj_classes2 FOREIGN KEY (obj_class_id) REFERENCES pontis.ui_obj_classes (obj_class_id) ON DELETE CASCADE
);