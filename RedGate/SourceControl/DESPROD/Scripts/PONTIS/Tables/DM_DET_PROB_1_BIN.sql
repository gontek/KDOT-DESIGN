CREATE TABLE pontis.dm_det_prob_1_bin (
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  num_years NUMBER(2) NOT NULL,
  skey NUMBER(1) NOT NULL,
  prob_value NUMBER(8,4) DEFAULT 0 NOT NULL,
  weight NUMBER(38) DEFAULT 0 NOT NULL,
  CONSTRAINT dm_det_prob_1_bin_pk PRIMARY KEY (elemkey,envkey,num_years,skey)
);
COMMENT ON COLUMN pontis.dm_det_prob_1_bin.elemkey IS 'Element key.';
COMMENT ON COLUMN pontis.dm_det_prob_1_bin.envkey IS 'Environment key.';
COMMENT ON COLUMN pontis.dm_det_prob_1_bin.num_years IS 'Number of years between observations.';
COMMENT ON COLUMN pontis.dm_det_prob_1_bin.skey IS 'State key.';
COMMENT ON COLUMN pontis.dm_det_prob_1_bin.prob_value IS 'One-year probability of staying in the same state for the specified condition unit and state.';
COMMENT ON COLUMN pontis.dm_det_prob_1_bin.weight IS 'Weight on the probability for the specified condition unit state and number of years.';