CREATE TABLE pontis.ui_obj_attr_classes (
  obj_class_id NUMBER(38) NOT NULL,
  attr_class_id NUMBER(38) NOT NULL,
  attr_class_name VARCHAR2(64 BYTE),
  CONSTRAINT ui_obj_attr_classes_pk PRIMARY KEY (obj_class_id,attr_class_id),
  CONSTRAINT ui_obj_classes3 FOREIGN KEY (obj_class_id) REFERENCES pontis.ui_obj_classes (obj_class_id) ON DELETE CASCADE
);