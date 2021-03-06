CREATE OR REPLACE TRIGGER pontis.TDB_MRRMODLS before delete
on pontis.MRRMODLS for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of DeleteParentRestrict constraint for "SCENARIO"
    cursor cfk1_scenario(var_mokey scenario.mokey%TYPE) is
       select 1
       from   SCENARIO
       where  MOKEY = var_mokey
        and   var_mokey is not null;

begin
    --  Cannot delete parent "MRRMODLS" if children still exist in "SCENARIO"
    open  cfk1_scenario(:old.MOKEY);
    fetch cfk1_scenario into dummy;
    found := cfk1_scenario%FOUND;
    close cfk1_scenario;
    if found then
        errno  := -20006;
        errmsg := 'Children still exist in "SCENARIO". Cannot delete parent "MRRMODLS".';
        raise integrity_error;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/