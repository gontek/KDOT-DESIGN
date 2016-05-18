CREATE TABLE pontis.costsets (
  cokey VARCHAR2(2 BYTE) NOT NULL,
  coname VARCHAR2(20 BYTE),
  codate DATE,
  cocostix NUMBER(6,2),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT costsets_pk PRIMARY KEY (cokey)
);
COMMENT ON COLUMN pontis.costsets.cokey IS 'Cost matrix key';
COMMENT ON COLUMN pontis.costsets.coname IS 'User s short name of the cost matrix';
COMMENT ON COLUMN pontis.costsets.codate IS 'Date and time when the set was last updated';
COMMENT ON COLUMN pontis.costsets.cocostix IS 'Cost index for inflation adjustments';
COMMENT ON COLUMN pontis.costsets.notes IS 'Entry comments';