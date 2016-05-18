CREATE TABLE pontis.pon_grps_param (
  ptkey NUMBER(6) NOT NULL,
  grpskey NUMBER(10) NOT NULL,
  "VALUE" NUMBER(12,4),
  CONSTRAINT pon_grps_param_pk PRIMARY KEY (ptkey,grpskey),
  CONSTRAINT fk_p_grps_param_p_bridge_grps FOREIGN KEY (grpskey) REFERENCES pontis.pon_bridge_grps (grpskey)
);