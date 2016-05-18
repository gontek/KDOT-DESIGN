CREATE TABLE pontis.polmatrx (
  pokey VARCHAR2(2 BYTE) NOT NULL,
  dim2val VARCHAR2(2 BYTE) NOT NULL,
  dim3val VARCHAR2(2 BYTE) NOT NULL,
  dim4val VARCHAR2(2 BYTE) NOT NULL,
  adtclass VARCHAR2(2 BYTE) NOT NULL,
  lslanewid FLOAT,
  lsshldwid FLOAT,
  lsvertclr FLOAT,
  dslanewid FLOAT,
  dsshldwid FLOAT,
  dsvertclr FLOAT,
  dsswell FLOAT,
  lsoprate FLOAT,
  lsinvrate FLOAT,
  lsothrate FLOAT,
  CONSTRAINT polmatrx_pk PRIMARY KEY (pokey,dim2val,dim3val,dim4val,adtclass),
  CONSTRAINT fk_polmatrx_57_polsets FOREIGN KEY (pokey) REFERENCES pontis.polsets (pokey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.polmatrx.pokey IS 'Policy matrix key';
COMMENT ON COLUMN pontis.polmatrx.dim2val IS 'Field value, dimension 2 Functional Class (Second policy dimension selection value)';
COMMENT ON COLUMN pontis.polmatrx.dim3val IS 'Field value, dimension 3 Ownership (Third policy--cost dimension selection value)';
COMMENT ON COLUMN pontis.polmatrx.dim4val IS 'Field value, dimension 4 NHS Status (Fourth policy--cost dimension selection value)';
COMMENT ON COLUMN pontis.polmatrx.adtclass IS 'Traffic volume class of the bridge';
COMMENT ON COLUMN pontis.polmatrx.lslanewid IS 'Lane width LOS standard';
COMMENT ON COLUMN pontis.polmatrx.lsshldwid IS 'Shoulder width LOS standard';
COMMENT ON COLUMN pontis.polmatrx.lsvertclr IS 'Vertical clearance LOS standard';
COMMENT ON COLUMN pontis.polmatrx.dslanewid IS 'Lane width design standard';
COMMENT ON COLUMN pontis.polmatrx.dsshldwid IS 'Shoulder width design standard';
COMMENT ON COLUMN pontis.polmatrx.dsvertclr IS 'Vertical clearance design standard';
COMMENT ON COLUMN pontis.polmatrx.dsswell IS 'Replacement swell factor';
COMMENT ON COLUMN pontis.polmatrx.lsoprate IS 'Policy operating rating';
COMMENT ON COLUMN pontis.polmatrx.lsinvrate IS 'Policy inventory rating';
COMMENT ON COLUMN pontis.polmatrx.lsothrate IS 'Policy other loading';