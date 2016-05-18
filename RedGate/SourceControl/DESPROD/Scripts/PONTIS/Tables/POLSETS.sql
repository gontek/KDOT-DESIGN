CREATE TABLE pontis.polsets (
  pokey VARCHAR2(2 BYTE) NOT NULL,
  poname VARCHAR2(20 BYTE),
  podate DATE,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT polsets_pk PRIMARY KEY (pokey)
);
COMMENT ON COLUMN pontis.polsets.pokey IS 'Policy matrix key';
COMMENT ON COLUMN pontis.polsets.poname IS 'Users short name of the policy matrix';
COMMENT ON COLUMN pontis.polsets.podate IS 'Date and time when the set was last updated';
COMMENT ON COLUMN pontis.polsets.notes IS 'Entry comments';