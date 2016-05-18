CREATE TABLE pontis.tmp_witems (
  witemkey VARCHAR2(30 BYTE) NOT NULL,
  brkey VARCHAR2(15 BYTE) NOT NULL,
  strunitkey NUMBER(4) NOT NULL,
  objkind CHAR NOT NULL,
  objcode VARCHAR2(10 BYTE) NOT NULL,
  actkind CHAR NOT NULL,
  actcode VARCHAR2(2 BYTE) NOT NULL,
  ykey NUMBER(4) NOT NULL,
  agency_status VARCHAR2(3 BYTE),
  "COST" NUMBER(10) NOT NULL,
  benefit NUMBER(10) NOT NULL,
  lockcost CHAR NOT NULL,
  lockben CHAR NOT NULL,
  quantity FLOAT NOT NULL,
  state1 CHAR NOT NULL,
  state2 CHAR NOT NULL,
  state3 CHAR NOT NULL,
  state4 CHAR NOT NULL,
  state5 CHAR NOT NULL,
  flexcode VARCHAR2(2 BYTE) NOT NULL,
  CONSTRAINT tmp_witems_pk PRIMARY KEY (witemkey)
);
COMMENT ON COLUMN pontis.tmp_witems.witemkey IS 'Work Item Key';
COMMENT ON COLUMN pontis.tmp_witems.brkey IS 'Primary pontis structure key--uniquely identifies the structure in the system.';
COMMENT ON COLUMN pontis.tmp_witems.strunitkey IS 'Structure unit identifier';
COMMENT ON COLUMN pontis.tmp_witems.objkind IS 'Object kind indicates whether the object is a bridge(0), element category(1), element type(2) or element(3)';
COMMENT ON COLUMN pontis.tmp_witems.objcode IS 'It is the actual value for the object kind; for bridge it is coded 0; for element category it is the code of element category; for element type it is the type of the element and for element it is the elementkey';
COMMENT ON COLUMN pontis.tmp_witems.actkind IS 'Action Kind (1: Action Type, 2: Action Category, 3: Flex Action)';
COMMENT ON COLUMN pontis.tmp_witems.actcode IS 'Action type key e.g.g 11,12,31,41 depending on the action kind';
COMMENT ON COLUMN pontis.tmp_witems.agency_status IS 'work item status';
COMMENT ON COLUMN pontis.tmp_witems.lockcost IS 'Lock costs';
COMMENT ON COLUMN pontis.tmp_witems.lockben IS 'Lock benefits';