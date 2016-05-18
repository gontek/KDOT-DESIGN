CREATE TABLE pontis.pon_formula_categories (
  categoryid NUMBER(38) NOT NULL,
  parentcategoryid NUMBER(38),
  categoryname VARCHAR2(50 BYTE),
  description VARCHAR2(2000 BYTE),
  CONSTRAINT pon_formula_categories_pk PRIMARY KEY (categoryid)
);