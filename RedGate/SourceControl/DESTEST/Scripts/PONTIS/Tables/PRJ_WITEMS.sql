CREATE TABLE pontis.prj_witems (
  witemkey VARCHAR2(30 BYTE) NOT NULL,
  witem_id VARCHAR2(30 BYTE) NOT NULL,
  projkey VARCHAR2(30 BYTE) NOT NULL,
  brkey VARCHAR2(15 BYTE) NOT NULL,
  strunitkey NUMBER(4),
  objkind CHAR,
  objcode VARCHAR2(10 BYTE),
  actkind CHAR,
  actcode VARCHAR2(2 BYTE) DEFAULT -1 NOT NULL,
  ykey NUMBER(4),
  fskey VARCHAR2(2 BYTE) NOT NULL,
  flag_whole CHAR,
  agency_status VARCHAR2(3 BYTE),
  agency_priority VARCHAR2(3 BYTE),
  workrecdate DATE,
  workassignment VARCHAR2(3 BYTE),
  witemsource CHAR,
  "COST" NUMBER(10),
  benefit NUMBER(10),
  lockcost CHAR,
  lockben CHAR,
  quantity FLOAT,
  state1 CHAR,
  state2 CHAR,
  state3 CHAR,
  state4 CHAR,
  state5 CHAR,
  flexcode VARCHAR2(2 BYTE),
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  docrefkey VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT prj_witems_pk PRIMARY KEY (witemkey),
  CONSTRAINT fk_prj_wite_102_prj_fund FOREIGN KEY (fskey) REFERENCES pontis.prj_fundsrc (fskey),
  CONSTRAINT fk_prj_wite_11_bridge FOREIGN KEY (brkey) REFERENCES pontis.bridge (brkey) ON DELETE CASCADE,
  CONSTRAINT fk_prj_wite_65_projects FOREIGN KEY (projkey) REFERENCES pontis.projects (projkey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.prj_witems.witemkey IS 'Work Item Key';
COMMENT ON COLUMN pontis.prj_witems.witem_id IS 'Agency Work Item ID';
COMMENT ON COLUMN pontis.prj_witems.projkey IS 'Project primary key';
COMMENT ON COLUMN pontis.prj_witems.brkey IS 'Primary pontis structure key--uniquely identifies the structure in the system.';
COMMENT ON COLUMN pontis.prj_witems.strunitkey IS 'Structure unit identifier';
COMMENT ON COLUMN pontis.prj_witems.objkind IS 'Object kind indicates whether the object is a bridge(0), element category(1), element type(2) or element(3)';
COMMENT ON COLUMN pontis.prj_witems.objcode IS 'It is the actual value for the object kind; for bridge it is coded 0; for element category it is the code of element category; for element type it is the type of the element and for element it is the elementkey';
COMMENT ON COLUMN pontis.prj_witems.actkind IS 'Action Kind (1: Action Type, 2: Action Category, 3: Flex Action)';
COMMENT ON COLUMN pontis.prj_witems.actcode IS 'Action type key e.g.g 11,12,31,41 depending on the action kind';
COMMENT ON COLUMN pontis.prj_witems.fskey IS 'Primary key for funding sources';
COMMENT ON COLUMN pontis.prj_witems.flag_whole IS 'Indicator for a whole bridge action. 0=partial bridge action, 1=whole bridge action';
COMMENT ON COLUMN pontis.prj_witems.agency_status IS 'work item status';
COMMENT ON COLUMN pontis.prj_witems.workrecdate IS 'Recommended date of each work item.  Default value is date of entry, overriden by the user';
COMMENT ON COLUMN pontis.prj_witems.workassignment IS 'Who performs the work (i.e, bridge repair crew, city agency, airforce etc.). The default is 01.';
COMMENT ON COLUMN pontis.prj_witems.witemsource IS 'Work Item Source';
COMMENT ON COLUMN pontis.prj_witems.lockcost IS 'Lock costs';
COMMENT ON COLUMN pontis.prj_witems.lockben IS 'Lock benefits';
COMMENT ON COLUMN pontis.prj_witems.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.prj_witems.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.prj_witems.docrefkey IS 'Document reference key';
COMMENT ON COLUMN pontis.prj_witems.notes IS 'Entry comments';