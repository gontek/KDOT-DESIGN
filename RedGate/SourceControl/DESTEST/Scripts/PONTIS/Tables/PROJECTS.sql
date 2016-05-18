CREATE TABLE pontis.projects (
  projkey VARCHAR2(30 BYTE) NOT NULL,
  progkey VARCHAR2(2 BYTE) NOT NULL,
  project_id VARCHAR2(30 BYTE) NOT NULL,
  projname VARCHAR2(50 BYTE),
  district VARCHAR2(2 BYTE),
  proj_acttype VARCHAR2(2 BYTE),
  progyear NUMBER(4),
  projenddate DATE,
  proj_status VARCHAR2(3 BYTE),
  proj_review_status CHAR,
  proj_reviewed_by VARCHAR2(4 BYTE),
  indirectben NUMBER(10),
  indirectcost NUMBER(10),
  scen_treat CHAR,
  routenum VARCHAR2(5 BYTE),
  beginkmpost FLOAT,
  endkmpost FLOAT,
  avghindex NUMBER(5,1),
  avgsuffrate FLOAT,
  agencyrank NUMBER(4),
  programrank NUMBER(4),
  contractor VARCHAR2(3 BYTE),
  contract_id VARCHAR2(30 BYTE),
  estcost NUMBER(10),
  contractcost NUMBER(10),
  finalcost NUMBER(10),
  agcyprojkey1 VARCHAR2(30 BYTE),
  agcyprojkey2 VARCHAR2(30 BYTE),
  agcyprojkey3 VARCHAR2(30 BYTE),
  agcyprojkey4 VARCHAR2(30 BYTE),
  agcyprojkey5 VARCHAR2(30 BYTE),
  agcyprojkey6 VARCHAR2(30 BYTE),
  agcyprojkey7 VARCHAR2(30 BYTE),
  agcyprojkey8 VARCHAR2(30 BYTE),
  agcyprojkey9 VARCHAR2(30 BYTE),
  agcyprojkey10 VARCHAR2(30 BYTE),
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  docrefkey VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT projects_pk PRIMARY KEY (projkey),
  CONSTRAINT fk_projects_63_prj_prog FOREIGN KEY (progkey) REFERENCES pontis.prj_programs (progkey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.projects.projkey IS 'Project primary key';
COMMENT ON COLUMN pontis.projects.progkey IS 'Primary key for work programs';
COMMENT ON COLUMN pontis.projects.project_id IS 'Agency project identifier - NOT USED AS COORDINATING KEY';
COMMENT ON COLUMN pontis.projects.projname IS 'Project name';
COMMENT ON COLUMN pontis.projects.proj_acttype IS 'Predominant action type for a project';
COMMENT ON COLUMN pontis.projects.proj_status IS 'Project Status';
COMMENT ON COLUMN pontis.projects.indirectben IS 'Other project benefits';
COMMENT ON COLUMN pontis.projects.indirectcost IS 'Other project costs';
COMMENT ON COLUMN pontis.projects.scen_treat IS 'Scenario treatment rule for a project (eg. compete, ignore etc. )';
COMMENT ON COLUMN pontis.projects.routenum IS 'Route number';
COMMENT ON COLUMN pontis.projects.avghindex IS 'Average health index';
COMMENT ON COLUMN pontis.projects.avgsuffrate IS 'Average sufficiency rating';
COMMENT ON COLUMN pontis.projects.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.projects.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.projects.docrefkey IS 'Document reference key';
COMMENT ON COLUMN pontis.projects.notes IS 'Entry comments';