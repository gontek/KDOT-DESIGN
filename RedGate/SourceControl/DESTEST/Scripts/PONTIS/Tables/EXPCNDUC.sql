CREATE TABLE pontis.expcnduc (
  userkey VARCHAR2(4 BYTE) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  weight NUMBER(3),
  failagcyco FLOAT,
  failuserco FLOAT,
  avgscale FLOAT,
  eff_date DATE,
  CONSTRAINT expcnduc_pk PRIMARY KEY (userkey,elemkey,envkey),
  CONSTRAINT fk_expcnduc_26_elemdefs FOREIGN KEY (elemkey) REFERENCES pontis.elemdefs (elemkey) ON DELETE CASCADE DISABLE NOVALIDATE,
  CONSTRAINT fk_expcnduc_34_envtdefs FOREIGN KEY (envkey) REFERENCES pontis.envtdefs (envkey) ON DELETE CASCADE,
  CONSTRAINT fk_expcnduc_88_users FOREIGN KEY (userkey) REFERENCES pontis."USERS" (userkey)
);
COMMENT ON COLUMN pontis.expcnduc.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.expcnduc.elemkey IS 'Element key';
COMMENT ON COLUMN pontis.expcnduc.envkey IS 'Environment key';
COMMENT ON COLUMN pontis.expcnduc.weight IS 'Weight of the expert s judgment (zero if no expertise)';
COMMENT ON COLUMN pontis.expcnduc.failagcyco IS 'Agency unit fixed cost of element failure';
COMMENT ON COLUMN pontis.expcnduc.failuserco IS 'User unit cost of element failure';
COMMENT ON COLUMN pontis.expcnduc.avgscale IS 'Average value of the scale variable';
COMMENT ON COLUMN pontis.expcnduc.eff_date IS 'Effective Date Of Elicitation';