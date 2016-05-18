CREATE TABLE pontis.statedfs (
  elemkey NUMBER(3) NOT NULL,
  skey NUMBER(1) NOT NULL,
  statenum NUMBER(1) NOT NULL,
  stateshort VARCHAR2(20 BYTE) NOT NULL,
  statedesc VARCHAR2(2000 BYTE) NOT NULL,
  CONSTRAINT statedfs_pk PRIMARY KEY (elemkey,skey),
  CONSTRAINT fk_statedfs_23_elemdefs FOREIGN KEY (elemkey) REFERENCES pontis.elemdefs (elemkey)
);
COMMENT ON COLUMN pontis.statedfs.elemkey IS 'Element key';
COMMENT ON COLUMN pontis.statedfs.skey IS 'Condition state key';
COMMENT ON COLUMN pontis.statedfs.statenum IS 'Condition state number';
COMMENT ON COLUMN pontis.statedfs.stateshort IS 'Condition state short name';
COMMENT ON COLUMN pontis.statedfs.statedesc IS 'Condition state description';