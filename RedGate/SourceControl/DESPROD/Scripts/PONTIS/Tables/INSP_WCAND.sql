CREATE TABLE pontis.insp_wcand (
  wckey VARCHAR2(30 BYTE) NOT NULL,
  wc_id VARCHAR2(30 BYTE) NOT NULL,
  ref_witemkey VARCHAR2(30 BYTE),
  brkey VARCHAR2(15 BYTE) NOT NULL,
  strunitkey NUMBER(4),
  objkind CHAR,
  objcode VARCHAR2(10 BYTE),
  actkind CHAR,
  actcode VARCHAR2(2 BYTE) DEFAULT -1 NOT NULL,
  targetyear NUMBER(4),
  flag_whole CHAR,
  agency_status VARCHAR2(3 BYTE),
  agency_priority VARCHAR2(3 BYTE),
  workrecdate DATE,
  workassignment VARCHAR2(3 BYTE),
  estimcost NUMBER(10),
  estimquantity FLOAT,
  state1 CHAR,
  state2 CHAR,
  state3 CHAR,
  state4 CHAR,
  state5 CHAR,
  assigned NUMBER(3),
  inspkey VARCHAR2(4 BYTE) NOT NULL,
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  docrefkey VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT insp_wcand_pk PRIMARY KEY (wckey)
);
COMMENT ON COLUMN pontis.insp_wcand.wckey IS 'Work Candidate Key';
COMMENT ON COLUMN pontis.insp_wcand.brkey IS 'Primary pontis structure key--uniquely identifies the structure in the system.';
COMMENT ON COLUMN pontis.insp_wcand.strunitkey IS 'Structure unit identifier';
COMMENT ON COLUMN pontis.insp_wcand.objkind IS 'Object kind indicates whether the object is a bridge(0), element category(1), element type(2) or element(3)';
COMMENT ON COLUMN pontis.insp_wcand.objcode IS 'It is the actual value for the object kind; for bridge it is coded 0; for element category it is the code of element category; for element type it is the type of the element and for element it is the elementkey';
COMMENT ON COLUMN pontis.insp_wcand.actkind IS 'Action Kind (1: Action Type, 2: Action Category, 3: Flex Action)';
COMMENT ON COLUMN pontis.insp_wcand.actcode IS 'Action type key e.g.g 11,12,31,41 depending on the action kind';
COMMENT ON COLUMN pontis.insp_wcand.flag_whole IS 'Indicator for a whole bridge action. 0=partial bridge action, 1=whole bridge action';
COMMENT ON COLUMN pontis.insp_wcand.agency_status IS 'Agency work candidate status (assigned, approved etc.)';
COMMENT ON COLUMN pontis.insp_wcand.workrecdate IS 'Recommended date of each work item.  Default value is date of entry, overriden by the user';
COMMENT ON COLUMN pontis.insp_wcand.workassignment IS 'Who performs the work (i.e, bridge repair crew, city agency, airforce etc.). The default is 01.';
COMMENT ON COLUMN pontis.insp_wcand.estimquantity IS 'Work candidate estimated quantity';
COMMENT ON COLUMN pontis.insp_wcand.inspkey IS 'Unique inspection key for bridge';
COMMENT ON COLUMN pontis.insp_wcand.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.insp_wcand.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.insp_wcand.docrefkey IS 'Document reference key';
COMMENT ON COLUMN pontis.insp_wcand.notes IS 'Entry comments';