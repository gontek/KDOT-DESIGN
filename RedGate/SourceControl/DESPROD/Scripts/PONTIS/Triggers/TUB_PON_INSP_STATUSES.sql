CREATE OR REPLACE TRIGGER pontis.TUB_PON_INSP_STATUSES
                before insert on pontis.PON_INSP_STATUSES for each row
                begin
                    select case when :new.STATUS_KEY is null then S_PON_INSP_STATUSES.nextval else :new.STATUS_KEY end into :new.STATUS_KEY from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/