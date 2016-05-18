CREATE TABLE pontis.dbdescrp (
  db_id_key VARCHAR2(6 BYTE) NOT NULL,
  actdbrow CHAR NOT NULL,
  thisdbdescr VARCHAR2(255 BYTE),
  thisdbtime DATE,
  thisdbtype VARCHAR2(8 BYTE),
  units_of_measure VARCHAR2(2 BYTE),
  owner_db_id_key VARCHAR2(6 BYTE),
  ownerdesc VARCHAR2(255 BYTE),
  owneruser VARCHAR2(4 BYTE),
  ownertime DATE,
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  CONSTRAINT dbdescrp_pk PRIMARY KEY (db_id_key)
);
COMMENT ON TABLE pontis.dbdescrp IS 'Database description table -one row per database, contains unique db_id_key';
COMMENT ON COLUMN pontis.dbdescrp.db_id_key IS 'Unique database ID stamp - used to generate row identifier keys for the database';
COMMENT ON COLUMN pontis.dbdescrp.actdbrow IS 'Active database flag.  It is set to 1 for only one record in this table';
COMMENT ON COLUMN pontis.dbdescrp.thisdbtime IS 'Time this database was created';
COMMENT ON COLUMN pontis.dbdescrp.thisdbtype IS 'Type of database ex: Access, Oracle, etc.';
COMMENT ON COLUMN pontis.dbdescrp.units_of_measure IS 'Tracks storage units of measure for the database.  Field must never be changed after a database is established.  Agencies should impose strict update prevention on this field.  Default value=SI: Values=US, SI';
COMMENT ON COLUMN pontis.dbdescrp.owner_db_id_key IS 'If this database has an owner database, the contents of the owner tdb_id_key fie';
COMMENT ON COLUMN pontis.dbdescrp.ownerdesc IS 'If this database has an owner database, the contents of the owner thisdbdesc fie';
COMMENT ON COLUMN pontis.dbdescrp.owneruser IS 'Userkey of the creator of the owner db, if there is an owner db for this databas';
COMMENT ON COLUMN pontis.dbdescrp.ownertime IS 'Time the owner db for this database was created, if there is an owner db';
COMMENT ON COLUMN pontis.dbdescrp.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.dbdescrp.userkey IS 'Primary key to the users table. Key of user that last modified record.';