CREATE TABLE pontis.pon_app_roles (
  rolekey NUMBER(38) NOT NULL,
  rolename VARCHAR2(255 BYTE) NOT NULL,
  defaultflag NUMBER(38) DEFAULT 0 NOT NULL,
  status NUMBER(38) DEFAULT 1 NOT NULL,
  pontis_standard_ind CHAR DEFAULT 'F' NOT NULL,
  CONSTRAINT pon_app_roles_pk PRIMARY KEY (rolekey) DISABLE NOVALIDATE
);