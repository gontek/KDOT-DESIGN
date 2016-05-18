CREATE TABLE pontis.kaws_projects (
  serialnumber VARCHAR2(15 BYTE),
  co_ser VARCHAR2(15 BYTE) NOT NULL,
  actvtydate NUMBER(4),
  projectnumber VARCHAR2(50 BYTE) NOT NULL,
  contractor VARCHAR2(2 BYTE),
  fabricator VARCHAR2(2 BYTE),
  actvtyid VARCHAR2(3 BYTE),
  CONSTRAINT pk_kaws_projects PRIMARY KEY (co_ser,projectnumber),
  CONSTRAINT fk_kaws_proj_kaws_struc FOREIGN KEY (co_ser) REFERENCES pontis.kaws_structures (co_ser) ON DELETE CASCADE
);