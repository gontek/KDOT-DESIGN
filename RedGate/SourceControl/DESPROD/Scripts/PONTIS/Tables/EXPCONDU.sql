CREATE TABLE pontis.expcondu (
  userkey VARCHAR2(4 BYTE) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  weight NUMBER(3),
  eff_date DATE,
  CONSTRAINT expcondu_pk PRIMARY KEY (userkey,elemkey,envkey),
  CONSTRAINT fk_expcondu_27_elemdefs FOREIGN KEY (elemkey) REFERENCES pontis.elemdefs (elemkey) ON DELETE CASCADE,
  CONSTRAINT fk_expcondu_31_envtdefs FOREIGN KEY (envkey) REFERENCES pontis.envtdefs (envkey) ON DELETE CASCADE,
  CONSTRAINT fk_expcondu_89_users FOREIGN KEY (userkey) REFERENCES pontis."USERS" (userkey)
);
COMMENT ON COLUMN pontis.expcondu.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.expcondu.elemkey IS 'Element key';
COMMENT ON COLUMN pontis.expcondu.envkey IS 'Environment key';
COMMENT ON COLUMN pontis.expcondu.weight IS 'Weight of the expert s judgment (zero if no expertise)';
COMMENT ON COLUMN pontis.expcondu.eff_date IS 'Effective Date Of Elicitation';