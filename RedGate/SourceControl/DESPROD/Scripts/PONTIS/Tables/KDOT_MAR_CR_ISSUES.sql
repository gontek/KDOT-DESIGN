CREATE TABLE pontis.kdot_mar_cr_issues (
  mar_cr_issue_key VARCHAR2(32 BYTE) NOT NULL,
  mar_cr_key VARCHAR2(32 BYTE) NOT NULL,
  mar_cr_type NUMBER(*,0) DEFAULT 1 NOT NULL,
  mar_cr_compliance_level NUMBER(*,0) DEFAULT 1 NOT NULL,
  mar_cr_kdot_review_status_flag NUMBER(*,0) DEFAULT 1 NOT NULL,
  createdatetime DATE,
  createuserkey NUMBER(*,0),
  mar_cr_assessment_findings VARCHAR2(4000 BYTE),
  CONSTRAINT pk_kdot_mar_cr_issues PRIMARY KEY (mar_cr_issue_key),
  CONSTRAINT fk_mar_cr_key_to_eventlog FOREIGN KEY (mar_cr_key) REFERENCES pontis.kdot_mar_cr_eventlog (mar_cr_key) ON DELETE CASCADE,
  CONSTRAINT fk_mar_cr_type_lookup FOREIGN KEY (mar_cr_type) REFERENCES pontis.kdot_mar_cr_types_lookup (mar_cr_type)
);
COMMENT ON TABLE pontis.kdot_mar_cr_issues IS 'Table of individual MAR compliance issues.  One record per issue per bridge per analysis event. Join to KDOT_MAR_CR_EVENTLOG on MAR_CR_KEY';
COMMENT ON COLUMN pontis.kdot_mar_cr_issues.mar_cr_issue_key IS 'Primary key for the table.';
COMMENT ON COLUMN pontis.kdot_mar_cr_issues.mar_cr_key IS 'GUID Pointer to compliance issues found for the bridge for a particular analysis review event';
COMMENT ON COLUMN pontis.kdot_mar_cr_issues.mar_cr_type IS 'Integer identifier for MAR compliance issue TYPE e.g. load posting issue.  Values are nominally 1-22';
COMMENT ON COLUMN pontis.kdot_mar_cr_issues.mar_cr_compliance_level IS 'Indicates 1=COMPLIANT, 2= SUBSTANTIALLY COMPLIANT, 3= NON-COMPLIANT (See PARAMTRS table)';
COMMENT ON COLUMN pontis.kdot_mar_cr_issues.mar_cr_kdot_review_status_flag IS '1=REPORTED, 2=ACCEPTED,3=REQUIRES FURTHER REVIEW, 4=REJECTED';
COMMENT ON COLUMN pontis.kdot_mar_cr_issues.createdatetime IS 'Timestamp for record creation';
COMMENT ON COLUMN pontis.kdot_mar_cr_issues.createuserkey IS 'Userkey for user creating the record';
COMMENT ON COLUMN pontis.kdot_mar_cr_issues.mar_cr_assessment_findings IS 'Shows text summary of the particular compliance issue free-form.';