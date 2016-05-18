CREATE TABLE pontis.pon_batch_brkeys (
  pon_session_batch_key NUMBER(38) NOT NULL,
  brkey VARCHAR2(15 BYTE) NOT NULL,
  CONSTRAINT pon_batch_brkeys_pk PRIMARY KEY (pon_session_batch_key,brkey),
  CONSTRAINT fk_pon_batch_504_session_batch FOREIGN KEY (pon_session_batch_key) REFERENCES pontis.pon_session_batch (pon_session_batch_key) ON DELETE CASCADE
);