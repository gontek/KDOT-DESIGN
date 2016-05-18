CREATE OR REPLACE TRIGGER pontis.TUB_PON_BRIDGE_GRPS
                before insert on pontis.PON_BRIDGE_GRPS for each row
                begin
                    select case when :new.GRPSKEY is null then S_PON_BRIDGE_GRPS.nextval else :new.GRPSKEY end into :new.GRPSKEY from dual;
                exception
                    when no_data_found then
                        null;
                    when others then
                        raise;
                end;
/