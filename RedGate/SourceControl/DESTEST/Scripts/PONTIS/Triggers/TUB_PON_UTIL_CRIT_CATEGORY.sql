CREATE OR REPLACE TRIGGER pontis.TUB_PON_UTIL_CRIT_CATEGORY
                before insert on pontis.PON_UTIL_CRIT_CATEGORY for each row
                begin
                    select case when :new.CATKEY is null then S_PON_UTIL_CRIT_CATEGORY.nextval else :new.CATKEY end into :new.CATKEY from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/