CREATE OR REPLACE TRIGGER pontis.TUB_PON_DEFS_ASSESSMENT
                before insert on pontis.PON_DEFS_ASSESSMENT for each row
                begin
                    select case when :new.ASMTDEFKEY is null then S_PON_DEFS_ASSESSMENT.nextval else :new.ASMTDEFKEY end into :new.ASMTDEFKEY from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/