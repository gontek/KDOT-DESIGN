CREATE TABLE pontis.dm_act_prob_experts (
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  skey NUMBER(1) NOT NULL,
  akey NUMBER(1) NOT NULL,
  prob1 NUMBER(7,2) NOT NULL,
  prob2 NUMBER(7,2) NOT NULL,
  prob3 NUMBER(7,2) NOT NULL,
  prob4 NUMBER(7,2) NOT NULL,
  prob5 NUMBER(7,2) NOT NULL,
  sum_weight NUMBER(8) NOT NULL,
  CONSTRAINT dm_act_prob_experts_pk PRIMARY KEY (elemkey,envkey,skey,akey)
);
COMMENT ON COLUMN pontis.dm_act_prob_experts.elemkey IS 'Element key.';
COMMENT ON COLUMN pontis.dm_act_prob_experts.envkey IS 'Environment key.';
COMMENT ON COLUMN pontis.dm_act_prob_experts.skey IS 'State key.';
COMMENT ON COLUMN pontis.dm_act_prob_experts.akey IS 'Action key.';
COMMENT ON COLUMN pontis.dm_act_prob_experts.prob1 IS 'Probability of state 1 in one year.';
COMMENT ON COLUMN pontis.dm_act_prob_experts.prob2 IS 'Probability of state 2 in one year.';
COMMENT ON COLUMN pontis.dm_act_prob_experts.prob3 IS 'Probability of state 3 in one year.';
COMMENT ON COLUMN pontis.dm_act_prob_experts.prob4 IS 'Probability of state 4 in one year.';
COMMENT ON COLUMN pontis.dm_act_prob_experts.prob5 IS 'Probability of state 5 in one year.';
COMMENT ON COLUMN pontis.dm_act_prob_experts.sum_weight IS 'Sum of weights for all observations for the specified condition unit and state.';