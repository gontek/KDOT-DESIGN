CREATE OR REPLACE TRIGGER pontis.TDB_SCOPESETS before delete
on pontis.SCOPESETS for each row




DISABLE declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of DeleteParentRestrict constraint for "SCENARIO"
    cursor cfk1_scenario(var_scopesetkey scenario.scopesetkey%TYPE) is
       select 1
       from   SCENARIO
       where  SCOPESETKEY = var_scopesetkey
        and   var_scopesetkey is not null;

begin
    --  Cannot delete parent "SCOPESETS" if children still exist in "SCENARIO"
    open  cfk1_scenario(:old.SCOPESETKEY);
    fetch cfk1_scenario into dummy;
    found := cfk1_scenario%FOUND;
    close cfk1_scenario;
    if found then
        errno  := -20006;
        errmsg := 'Children still exist in "SCENARIO". Cannot delete parent "SCOPESETS".';
        raise integrity_error;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/