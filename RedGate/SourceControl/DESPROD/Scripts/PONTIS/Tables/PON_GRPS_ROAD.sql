CREATE TABLE pontis.pon_grps_road (
  grpskey NUMBER(10) NOT NULL,
  brkey VARCHAR2(15 BYTE) NOT NULL,
  on_under VARCHAR2(2 BYTE) NOT NULL,
  CONSTRAINT pon_grps_road_pk PRIMARY KEY (grpskey,brkey,on_under),
  CONSTRAINT fk_pon_grps_road_roadway FOREIGN KEY (brkey,on_under) REFERENCES pontis.roadway (brkey,on_under),
  CONSTRAINT fk_p_grps_road_p_bridge_grps FOREIGN KEY (grpskey) REFERENCES pontis.pon_bridge_grps (grpskey)
);