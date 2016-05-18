CREATE TABLE pontis.tbl_route_id (
  routeid VARCHAR2(4 BYTE) NOT NULL,
  prefix CHAR,
  route VARCHAR2(5 BYTE),
  suffix CHAR,
  uniqueid NUMBER,
  descr VARCHAR2(15 BYTE),
  end_date DATE
);