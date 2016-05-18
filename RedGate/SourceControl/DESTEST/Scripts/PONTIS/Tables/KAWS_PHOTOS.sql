CREATE TABLE pontis.kaws_photos (
  co_ser VARCHAR2(15 BYTE) NOT NULL,
  inspkey VARCHAR2(4 BYTE) NOT NULL,
  inspfirm VARCHAR2(24 BYTE) NOT NULL,
  "SEQUENCE" NUMBER(5) NOT NULL,
  photo_id VARCHAR2(24 BYTE),
  photodesc VARCHAR2(30 BYTE),
  photo_latitude FLOAT,
  photo_longitude FLOAT,
  photo_bearing FLOAT,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT pk_kaws_photos PRIMARY KEY (co_ser,inspkey,inspfirm,"SEQUENCE"),
  CONSTRAINT fk_k_insp_kaws_inspevnt FOREIGN KEY (co_ser,inspkey,inspfirm) REFERENCES pontis.kaws_inspevnt (co_ser,inspkey,inspfirm) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.kaws_photos.co_ser IS 'Structure ID used to connect photos to the structure, part of the primary key';
COMMENT ON COLUMN pontis.kaws_photos.inspkey IS 'Inspection ID used to connect to the inspection event, part of the primary key';
COMMENT ON COLUMN pontis.kaws_photos.inspfirm IS 'Inspection firm identifier (text or numerical or both) to tie photos to inspection event.';
COMMENT ON COLUMN pontis.kaws_photos."SEQUENCE" IS 'Sequence number for the photo, used to distinguish between multiple photos, part of the primary key';
COMMENT ON COLUMN pontis.kaws_photos.photo_id IS 'Photo number (text or numerical or both) for use by the inspectors to locate the photo in the file set.';
COMMENT ON COLUMN pontis.kaws_photos.photodesc IS 'Description of the photo';
COMMENT ON COLUMN pontis.kaws_photos.photo_latitude IS 'Latitude of Photo taken';
COMMENT ON COLUMN pontis.kaws_photos.photo_longitude IS 'Longitude of photo taken';
COMMENT ON COLUMN pontis.kaws_photos.photo_bearing IS 'Photo Compass Bearing';
COMMENT ON COLUMN pontis.kaws_photos.notes IS 'Any additional comments regarding the photo';