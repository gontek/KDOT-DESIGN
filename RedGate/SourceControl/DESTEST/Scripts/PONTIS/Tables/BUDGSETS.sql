CREATE TABLE pontis.budgsets (
  bukey VARCHAR2(2 BYTE) NOT NULL,
  buname VARCHAR2(20 BYTE),
  budate DATE,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT budgsets_pk PRIMARY KEY (bukey)
);
COMMENT ON COLUMN pontis.budgsets.bukey IS 'Budget matrix key';
COMMENT ON COLUMN pontis.budgsets.buname IS 'User s short name of the matrix';
COMMENT ON COLUMN pontis.budgsets.budate IS 'Date and time when the set was last updated';
COMMENT ON COLUMN pontis.budgsets.notes IS 'Entry comments';