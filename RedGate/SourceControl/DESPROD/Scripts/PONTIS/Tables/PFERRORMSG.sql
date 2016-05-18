CREATE TABLE pontis.pferrormsg (
  error_num NUMBER(38) NOT NULL,
  title_text VARCHAR2(40 BYTE),
  body_text VARCHAR2(255 BYTE),
  icon NUMBER(38),
  buttons NUMBER(38),
  short_desc VARCHAR2(40 BYTE),
  severity NUMBER(38),
  log_error CHAR,
  CONSTRAINT pferrormsg_pk PRIMARY KEY (error_num)
);
COMMENT ON COLUMN pontis.pferrormsg.error_num IS 'Code number of the error message';
COMMENT ON COLUMN pontis.pferrormsg.title_text IS 'Text to be displayed in the message box title bar.';
COMMENT ON COLUMN pontis.pferrormsg.body_text IS 'Text to be displayed as the standard message text.';
COMMENT ON COLUMN pontis.pferrormsg.icon IS 'The icon to be displayed in the message box.';
COMMENT ON COLUMN pontis.pferrormsg.buttons IS 'Code representing the combination of commandbuttons to display.';
COMMENT ON COLUMN pontis.pferrormsg.short_desc IS 'A short description which further identifies the error message.';
COMMENT ON COLUMN pontis.pferrormsg.severity IS 'Code representing the severity of error';
COMMENT ON COLUMN pontis.pferrormsg.log_error IS 'Flag indicating whether or not to log the error. Y means log, N means don_t log';