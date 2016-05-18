CREATE TABLE pontis.kdot_mar_cr_lvl_lookup (
  mar_cr_compliance_level NUMBER(*,0) DEFAULT 1 NOT NULL,
  mar_default_level NUMBER(1) DEFAULT 1 NOT NULL,
  mar_cr_level_shortdesc VARCHAR2(50 BYTE) DEFAULT 'Please enter a description of CR compliance level' NOT NULL,
  mar_cr_level_comments VARCHAR2(4000 BYTE),
  CONSTRAINT pk_mar_cr_levels PRIMARY KEY (mar_cr_compliance_level)
);
COMMENT ON COLUMN pontis.kdot_mar_cr_lvl_lookup.mar_cr_compliance_level IS 'Integer identifier for MAR issue compliance  LEVEL e.g. 1 means SUBSTANTIALLY COMPLIANT.';
COMMENT ON COLUMN pontis.kdot_mar_cr_lvl_lookup.mar_default_level IS 'Set to 1 to identify the default level for new records.';
COMMENT ON COLUMN pontis.kdot_mar_cr_lvl_lookup.mar_cr_level_shortdesc IS 'Label for the CR compliance level code';
COMMENT ON COLUMN pontis.kdot_mar_cr_lvl_lookup.mar_cr_level_comments IS 'Documentation of this CR LEVEL (from FHWA...)';