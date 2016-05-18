CREATE TABLE pontis.dm_eleminsp (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  inspkey VARCHAR2(4 BYTE) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  strunitkey NUMBER(4) NOT NULL,
  elmrowidkey VARCHAR2(30 BYTE),
  elinspdate DATE,
  quantity FLOAT,
  pctstate1 FLOAT,
  qtystate1 FLOAT,
  pctstate2 FLOAT,
  qtystate2 FLOAT,
  pctstate3 FLOAT,
  qtystate3 FLOAT,
  pctstate4 FLOAT,
  qtystate4 FLOAT,
  pctstate5 FLOAT,
  qtystate5 FLOAT,
  CONSTRAINT dm_eleminsp_pk PRIMARY KEY (brkey,inspkey,elemkey,envkey,strunitkey)
);
COMMENT ON TABLE pontis.dm_eleminsp IS 'eleminsp';
COMMENT ON COLUMN pontis.dm_eleminsp.brkey IS 'Primary pontis structure key - uniquely identifies the structure in the system.';
COMMENT ON COLUMN pontis.dm_eleminsp.inspkey IS 'Unique inspection key for bridge';
COMMENT ON COLUMN pontis.dm_eleminsp.elemkey IS 'Element key';
COMMENT ON COLUMN pontis.dm_eleminsp.envkey IS 'Environment key';
COMMENT ON COLUMN pontis.dm_eleminsp.strunitkey IS 'Structure unit identifier';
COMMENT ON COLUMN pontis.dm_eleminsp.elmrowidkey IS 'Element inspection unique row identification key';
COMMENT ON COLUMN pontis.dm_eleminsp.elinspdate IS 'Maintains the date of the element inspection associated with the record.';
COMMENT ON COLUMN pontis.dm_eleminsp.quantity IS 'Quantity of the element present';
COMMENT ON COLUMN pontis.dm_eleminsp.pctstate1 IS 'Element Percent in State 1';
COMMENT ON COLUMN pontis.dm_eleminsp.qtystate1 IS 'Element Quantity in State 1';
COMMENT ON COLUMN pontis.dm_eleminsp.pctstate2 IS 'Percent Of This Element In State 2';
COMMENT ON COLUMN pontis.dm_eleminsp.qtystate2 IS 'Amount Of This Element In State 2';
COMMENT ON COLUMN pontis.dm_eleminsp.pctstate3 IS 'Percent Of This Element In State 3';
COMMENT ON COLUMN pontis.dm_eleminsp.qtystate3 IS 'Amount Of This Element In State 3';
COMMENT ON COLUMN pontis.dm_eleminsp.pctstate4 IS 'Percent Of This Element In State 4';
COMMENT ON COLUMN pontis.dm_eleminsp.qtystate4 IS 'Amount Of This Element In State 4';
COMMENT ON COLUMN pontis.dm_eleminsp.pctstate5 IS 'Percent Of This Element In State 5';
COMMENT ON COLUMN pontis.dm_eleminsp.qtystate5 IS 'Amount Of This Element In State 5';