CREATE TABLE pontis.pon_app_roles_tabs (
  rolekey NUMBER(38) NOT NULL,
  tabid NUMBER(38) NOT NULL,
  tabname VARCHAR2(32 BYTE) NOT NULL,
  granted NUMBER(38) DEFAULT 0 NOT NULL,
  CONSTRAINT pon_app_roles_tabs_pk PRIMARY KEY (rolekey,tabid) DISABLE NOVALIDATE,
  CONSTRAINT fk_roles_tabs_510_roles FOREIGN KEY (rolekey) REFERENCES pontis.pon_app_roles (rolekey) ON DELETE CASCADE DISABLE NOVALIDATE
);