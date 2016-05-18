CREATE TABLE pontis.dm_det_prob_history (
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  skey NUMBER(1) NOT NULL,
  prob_pct NUMBER(14,4) NOT NULL,
  sum_weight NUMBER(38) NOT NULL,
  CONSTRAINT dm_det_prob_history_pk PRIMARY KEY (elemkey,envkey,skey)
);
COMMENT ON COLUMN pontis.dm_det_prob_history.elemkey IS 'Element key.';
COMMENT ON COLUMN pontis.dm_det_prob_history.envkey IS 'Environment key.';
COMMENT ON COLUMN pontis.dm_det_prob_history.skey IS 'State key.';
COMMENT ON COLUMN pontis.dm_det_prob_history.prob_pct IS 'One-year probability of staying in the same state for the specified condition unit and state.';
COMMENT ON COLUMN pontis.dm_det_prob_history.sum_weight IS 'Sum of weights for all observations for the specified condition unit and state.';