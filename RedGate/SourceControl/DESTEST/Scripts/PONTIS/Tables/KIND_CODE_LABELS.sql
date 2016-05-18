CREATE TABLE pontis.kind_code_labels (
  label_type VARCHAR2(2 BYTE) NOT NULL,
  kind VARCHAR2(2 BYTE) NOT NULL,
  code VARCHAR2(3 BYTE) NOT NULL,
  "LABEL" VARCHAR2(40 BYTE),
  CONSTRAINT kind_code_labels_pk PRIMARY KEY (label_type,kind,code)
)
CACHE;
COMMENT ON COLUMN pontis.kind_code_labels.code IS 'Lookup table for objkind--objcode and actkind--actcode';