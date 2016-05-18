CREATE OR REPLACE TRIGGER pontis.TUB_PON_FLEX_ELEMS
                before insert on pontis.PON_FLEX_ELEMS for each row
                begin
                    select case when :new.FLEXELEMID is null then S_PON_FLEX_ELEMS.nextval else :new.FLEXELEMID end into :new.FLEXELEMID from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/