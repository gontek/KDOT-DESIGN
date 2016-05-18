CREATE OR REPLACE TRIGGER pontis.TUA_BUDGSETS after update
of BUKEY
on pontis.BUDGSETS for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
    IntegrityPackage.NextNestLevel;
    --  Modify parent code of "BUDGSETS" for all children in "SCENARIO"
    if (updating('BUKEY') and :old.BUKEY != :new.BUKEY) then
       update SCENARIO
        set   BUKEY = :new.BUKEY
       where  BUKEY = :old.BUKEY;
    end if;

    --  Modify parent code of "BUDGSETS" for all children in "BUDGMTRX"
    if (updating('BUKEY') and :old.BUKEY != :new.BUKEY) then
       update BUDGMTRX
        set   BUKEY = :new.BUKEY
       where  BUKEY = :old.BUKEY;
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