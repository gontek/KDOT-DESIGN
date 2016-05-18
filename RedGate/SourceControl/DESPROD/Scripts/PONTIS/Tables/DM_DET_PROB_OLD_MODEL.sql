CREATE TABLE pontis.dm_det_prob_old_model (
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  skey NUMBER(1) NOT NULL,
  prob_pct NUMBER(8,4) NOT NULL,
  sum_weight NUMBER(38) NOT NULL,
  CONSTRAINT dm_det_prob_old_model_pk PRIMARY KEY (elemkey,envkey,skey)
);
COMMENT ON COLUMN pontis.dm_det_prob_old_model.elemkey IS 'Element key.';
COMMENT ON COLUMN pontis.dm_det_prob_old_model.envkey IS 'Environment key.';
COMMENT ON COLUMN pontis.dm_det_prob_old_model.skey IS 'State key.';
COMMENT ON COLUMN pontis.dm_det_prob_old_model.prob_pct IS 'One-year probability of staying in the same state for the specified condition unit and state.';
COMMENT ON COLUMN pontis.dm_det_prob_old_model.sum_weight IS 'Sum of weights for all observations for the specified condition unit and state.';