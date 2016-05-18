CREATE TABLE pontis.kdot_mar_cr_review_lookup (
  mar_cr_kdot_review_status_flag NUMBER(*,0) DEFAULT 1 NOT NULL,
  mar_default_status NUMBER(1) DEFAULT 1 NOT NULL,
  mar_cr_status_shortdesc VARCHAR2(50 BYTE) DEFAULT 'Please enter a CR review status level' NOT NULL,
  mar_cr_status_comments VARCHAR2(4000 BYTE),
  CONSTRAINT pk_mar_cr_status PRIMARY KEY (mar_cr_kdot_review_status_flag)
);
COMMENT ON COLUMN pontis.kdot_mar_cr_review_lookup.mar_cr_kdot_review_status_flag IS 'Int identifier for MAR issue REVIEW LEVEL e.g. 1 means RECOGNIZED/ACKNOWLEDGED.';
COMMENT ON COLUMN pontis.kdot_mar_cr_review_lookup.mar_default_status IS 'Set to 1 to identify the default review status for new records.';
COMMENT ON COLUMN pontis.kdot_mar_cr_review_lookup.mar_cr_status_shortdesc IS 'Label for the CR compliance review status code';
COMMENT ON COLUMN pontis.kdot_mar_cr_review_lookup.mar_cr_status_comments IS 'Documentation of this review status';