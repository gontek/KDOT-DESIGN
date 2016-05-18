CREATE TABLE pontis.pon_app_roles_tasks (
  rolekey NUMBER(38) NOT NULL,
  tabid NUMBER(38) NOT NULL,
  taskname VARCHAR2(32 BYTE) NOT NULL,
  granted NUMBER(38) NOT NULL,
  CONSTRAINT pon_app_roles_tasks_pk PRIMARY KEY (rolekey,tabid,taskname) DISABLE NOVALIDATE,
  CONSTRAINT fk_roles_tasks_511_roles FOREIGN KEY (rolekey) REFERENCES pontis.pon_app_roles (rolekey) ON DELETE CASCADE DISABLE NOVALIDATE
);