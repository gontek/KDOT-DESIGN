CREATE OR REPLACE TRIGGER pontis.TDB_REHABSETS before delete
on pontis.REHABSETS for each row




DISABLE declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of DeleteParentRestrict constraint for "SCENARIO"
    cursor cfk1_scenario(var_rehabsetkey scenario.rehabsetkey%TYPE) is
       select 1
       from   SCENARIO
       where  REHABSETKEY = var_rehabsetkey
        and   var_rehabsetkey is not null;

begin
    --  Cannot delete parent "REHABSETS" if children still exist in "SCENARIO"
    open  cfk1_scenario(:old.REHABSETKEY);
    fetch cfk1_scenario into dummy;
    found := cfk1_scenario%FOUND;
    close cfk1_scenario;
    if found then
        errno  := -20006;
        errmsg := 'Children still exist in "SCENARIO". Cannot delete parent "REHABSETS".';
        raise integrity_error;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/