CREATE TABLE pontis.agencypolrule (
  agcypolsetkey VARCHAR2(2 BYTE) NOT NULL,
  agcypolrulekey VARCHAR2(2 BYTE) NOT NULL,
  "PRIORITY" NUMBER(2),
  ifobjkind CHAR,
  ifobjcode VARCHAR2(10 BYTE),
  threshold_state CHAR,
  threshold_pct NUMBER(3),
  thobjkind CHAR,
  thobjcode VARCHAR2(10 BYTE),
  thactkind1 CHAR,
  thactcode1 VARCHAR2(2 BYTE),
  thactkind2 CHAR,
  thactcode2 VARCHAR2(2 BYTE),
  thactkind3 CHAR,
  thactcode3 VARCHAR2(2 BYTE),
  thactkind4 CHAR,
  thactcode4 VARCHAR2(2 BYTE),
  thactkind5 CHAR,
  thactcode5 VARCHAR2(2 BYTE),
  description VARCHAR2(255 BYTE),
  CONSTRAINT agencypolrule_pk PRIMARY KEY (agcypolsetkey,agcypolrulekey),
  CONSTRAINT fk_agencypo_104_agencypo FOREIGN KEY (agcypolsetkey) REFERENCES pontis.agencypolsets (agcypolsetkey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.agencypolrule.agcypolsetkey IS 'Agency preservation policy set key.  Two character code of the rule set as it will be addressed by scenario.';
COMMENT ON COLUMN pontis.agencypolrule.agcypolrulekey IS 'Character code of the rule that will uniquely identify its within a set.  Must contain a number.';
COMMENT ON COLUMN pontis.agencypolrule."PRIORITY" IS 'Numeric code used to prioritization of the rules.  Rules with lower priority number will be checked first.';
COMMENT ON COLUMN pontis.agencypolrule.ifobjkind IS 'Indicates how controlling object (one whose condition is evaluated) is identified for the rule, i.e, as element category, type or number.  Allowable entries are 1, 2 or 3, corresponding to the element type, category or number.';
COMMENT ON COLUMN pontis.agencypolrule.ifobjcode IS 'Code of the controlling object.  Depending on the contents of the ifobjkind field, this may be the code of the category, type, or an element number.';
COMMENT ON COLUMN pontis.agencypolrule.threshold_state IS 'Number of the threshold condition state.  Allowable entries are 1, 2, 3, 4, 5.';
COMMENT ON COLUMN pontis.agencypolrule.threshold_pct IS 'Percentage value of the threshold.  Rule is triggered when the fraction of the elements quantity in condition states threshold_state and below reaches or exceeds the given percentage value.';
COMMENT ON COLUMN pontis.agencypolrule.thobjkind IS 'Indicates how controlling object (one for which the action prescribed) is identified for the rule, i.e, as element category, type or number.  Allowable entries are 1, 2 or 3, corresponding to the element type, category or number.';
COMMENT ON COLUMN pontis.agencypolrule.thobjcode IS 'Code of the controlling object';
COMMENT ON COLUMN pontis.agencypolrule.thactkind1 IS 'Code indicating how to interpret the contents of the next column. Allowable entries are 0,1,2,3.  0- Let Pontis decide applying its MRR model.  Other codes correspond to the action category, type and number.';
COMMENT ON COLUMN pontis.agencypolrule.thactcode1 IS 'Code of the action prescribed by the rule for condition state 1.  Field may contain action  number in MRR model, action type or action category code.';
COMMENT ON COLUMN pontis.agencypolrule.thactkind2 IS 'Code indicating how to interpret the contents of the next column. Allowable entries are 0,1,2,3.  0- Let Pontis decide applying its MRR model.  Other codes correspond to the action category, type and number.';
COMMENT ON COLUMN pontis.agencypolrule.thactcode2 IS 'Code of the action prescribed b the rule for condition state 2.  Field may contain action  number in MRR model, action type or action category code.';
COMMENT ON COLUMN pontis.agencypolrule.thactkind3 IS 'Code indicating how to interpret the contents of the next column. Allowable entries are 0,1,2,3.  0- Let Pontis decide applying its MRR model.  Other codes correspond to the action category, type and number.';
COMMENT ON COLUMN pontis.agencypolrule.thactcode3 IS 'Code of the action prescribed b the rule for condition state 3.  Field may contain action  number in MRR model, action type or action category code.';
COMMENT ON COLUMN pontis.agencypolrule.thactkind4 IS 'Code indicating how to interpret the contents of the next column. Allowable entries are 0,1,2,3.  0- Let Pontis decide applying its MRR model.  Other codes correspond to the action category, type and number.';
COMMENT ON COLUMN pontis.agencypolrule.thactcode4 IS 'Code of the action prescribed b the rule for condition state 4.  Field may contain action  number in MRR model, action type or action category code.';
COMMENT ON COLUMN pontis.agencypolrule.thactkind5 IS 'Code indicating how to interpret the contents of the next column. Allowable entries are 0,1,2,3.  0- Let Pontis decide applying its MRR model.  Other codes correspond to the action category, type and number.';
COMMENT ON COLUMN pontis.agencypolrule.thactcode5 IS 'Code of the action prescribed b the rule for condition state 5.  Field may contain action  number in MRR model, action type or action category code.';