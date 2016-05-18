CREATE OR REPLACE TRIGGER pontis.TUB_PON_FORMULAS
                before insert on pontis.PON_FORMULAS for each row
                begin
                    select case when :new.FORMULA_ID is null then S_PON_FORMULAS.nextval else :new.FORMULA_ID end into :new.FORMULA_ID from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/