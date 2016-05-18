CREATE TABLE pontis.dm_cond_state_pairs (
  item_key NUMBER(12) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  skey NUMBER(1) NOT NULL,
  num_years NUMBER(2) NOT NULL,
  quant_x FLOAT NOT NULL,
  quant_y FLOAT NOT NULL,
  pair_key NUMBER(38),
  CONSTRAINT dm_cond_state_pairs_pk PRIMARY KEY (item_key)
);
COMMENT ON COLUMN pontis.dm_cond_state_pairs.item_key IS 'Item key.  Unique identifier for the specified state of the observation pair.';
COMMENT ON COLUMN pontis.dm_cond_state_pairs.elemkey IS 'Element key.';
COMMENT ON COLUMN pontis.dm_cond_state_pairs.envkey IS 'Environment key.';
COMMENT ON COLUMN pontis.dm_cond_state_pairs.skey IS 'State key.';
COMMENT ON COLUMN pontis.dm_cond_state_pairs.num_years IS 'Number of years between observations.';
COMMENT ON COLUMN pontis.dm_cond_state_pairs.quant_x IS 'Total quantity for observation 1.';
COMMENT ON COLUMN pontis.dm_cond_state_pairs.quant_y IS 'Total quantity for observation 2.';
COMMENT ON COLUMN pontis.dm_cond_state_pairs.pair_key IS 'Pair key.  Refers to the pairkey in the dm_elem_obs_pairs table.';