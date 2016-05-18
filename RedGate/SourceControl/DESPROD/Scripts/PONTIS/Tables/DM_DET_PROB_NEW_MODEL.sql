CREATE TABLE pontis.dm_det_prob_new_model (
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  skey NUMBER(1) NOT NULL,
  prob_pct NUMBER(5,2) DEFAULT 0 NOT NULL,
  sum_weight NUMBER(38) NOT NULL,
  sum_prob_weight FLOAT DEFAULT 0 NOT NULL,
  weight_expert NUMBER(38) DEFAULT 0 NOT NULL,
  weight_history NUMBER(38) DEFAULT 0 NOT NULL,
  weight_old NUMBER(38) DEFAULT 0 NOT NULL,
  CONSTRAINT dm_det_prob_new_model_pk PRIMARY KEY (elemkey,envkey,skey)
);
COMMENT ON COLUMN pontis.dm_det_prob_new_model.elemkey IS 'Element key.';
COMMENT ON COLUMN pontis.dm_det_prob_new_model.envkey IS 'Environment key.';
COMMENT ON COLUMN pontis.dm_det_prob_new_model.skey IS 'State key.';
COMMENT ON COLUMN pontis.dm_det_prob_new_model.prob_pct IS 'One-year probability of staying in the same state for the specified condition unit and state.';
COMMENT ON COLUMN pontis.dm_det_prob_new_model.sum_weight IS 'Sum of weights for all observations for the specified condition unit and state.';
COMMENT ON COLUMN pontis.dm_det_prob_new_model.sum_prob_weight IS 'Sum of weights for all observations for the specified condition unit and state weighted by probability.';
COMMENT ON COLUMN pontis.dm_det_prob_new_model.weight_expert IS 'Sum of weights for experts for the specified condition unit and state.';
COMMENT ON COLUMN pontis.dm_det_prob_new_model.weight_history IS 'Sum of weights for inspection history for the specified condition unit and state.';
COMMENT ON COLUMN pontis.dm_det_prob_new_model.weight_old IS 'Sum of weights for the old model for the specified condition unit and state.';