CREATE OR REPLACE TRIGGER pontis.TUB_PON_SESSION
                before insert on pontis.PON_SESSION for each row
                begin
                    select case when :new.PON_SESSION_KEY is null then S_PON_SESSION.nextval else :new.PON_SESSION_KEY end into :new.PON_SESSION_KEY from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/