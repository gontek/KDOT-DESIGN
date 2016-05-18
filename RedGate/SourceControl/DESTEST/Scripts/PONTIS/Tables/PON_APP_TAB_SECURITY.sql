CREATE TABLE pontis.pon_app_tab_security (
  rolekey NUMBER(38) NOT NULL,
  tab_id NUMBER(38) NOT NULL,
  visible_ind CHAR NOT NULL,
  read_only_ind CHAR NOT NULL,
  mobile_visible_ind CHAR NOT NULL,
  mobile_read_only_ind CHAR NOT NULL,
  CONSTRAINT pon_app_tab_security_pk PRIMARY KEY (rolekey,tab_id) DISABLE NOVALIDATE,
  CONSTRAINT fk_tab_sec_to_app_roles FOREIGN KEY (rolekey) REFERENCES pontis.pon_app_roles (rolekey) DISABLE NOVALIDATE,
  CONSTRAINT fk_tab_sec_to_nav_tab FOREIGN KEY (tab_id) REFERENCES pontis.pon_nav_tab (tab_id) DISABLE NOVALIDATE
);