CREATE TABLE pontis.dm_control (
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  num_years NUMBER(2) NOT NULL,
  mx_inversion_flag NUMBER(1) NOT NULL,
  max_xy FLOAT NOT NULL,
  max_xx FLOAT NOT NULL,
  max_all FLOAT NOT NULL,
  min_xy FLOAT,
  min_xx FLOAT,
  min_all FLOAT,
  CONSTRAINT dm_control_pk PRIMARY KEY (elemkey,envkey,num_years)
);
COMMENT ON COLUMN pontis.dm_control.elemkey IS 'Element key.';
COMMENT ON COLUMN pontis.dm_control.envkey IS 'Environment key.';
COMMENT ON COLUMN pontis.dm_control.num_years IS 'Number of years between observations.';
COMMENT ON COLUMN pontis.dm_control.mx_inversion_flag IS 'Matrix inversion flag.';
COMMENT ON COLUMN pontis.dm_control.max_xy IS 'Scaling factor for matrix inversions.';
COMMENT ON COLUMN pontis.dm_control.max_xx IS 'Scaling factor for matrix inversions.';
COMMENT ON COLUMN pontis.dm_control.max_all IS 'Scaling factor for matrix inversions.';
COMMENT ON COLUMN pontis.dm_control.min_xy IS 'Scaling factor for matrix inversions.';
COMMENT ON COLUMN pontis.dm_control.min_xx IS 'Scaling factor for matrix inversions.';
COMMENT ON COLUMN pontis.dm_control.min_all IS 'Scaling factor for matrix inversions.';