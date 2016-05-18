CREATE TABLE pontis.structure_unit (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  strunitkey NUMBER(4) NOT NULL,
  strunittype CHAR NOT NULL,
  strunitlabel VARCHAR2(24 BYTE),
  strunitdescription VARCHAR2(255 BYTE),
  defaultflag CHAR,
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  docrefkey VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT structure_unit_pk PRIMARY KEY (brkey,strunitkey),
  CONSTRAINT fk_structur_13_bridge FOREIGN KEY (brkey) REFERENCES pontis.bridge (brkey) ON DELETE CASCADE
);
COMMENT ON TABLE pontis.structure_unit IS 'Bridge Structure Unit - Agency defined collector for elements';
COMMENT ON COLUMN pontis.structure_unit.brkey IS 'Primary pontis structure key--uniquely identifies the structure in the system.';
COMMENT ON COLUMN pontis.structure_unit.strunitkey IS 'Structure unit identifier';
COMMENT ON COLUMN pontis.structure_unit.strunittype IS 'MODIFIED FOR KDOT to support synchronization process';
COMMENT ON COLUMN pontis.structure_unit.strunitlabel IS 'Structure Unit Descriptive Label for reporting';
COMMENT ON COLUMN pontis.structure_unit.strunitdescription IS 'Structure Unit Description - role--purpose for defining this structure unit for this bridge';
COMMENT ON COLUMN pontis.structure_unit.defaultflag IS 'Indicatator for default structure unit for a bridge';
COMMENT ON COLUMN pontis.structure_unit.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.structure_unit.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.structure_unit.docrefkey IS 'Document reference key';
COMMENT ON COLUMN pontis.structure_unit.notes IS 'Entry comments';