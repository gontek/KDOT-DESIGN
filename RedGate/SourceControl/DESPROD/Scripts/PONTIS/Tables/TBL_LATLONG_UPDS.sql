CREATE TABLE pontis.tbl_latlong_upds (
  str_name VARCHAR2(30 BYTE),
  brkey VARCHAR2(6 BYTE) NOT NULL,
  latitude FLOAT,
  longitude FLOAT,
  CONSTRAINT pk_brkey PRIMARY KEY (brkey)
);