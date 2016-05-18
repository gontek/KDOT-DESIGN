CREATE TABLE pontis.eleminsp (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  inspkey VARCHAR2(4 BYTE) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  strunitkey NUMBER(4) NOT NULL,
  elmrowidkey VARCHAR2(30 BYTE),
  elinspdate DATE,
  quantity FLOAT,
  elem_scale_factor FLOAT,
  pctstate1 FLOAT,
  qtystate1 FLOAT,
  pctstate2 FLOAT,
  qtystate2 FLOAT,
  pctstate3 FLOAT,
  qtystate3 FLOAT,
  pctstate4 FLOAT,
  qtystate4 FLOAT,
  pctstate5 FLOAT,
  qtystate5 FLOAT,
  elcondest CHAR,
  citrigger CHAR,
  description VARCHAR2(255 BYTE),
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  docrefkey VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT eleminsp_pk PRIMARY KEY (brkey,inspkey,elemkey,envkey,strunitkey)
);
COMMENT ON TABLE pontis.eleminsp IS 'eleminsp';
COMMENT ON COLUMN pontis.eleminsp.brkey IS 'Primary pontis structure key--uniquely identifies the structure in the system.';
COMMENT ON COLUMN pontis.eleminsp.inspkey IS 'Unique inspection key for bridge';
COMMENT ON COLUMN pontis.eleminsp.elemkey IS 'Element key';
COMMENT ON COLUMN pontis.eleminsp.envkey IS 'Environment key';
COMMENT ON COLUMN pontis.eleminsp.strunitkey IS 'Structure unit identifier';
COMMENT ON COLUMN pontis.eleminsp.elmrowidkey IS 'Element inspection unique row identification key';
COMMENT ON COLUMN pontis.eleminsp.elinspdate IS 'Maintains the date of the element inspection associated with the record.';
COMMENT ON COLUMN pontis.eleminsp.quantity IS 'Quantity of the element present';
COMMENT ON COLUMN pontis.eleminsp.elem_scale_factor IS 'Element specific scale factor for a particular bridge--element inspection (formerly AUX_QUANT)';
COMMENT ON COLUMN pontis.eleminsp.pctstate1 IS 'Percent of this Element in State 1';
COMMENT ON COLUMN pontis.eleminsp.qtystate1 IS 'Anount of this Element in State 1';
COMMENT ON COLUMN pontis.eleminsp.pctstate2 IS 'Percent Of This Element In State 2';
COMMENT ON COLUMN pontis.eleminsp.qtystate2 IS 'Amount Of This Element In State 2';
COMMENT ON COLUMN pontis.eleminsp.pctstate3 IS 'Percent Of This Element In State 3';
COMMENT ON COLUMN pontis.eleminsp.qtystate3 IS 'Amount Of This Element In State 3';
COMMENT ON COLUMN pontis.eleminsp.pctstate4 IS 'Percent Of This Element In State 4';
COMMENT ON COLUMN pontis.eleminsp.qtystate4 IS 'Amount Of This Element In State 4';
COMMENT ON COLUMN pontis.eleminsp.pctstate5 IS 'Percent Of This Element In State 5';
COMMENT ON COLUMN pontis.eleminsp.qtystate5 IS 'Amount Of This Element In State 5';
COMMENT ON COLUMN pontis.eleminsp.elcondest IS 'Element Condition Estimated Y--N';
COMMENT ON COLUMN pontis.eleminsp.citrigger IS 'Flag to trigger missing values formulas';
COMMENT ON COLUMN pontis.eleminsp.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.eleminsp.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.eleminsp.docrefkey IS 'Document reference key';
COMMENT ON COLUMN pontis.eleminsp.notes IS 'Entry comments';