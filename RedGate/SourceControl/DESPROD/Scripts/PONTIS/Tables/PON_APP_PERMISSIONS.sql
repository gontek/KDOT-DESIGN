CREATE TABLE pontis.pon_app_permissions (
  permissionkey NUMBER(38) NOT NULL,
  permissionname VARCHAR2(255 BYTE) NOT NULL,
  defaultvalue NUMBER(38) DEFAULT 0 NOT NULL,
  "CONTEXT" VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT pon_app_permissions_pk PRIMARY KEY (permissionkey) DISABLE NOVALIDATE
);