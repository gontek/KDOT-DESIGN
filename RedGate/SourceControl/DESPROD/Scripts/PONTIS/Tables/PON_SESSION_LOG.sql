CREATE TABLE pontis.pon_session_log (
  pon_session_log_key NUMBER(38) NOT NULL,
  pon_session_key NUMBER(38) NOT NULL,
  logged_on DATE NOT NULL,
  logged_record VARCHAR2(2000 BYTE),
  CONSTRAINT pon_session_log_pk PRIMARY KEY (pon_session_log_key),
  CONSTRAINT fk_session_log_507_session FOREIGN KEY (pon_session_key) REFERENCES pontis.pon_session (pon_session_key) ON DELETE CASCADE
);