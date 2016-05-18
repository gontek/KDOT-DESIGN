CREATE TABLE pontis.pon_flex_benefit (
  flexkey VARCHAR2(8 BYTE) NOT NULL,
  benefit_group_id NUMBER(38) NOT NULL,
  CONSTRAINT pon_flex_benefit_pk PRIMARY KEY (flexkey,benefit_group_id),
  CONSTRAINT fk_flex_benefit_bengrp FOREIGN KEY (benefit_group_id) REFERENCES pontis.pon_benefit_groups (benefit_group_id),
  CONSTRAINT fk_flex_benefit_flexkey FOREIGN KEY (flexkey) REFERENCES pontis.pon_flexactions_sets (flex_action_key)
);