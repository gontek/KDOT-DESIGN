CREATE TABLE pontis.bridge (
  brkey VARCHAR2(15 BYTE) NOT NULL DISABLE,
  bridge_id VARCHAR2(30 BYTE) NOT NULL DISABLE,
  struct_num VARCHAR2(15 BYTE),
  strucname VARCHAR2(50 BYTE),
  featint VARCHAR2(24 BYTE),
  fhwa_regn CHAR,
  district VARCHAR2(2 BYTE),
  county VARCHAR2(3 BYTE),
  "FACILITY" VARCHAR2(18 BYTE),
  "LOCATION" VARCHAR2(25 BYTE),
  custodian VARCHAR2(2 BYTE),
  "OWNER" VARCHAR2(2 BYTE),
  adminarea VARCHAR2(2 BYTE),
  bridgegroup VARCHAR2(20 BYTE),
  nstatecode VARCHAR2(3 BYTE),
  n_fhwa_reg CHAR,
  bb_pct NUMBER(2),
  bb_brdgeid VARCHAR2(15 BYTE),
  propwork VARCHAR2(2 BYTE),
  workby CHAR,
  nbiimpcost NUMBER(9),
  nbirwcost NUMBER(9),
  nbitotcost NUMBER(9),
  nbiyrcost NUMBER(4),
  yearbuilt NUMBER(4),
  yearrecon NUMBER(4),
  histsign CHAR,
  designload CHAR,
  servtypon CHAR,
  servtypund CHAR,
  sumlanes NUMBER(2),
  mainspans NUMBER(3),
  appspans NUMBER(4),
  maxspan FLOAT,
  "LENGTH" FLOAT,
  deck_area FLOAT,
  bridgemed CHAR,
  skew NUMBER(2),
  materialmain CHAR,
  designmain VARCHAR2(2 BYTE),
  materialappr CHAR,
  designappr VARCHAR2(2 BYTE),
  dkstructyp CHAR,
  dkmembtype CHAR,
  dksurftype CHAR,
  dkprotect CHAR,
  deckwidth FLOAT,
  lftcurbsw FLOAT,
  rtcurbsw FLOAT,
  strflared CHAR,
  refvuc CHAR,
  refhuc CHAR,
  hclrurt FLOAT,
  hclrult FLOAT,
  lftbrnavcl FLOAT,
  navcntrol CHAR,
  navhc FLOAT,
  navvc FLOAT,
  paralstruc CHAR,
  tempstruc CHAR,
  nbislen CHAR,
  latitude NUMBER(8,2),
  longitude NUMBER(9,2),
  vclrover FLOAT,
  vclrunder FLOAT,
  placecode VARCHAR2(5 BYTE),
  implen FLOAT,
  fips_state VARCHAR2(2 BYTE),
  tot_length FLOAT,
  nextinspid VARCHAR2(4 BYTE),
  crewhrs NUMBER(8,2),
  flaggerhrs NUMBER(5,2),
  helperhrs NUMBER(5,2),
  snooperhrs NUMBER(5,2),
  spcrewhrs NUMBER(8,2),
  spequiphrs NUMBER(5,2),
  on_off_sys VARCHAR2(1 BYTE),
  ratingdate DATE,
  rater_ini VARCHAR2(3 BYTE),
  orload FLOAT,
  ortype CHAR,
  irload FLOAT,
  irtype CHAR,
  posting CHAR,
  req_op_rat NUMBER(2),
  def_op_rat CHAR,
  fc_detail VARCHAR2(5 BYTE),
  altorload FLOAT,
  altormeth VARCHAR2(4 BYTE),
  altirload FLOAT,
  altirmeth VARCHAR2(4 BYTE),
  otherload FLOAT,
  truck1or FLOAT,
  truck2or FLOAT,
  truck3or FLOAT,
  truck1ir FLOAT,
  truck2ir FLOAT,
  truck3ir FLOAT,
  srstatus CHAR,
  userkey1 VARCHAR2(30 BYTE),
  userkey2 VARCHAR2(30 BYTE),
  userkey3 VARCHAR2(30 BYTE),
  userkey4 VARCHAR2(30 BYTE),
  userkey5 VARCHAR2(30 BYTE),
  userkey6 VARCHAR2(30 BYTE),
  userkey7 VARCHAR2(30 BYTE),
  userkey8 VARCHAR2(30 BYTE),
  userkey9 VARCHAR2(30 BYTE),
  userkey10 VARCHAR2(30 BYTE),
  userkey11 VARCHAR2(30 BYTE),
  userkey12 VARCHAR2(30 BYTE),
  userkey13 VARCHAR2(30 BYTE),
  userkey14 VARCHAR2(30 BYTE),
  userkey15 VARCHAR2(30 BYTE),
  btrigger CHAR,
  traceflag CHAR,
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  docrefkey VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE),
  bridge_status VARCHAR2(8 BYTE),
  bridge_lifecycle_phase VARCHAR2(8 BYTE),
  "IMPACT" NUMBER(10,2),
  orfactor NUMBER(3,2),
  irfactor NUMBER(3,2),
  precise_lat FLOAT,
  precise_lon FLOAT,
  CONSTRAINT bridge_pk PRIMARY KEY (brkey)
);
COMMENT ON TABLE pontis.bridge IS 'bridge';
COMMENT ON COLUMN pontis.bridge.brkey IS 'Primary pontis structure key--uniquely identifies the structure in the system.';
COMMENT ON COLUMN pontis.bridge.bridge_id IS 'Agency Bridge ID - Entered by agency';
COMMENT ON COLUMN pontis.bridge.struct_num IS 'FHWA Structure Number - NBI 8';
COMMENT ON COLUMN pontis.bridge.strucname IS 'Agency structure name';
COMMENT ON COLUMN pontis.bridge.fhwa_regn IS 'FHWA Region';
COMMENT ON COLUMN pontis.bridge.district IS 'Highway agency district';
COMMENT ON COLUMN pontis.bridge.county IS 'County';
COMMENT ON COLUMN pontis.bridge."FACILITY" IS 'Facility Carried';
COMMENT ON COLUMN pontis.bridge."LOCATION" IS 'Location';
COMMENT ON COLUMN pontis.bridge.custodian IS 'Custodian';
COMMENT ON COLUMN pontis.bridge."OWNER" IS 'Owner';
COMMENT ON COLUMN pontis.bridge.adminarea IS 'Geographic stratification--administrative area--of a state';
COMMENT ON COLUMN pontis.bridge.bridgegroup IS 'Agency defined bridge group for a bridge.  Used to group sets of bridges for assignment to inspectors or for other review purposes.  Not unique';
COMMENT ON COLUMN pontis.bridge.nstatecode IS 'Neighbor state code of a border bridge';
COMMENT ON COLUMN pontis.bridge.n_fhwa_reg IS 'Neighbor FHWA Reg';
COMMENT ON COLUMN pontis.bridge.bb_pct IS 'Percent in other state';
COMMENT ON COLUMN pontis.bridge.bb_brdgeid IS 'Border bridge ID';
COMMENT ON COLUMN pontis.bridge.propwork IS 'Proposed Work';
COMMENT ON COLUMN pontis.bridge.workby IS 'Work done by';
COMMENT ON COLUMN pontis.bridge.nbiimpcost IS 'Cost of proposed action - construction portion only';
COMMENT ON COLUMN pontis.bridge.nbirwcost IS 'Right of way cost for proposed action';
COMMENT ON COLUMN pontis.bridge.nbitotcost IS 'NBI total cost';
COMMENT ON COLUMN pontis.bridge.nbiyrcost IS 'Year of Improvement Cost Estimate';
COMMENT ON COLUMN pontis.bridge.yearbuilt IS 'Year built';
COMMENT ON COLUMN pontis.bridge.yearrecon IS 'Year reconstruction';
COMMENT ON COLUMN pontis.bridge.histsign IS 'Historical Significance';
COMMENT ON COLUMN pontis.bridge.designload IS 'Live load for which the structure was designed';
COMMENT ON COLUMN pontis.bridge.servtypon IS 'Type of service on bridge';
COMMENT ON COLUMN pontis.bridge.servtypund IS 'Type of service under bridge';
COMMENT ON COLUMN pontis.bridge.sumlanes IS 'Sum of all lanes for all NBI routes passing under the structure';
COMMENT ON COLUMN pontis.bridge.mainspans IS 'Number of main spans';
COMMENT ON COLUMN pontis.bridge.appspans IS 'Number of approach spans';
COMMENT ON COLUMN pontis.bridge.maxspan IS 'Length of maximum span';
COMMENT ON COLUMN pontis.bridge."LENGTH" IS 'Structure Length';
COMMENT ON COLUMN pontis.bridge.deck_area IS 'Deck Area';
COMMENT ON COLUMN pontis.bridge.bridgemed IS 'Bridge Median';
COMMENT ON COLUMN pontis.bridge.skew IS 'Skew';
COMMENT ON COLUMN pontis.bridge.materialmain IS 'Material';
COMMENT ON COLUMN pontis.bridge.designmain IS 'Design';
COMMENT ON COLUMN pontis.bridge.materialappr IS 'Material of the approach span';
COMMENT ON COLUMN pontis.bridge.designappr IS 'Design of the approach span';
COMMENT ON COLUMN pontis.bridge.dkstructyp IS 'Deck structure type';
COMMENT ON COLUMN pontis.bridge.dkmembtype IS 'Deck membrane type';
COMMENT ON COLUMN pontis.bridge.dksurftype IS 'Deck surface type';
COMMENT ON COLUMN pontis.bridge.dkprotect IS 'Deck protection';
COMMENT ON COLUMN pontis.bridge.deckwidth IS 'Deck width, Out-to-Out';
COMMENT ON COLUMN pontis.bridge.lftcurbsw IS 'Left curb side walk width';
COMMENT ON COLUMN pontis.bridge.rtcurbsw IS 'Right curb side walk width';
COMMENT ON COLUMN pontis.bridge.strflared IS 'Structure flared';
COMMENT ON COLUMN pontis.bridge.refvuc IS 'Reference feature for underclearance measurement';
COMMENT ON COLUMN pontis.bridge.refhuc IS 'Reference feature for lateral underclearance';
COMMENT ON COLUMN pontis.bridge.hclrurt IS 'Minimum lateral underclearance on right';
COMMENT ON COLUMN pontis.bridge.hclrult IS 'Minimum lateral underclearance on left';
COMMENT ON COLUMN pontis.bridge.lftbrnavcl IS 'Minimum navigation vertical clearance';
COMMENT ON COLUMN pontis.bridge.navcntrol IS 'Navigation Control';
COMMENT ON COLUMN pontis.bridge.navhc IS 'Navigation horizontal Clearance';
COMMENT ON COLUMN pontis.bridge.navvc IS 'Navigation vertical clearance';
COMMENT ON COLUMN pontis.bridge.paralstruc IS 'Parrallel Struct';
COMMENT ON COLUMN pontis.bridge.tempstruc IS 'Temporary structure designation';
COMMENT ON COLUMN pontis.bridge.nbislen IS 'NBIS Length Met';
COMMENT ON COLUMN pontis.bridge.latitude IS 'Latitude';
COMMENT ON COLUMN pontis.bridge.longitude IS 'Longitude';
COMMENT ON COLUMN pontis.bridge.vclrover IS 'Minimum vertical clearance over bridge roadway';
COMMENT ON COLUMN pontis.bridge.vclrunder IS 'Minimum vertical underclearance';
COMMENT ON COLUMN pontis.bridge.placecode IS 'Place Code';
COMMENT ON COLUMN pontis.bridge.implen IS 'Length of structure improvement';
COMMENT ON COLUMN pontis.bridge.fips_state IS 'FIPS State';
COMMENT ON COLUMN pontis.bridge.tot_length IS 'Total length';
COMMENT ON COLUMN pontis.bridge.nextinspid IS 'Userkey of the person who will do the next inspection';
COMMENT ON COLUMN pontis.bridge.crewhrs IS 'Number of crew hours required for an inspection';
COMMENT ON COLUMN pontis.bridge.flaggerhrs IS 'Number of flagger hours required for an inspection';
COMMENT ON COLUMN pontis.bridge.helperhrs IS 'Number of helper hours required for an inspection';
COMMENT ON COLUMN pontis.bridge.snooperhrs IS 'Number of snooper hours required for an inspection';
COMMENT ON COLUMN pontis.bridge.spcrewhrs IS 'Number of special crew hours required for an inspection';
COMMENT ON COLUMN pontis.bridge.spequiphrs IS 'Number of special equipment hours required for an inspection';
COMMENT ON COLUMN pontis.bridge.on_off_sys IS 'Flag indicates whether bridge is on or off the system of the agency.  Usually but not always determined as a function of bridge.owner.';
COMMENT ON COLUMN pontis.bridge.ratingdate IS 'Date Load Rated';
COMMENT ON COLUMN pontis.bridge.rater_ini IS 'Load Rater--Engineer Responsible';
COMMENT ON COLUMN pontis.bridge.orload IS 'Operating rating load';
COMMENT ON COLUMN pontis.bridge.ortype IS 'Method Used to Determine Operating Rating';
COMMENT ON COLUMN pontis.bridge.irload IS 'Inventory rating load';
COMMENT ON COLUMN pontis.bridge.irtype IS 'Inventory rating type';
COMMENT ON COLUMN pontis.bridge.posting IS 'Bridge Posting';
COMMENT ON COLUMN pontis.bridge.req_op_rat IS 'Required Operating Rating';
COMMENT ON COLUMN pontis.bridge.def_op_rat IS 'Deficiency Operating Rating Flag';
COMMENT ON COLUMN pontis.bridge.fc_detail IS 'FC Detail on Structure';
COMMENT ON COLUMN pontis.bridge.altorload IS 'Alternate Load Rating';
COMMENT ON COLUMN pontis.bridge.altormeth IS 'Alternate Operating Rating Method';
COMMENT ON COLUMN pontis.bridge.altirload IS 'Alternate Inventory Load Rating';
COMMENT ON COLUMN pontis.bridge.altirmeth IS 'Alternate Inventory Rating Method';
COMMENT ON COLUMN pontis.bridge.otherload IS 'Other load rating';
COMMENT ON COLUMN pontis.bridge.truck1or IS 'Operating rating for truck type 1';
COMMENT ON COLUMN pontis.bridge.truck2or IS 'Operating rating for truck type 2';
COMMENT ON COLUMN pontis.bridge.truck3or IS 'Operating rating for truck type 3';
COMMENT ON COLUMN pontis.bridge.truck1ir IS 'Inventory rating for truck type 1';
COMMENT ON COLUMN pontis.bridge.truck2ir IS 'Inventory rating for truck type 2';
COMMENT ON COLUMN pontis.bridge.truck3ir IS 'Inventory rating for truck type 3';
COMMENT ON COLUMN pontis.bridge.srstatus IS 'Bridges where SR status has changed';
COMMENT ON COLUMN pontis.bridge.userkey1 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.userkey2 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.userkey3 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.userkey4 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.userkey5 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.userkey6 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.userkey7 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.userkey8 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.userkey9 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.userkey10 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.userkey11 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.userkey12 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.userkey13 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.userkey14 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.userkey15 IS 'User defined key fields';
COMMENT ON COLUMN pontis.bridge.btrigger IS 'Flag to trigger missing value formulas';
COMMENT ON COLUMN pontis.bridge.traceflag IS 'When checked, bridge is traced in log file during program simulation routine.';
COMMENT ON COLUMN pontis.bridge.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.bridge.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.bridge.docrefkey IS 'Document reference key';
COMMENT ON COLUMN pontis.bridge.notes IS 'Entry comments';