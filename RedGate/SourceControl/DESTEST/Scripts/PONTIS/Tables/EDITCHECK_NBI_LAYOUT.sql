CREATE TABLE pontis.editcheck_nbi_layout (
  layout_key NUMBER(38) NOT NULL,
  nbi_item VARCHAR2(12 BYTE),
  nbi_item_name VARCHAR2(255 BYTE),
  nbi_item_desc VARCHAR2(255 BYTE),
  table_name VARCHAR2(30 BYTE),
  col_name VARCHAR2(30 BYTE),
  startpos NUMBER(38),
  "LENGTH" NUMBER(38),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT editcheck_nbi_layout_pk PRIMARY KEY (layout_key)
);
COMMENT ON COLUMN pontis.editcheck_nbi_layout.layout_key IS 'Identifier of the NBI layout entry';
COMMENT ON COLUMN pontis.editcheck_nbi_layout.nbi_item IS 'NBI item number';
COMMENT ON COLUMN pontis.editcheck_nbi_layout.nbi_item_name IS 'NBI item name';
COMMENT ON COLUMN pontis.editcheck_nbi_layout.nbi_item_desc IS 'NBI item description';
COMMENT ON COLUMN pontis.editcheck_nbi_layout.table_name IS 'Corresponding database table name';
COMMENT ON COLUMN pontis.editcheck_nbi_layout.col_name IS 'Corresponding database column name';
COMMENT ON COLUMN pontis.editcheck_nbi_layout.startpos IS 'Start position for the NBI item in the metric NBI file';
COMMENT ON COLUMN pontis.editcheck_nbi_layout."LENGTH" IS 'Length of the NBI item in the metric NBI file';
COMMENT ON COLUMN pontis.editcheck_nbi_layout.modtime IS 'Time the record was last modified';
COMMENT ON COLUMN pontis.editcheck_nbi_layout.userkey IS 'Key of user that last modified record';
COMMENT ON COLUMN pontis.editcheck_nbi_layout.notes IS 'Entry comments';