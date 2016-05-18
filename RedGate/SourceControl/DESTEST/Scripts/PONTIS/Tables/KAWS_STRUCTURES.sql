CREATE TABLE pontis.kaws_structures (
  serialnumber VARCHAR2(15 BYTE),
  co_ser VARCHAR2(15 BYTE) NOT NULL,
  structure_id VARCHAR2(15 BYTE),
  district VARCHAR2(2 BYTE),
  area VARCHAR2(2 BYTE),
  subarea VARCHAR2(2 BYTE),
  route_prefix VARCHAR2(3 BYTE),
  route VARCHAR2(3 BYTE),
  ref_point NUMBER(7,3),
  loc_desc VARCHAR2(150 BYTE),
  orientation CHAR,
  latitude FLOAT,
  longitude FLOAT,
  marked_text VARCHAR2(25 BYTE),
  marked_no FLOAT,
  matrl_type VARCHAR2(3 BYTE),
  supr_type VARCHAR2(3 BYTE),
  super_design_ty VARCHAR2(3 BYTE),
  "OWNER" VARCHAR2(3 BYTE),
  pole_height FLOAT,
  arm_truss_span FLOAT,
  county_fipps VARCHAR2(3 BYTE),
  attached VARCHAR2(3 BYTE),
  vertclr FLOAT,
  signrtfttype VARCHAR2(3 BYTE),
  signltfttype VARCHAR2(3 BYTE),
  anchorboltno FLOAT,
  anchorboltspacing FLOAT,
  anchorboltdiam FLOAT,
  anchorboltlength_design FLOAT,
  baseplateshape VARCHAR2(3 BYTE),
  baseplatewidth FLOAT,
  baseplatethick FLOAT,
  attach_catwalk VARCHAR2(3 BYTE),
  attach_electric VARCHAR2(3 BYTE),
  attach_lighting VARCHAR2(3 BYTE),
  attach_downarrows VARCHAR2(3 BYTE),
  attach_other_desc VARCHAR2(2000 BYTE),
  attach_other VARCHAR2(3 BYTE),
  geogloc CHAR,
  standoffdist FLOAT,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT pk_kaws_struc PRIMARY KEY (co_ser)
);
COMMENT ON COLUMN pontis.kaws_structures.serialnumber IS 'Identifier field from previous database';
COMMENT ON COLUMN pontis.kaws_structures.co_ser IS 'Primary Key using county, serial, L or S';
COMMENT ON COLUMN pontis.kaws_structures.structure_id IS 'Co-Ser in Pontis format XXXX-L-XXXX';
COMMENT ON COLUMN pontis.kaws_structures.district IS 'District jurisdiction for the structure';
COMMENT ON COLUMN pontis.kaws_structures.area IS 'Area jurisdiction for the structure';
COMMENT ON COLUMN pontis.kaws_structures.subarea IS 'Subarea jurisdiction for the structure';
COMMENT ON COLUMN pontis.kaws_structures.route_prefix IS 'Route Prefix (U,K,I)';
COMMENT ON COLUMN pontis.kaws_structures.route IS 'Route';
COMMENT ON COLUMN pontis.kaws_structures.ref_point IS 'Milepost reference point for the structure along the assigned route';
COMMENT ON COLUMN pontis.kaws_structures.loc_desc IS 'Description of location of structure';
COMMENT ON COLUMN pontis.kaws_structures.orientation IS 'Juxtoposition of structure relative to roadway';
COMMENT ON COLUMN pontis.kaws_structures.latitude IS 'latitude of structure';
COMMENT ON COLUMN pontis.kaws_structures.longitude IS 'Longitude of structure';
COMMENT ON COLUMN pontis.kaws_structures.marked_text IS 'Alphabetical identifier on structure';
COMMENT ON COLUMN pontis.kaws_structures.marked_no IS 'Numerical identifier on structure';
COMMENT ON COLUMN pontis.kaws_structures.matrl_type IS 'First character of 3-character designation of main material portion of structure type';
COMMENT ON COLUMN pontis.kaws_structures.supr_type IS 'Second two characters of the 3-character designation for structure type';
COMMENT ON COLUMN pontis.kaws_structures.super_design_ty IS 'Place holder for character for super design type if needed';
COMMENT ON COLUMN pontis.kaws_structures."OWNER" IS 'Owner of structure';
COMMENT ON COLUMN pontis.kaws_structures.pole_height IS 'Height of light tower pole';
COMMENT ON COLUMN pontis.kaws_structures.arm_truss_span IS 'Length of arm/truss span';
COMMENT ON COLUMN pontis.kaws_structures.county_fipps IS 'FIPPS County No designation';
COMMENT ON COLUMN pontis.kaws_structures.attached IS '3-digit serial number for bridge the sign is attached to';
COMMENT ON COLUMN pontis.kaws_structures.vertclr IS 'Minimum vertical clearance from roadway to structure';
COMMENT ON COLUMN pontis.kaws_structures.signrtfttype IS 'footing type right';
COMMENT ON COLUMN pontis.kaws_structures.signltfttype IS 'footing type left';
COMMENT ON COLUMN pontis.kaws_structures.anchorboltno IS 'Number of anchor bolts';
COMMENT ON COLUMN pontis.kaws_structures.anchorboltspacing IS 'Spacing between anchor bolts';
COMMENT ON COLUMN pontis.kaws_structures.anchorboltdiam IS 'Diameter of Anchor bolts';
COMMENT ON COLUMN pontis.kaws_structures.anchorboltlength_design IS 'Minimum Anchor Bolt Length from Design Plans';
COMMENT ON COLUMN pontis.kaws_structures.baseplateshape IS 'Base Plate Shape';
COMMENT ON COLUMN pontis.kaws_structures.baseplatewidth IS 'Base plate width';
COMMENT ON COLUMN pontis.kaws_structures.baseplatethick IS 'base plate thickness';
COMMENT ON COLUMN pontis.kaws_structures.attach_catwalk IS 'Catwalk attached?';
COMMENT ON COLUMN pontis.kaws_structures.attach_electric IS 'Electric attached?';
COMMENT ON COLUMN pontis.kaws_structures.attach_lighting IS 'Lighting attached?';
COMMENT ON COLUMN pontis.kaws_structures.attach_downarrows IS 'Downarrows attached?';
COMMENT ON COLUMN pontis.kaws_structures.attach_other_desc IS 'Other attachment description';
COMMENT ON COLUMN pontis.kaws_structures.attach_other IS 'Anything else attached?';
COMMENT ON COLUMN pontis.kaws_structures.geogloc IS 'Location for setting inspection area';
COMMENT ON COLUMN pontis.kaws_structures.standoffdist IS 'Stand Off Distance';
COMMENT ON COLUMN pontis.kaws_structures.notes IS 'structure-level notes';