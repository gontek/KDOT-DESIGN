CREATE OR REPLACE TRIGGER pontis.TUB_MULTIMEDIA
                before insert on pontis.MULTIMEDIA for each row
                begin
                    select case when :new.SEQUENCE is null then S_MULTIMEDIA.nextval else :new.SEQUENCE end into :new.SEQUENCE from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/