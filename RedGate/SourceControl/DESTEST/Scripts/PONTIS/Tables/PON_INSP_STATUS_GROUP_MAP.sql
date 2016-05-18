CREATE TABLE pontis.pon_insp_status_group_map (
  groupkey NUMBER(38) NOT NULL,
  status_key NUMBER(38) NOT NULL,
  CONSTRAINT pon_insp_status_group_map_pk PRIMARY KEY (groupkey,status_key)
);