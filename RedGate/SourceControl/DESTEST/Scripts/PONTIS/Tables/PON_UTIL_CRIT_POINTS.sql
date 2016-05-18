CREATE TABLE pontis.pon_util_crit_points (
  catkey NUMBER(6) NOT NULL,
  x VARCHAR2(6 BYTE) NOT NULL,
  y NUMBER(6) NOT NULL,
  CONSTRAINT pon_util_crit_points_pk PRIMARY KEY (catkey,x,y),
  CONSTRAINT fk_crit_category_key FOREIGN KEY (catkey) REFERENCES pontis.pon_util_crit_category (catkey)
);