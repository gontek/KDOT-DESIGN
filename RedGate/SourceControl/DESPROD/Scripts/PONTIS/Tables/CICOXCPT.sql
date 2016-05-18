CREATE TABLE pontis.cicoxcpt (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  ioflag CHAR NOT NULL,
  iomoment DATE NOT NULL,
  cicoid CHAR(4 BYTE) NOT NULL,
  pdifname VARCHAR2(15 BYTE) NOT NULL,
  rtrigger CHAR NOT NULL,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT cicoxcpt_pk PRIMARY KEY (brkey,ioflag,iomoment,cicoid)
);
COMMENT ON TABLE pontis.cicoxcpt IS 'cicoxcpt';
COMMENT ON COLUMN pontis.cicoxcpt.brkey IS 'Primary pontis structure key--uniquely identifies the structure in the system.';
COMMENT ON COLUMN pontis.cicoxcpt.ioflag IS 'I or O indicates input or output';
COMMENT ON COLUMN pontis.cicoxcpt.iomoment IS 'Time when session in which this structure was checked out began.';
COMMENT ON COLUMN pontis.cicoxcpt.cicoid IS 'Check-in--Check-out Session ID';
COMMENT ON COLUMN pontis.cicoxcpt.pdifname IS 'Name of the PDI input file.';
COMMENT ON COLUMN pontis.cicoxcpt.rtrigger IS 'Set to 1 when user accepts this check-in exception.';
COMMENT ON COLUMN pontis.cicoxcpt.notes IS 'Entry comments';