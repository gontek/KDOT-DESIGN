CREATE TABLE pontis.pont_work (
  witemkey VARCHAR2(30 BYTE) NOT NULL,
  sckey VARCHAR2(2 BYTE) NOT NULL,
  dim1val VARCHAR2(2 BYTE),
  dim2val VARCHAR2(2 BYTE),
  dim3val VARCHAR2(2 BYTE),
  dim4val VARCHAR2(2 BYTE),
  ykey NUMBER(4) NOT NULL,
  brkey VARCHAR2(15 BYTE) NOT NULL,
  strunitkey NUMBER(4) NOT NULL,
  objkind CHAR NOT NULL,
  objcode VARCHAR2(10 BYTE) NOT NULL,
  actkind CHAR NOT NULL,
  actcode VARCHAR2(2 BYTE) NOT NULL,
  quantity FLOAT NOT NULL,
  ref_witemkey VARCHAR2(30 BYTE) NOT NULL,
  projkey VARCHAR2(30 BYTE) NOT NULL,
  state1 CHAR NOT NULL,
  state2 CHAR NOT NULL,
  state3 CHAR NOT NULL,
  state4 CHAR NOT NULL,
  state5 CHAR NOT NULL,
  genflagpm CHAR NOT NULL,
  genflagap CHAR NOT NULL,
  genflagsr CHAR NOT NULL,
  genflagpr CHAR NOT NULL,
  genflagrh CHAR NOT NULL,
  genflagpu CHAR NOT NULL,
  genflagup CHAR NOT NULL,
  genflagpg CHAR NOT NULL,
  sysflag1 VARCHAR2(2 BYTE) NOT NULL,
  sysflag2 VARCHAR2(2 BYTE) NOT NULL,
  sysflag3 VARCHAR2(2 BYTE) NOT NULL,
  sysflag4 VARCHAR2(2 BYTE) NOT NULL,
  sysflag5 VARCHAR2(2 BYTE) NOT NULL,
  sysflag6 VARCHAR2(2 BYTE) NOT NULL,
  sysflag7 VARCHAR2(2 BYTE) NOT NULL,
  sysflag8 VARCHAR2(2 BYTE) NOT NULL,
  sysflag9 VARCHAR2(2 BYTE) NOT NULL,
  sysflag10 VARCHAR2(2 BYTE) NOT NULL,
  flagmcost CHAR NOT NULL,
  flagmsave CHAR NOT NULL,
  flagmbenf CHAR NOT NULL,
  agcycost NUMBER(9) NOT NULL,
  agcysave NUMBER(9) NOT NULL,
  userbenf NUMBER(9) NOT NULL,
  assigned NUMBER(3) NOT NULL,
  pontwcstatus NUMBER(1) NOT NULL,
  explic VARCHAR2(255 BYTE) NOT NULL,
  CONSTRAINT pont_work_pk PRIMARY KEY (witemkey),
  CONSTRAINT fk_pont_wor_73_scenario FOREIGN KEY (sckey) REFERENCES pontis.scenario (sckey) ON DELETE CASCADE,
  CONSTRAINT fk_pont_wor_8_bridge FOREIGN KEY (brkey) REFERENCES pontis.bridge (brkey) ON DELETE CASCADE
);
COMMENT ON TABLE pontis.pont_work IS 'Pontis work candidates and Project work items';
COMMENT ON COLUMN pontis.pont_work.witemkey IS 'Work Item Key';
COMMENT ON COLUMN pontis.pont_work.sckey IS 'Scenario key';
COMMENT ON COLUMN pontis.pont_work.dim1val IS 'First policy dimension selection value';
COMMENT ON COLUMN pontis.pont_work.dim2val IS 'Second policy dimension selection value';
COMMENT ON COLUMN pontis.pont_work.dim3val IS 'Third policy--cost dimension selection value';
COMMENT ON COLUMN pontis.pont_work.dim4val IS 'Fourth policy--cost dimension selection value';
COMMENT ON COLUMN pontis.pont_work.brkey IS 'Primary pontis structure key--uniquely identifies the structure in the system.';
COMMENT ON COLUMN pontis.pont_work.strunitkey IS 'Structure unit identifier';
COMMENT ON COLUMN pontis.pont_work.objkind IS 'Object kind indicates whether the object is a bridge(0), element category(1), element type(2) or element(3)';
COMMENT ON COLUMN pontis.pont_work.objcode IS 'It is the actual value for the object kind; for bridge it is coded 0; for element category it is the code of element category; for element type it is the type of the element and for element it is the elementkey';
COMMENT ON COLUMN pontis.pont_work.actkind IS 'Action Kind (1: Action Type, 2: Action Category, 3: Flex Action)ry, 2: Action Type, 3: Flex Action)';
COMMENT ON COLUMN pontis.pont_work.actcode IS 'Action type key e.g.g 11,12,31,41 depending on the action kind';
COMMENT ON COLUMN pontis.pont_work.projkey IS 'Project primary key';
COMMENT ON COLUMN pontis.pont_work.pontwcstatus IS 'Pontis work candidate status (assigned, approved etc.)';