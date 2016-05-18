CREATE TABLE pontis.metric_english (
  paircode NUMBER(2) NOT NULL,
  metricunit VARCHAR2(10 BYTE) NOT NULL,
  englishunit VARCHAR2(10 BYTE) NOT NULL,
  "FACTOR" FLOAT NOT NULL,
  CONSTRAINT metric_english_pk PRIMARY KEY (paircode)
)
CACHE;
COMMENT ON COLUMN pontis.metric_english.paircode IS 'Metric English Pair Code';
COMMENT ON COLUMN pontis.metric_english.metricunit IS 'Metric English Metric Unit';
COMMENT ON COLUMN pontis.metric_english.englishunit IS 'Metric English English Unit';
COMMENT ON COLUMN pontis.metric_english."FACTOR" IS 'Metric English Conversion Factor';