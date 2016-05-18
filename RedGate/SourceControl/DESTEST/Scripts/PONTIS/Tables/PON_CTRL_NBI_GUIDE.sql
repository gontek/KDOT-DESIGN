CREATE TABLE pontis.pon_ctrl_nbi_guide (
  nbi_item_id VARCHAR2(16 BYTE) NOT NULL,
  nbi_level VARCHAR2(16 BYTE) NOT NULL,
  pontis_table_name VARCHAR2(32 BYTE) NOT NULL,
  pontis_column_name VARCHAR2(32 BYTE) NOT NULL,
  metric_english_type VARCHAR2(16 BYTE) NOT NULL,
  import_destination VARCHAR2(8 BYTE) NOT NULL,
  export_source VARCHAR2(8 BYTE) NOT NULL,
  original_source VARCHAR2(16 BYTE) NOT NULL,
  item_description VARCHAR2(256 BYTE) NOT NULL,
  starting_position VARCHAR2(4 BYTE) NOT NULL,
  nbi_data_item_length VARCHAR2(4 BYTE) NOT NULL,
  data_item_type VARCHAR2(4 BYTE) NOT NULL,
  import_treatment VARCHAR2(16 BYTE) NOT NULL,
  export_treatment VARCHAR2(16 BYTE) NOT NULL,
  missing_treatment VARCHAR2(256 BYTE) NOT NULL,
  special_purpose VARCHAR2(32 BYTE),
  ceiling VARCHAR2(16 BYTE),
  CONSTRAINT pon_ctrl_nbi_guide_pk PRIMARY KEY (nbi_item_id,nbi_level,pontis_table_name,pontis_column_name,metric_english_type)
);