CREATE TABLE pontis.pon_app_language_caption (
  caption_id NUMBER(38) NOT NULL,
  language_id NUMBER(38) NOT NULL,
  display_text NVARCHAR2(2000) NOT NULL,
  CONSTRAINT pon_app_language_caption_pk PRIMARY KEY (caption_id,language_id) DISABLE NOVALIDATE,
  CONSTRAINT fk_lang_caption_to_caption FOREIGN KEY (caption_id) REFERENCES pontis.pon_app_caption (caption_id) DISABLE NOVALIDATE,
  CONSTRAINT fk_lang_caption_to_language FOREIGN KEY (language_id) REFERENCES pontis.pon_app_language (language_id) DISABLE NOVALIDATE
);