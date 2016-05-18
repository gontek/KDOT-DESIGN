CREATE TABLE pontis.pon_session (
  pon_session_key NUMBER(38) NOT NULL,
  userkey NUMBER(38) NOT NULL,
  db_session NUMBER(38) NOT NULL,
  started_on DATE DEFAULT SYSDATE NOT NULL,
  ended_on DATE,
  CONSTRAINT pon_session_pk PRIMARY KEY (pon_session_key),
  CONSTRAINT fk_session_508_pon_users FOREIGN KEY (userkey) REFERENCES pontis.pon_app_users (userkey) ON DELETE CASCADE DISABLE NOVALIDATE
);