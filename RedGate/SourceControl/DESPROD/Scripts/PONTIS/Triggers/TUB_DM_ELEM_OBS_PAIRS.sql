CREATE OR REPLACE TRIGGER pontis.TUB_DM_ELEM_OBS_PAIRS
                before insert on pontis.DM_ELEM_OBS_PAIRS for each row
                begin
                    select case when :new.PAIR_KEY is null then S_DM_ELEM_OBS_PAIRS.nextval else :new.PAIR_KEY end into :new.PAIR_KEY from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/