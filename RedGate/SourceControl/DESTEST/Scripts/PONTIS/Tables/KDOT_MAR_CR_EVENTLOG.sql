CREATE TABLE pontis.kdot_mar_cr_eventlog (
  mar_cr_key VARCHAR2(32 BYTE) NOT NULL,
  brkey VARCHAR2(15 BYTE) NOT NULL,
  compliance_review_date DATE DEFAULT SYSDATE NOT NULL,
  createuserkey NUMBER(*,0) NOT NULL,
  createdatetime DATE DEFAULT SYSDATE NOT NULL,
  CONSTRAINT pk_mar_cr_eventlog PRIMARY KEY (mar_cr_key)
);
COMMENT ON COLUMN pontis.kdot_mar_cr_eventlog.mar_cr_key IS 'GUID Pointer to compliance issues found for the bridge';
COMMENT ON COLUMN pontis.kdot_mar_cr_eventlog.brkey IS 'Pointer to bridge record with MAR compliance issues';
COMMENT ON COLUMN pontis.kdot_mar_cr_eventlog.compliance_review_date IS 'Date of compliance analysis';
COMMENT ON COLUMN pontis.kdot_mar_cr_eventlog.createuserkey IS 'Userkey for the user that ran the analysis';
COMMENT ON COLUMN pontis.kdot_mar_cr_eventlog.createdatetime IS 'Date of last record change (originally same as review_date)';