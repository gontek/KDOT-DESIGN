CREATE TABLE pontis.condadjload_output (
  brkey VARCHAR2(10 BYTE),
  strtype VARCHAR2(5 BYTE),
  attrib VARCHAR2(15 BYTE),
  chng_type NUMBER(2),
  "FACTOR" NUMBER,
  old_value VARCHAR2(12 BYTE),
  new_value VARCHAR2(12 BYTE),
  chng_text VARCHAR2(80 BYTE)
);