CREATE TABLE pontis.futmetric (
  sckey VARCHAR2(2 BYTE) NOT NULL,
  brkey VARCHAR2(15 BYTE) NOT NULL,
  ykey NUMBER(4) NOT NULL,
  tev NUMBER(10),
  adt NUMBER(7),
  adt_class CHAR,
  hindex NUMBER(5,1),
  ptindex NUMBER(5,1),
  cix_unkn NUMBER(5,1),
  cix_supr NUMBER(5,1),
  cix_sub NUMBER(5,1),
  cix_joint NUMBER(5,1),
  cix_bear NUMBER(5,1),
  cix_othr NUMBER(5,1),
  cix_deck NUMBER(5,1),
  cix_smart NUMBER(5,1),
  rating_deck CHAR,
  rating_sup CHAR,
  rating_sub CHAR,
  rating_culv CHAR,
  rating_str CHAR,
  rating_dkgeo CHAR,
  rating_undcl CHAR,
  suff_prefix CHAR,
  suff_rating NUMBER(5,1),
  rating_nbi CHAR,
  elig_flag CHAR,
  CONSTRAINT futmetric_pk PRIMARY KEY (sckey,brkey,ykey),
  CONSTRAINT fk_futmetri_76_scenario FOREIGN KEY (sckey) REFERENCES pontis.scenario (sckey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.futmetric.sckey IS 'Scenario key';
COMMENT ON COLUMN pontis.futmetric.brkey IS 'Primary pontis structure key--uniquely identifies the structure in the system.';
COMMENT ON COLUMN pontis.futmetric.ykey IS 'Calendar year of simulation';
COMMENT ON COLUMN pontis.futmetric.tev IS 'Total Element Value';
COMMENT ON COLUMN pontis.futmetric.adt IS 'ADT projection for year';
COMMENT ON COLUMN pontis.futmetric.adt_class IS 'ADT class projection for year';
COMMENT ON COLUMN pontis.futmetric.hindex IS 'Heatlh index value (%)';
COMMENT ON COLUMN pontis.futmetric.ptindex IS 'Painting index (%)';
COMMENT ON COLUMN pontis.futmetric.cix_unkn IS 'Condition index (%) - unknown category of elements';
COMMENT ON COLUMN pontis.futmetric.cix_supr IS 'Condition index (%) - superstructure';
COMMENT ON COLUMN pontis.futmetric.cix_sub IS 'Condition index (%) - substructure';
COMMENT ON COLUMN pontis.futmetric.cix_joint IS 'Condition index (%) - joints';
COMMENT ON COLUMN pontis.futmetric.cix_bear IS 'Condition index (%) - bearings';
COMMENT ON COLUMN pontis.futmetric.cix_othr IS 'Condition index (%) - other elements';
COMMENT ON COLUMN pontis.futmetric.cix_deck IS 'Condition index (%) - decks and slabs';
COMMENT ON COLUMN pontis.futmetric.cix_smart IS 'Condition index (%) - smart flags';
COMMENT ON COLUMN pontis.futmetric.rating_deck IS 'Deck rating 0-9N';
COMMENT ON COLUMN pontis.futmetric.rating_sup IS 'Superstructure rating 0-9N';
COMMENT ON COLUMN pontis.futmetric.rating_sub IS 'Substructure rating 0-9N';
COMMENT ON COLUMN pontis.futmetric.rating_culv IS 'Culvert rating 0-9N';
COMMENT ON COLUMN pontis.futmetric.rating_str IS 'Structure rating 0-9N';
COMMENT ON COLUMN pontis.futmetric.rating_dkgeo IS 'Deck geometry rating 0-9N';
COMMENT ON COLUMN pontis.futmetric.rating_undcl IS 'Underclearance rating 0-9N';
COMMENT ON COLUMN pontis.futmetric.suff_prefix IS 'Sufficiency rating prefix';
COMMENT ON COLUMN pontis.futmetric.suff_rating IS 'Sufficiency rating';
COMMENT ON COLUMN pontis.futmetric.rating_nbi IS 'NBI rating';
COMMENT ON COLUMN pontis.futmetric.elig_flag IS 'Eligibility flag: 0 - not eligible for HBRR funds, 1 - eligible for rehabilitation, 2 - eligible for replacement';