CREATE TABLE pontis.dm_elem_obs_pairs (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  strunitkey NUMBER(4) NOT NULL,
  inspkey1 VARCHAR2(4 BYTE) NOT NULL,
  inspkey2 VARCHAR2(4 BYTE) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  inspdate1 DATE NOT NULL,
  inspdate2 DATE NOT NULL,
  quantity_x FLOAT NOT NULL,
  quantity_y FLOAT NOT NULL,
  quant_x_1 FLOAT DEFAULT 0 NOT NULL,
  quant_x_2 FLOAT DEFAULT 0 NOT NULL,
  quant_x_3 FLOAT DEFAULT 0 NOT NULL,
  quant_x_4 FLOAT DEFAULT 0 NOT NULL,
  quant_x_5 FLOAT DEFAULT 0 NOT NULL,
  quant_y_1 FLOAT DEFAULT 0 NOT NULL,
  quant_y_2 FLOAT DEFAULT 0 NOT NULL,
  quant_y_3 FLOAT DEFAULT 0 NOT NULL,
  quant_y_4 FLOAT DEFAULT 0 NOT NULL,
  quant_y_5 FLOAT DEFAULT 0 NOT NULL,
  qual_flag NUMBER(38) DEFAULT 0 NOT NULL,
  num_years NUMBER(38) DEFAULT -1 NOT NULL,
  pair_key NUMBER(12) NOT NULL,
  CONSTRAINT dm_elem_obs_pairs_pk PRIMARY KEY (brkey,strunitkey,inspkey1,inspkey2,elemkey,envkey)
);
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.brkey IS 'Bridge key.  Primary structure identifier in Pontis.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.strunitkey IS 'Structure unit key.  Primary identifier for the structure unit.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.inspkey1 IS 'Inspection key for observation 1.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.inspkey2 IS 'Inspection key for observation 2.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.elemkey IS 'Element key.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.envkey IS 'Environment key.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.inspdate1 IS 'Inspection date for observation 1.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.inspdate2 IS 'Inspection date for observation 2.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.quantity_x IS 'Total quantity for observation 1.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.quantity_y IS 'Total quantity for observation 2.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.quant_x_1 IS 'Total quantity for state 1 for observation 1.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.quant_x_2 IS 'Total quantity for state 2 for observation 1.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.quant_x_3 IS 'Total quantity for state 3 for observation 1.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.quant_x_4 IS 'Total quantity for state 4 for observation 1.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.quant_x_5 IS 'Total quantity for state 5 for observation 1.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.quant_y_1 IS 'Total quantity for state 1 for observation 2.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.quant_y_2 IS 'Total quantity for state 2 for observation 2.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.quant_y_3 IS 'Total quantity for state 3 for observation 2.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.quant_y_4 IS 'Total quantity for state 4 for observation 2.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.quant_y_5 IS 'Total quantity for state 5 for observation 2.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.qual_flag IS 'Indicator on quality of the observation pair.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.num_years IS 'Number of years between observations.';
COMMENT ON COLUMN pontis.dm_elem_obs_pairs.pair_key IS 'Pair key.  Unique identifier for the observation pair.';