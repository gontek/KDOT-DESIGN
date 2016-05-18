CREATE OR REPLACE TRIGGER pontis.TDB_USERS before delete
on pontis.USERS for each row




DISABLE declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of DeleteParentRestrict constraint for "CICOCNTL"
    cursor cfk1_cicocntl(var_userkey cicocntl.userkey%TYPE) is
       select 1
       from   CICOCNTL
       where  USERKEY = var_userkey
        and   var_userkey is not null;

begin
    --  Cannot delete parent "USERS" if children still exist in "CICOCNTL"
    open  cfk1_cicocntl(:old.USERKEY);
    fetch cfk1_cicocntl into dummy;
    found := cfk1_cicocntl%FOUND;
    close cfk1_cicocntl;
    if found then
        errno  := -20006;
        errmsg := 'Children still exist in "CICOCNTL". Cannot delete parent "USERS".';
        raise integrity_error;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/