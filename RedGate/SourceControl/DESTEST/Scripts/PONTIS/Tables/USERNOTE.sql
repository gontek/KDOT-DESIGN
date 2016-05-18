CREATE TABLE pontis.usernote (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  note_date DATE NOT NULL,
  note_typ CHAR(3 BYTE) NOT NULL CHECK (note_typ IN ('DEC', 'SUP', 'CUL', 'SUB', 'CHN', 'DRN', 'APR', 'POS', 'SAF', 'REC', 'SPC', 'CHG')),
  note_text VARCHAR2(4000 BYTE),
  CONSTRAINT pk_usernote PRIMARY KEY (brkey,note_date,note_typ),
  CONSTRAINT fk_usernote_14_bridge FOREIGN KEY (brkey) REFERENCES pontis.bridge (brkey) ON DELETE CASCADE DISABLE NOVALIDATE
);