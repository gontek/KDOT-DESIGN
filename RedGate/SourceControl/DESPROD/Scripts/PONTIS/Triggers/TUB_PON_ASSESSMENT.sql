CREATE OR REPLACE TRIGGER pontis.TUB_PON_ASSESSMENT
                before insert on pontis.PON_ASSESSMENT for each row
                begin
                    select case when :new.ASMTKEY is null then S_PON_ASSESSMENT.nextval else :new.ASMTKEY end into :new.ASMTKEY from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/