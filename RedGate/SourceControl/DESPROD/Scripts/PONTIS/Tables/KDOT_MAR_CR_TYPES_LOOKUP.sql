CREATE TABLE pontis.kdot_mar_cr_types_lookup (
  mar_cr_type NUMBER(*,0) DEFAULT 1 NOT NULL,
  mar_cr_type_enforced NUMBER(1) DEFAULT 1 NOT NULL,
  mar_cr_type_severity NUMBER(1) DEFAULT 1 NOT NULL,
  mar_cr_shortdesc VARCHAR2(50 BYTE) DEFAULT 'Please enter a description of this CR type code' NOT NULL,
  mar_cr_comments VARCHAR2(4000 BYTE),
  CONSTRAINT pk_mar_cr_type PRIMARY KEY (mar_cr_type)
);
COMMENT ON COLUMN pontis.kdot_mar_cr_types_lookup.mar_cr_type IS 'Integer identifier for MAR compliance issue TYPE e.g. load posting issue.  Values are nominally 1-22';
COMMENT ON COLUMN pontis.kdot_mar_cr_types_lookup.mar_cr_type_enforced IS 'Set to 0 to disable this check.  1 means enforced.';
COMMENT ON COLUMN pontis.kdot_mar_cr_types_lookup.mar_cr_type_severity IS 'Severity levels are 1 = normal compliance issue, 2= urgent compliance issue, 3= critical compliance issue';
COMMENT ON COLUMN pontis.kdot_mar_cr_types_lookup.mar_cr_shortdesc IS 'Label for the CR type code';
COMMENT ON COLUMN pontis.kdot_mar_cr_types_lookup.mar_cr_comments IS 'Documentation of this CR TYPE (from FHWA...)';