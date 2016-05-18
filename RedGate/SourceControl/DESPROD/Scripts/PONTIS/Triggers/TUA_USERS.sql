CREATE OR REPLACE TRIGGER pontis.TUA_USERS after update
of USERKEY
on pontis.USERS for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
    IntegrityPackage.NextNestLevel;
    --  Modify parent code of "USERS" for all children in "CICOCNTL"
    if (updating('USERKEY') and :old.USERKEY != :new.USERKEY) then
       update CICOCNTL
        set   USERKEY = :new.USERKEY
       where  USERKEY = :old.USERKEY;
    end if;

    --  Modify parent code of "USERS" for all children in "EXPCNDUC"
    if (updating('USERKEY') and :old.USERKEY != :new.USERKEY) then
       update EXPCNDUC
        set   USERKEY = :new.USERKEY
       where  USERKEY = :old.USERKEY;
    end if;

    --  Modify parent code of "USERS" for all children in "EXPCONDU"
    if (updating('USERKEY') and :old.USERKEY != :new.USERKEY) then
       update EXPCONDU
        set   USERKEY = :new.USERKEY
       where  USERKEY = :old.USERKEY;
    end if;

    --  Modify parent code of "USERS" for all children in "USEROLES"
    if (updating('USERKEY') and :old.USERKEY != :new.USERKEY) then
       update USEROLES
        set   USERKEY = :new.USERKEY
       where  USERKEY = :old.USERKEY;
    end if;

    IntegrityPackage.PreviousNestLevel;

--  Errors handling
exception
    when integrity_error then
       begin
       IntegrityPackage.InitNestLevel;
       raise_application_error(errno, errmsg);
       end;
end;
/