CREATE OR REPLACE TRIGGER pontis.TUB_EDITCHECK_SESSION_LOG
                before insert on pontis.EDITCHECK_SESSION_LOG for each row
                begin
                    select case when :new.LOGKEY is null then S_EDITCHECK_SESSION_LOG.nextval else :new.LOGKEY end into :new.LOGKEY from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/