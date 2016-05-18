CREATE TABLE pontis.pon_app_control_security_t (
  rolekey NUMBER(38) NOT NULL,
  tab_id NUMBER(38) NOT NULL,
  task_id NUMBER(38) NOT NULL,
  control_group_id NUMBER(38) NOT NULL,
  control_id NUMBER(38) NOT NULL,
  visible_ind CHAR NOT NULL,
  read_only_ind CHAR NOT NULL,
  mobile_visible_ind CHAR NOT NULL,
  mobile_read_only_ind CHAR NOT NULL
);