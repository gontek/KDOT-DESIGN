CREATE TABLE pontis.roadway (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  on_under VARCHAR2(2 BYTE) NOT NULL,
  kind_hwy CHAR,
  levl_srvc CHAR,
  routenum VARCHAR2(5 BYTE),
  dirsuffix CHAR,
  roadway_name VARCHAR2(30 BYTE),
  crit_feat CHAR,
  kmpost FLOAT,
  bypasslen FLOAT,
  tollfac CHAR,
  defhwy CHAR,
  trucknet CHAR,
  lanes NUMBER(2),
  funcclass VARCHAR2(2 BYTE),
  adttotal NUMBER(8),
  adtyear NUMBER(4),
  trafficdir CHAR,
  truckpct NUMBER(2),
  adtfuture NUMBER(8),
  adtfutyear NUMBER(4),
  road_speed NUMBER(4),
  det_speed NUMBER(4),
  school_bus CHAR,
  transit_rt CHAR,
  crit_trav CHAR,
  num_median CHAR,
  ten_yr_cnt NUMBER(5),
  acc_rate NUMBER(6),
  acc_risk NUMBER(10,9),
  vclrinv FLOAT,
  hclrinv FLOAT,
  aroadwidth FLOAT,
  roadwidth FLOAT,
  rkey VARCHAR2(2 BYTE),
  rinspdone CHAR,
  nhs_ind CHAR,
  userrwkey1 VARCHAR2(30 BYTE),
  userrwkey2 VARCHAR2(30 BYTE),
  userrwkey3 VARCHAR2(30 BYTE),
  userrwkey4 VARCHAR2(30 BYTE),
  userrwkey5 VARCHAR2(30 BYTE),
  nbi_rw_flag CHAR,
  acc_count NUMBER(6,2),
  rtrigger CHAR,
  fedlandhwy CHAR,
  adtclass VARCHAR2(2 BYTE),
  onbasenet CHAR,
  lrsinvrt VARCHAR2(10 BYTE),
  subrtnum VARCHAR2(2 BYTE),
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  userkey VARCHAR2(4 BYTE),
  modtime DATE,
  docrefkey VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT roadway_pk PRIMARY KEY (brkey,on_under),
  CONSTRAINT fk_roadway_10_bridge FOREIGN KEY (brkey) REFERENCES pontis.bridge (brkey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.roadway.brkey IS 'Primary pontis structure key--uniquely identifies the structure in the system.';
COMMENT ON COLUMN pontis.roadway.on_under IS 'Record type, 1 if on-structure';
COMMENT ON COLUMN pontis.roadway.kind_hwy IS 'Route signing prefix';
COMMENT ON COLUMN pontis.roadway.levl_srvc IS 'Designated level of service';
COMMENT ON COLUMN pontis.roadway.routenum IS 'Route number';
COMMENT ON COLUMN pontis.roadway.dirsuffix IS 'Direction suffix';
COMMENT ON COLUMN pontis.roadway.roadway_name IS 'Enter a free form description for the roadway e.g. streetname.  It identifies multiple routes under where no LRS or Route# is available.';
COMMENT ON COLUMN pontis.roadway.crit_feat IS 'Critical facility indicator';
COMMENT ON COLUMN pontis.roadway.kmpost IS 'Kilometer point';
COMMENT ON COLUMN pontis.roadway.bypasslen IS 'Bypass length';
COMMENT ON COLUMN pontis.roadway.tollfac IS 'Toll facility';
COMMENT ON COLUMN pontis.roadway.defhwy IS 'Defense highway designation';
COMMENT ON COLUMN pontis.roadway.trucknet IS 'Truck network';
COMMENT ON COLUMN pontis.roadway.lanes IS 'Number of lanes on or under the structure';
COMMENT ON COLUMN pontis.roadway.funcclass IS 'Functional class of the bridge';
COMMENT ON COLUMN pontis.roadway.adttotal IS 'Average daily traffic total';
COMMENT ON COLUMN pontis.roadway.adtyear IS 'Year of average daily traffic';
COMMENT ON COLUMN pontis.roadway.trafficdir IS 'Traffic direction';
COMMENT ON COLUMN pontis.roadway.truckpct IS 'Truck percent';
COMMENT ON COLUMN pontis.roadway.adtfuture IS 'Future average daily traffic';
COMMENT ON COLUMN pontis.roadway.adtfutyear IS 'Year of future average daily traffic';
COMMENT ON COLUMN pontis.roadway.road_speed IS 'Speed on roadway';
COMMENT ON COLUMN pontis.roadway.det_speed IS 'Speed on detour';
COMMENT ON COLUMN pontis.roadway.school_bus IS 'School bus route';
COMMENT ON COLUMN pontis.roadway.transit_rt IS 'Transit route';
COMMENT ON COLUMN pontis.roadway.crit_trav IS 'Critical travel route';
COMMENT ON COLUMN pontis.roadway.num_median IS 'Number of medians';
COMMENT ON COLUMN pontis.roadway.ten_yr_cnt IS 'Number of accidents in 10 years';
COMMENT ON COLUMN pontis.roadway.acc_rate IS 'Accidents per 100m VMT';
COMMENT ON COLUMN pontis.roadway.acc_risk IS 'Estimated accident rate';
COMMENT ON COLUMN pontis.roadway.vclrinv IS 'VertClr InvRoute';
COMMENT ON COLUMN pontis.roadway.hclrinv IS 'Inventory route, total horizontal clearance';
COMMENT ON COLUMN pontis.roadway.aroadwidth IS 'Approach roadway width';
COMMENT ON COLUMN pontis.roadway.roadwidth IS 'Bridge roadway width, curb-to-curb';
COMMENT ON COLUMN pontis.roadway.rkey IS 'Roadway key, within structure and span';
COMMENT ON COLUMN pontis.roadway.rinspdone IS 'Inspection complete flag';
COMMENT ON COLUMN pontis.roadway.nhs_ind IS 'Nhs Ind';
COMMENT ON COLUMN pontis.roadway.userrwkey1 IS 'User-defined route number 1';
COMMENT ON COLUMN pontis.roadway.userrwkey2 IS 'User-defined route number 2';
COMMENT ON COLUMN pontis.roadway.userrwkey3 IS 'User-defined route number 3';
COMMENT ON COLUMN pontis.roadway.userrwkey4 IS 'User-defined route number 4';
COMMENT ON COLUMN pontis.roadway.userrwkey5 IS 'User-defined route number 5';
COMMENT ON COLUMN pontis.roadway.nbi_rw_flag IS 'NBI roadway flag';
COMMENT ON COLUMN pontis.roadway.acc_count IS 'Average annual accident count';
COMMENT ON COLUMN pontis.roadway.rtrigger IS 'Set to 1 when user accepts this check-in exception.';
COMMENT ON COLUMN pontis.roadway.fedlandhwy IS 'Federal Land Highway';
COMMENT ON COLUMN pontis.roadway.adtclass IS 'Traffic volume class of the bridge';
COMMENT ON COLUMN pontis.roadway.onbasenet IS 'Flag field indicating whether inventory route is on base highway network';
COMMENT ON COLUMN pontis.roadway.lrsinvrt IS 'Linear referencing system (LRS) inventory route number';
COMMENT ON COLUMN pontis.roadway.subrtnum IS 'Linear referencing system (LRS) subroute number';
COMMENT ON COLUMN pontis.roadway.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.roadway.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.roadway.docrefkey IS 'Document reference key';
COMMENT ON COLUMN pontis.roadway.notes IS 'Entry comments';