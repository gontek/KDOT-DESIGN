CREATE TABLE pontis.pon_exchange_option_detail (
  exchange_option_id NUMBER(38) NOT NULL,
  detail_id NUMBER(38) NOT NULL,
  table_name VARCHAR2(32 BYTE) NOT NULL,
  table_order_num NUMBER(38) NOT NULL,
  include_ind CHAR NOT NULL,
  CONSTRAINT pon_exchange_option_detail_pk PRIMARY KEY (exchange_option_id,detail_id),
  CONSTRAINT fk_detail_to_exchange_option FOREIGN KEY (exchange_option_id) REFERENCES pontis.pon_exchange_option (exchange_option_id) ON DELETE CASCADE
);