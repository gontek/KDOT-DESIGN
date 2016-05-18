CREATE TABLE pontis.editcheck_definitions (
  check_key NUMBER(38) NOT NULL,
  severity VARCHAR2(1 BYTE),
  check_level NUMBER(38),
  "CONTEXT" VARCHAR2(1 BYTE),
  nbi_item VARCHAR2(12 BYTE),
  formula_string VARCHAR2(2000 BYTE),
  exception_id VARCHAR2(12 BYTE),
  exception_text VARCHAR2(255 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT editcheck_definitions_pk PRIMARY KEY (check_key)
);
COMMENT ON COLUMN pontis.editcheck_definitions.check_key IS 'Edit check key value';
COMMENT ON COLUMN pontis.editcheck_definitions.severity IS 'Severity of the check - fatal or warning';
COMMENT ON COLUMN pontis.editcheck_definitions.check_level IS 'Check level - checks are processed in order of severity and level';
COMMENT ON COLUMN pontis.editcheck_definitions."CONTEXT" IS 'Specifies whether the check applies to on records, under records or both';
COMMENT ON COLUMN pontis.editcheck_definitions.nbi_item IS 'NBI Item checked - applicable for single item checks only';
COMMENT ON COLUMN pontis.editcheck_definitions.formula_string IS 'Formulat text for the edit check';
COMMENT ON COLUMN pontis.editcheck_definitions.exception_id IS 'ID of exception text, used for coordination with FHWA';
COMMENT ON COLUMN pontis.editcheck_definitions.exception_text IS 'Text displayed when the formula results in a value if 0';
COMMENT ON COLUMN pontis.editcheck_definitions.modtime IS 'Time the record was last modified';
COMMENT ON COLUMN pontis.editcheck_definitions.userkey IS 'Key of user that last modified record';
COMMENT ON COLUMN pontis.editcheck_definitions.notes IS 'Entry comments';