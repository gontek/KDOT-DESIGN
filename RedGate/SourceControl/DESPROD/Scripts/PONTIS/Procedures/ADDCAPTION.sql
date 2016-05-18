CREATE OR REPLACE procedure pontis.AddCaption(caption in varchar2, CAPTIONID out number)
        IS
            cnt number;
        BEGIN
            SELECT COUNT(1) INTO CNT FROM PON_APP_CAPTION WHERE DEFAULT_CAPTION = CAPTION AND ROWNUM = 1;
            if CNT <= 0 then
                SELECT MAX(CAPTION_ID) + 1 INTO CAPTIONID FROM PON_APP_CAPTION;
                if CAPTIONID IS NULL then
                    CAPTIONID := 1;
                END IF;
                insert into PON_APP_CAPTION values (CAPTIONID, caption, NULL, 'T');
                INSERT INTO PON_APP_LANGUAGE_CAPTION VALUES (CAPTIONID, 1, CAPTION);
            ELSE
              SELECT CAPTION_ID INTO CAPTIONID FROM PON_APP_CAPTION WHERE DEFAULT_CAPTION = CAPTION and rownum = 1;
            end if;
        end;
/