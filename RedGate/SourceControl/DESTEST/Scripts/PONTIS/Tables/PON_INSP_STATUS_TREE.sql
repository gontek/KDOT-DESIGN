CREATE TABLE pontis.pon_insp_status_tree (
  status_key NUMBER(38) NOT NULL,
  status_target NUMBER(38) NOT NULL,
  CONSTRAINT pon_insp_status_tree_pk PRIMARY KEY (status_key,status_target)
);