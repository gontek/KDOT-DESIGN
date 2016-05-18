CREATE TABLE pontis.pbcatcol (
  pbc_tnam CHAR(31 BYTE) NOT NULL,
  pbc_tid NUMBER(10),
  pbc_ownr CHAR(31 BYTE) NOT NULL,
  pbc_cnam CHAR(31 BYTE) NOT NULL,
  pbc_cid NUMBER(5),
  pbc_labl VARCHAR2(254 BYTE),
  pbc_lpos NUMBER(5),
  pbc_hdr VARCHAR2(254 BYTE),
  pbc_hpos NUMBER(5),
  pbc_jtfy NUMBER(5),
  pbc_mask VARCHAR2(31 BYTE),
  pbc_case NUMBER(5),
  pbc_hght NUMBER(5),
  pbc_wdth NUMBER(5),
  pbc_ptrn VARCHAR2(31 BYTE),
  pbc_bmap CHAR,
  pbc_init VARCHAR2(254 BYTE),
  pbc_cmnt VARCHAR2(254 BYTE),
  pbc_edit VARCHAR2(31 BYTE),
  pbc_tag VARCHAR2(254 BYTE)
);