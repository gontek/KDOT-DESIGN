CREATE TABLE pontis.pon_app_users_roles (
  userkey NUMBER(38) NOT NULL,
  rolekey NUMBER(38) NOT NULL,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT pon_app_users_roles_pk PRIMARY KEY (userkey,rolekey) DISABLE NOVALIDATE,
  CONSTRAINT fk_users_roles_606_users FOREIGN KEY (userkey) REFERENCES pontis.pon_app_users (userkey) ON DELETE CASCADE DISABLE NOVALIDATE,
  CONSTRAINT fk_users_roles_607_roles FOREIGN KEY (rolekey) REFERENCES pontis.pon_app_roles (rolekey) ON DELETE CASCADE DISABLE NOVALIDATE
);