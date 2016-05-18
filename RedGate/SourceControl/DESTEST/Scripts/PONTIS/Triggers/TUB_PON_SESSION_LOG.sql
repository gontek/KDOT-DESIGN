CREATE OR REPLACE TRIGGER pontis.TUB_PON_SESSION_LOG
                before insert on pontis.PON_SESSION_LOG for each row
                begin
                    select case when :new.PON_SESSION_LOG_KEY is null then S_PON_SESSION_LOG.nextval else :new.PON_SESSION_LOG_KEY end into :new.PON_SESSION_LOG_KEY from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/