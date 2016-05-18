CREATE TABLE ksbms_robot.ds_transfer_key_types (
  transfer_key_map_id NUMBER(*,0) NOT NULL,
  remarks VARCHAR2(255 BYTE),
  CONSTRAINT pk_ds_transfer_key_types PRIMARY KEY (transfer_key_map_id)
);