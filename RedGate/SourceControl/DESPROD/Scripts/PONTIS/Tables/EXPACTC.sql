CREATE TABLE pontis.expactc (
  userkey VARCHAR2(4 BYTE) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  skey NUMBER(1) NOT NULL,
  akey NUMBER(1) NOT NULL,
  unitcost FLOAT,
  CONSTRAINT expactc_pk PRIMARY KEY (userkey,elemkey,envkey,skey,akey),
  CONSTRAINT fk_expactc_35_expcnduc FOREIGN KEY (userkey,elemkey,envkey) REFERENCES pontis.expcnduc (userkey,elemkey,envkey) ON DELETE CASCADE,
  CONSTRAINT fk_expactc_51_mrractdf FOREIGN KEY (elemkey,skey,akey) REFERENCES pontis.mrractdf (elemkey,skey,akey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.expactc.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.expactc.elemkey IS 'Element key';
COMMENT ON COLUMN pontis.expactc.envkey IS 'Environment key';
COMMENT ON COLUMN pontis.expactc.skey IS 'Condition state key';
COMMENT ON COLUMN pontis.expactc.akey IS 'Action key';
COMMENT ON COLUMN pontis.expactc.unitcost IS 'Unit cost';