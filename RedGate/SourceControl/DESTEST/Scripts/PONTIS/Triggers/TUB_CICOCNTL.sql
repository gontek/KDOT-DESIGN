CREATE OR REPLACE TRIGGER pontis.TUB_CICOCNTL before update
of BRKEY,
   IOFLAG,
   IOMOMENT,
   CICOID,
   USERKEY
on pontis.CICOCNTL for each row




DISABLE declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    seq NUMBER;
    --  Declaration of UpdateChildParentExist constraint for the parent "BRIDGE"
    cursor cpk1_cicocntl(var_brkey cicocntl.brkey%TYPE) is
       select 1
       from   BRIDGE
       where  BRKEY = var_brkey
        and   var_brkey is not null;
    --  Declaration of UpdateChildParentExist constraint for the parent "USERS"
    cursor cpk2_cicocntl(var_userkey cicocntl.userkey%TYPE) is
       select 1
       from   USERS
       where  USERKEY = var_userkey
        and   var_userkey is not null;

begin
    seq := IntegrityPackage.GetNestLevel;
    --  Parent "BRIDGE" must exist when updating a child in "CICOCNTL"
    if (:new.BRKEY is not null) and (seq = 0) then
       open  cpk1_cicocntl(:new.BRKEY);
       fetch cpk1_cicocntl into dummy;
       found := cpk1_cicocntl%FOUND;
                                    close cpk1_cicocntl;
                                    if not found then
                                     errno  := -20003;
                                     errmsg := 'Parent does not exist in "BRIDGE". Cannot update child in "CICOCNTL".';
                                     raise integrity_error;
                                    end if;
                                 end if;

                                 --  Parent "USERS" must exist when updating a child in "CICOCNTL"
                                 if (:new.USERKEY is not null) and (seq = 0) then
                                    open  cpk2_cicocntl(:new.USERKEY);
                                    fetch cpk2_cicocntl into dummy;
                                    found := cpk2_cicocntl%FOUND;
       close cpk2_cicocntl;
       if not found then
        errno  := -20003;
        errmsg := 'Parent does not exist in "USERS". Cannot update child in "CICOCNTL".';
        raise integrity_error;
       end if;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/