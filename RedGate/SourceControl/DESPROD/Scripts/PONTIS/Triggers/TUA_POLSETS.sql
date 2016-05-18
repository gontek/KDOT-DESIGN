CREATE OR REPLACE TRIGGER pontis.TUA_POLSETS after update
of POKEY
on pontis.POLSETS for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
    IntegrityPackage.NextNestLevel;
    --  Modify parent code of "POLSETS" for all children in "SCENARIO"
    if (updating('POKEY') and :old.POKEY != :new.POKEY) then
       update SCENARIO
        set   POKEY = :new.POKEY
       where  POKEY = :old.POKEY;
    end if;

    --  Modify parent code of "POLSETS" for all children in "POLMATRX"
    if (updating('POKEY') and :old.POKEY != :new.POKEY) then
       update POLMATRX
        set   POKEY = :new.POKEY
       where  POKEY = :old.POKEY;
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