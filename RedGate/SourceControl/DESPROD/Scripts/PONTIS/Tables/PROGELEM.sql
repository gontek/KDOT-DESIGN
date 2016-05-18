CREATE TABLE pontis.progelem (
  sckey VARCHAR2(2 BYTE) NOT NULL,
  ykey NUMBER(4) NOT NULL,
  brkey VARCHAR2(15 BYTE) NOT NULL,
  strunitkey NUMBER(4) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  pct1 NUMBER(6,3),
  pct2 NUMBER(6,3),
  pct3 NUMBER(6,3),
  pct4 NUMBER(6,3),
  pct5 NUMBER(6,3),
  CONSTRAINT progelem_pk PRIMARY KEY (sckey,ykey,brkey,strunitkey,elemkey,envkey),
  CONSTRAINT fk_progelem_95_scenario FOREIGN KEY (sckey) REFERENCES pontis.scenario (sckey) ON DELETE CASCADE
);