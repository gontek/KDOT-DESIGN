CREATE TABLE pontis.ui_obj_classes (
  obj_class_id NUMBER(38) NOT NULL,
  obj_class_name VARCHAR2(64 BYTE),
  language_id NUMBER(38),
  CONSTRAINT ui_obj_classes_pk PRIMARY KEY (obj_class_id)
);