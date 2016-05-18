CREATE OR REPLACE TRIGGER pontis.TUB_PON_SESSION_BATCH
                before insert on pontis.PON_SESSION_BATCH for each row
                begin
                    select case when :new.PON_SESSION_BATCH_KEY is null then S_PON_SESSION_BATCH.nextval else :new.PON_SESSION_BATCH_KEY end into :new.PON_SESSION_BATCH_KEY from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/