CREATE TABLE pontis.pon_app_group_access_filters (
  groupkey NUMBER(38) NOT NULL,
  filterkey NUMBER(38) NOT NULL,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT pon_app_group_access_filter_pk PRIMARY KEY (groupkey,filterkey) DISABLE NOVALIDATE,
  CONSTRAINT fk_grg_filters_604_grps FOREIGN KEY (groupkey) REFERENCES pontis.pon_app_groups (groupkey) ON DELETE CASCADE DISABLE NOVALIDATE,
  CONSTRAINT fk_grp_filters_605_filters FOREIGN KEY (filterkey) REFERENCES pontis.pon_filters (filterkey) ON DELETE CASCADE DISABLE NOVALIDATE
);