CREATE TABLE pontis.pon_app_users_groups (
  userkey NUMBER(38) NOT NULL,
  groupkey NUMBER(38) NOT NULL,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT pon_app_users_groups_pk PRIMARY KEY (userkey,groupkey) DISABLE NOVALIDATE,
  CONSTRAINT fk_users_groups_602_users FOREIGN KEY (userkey) REFERENCES pontis.pon_app_users (userkey) ON DELETE CASCADE DISABLE NOVALIDATE,
  CONSTRAINT fk_users_groups_603_users FOREIGN KEY (groupkey) REFERENCES pontis.pon_app_groups (groupkey) ON DELETE CASCADE DISABLE NOVALIDATE
);