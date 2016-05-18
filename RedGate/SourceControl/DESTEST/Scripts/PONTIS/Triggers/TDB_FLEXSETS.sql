CREATE OR REPLACE TRIGGER pontis.TDB_FLEXSETS before delete
on pontis.FLEXSETS for each row




DISABLE declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of DeleteParentRestrict constraint for "SCENARIO"
    cursor cfk1_scenario(var_fxsetkey scenario.fxsetkey%TYPE) is
       select 1
       from   SCENARIO
       where  FXSETKEY = var_fxsetkey
        and   var_fxsetkey is not null;

begin
    --  Cannot delete parent "FLEXSETS" if children still exist in "SCENARIO"
    open  cfk1_scenario(:old.FXSETKEY);
    fetch cfk1_scenario into dummy;
    found := cfk1_scenario%FOUND;
    close cfk1_scenario;
    if found then
        errno  := -20006;
        errmsg := 'Children still exist in "SCENARIO". Cannot delete parent "FLEXSETS".';
        raise integrity_error;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/