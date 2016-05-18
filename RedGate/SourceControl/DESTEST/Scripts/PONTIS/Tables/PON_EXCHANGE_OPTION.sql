CREATE TABLE pontis.pon_exchange_option (
  exchange_option_id NUMBER(38) NOT NULL,
  option_name VARCHAR2(64 BYTE) NOT NULL,
  export_option_ind CHAR NOT NULL,
  checkout_option_ind CHAR NOT NULL,
  option_order_num NUMBER(38) NOT NULL,
  CONSTRAINT pon_exchange_option_pk PRIMARY KEY (exchange_option_id)
);