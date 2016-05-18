CREATE OR REPLACE TRIGGER pontis.TUB_DM_COND_STATE_PAIRS
                before insert on pontis.DM_COND_STATE_PAIRS for each row
                begin
                    select case when :new.ITEM_KEY is null then S_DM_COND_STATE_PAIRS.nextval else :new.ITEM_KEY end into :new.ITEM_KEY from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/