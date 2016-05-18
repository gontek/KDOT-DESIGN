CREATE TABLE pontis.keystash (
  select_key VARCHAR2(30 BYTE) NOT NULL,
  increments NUMBER(7) NOT NULL,
  "VALUE" VARCHAR2(255 BYTE) NOT NULL,
  createuserkey VARCHAR2(4 BYTE) NOT NULL,
  createdatetime DATE NOT NULL,
  CONSTRAINT keystash_pk PRIMARY KEY (select_key,increments,"VALUE",createuserkey,createdatetime)
);