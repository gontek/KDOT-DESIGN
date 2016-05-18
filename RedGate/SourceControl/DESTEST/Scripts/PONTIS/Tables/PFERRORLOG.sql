CREATE TABLE pontis.pferrorlog (
  error_num NUMBER(38) NOT NULL,
  user_id VARCHAR2(30 BYTE) NOT NULL,
  error_date DATE NOT NULL,
  error_log_num FLOAT NOT NULL,
  dberror_no NUMBER(38),
  dberror_text VARCHAR2(2000 BYTE),
  additional_text VARCHAR2(255 BYTE),
  window_name VARCHAR2(40 BYTE),
  error_label VARCHAR2(80 BYTE),
  CONSTRAINT pferrorlog_pk PRIMARY KEY (error_num,user_id,error_date,error_log_num)
);
COMMENT ON TABLE pontis.pferrorlog IS 'pferrorlog';
COMMENT ON COLUMN pontis.pferrorlog.error_num IS 'Code number of the error message';
COMMENT ON COLUMN pontis.pferrorlog.user_id IS 'ID of the user who received the error';
COMMENT ON COLUMN pontis.pferrorlog.error_date IS 'Date and time error occurred';
COMMENT ON COLUMN pontis.pferrorlog.error_log_num IS 'Unique error log number';
COMMENT ON COLUMN pontis.pferrorlog.dberror_no IS 'The error number returned by the DBMS.';
COMMENT ON COLUMN pontis.pferrorlog.dberror_text IS 'Text explaining database error (from DBMS)';
COMMENT ON COLUMN pontis.pferrorlog.additional_text IS 'Additional text to be displayed beyond the standard message text';
COMMENT ON COLUMN pontis.pferrorlog.window_name IS 'The PowerBuilder name of the window object.';
COMMENT ON COLUMN pontis.pferrorlog.error_label IS 'A string identifying the point in the application script logic that triggered er';