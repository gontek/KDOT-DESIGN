CREATE OR REPLACE TRIGGER pontis.TDB_BUDGSETS before delete
on pontis.BUDGSETS for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of DeleteParentRestrict constraint for "SCENARIO"
    cursor cfk1_scenario(var_bukey scenario.bukey%TYPE) is
       select 1
       from   SCENARIO
       where  BUKEY = var_bukey
        and   var_bukey is not null;

begin
    --  Cannot delete parent "BUDGSETS" if children still exist in "SCENARIO"
    open  cfk1_scenario(:old.BUKEY);
    fetch cfk1_scenario into dummy;
    found := cfk1_scenario%FOUND;
    close cfk1_scenario;
    if found then
        errno  := -20006;
        errmsg := 'Children still exist in "SCENARIO". Cannot delete parent "BUDGSETS".';
        raise integrity_error;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/