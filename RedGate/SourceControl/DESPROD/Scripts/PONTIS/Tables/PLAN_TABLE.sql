CREATE TABLE pontis.plan_table (
  "STATEMENT_ID" VARCHAR2(30 BYTE),
  "TIMESTAMP" DATE,
  remarks VARCHAR2(80 BYTE),
  operation VARCHAR2(30 BYTE),
  options VARCHAR2(30 BYTE),
  object_node VARCHAR2(128 BYTE),
  object_owner VARCHAR2(30 BYTE),
  object_name VARCHAR2(30 BYTE),
  object_instance NUMBER(*,0),
  object_type VARCHAR2(30 BYTE),
  optimizer VARCHAR2(255 BYTE),
  search_columns NUMBER,
  "ID" NUMBER(*,0),
  parent_id NUMBER(*,0),
  position NUMBER(*,0),
  "COST" NUMBER(*,0),
  "CARDINALITY" NUMBER(*,0),
  bytes NUMBER(*,0),
  other_tag VARCHAR2(255 BYTE),
  partition_start VARCHAR2(255 BYTE),
  partition_stop VARCHAR2(255 BYTE),
  partition_id NUMBER(*,0),
  "OTHER" LONG,
  distribution VARCHAR2(30 BYTE),
  cpu_cost NUMBER(*,0),
  io_cost NUMBER(*,0),
  temp_space NUMBER(*,0)
);