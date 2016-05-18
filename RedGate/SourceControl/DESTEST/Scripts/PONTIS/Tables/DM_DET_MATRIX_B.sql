CREATE TABLE pontis.dm_det_matrix_b (
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  num_years NUMBER(2) NOT NULL,
  skey_i NUMBER(1) NOT NULL,
  skey_j NUMBER(1) NOT NULL,
  sum_products FLOAT DEFAULT 0 NOT NULL,
  elem_weight NUMBER(38) DEFAULT 0,
  x_weight NUMBER(38),
  CONSTRAINT dm_det_matrix_b_pk PRIMARY KEY (elemkey,envkey,num_years,skey_i,skey_j)
);
COMMENT ON COLUMN pontis.dm_det_matrix_b.elemkey IS 'Element key.';
COMMENT ON COLUMN pontis.dm_det_matrix_b.envkey IS 'Environment key.';
COMMENT ON COLUMN pontis.dm_det_matrix_b.num_years IS 'Number of years between observations.';
COMMENT ON COLUMN pontis.dm_det_matrix_b.skey_i IS 'State key for the state from which element transition occurs.';
COMMENT ON COLUMN pontis.dm_det_matrix_b.skey_j IS 'State key for the state to which element transition occurs.';
COMMENT ON COLUMN pontis.dm_det_matrix_b.sum_products IS 'Sum of products.  Used to support matrix calculations.';
COMMENT ON COLUMN pontis.dm_det_matrix_b.elem_weight IS 'Element weight.  Used to support matrix calculations.';
COMMENT ON COLUMN pontis.dm_det_matrix_b.x_weight IS 'Weight on element quantity.  Used to support matrix calculations.';