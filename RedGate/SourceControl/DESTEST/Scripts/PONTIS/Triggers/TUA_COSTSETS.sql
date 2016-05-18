CREATE OR REPLACE TRIGGER pontis.TUA_COSTSETS after update
of COKEY
on pontis.COSTSETS for each row




DISABLE declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
    IntegrityPackage.NextNestLevel;
    --  Modify parent code of "COSTSETS" for all children in "SCENARIO"
    if (updating('COKEY') and :old.COKEY != :new.COKEY) then
       update SCENARIO
        set   COKEY = :new.COKEY
       where  COKEY = :old.COKEY;
    end if;

    --  Modify parent code of "COSTSETS" for all children in "COSTMTRX"
    if (updating('COKEY') and :old.COKEY != :new.COKEY) then
       update COSTMTRX
        set   COKEY = :new.COKEY
       where  COKEY = :old.COKEY;
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