CREATE TABLE pontis.kaws_struc_temp_2 (
  inspecfirm VARCHAR2(25 BYTE),
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
  notes VARCHAR2(2000 BYTE)
);