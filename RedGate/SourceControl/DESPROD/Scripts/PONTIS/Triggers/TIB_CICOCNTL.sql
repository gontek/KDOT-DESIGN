CREATE OR REPLACE TRIGGER pontis.TIB_CICOCNTL before insert
on pontis.CICOCNTL for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of InsertChildParentExist constraint for the parent "BRIDGE"

    cursor cpk1_cicocntl(var_brkey cicocntl.brkey%TYPE) is
       select 1
       from   BRIDGE
       where  BRKEY = var_brkey
        and   var_brkey is not null;
    --  Declaration of InsertChildParentExist constraint for the parent "USERS"

    cursor cpk2_cicocntl(var_userkey cicocntl.userkey%TYPE) is
       select 1
       from   USERS
       where  USERKEY = var_userkey
        and   var_userkey is not null;

begin
    --  Parent "BRIDGE" must exist when inserting a child in "CICOCNTL"
    if :new.BRKEY is not null then
       open  cpk1_cicocntl(:new.BRKEY);
       fetch cpk1_cicocntl into dummy;
       found := cpk1_cicocntl%FOUND;
                                    close cpk1_cicocntl;
                                    if not found then
                                     errno  := -20002;
                                     errmsg := 'Parent does not exist in "BRIDGE". Cannot create child in "CICOCNTL".';
                                     raise integrity_error;
                                    end if;
                                 end if;

                                 --  Parent "USERS" must exist when inserting a child in "CICOCNTL"
                                 if :new.USERKEY is not null then
                                    open  cpk2_cicocntl(:new.USERKEY);
                                    fetch cpk2_cicocntl into dummy;
                                    found := cpk2_cicocntl%FOUND;
       close cpk2_cicocntl;
       if not found then
        errno  := -20002;
        errmsg := 'Parent does not exist in "USERS". Cannot create child in "CICOCNTL".';
        raise integrity_error;
       end if;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/