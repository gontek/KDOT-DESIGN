CREATE TABLE pontis.pon_app_roles_permissions (
  rolekey NUMBER(38) NOT NULL,
  permissionkey NUMBER(38) NOT NULL,
  granted NUMBER(38) NOT NULL,
  CONSTRAINT pon_app_roles_permissions_pk PRIMARY KEY (rolekey,permissionkey) DISABLE NOVALIDATE,
  CONSTRAINT fk_roles_perms_513_roles FOREIGN KEY (rolekey) REFERENCES pontis.pon_app_roles (rolekey) ON DELETE CASCADE DISABLE NOVALIDATE,
  CONSTRAINT fk_roles_perms_514_perms FOREIGN KEY (permissionkey) REFERENCES pontis.pon_app_permissions (permissionkey) ON DELETE CASCADE DISABLE NOVALIDATE
);