CREATE OR REPLACE TRIGGER pontis.TUB_PON_BENEFIT_GROUPS
                before insert on pontis.PON_BENEFIT_GROUPS for each row
                begin
                    select case when :new.BENEFIT_GROUP_ID is null then S_PON_BENEFIT_GROUPS.nextval else :new.BENEFIT_GROUP_ID end into :new.BENEFIT_GROUP_ID from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/