CREATE TABLE pontis.inspevnt (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  inspkey VARCHAR2(4 BYTE) NOT NULL,
  inspdate DATE NOT NULL,
  inspname VARCHAR2(24 BYTE),
  inspusrkey VARCHAR2(4 BYTE) NOT NULL,
  rev_req CHAR DEFAULT '1',
  det_upd CHAR,
  inspectcontrolid VARCHAR2(20 BYTE),
  nbinspdone CHAR,
  brinspfreq NUMBER(2),
  lastinsp DATE,
  nextinsp DATE,
  elinspdone CHAR,
  elinspfreq NUMBER(2),
  elinspdate DATE,
  elnextdate DATE,
  uwinspreq CHAR,
  uwinspdone CHAR,
  uwinspfreq NUMBER(2),
  uwlastinsp DATE,
  uwnextdate DATE,
  fcinspreq CHAR,
  fcinspdone CHAR,
  fcinspfreq NUMBER(2),
  fclastinsp DATE,
  fcnextdate DATE,
  osinspreq CHAR,
  osinspdone CHAR,
  osinspfreq NUMBER(2),
  oslastinsp DATE,
  osnextdate DATE,
  ietrigger CHAR,
  apprdate DATE,
  railrating CHAR,
  transratin CHAR,
  arailratin CHAR,
  aendrating CHAR,
  oppostcl CHAR,
  deckgeom CHAR,
  underclr CHAR,
  wateradeq CHAR,
  pierprot CHAR,
  scourcrit CHAR,
  appralign CHAR,
  dkrating CHAR,
  suprating CHAR,
  subrating CHAR,
  chanrating CHAR,
  culvrating CHAR,
  strrating CHAR,
  nbi_rating CHAR,
  suff_rate NUMBER(4,1),
  suff_prefx CHAR,
  insptype CHAR NOT NULL,
  inspstat CHAR DEFAULT '1',
  deckdistr FLOAT,
  bitrigger CHAR,
  recworkflg CHAR,
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  docrefkey VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE),
  elemconvert CHAR,
  CONSTRAINT inspevnt_pk PRIMARY KEY (brkey,inspkey),
  CONSTRAINT fk_inspevnt_9_bridge FOREIGN KEY (brkey) REFERENCES pontis.bridge (brkey) ON DELETE CASCADE
);
COMMENT ON TABLE pontis.inspevnt IS 'inspevnt';
COMMENT ON COLUMN pontis.inspevnt.brkey IS 'Primary pontis structure key--uniquely identifies the structure in the system.';
COMMENT ON COLUMN pontis.inspevnt.inspkey IS 'Unique inspection key for bridge';
COMMENT ON COLUMN pontis.inspevnt.inspdate IS 'Primary pontis structure key--uniquely identifies the structure in the system.';
COMMENT ON COLUMN pontis.inspevnt.inspname IS 'Name of inspector';
COMMENT ON COLUMN pontis.inspevnt.inspusrkey IS 'User key of the person who did the inspection';
COMMENT ON COLUMN pontis.inspevnt.rev_req IS 'Review required--critical findings';
COMMENT ON COLUMN pontis.inspevnt.det_upd IS 'Has been used in deterioration updating';
COMMENT ON COLUMN pontis.inspevnt.inspectcontrolid IS 'Agency defined control ID for inspection.  Used to assign inspection records from 1 or more bridges for processing and review. Not unique';
COMMENT ON COLUMN pontis.inspevnt.nbinspdone IS 'NBI inspection completed flag';
COMMENT ON COLUMN pontis.inspevnt.brinspfreq IS 'Inspection frequency';
COMMENT ON COLUMN pontis.inspevnt.lastinsp IS 'Inspection date (also applies to Pontis inspections)';
COMMENT ON COLUMN pontis.inspevnt.nextinsp IS 'Next Scheduled Inspection';
COMMENT ON COLUMN pontis.inspevnt.elinspdone IS 'NBI element inspection completed flag';
COMMENT ON COLUMN pontis.inspevnt.elinspfreq IS 'Element inspection frequency';
COMMENT ON COLUMN pontis.inspevnt.elinspdate IS 'Maintains the date of the element inspection associated with the record.';
COMMENT ON COLUMN pontis.inspevnt.elnextdate IS 'Next element inspection date';
COMMENT ON COLUMN pontis.inspevnt.uwinspreq IS 'Underwater inspection required';
COMMENT ON COLUMN pontis.inspevnt.uwinspdone IS 'NBI underwater inpsection completed flag';
COMMENT ON COLUMN pontis.inspevnt.uwinspfreq IS 'Underwater inspection frequency';
COMMENT ON COLUMN pontis.inspevnt.uwlastinsp IS 'Underwater inspection date';
COMMENT ON COLUMN pontis.inspevnt.uwnextdate IS 'Next underwater inspection date';
COMMENT ON COLUMN pontis.inspevnt.fcinspreq IS 'Fracture critical details inspection needed';
COMMENT ON COLUMN pontis.inspevnt.fcinspdone IS 'NBI FC compeleted flag';
COMMENT ON COLUMN pontis.inspevnt.fcinspfreq IS 'Fracture critical details inspection frequency';
COMMENT ON COLUMN pontis.inspevnt.fclastinsp IS 'Fracture critical inspection date';
COMMENT ON COLUMN pontis.inspevnt.fcnextdate IS 'Next fracture-critical inpsection date';
COMMENT ON COLUMN pontis.inspevnt.osinspreq IS 'Other special critical feature inspection needed';
COMMENT ON COLUMN pontis.inspevnt.osinspdone IS 'NBI other special inspection completed flag';
COMMENT ON COLUMN pontis.inspevnt.osinspfreq IS 'Other special critical feature inspection frequency';
COMMENT ON COLUMN pontis.inspevnt.oslastinsp IS 'Other inspection date';
COMMENT ON COLUMN pontis.inspevnt.osnextdate IS 'Next other special inspection date';
COMMENT ON COLUMN pontis.inspevnt.ietrigger IS 'Flag to trigger missing value formulas';
COMMENT ON COLUMN pontis.inspevnt.apprdate IS 'Appraisal Date';
COMMENT ON COLUMN pontis.inspevnt.railrating IS 'Rail Rating';
COMMENT ON COLUMN pontis.inspevnt.transratin IS 'Transition Rating';
COMMENT ON COLUMN pontis.inspevnt.arailratin IS 'Approach Rail';
COMMENT ON COLUMN pontis.inspevnt.aendrating IS 'Approach guardrail ends';
COMMENT ON COLUMN pontis.inspevnt.oppostcl IS 'Structure open, posted, or closed to traffic';
COMMENT ON COLUMN pontis.inspevnt.deckgeom IS 'Deck Geometry';
COMMENT ON COLUMN pontis.inspevnt.underclr IS 'Underclearances, vertical and horizontal';
COMMENT ON COLUMN pontis.inspevnt.wateradeq IS 'Waterway Adequacy';
COMMENT ON COLUMN pontis.inspevnt.pierprot IS 'Pier Protect';
COMMENT ON COLUMN pontis.inspevnt.scourcrit IS 'Scour Critical';
COMMENT ON COLUMN pontis.inspevnt.appralign IS 'Approach Alignment';
COMMENT ON COLUMN pontis.inspevnt.dkrating IS 'Deck Rating';
COMMENT ON COLUMN pontis.inspevnt.suprating IS 'Superstructure rating';
COMMENT ON COLUMN pontis.inspevnt.subrating IS 'Substructure rating';
COMMENT ON COLUMN pontis.inspevnt.chanrating IS 'Channel and channel protection rating';
COMMENT ON COLUMN pontis.inspevnt.culvrating IS 'Culvert Rating';
COMMENT ON COLUMN pontis.inspevnt.strrating IS 'Structural Rating';
COMMENT ON COLUMN pontis.inspevnt.nbi_rating IS 'May be used to flag structure as structurally deficient or functionally obsolete';
COMMENT ON COLUMN pontis.inspevnt.suff_rate IS 'Sufficiency Rating';
COMMENT ON COLUMN pontis.inspevnt.suff_prefx IS 'Sufficiency rating prefix';
COMMENT ON COLUMN pontis.inspevnt.insptype IS 'Regular or interim NBI inspection';
COMMENT ON COLUMN pontis.inspevnt.inspstat IS 'Inspection status';
COMMENT ON COLUMN pontis.inspevnt.deckdistr IS 'Actual distressed deck area';
COMMENT ON COLUMN pontis.inspevnt.bitrigger IS 'Flag to trigger missing value formulas';
COMMENT ON COLUMN pontis.inspevnt.recworkflg IS 'Flag on the Notes card to allow the inspector to indicate that work recommendati';
COMMENT ON COLUMN pontis.inspevnt.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.inspevnt.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.inspevnt.docrefkey IS 'Document reference key';
COMMENT ON COLUMN pontis.inspevnt.notes IS 'Entry comments';