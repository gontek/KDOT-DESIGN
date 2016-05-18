CREATE TABLE pontis.kaws_inspevnt (
  serialnumber VARCHAR2(15 BYTE),
  co_ser VARCHAR2(15 BYTE) NOT NULL,
  inspkey VARCHAR2(4 BYTE) NOT NULL,
  intrvl FLOAT,
  inspdate DATE,
  rating NUMBER(1),
  healthindex NUMBER(16,1),
  recom_contr_maint VARCHAR2(2000 BYTE),
  recom_dist_maint VARCHAR2(2000 BYTE),
  recom_area_maint VARCHAR2(2000 BYTE),
  qcqa_flag CHAR DEFAULT '0',
  inspname1 VARCHAR2(24 BYTE),
  inspname2 VARCHAR2(24 BYTE),
  inspfirm VARCHAR2(24 BYTE) NOT NULL,
  traffic_cntrl CHAR,
  traffic_cntrl_comments VARCHAR2(400 BYTE),
  anchorboltlength_measured FLOAT,
  inspec_notes VARCHAR2(2000 BYTE),
  crtcl_find_date DATE,
  crtcl_find_compl DATE,
  crtcl_comments VARCHAR2(2000 BYTE),
  crtcl_element NUMBER(3),
  CONSTRAINT pk_kaws_inspevnt PRIMARY KEY (co_ser,inspkey,inspfirm),
  CONSTRAINT fk_kaws_inspev_kaws_struc FOREIGN KEY (co_ser) REFERENCES pontis.kaws_structures (co_ser) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.kaws_inspevnt.serialnumber IS 'Previous identifier for structure';
COMMENT ON COLUMN pontis.kaws_inspevnt.co_ser IS 'Primary Key';
COMMENT ON COLUMN pontis.kaws_inspevnt.inspkey IS 'Unique inspection key for structure,part of primary';
COMMENT ON COLUMN pontis.kaws_inspevnt.intrvl IS 'inspection interval';
COMMENT ON COLUMN pontis.kaws_inspevnt.inspdate IS 'inspection date';
COMMENT ON COLUMN pontis.kaws_inspevnt.rating IS 'Overall structure rating 0-9';
COMMENT ON COLUMN pontis.kaws_inspevnt.healthindex IS 'health index average';
COMMENT ON COLUMN pontis.kaws_inspevnt.recom_contr_maint IS 'maintenance recommendations contractual';
COMMENT ON COLUMN pontis.kaws_inspevnt.recom_dist_maint IS 'maintenance recommendations for district staff';
COMMENT ON COLUMN pontis.kaws_inspevnt.recom_area_maint IS 'maintenance recommendations for area staff';
COMMENT ON COLUMN pontis.kaws_inspevnt.qcqa_flag IS '1 for yes, 0 for no';
COMMENT ON COLUMN pontis.kaws_inspevnt.inspname1 IS 'Name of First Inspector';
COMMENT ON COLUMN pontis.kaws_inspevnt.inspname2 IS 'Name of Second Inspector';
COMMENT ON COLUMN pontis.kaws_inspevnt.inspfirm IS 'Firm responsible for inspection (or KDOT)';
COMMENT ON COLUMN pontis.kaws_inspevnt.traffic_cntrl IS 'Indicator for whether traffic control was needed or not';
COMMENT ON COLUMN pontis.kaws_inspevnt.traffic_cntrl_comments IS 'Column for comments regarding traffic control measures';
COMMENT ON COLUMN pontis.kaws_inspevnt.anchorboltlength_measured IS 'Actual minimum in field measurement of anchor bolt length';
COMMENT ON COLUMN pontis.kaws_inspevnt.inspec_notes IS 'inspection notes';
COMMENT ON COLUMN pontis.kaws_inspevnt.crtcl_find_date IS 'Date of Critical Finding';
COMMENT ON COLUMN pontis.kaws_inspevnt.crtcl_find_compl IS 'Date recommendations for critical finding completed.';
COMMENT ON COLUMN pontis.kaws_inspevnt.crtcl_comments IS 'Critical finding explanation and recommendations.';
COMMENT ON COLUMN pontis.kaws_inspevnt.crtcl_element IS 'Primary Element Involved in Critical Finding';