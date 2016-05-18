CREATE TABLE pontis.pon_app_control_security (
  rolekey NUMBER(38) NOT NULL,
  tab_id NUMBER(38) NOT NULL,
  task_id NUMBER(38) NOT NULL,
  control_group_id NUMBER(38) NOT NULL,
  control_id NUMBER(38) NOT NULL,
  visible_ind CHAR NOT NULL,
  read_only_ind CHAR NOT NULL,
  mobile_visible_ind CHAR NOT NULL,
  mobile_read_only_ind CHAR NOT NULL,
  CONSTRAINT pon_app_control_security_pk PRIMARY KEY (rolekey,tab_id,task_id,control_group_id,control_id) DISABLE NOVALIDATE,
  CONSTRAINT fk_ctrl_sec_to_nav_control FOREIGN KEY (tab_id,task_id,control_group_id,control_id) REFERENCES pontis.pon_nav_control (tab_id,task_id,control_group_id,control_id) DISABLE NOVALIDATE,
  CONSTRAINT fk_ctrl_sec_to_roles FOREIGN KEY (rolekey) REFERENCES pontis.pon_app_roles (rolekey) DISABLE NOVALIDATE
);