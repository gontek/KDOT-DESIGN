CREATE TABLE pontis.imprmtrx (
  imkey VARCHAR2(2 BYTE) NOT NULL,
  gaccriska NUMBER(7,5) DEFAULT 2.0 NOT NULL,
  gaccriskb NUMBER(3,1) DEFAULT 9.0 NOT NULL,
  gaccriskc NUMBER(4,2) DEFAULT 6.5 NOT NULL,
  defaulttruckpct NUMBER(3,1) DEFAULT 5 NOT NULL,
  accrisccoeff NUMBER(4) DEFAULT 200 NOT NULL,
  mindualttst NUMBER(6,3) DEFAULT 2.3 NOT NULL,
  dualttstxa NUMBER(6,3) DEFAULT 18 NOT NULL,
  dualttstya NUMBER(4,2) DEFAULT 64.32 NOT NULL,
  dualttstxb NUMBER(6,3) DEFAULT 41 NOT NULL,
  dualttstyb NUMBER(4,2) DEFAULT 83.57 NOT NULL,
  widthdeffactor NUMBER(4,2) DEFAULT 0.9 NOT NULL,
  raisecriticaladt NUMBER(7) DEFAULT 50 NOT NULL,
  raisecriticalbypasslen NUMBER(3) DEFAULT 8 NOT NULL,
  replacecriticaladt NUMBER(7) DEFAULT 50 NOT NULL,
  replacecriticalbypasslen NUMBER(3) DEFAULT 8 NOT NULL,
  clrdetoursthresha NUMBER(5,3) DEFAULT 0 NOT NULL,
  clrdetoursfraca NUMBER(5,3) DEFAULT 0 NOT NULL,
  clrdetoursthreshb NUMBER(5,3) DEFAULT 3.96 NOT NULL,
  clrdetoursfracb NUMBER(5,3) DEFAULT 10.8 NOT NULL,
  clrdetoursthreshc NUMBER(5,3) DEFAULT 4.11 NOT NULL,
  clrdetoursfracc NUMBER(5,3) DEFAULT 0.18 NOT NULL,
  clrdetoursthreshd NUMBER(5,3) DEFAULT 4.27 NOT NULL,
  clrdetoursfracd NUMBER(5,3) DEFAULT 0.05 NOT NULL,
  clrdetoursthreshe NUMBER(5,3) DEFAULT 4.42 NOT NULL,
  clrdetoursfrace NUMBER(5,3) DEFAULT 0.027 NOT NULL,
  clrdetoursdefault NUMBER(5,3) DEFAULT 0 NOT NULL,
  strdetoursminthresh NUMBER(6,3) DEFAULT 2.3 NOT NULL,
  strdetourscornerx NUMBER(6,3) DEFAULT 18 NOT NULL,
  strdetourscornery NUMBER(5,3) DEFAULT 50.425 NOT NULL,
  strdetoursmaxthresh NUMBER(6,3) DEFAULT 41 NOT NULL,
  defaultroadspeedfc01 NUMBER(4,1) DEFAULT 94 NOT NULL,
  defaultroadspeedfc02 NUMBER(4,1) DEFAULT 87.8 NOT NULL,
  defaultroadspeedfc06 NUMBER(4,1) DEFAULT 80 NOT NULL,
  defaultroadspeedfc07 NUMBER(4,1) DEFAULT 80 NOT NULL,
  defaultroadspeedfc08 NUMBER(4,1) DEFAULT 40 NOT NULL,
  defaultroadspeedfc09 NUMBER(4,1) DEFAULT 40 NOT NULL,
  defaultroadspeedfc11 NUMBER(4,1) DEFAULT 91 NOT NULL,
  defaultroadspeedfc12 NUMBER(4,1) DEFAULT 83 NOT NULL,
  defaultroadspeedfc14 NUMBER(4,1) DEFAULT 83 NOT NULL,
  defaultroadspeedfc16 NUMBER(4,1) DEFAULT 48 NOT NULL,
  defaultroadspeedfc17 NUMBER(4,1) DEFAULT 48 NOT NULL,
  defaultroadspeedfc19 NUMBER(4,1) DEFAULT 32 NOT NULL,
  detspeedfactor NUMBER(3,2) DEFAULT 0.8 NOT NULL,
  maxwidenlength NUMBER(3,1) DEFAULT 60 NOT NULL,
  defaultadtchange NUMBER(2) DEFAULT 20 NOT NULL,
  CONSTRAINT imprmtrx_pk PRIMARY KEY (imkey),
  CONSTRAINT fk_imprmtrx_42_imprsets FOREIGN KEY (imkey) REFERENCES pontis.imprsets (imkey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.imprmtrx.imkey IS 'Improvement formula values';
COMMENT ON COLUMN pontis.imprmtrx.gaccriska IS '(units: NBI rating) The minimum possible NBI approach alignment rating, ordinar';
COMMENT ON COLUMN pontis.imprmtrx.gaccriskb IS '(units: NBI rating) The maximum possible NBI approach alignment rating, ordinar';
COMMENT ON COLUMN pontis.imprmtrx.gaccriskc IS 'The accident rate is proportional to W^(-GAccRiskC).';
COMMENT ON COLUMN pontis.imprmtrx.defaulttruckpct IS '(units: percent) Default Truck Percentage.';
COMMENT ON COLUMN pontis.imprmtrx.accrisccoeff IS 'Accident Risk Coefficient.';
COMMENT ON COLUMN pontis.imprmtrx.mindualttst IS '(units: tons) Tech Manual G(L) is 0 when load limit is below this.';
COMMENT ON COLUMN pontis.imprmtrx.dualttstxa IS '(units: tons) x-coordinate (load) of right endpoint of first piece of G(L) pw-l';
COMMENT ON COLUMN pontis.imprmtrx.dualttstya IS '(units: percent) y-coordinate (percent) of right endpoint of first piece of G(L';
COMMENT ON COLUMN pontis.imprmtrx.dualttstxb IS '(units: tons) x-coordinate (load) of right endpoint of second piece of G(L) pw-';
COMMENT ON COLUMN pontis.imprmtrx.dualttstyb IS '(units: percent) y-coordinate (percent) of right endpoint of second piece of G(';
COMMENT ON COLUMN pontis.imprmtrx.widthdeffactor IS '(units: fraction) Width Deficiency Factor.';
COMMENT ON COLUMN pontis.imprmtrx.raisecriticaladt IS '(units: vehicles per day) Critical ADT for raising needs.';
COMMENT ON COLUMN pontis.imprmtrx.raisecriticalbypasslen IS '(units: kilometers) Critical Bypasslength for raising needs.';
COMMENT ON COLUMN pontis.imprmtrx.replacecriticaladt IS '(units: vehicles per day) Critical ADT for replacement needs.';
COMMENT ON COLUMN pontis.imprmtrx.replacecriticalbypasslen IS '(units: kilometers) Critical Bypasslength for replacement needs.';
COMMENT ON COLUMN pontis.imprmtrx.clrdetoursthresha IS '(units: meters) 1st input threshold for vert clr. detours stepfunction.';
COMMENT ON COLUMN pontis.imprmtrx.clrdetoursfraca IS '(units: percent) height of 1st step for vert clr. detours stepfunction.';
COMMENT ON COLUMN pontis.imprmtrx.clrdetoursthreshb IS '(units: meters) 2nd input threshold for vert clr. detours stepfunction.';
COMMENT ON COLUMN pontis.imprmtrx.clrdetoursfracb IS '(units: percent) height of 2nd step for vert clr. detours stepfunction.';
COMMENT ON COLUMN pontis.imprmtrx.clrdetoursthreshc IS '(units: meters) 3rd input threshold for vert clr. detours stepfunction.';
COMMENT ON COLUMN pontis.imprmtrx.clrdetoursfracc IS '(units: percent) height of 3rd step for vert clr. detours stepfunction.';
COMMENT ON COLUMN pontis.imprmtrx.clrdetoursthreshd IS '(units: meters) 4th input threshold for vert clr. detours stepfunction.';
COMMENT ON COLUMN pontis.imprmtrx.clrdetoursfracd IS '(units: percent) height of 4th step for vert clr. detours stepfunction.';
COMMENT ON COLUMN pontis.imprmtrx.clrdetoursthreshe IS '(units: meters) 5th input threshold for vert clr. detours stepfunction.';
COMMENT ON COLUMN pontis.imprmtrx.clrdetoursfrace IS '(units: percent) height of 5th step for vert clr. detours stepfunction.';
COMMENT ON COLUMN pontis.imprmtrx.clrdetoursdefault IS '(units: percent) percent detoured for vert clr. if all thresholds are exceeded.';
COMMENT ON COLUMN pontis.imprmtrx.strdetoursminthresh IS '(units: tons) nonzero load ratings below this min will detour all traffic.';
COMMENT ON COLUMN pontis.imprmtrx.strdetourscornerx IS '(units: tons) x-coord (wt limit) of bend in piecewise linear model of P(L).';
COMMENT ON COLUMN pontis.imprmtrx.strdetourscornery IS '(units: percent) y-coord (percent detoured) of bend in piecewise linear model o';
COMMENT ON COLUMN pontis.imprmtrx.strdetoursmaxthresh IS '(units: tons) load ratings above this max will not detour any traffic.';
COMMENT ON COLUMN pontis.imprmtrx.defaultroadspeedfc01 IS '(units: kilometers per hour)Functional Class 01 Default Roadspeed.';
COMMENT ON COLUMN pontis.imprmtrx.defaultroadspeedfc02 IS '(units: kilometers per hour)Functional Class 02 Default Roadspeed.';
COMMENT ON COLUMN pontis.imprmtrx.defaultroadspeedfc06 IS '(units: kilometers per hour)Functional Class 06 Default Roadspeed.';
COMMENT ON COLUMN pontis.imprmtrx.defaultroadspeedfc07 IS '(units: kilometers per hour)Functional Class 07 Default Roadspeed.';
COMMENT ON COLUMN pontis.imprmtrx.defaultroadspeedfc08 IS '(units: kilometers per hour)Functional Class 08 Default Roadspeed.';
COMMENT ON COLUMN pontis.imprmtrx.defaultroadspeedfc09 IS '(units: kilometers per hour)Functional Class 09 Default Roadspeed.';
COMMENT ON COLUMN pontis.imprmtrx.defaultroadspeedfc11 IS '(units: kilometers per hour)Functional Class 11 Default Roadspeed.';
COMMENT ON COLUMN pontis.imprmtrx.defaultroadspeedfc12 IS '(units: kilometers per hour)Functional Class 12 Default Roadspeed.';
COMMENT ON COLUMN pontis.imprmtrx.defaultroadspeedfc14 IS '(units: kilometers per hour)Functional Class 14 Default Roadspeed.';
COMMENT ON COLUMN pontis.imprmtrx.defaultroadspeedfc16 IS '(units: kilometers per hour)Functional Class 16 Default Roadspeed.';
COMMENT ON COLUMN pontis.imprmtrx.defaultroadspeedfc17 IS '(units: kilometers per hour)Functional Class 17 Default Roadspeed.';
COMMENT ON COLUMN pontis.imprmtrx.defaultroadspeedfc19 IS '(units: kilometers per hour)Functional Class 19 Default Roadspeed.';
COMMENT ON COLUMN pontis.imprmtrx.detspeedfactor IS '(units: fraction) Detourspeed Factor CProjCont::CalcStatic.';
COMMENT ON COLUMN pontis.imprmtrx.maxwidenlength IS '(units: meters) Bridges shorter than this should be almost as wide as approach.';
COMMENT ON COLUMN pontis.imprmtrx.defaultadtchange IS '(units: vehicles per day) Used if annual ADT increase input is missing.';