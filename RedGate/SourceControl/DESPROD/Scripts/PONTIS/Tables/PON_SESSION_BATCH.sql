CREATE TABLE pontis.pon_session_batch (
  pon_session_batch_key NUMBER(38) NOT NULL,
  pon_session_key NUMBER(38) NOT NULL,
  "CONTEXT" VARCHAR2(32 BYTE) DEFAULT 'PONTIS' NOT NULL,
  batch_descr VARCHAR2(256 BYTE) NOT NULL,
  started_on DATE DEFAULT SYSDATE NOT NULL,
  ended_on DATE,
  CONSTRAINT pon_session_batch_pk PRIMARY KEY (pon_session_batch_key),
  CONSTRAINT fk_sess_batch_509_session FOREIGN KEY (pon_session_key) REFERENCES pontis.pon_session (pon_session_key) ON DELETE CASCADE
);