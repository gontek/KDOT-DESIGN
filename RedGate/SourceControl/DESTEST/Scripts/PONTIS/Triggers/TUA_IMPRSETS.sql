CREATE OR REPLACE TRIGGER pontis.TUA_IMPRSETS after update
of IMKEY
on pontis.IMPRSETS for each row




DISABLE declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
    IntegrityPackage.NextNestLevel;
    --  Modify parent code of "IMPRSETS" for all children in "SCENARIO"
    if (updating('IMKEY') and :old.IMKEY != :new.IMKEY) then
       update SCENARIO
        set   IMKEY = :new.IMKEY
       where  IMKEY = :old.IMKEY;
    end if;

    --  Modify parent code of "IMPRSETS" for all children in "IMPRMTRX"
    if (updating('IMKEY') and :old.IMKEY != :new.IMKEY) then
       update IMPRMTRX
        set   IMKEY = :new.IMKEY
       where  IMKEY = :old.IMKEY;
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