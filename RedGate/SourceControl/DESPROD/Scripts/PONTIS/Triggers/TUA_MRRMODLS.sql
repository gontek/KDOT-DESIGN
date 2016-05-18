CREATE OR REPLACE TRIGGER pontis.TUA_MRRMODLS after update
of MOKEY
on pontis.MRRMODLS for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
    IntegrityPackage.NextNestLevel;
    --  Modify parent code of "MRRMODLS" for all children in "ACTMODLS"
    if (updating('MOKEY') and :old.MOKEY != :new.MOKEY) then
       update ACTMODLS
        set   MOKEY = :new.MOKEY
       where  MOKEY = :old.MOKEY;
    end if;

    --  Modify parent code of "MRRMODLS" for all children in "SCENARIO"
    if (updating('MOKEY') and :old.MOKEY != :new.MOKEY) then
       update SCENARIO
        set   MOKEY = :new.MOKEY
       where  MOKEY = :old.MOKEY;
    end if;

    --  Modify parent code of "MRRMODLS" for all children in "CONDUMDL"
    if (updating('MOKEY') and :old.MOKEY != :new.MOKEY) then
       update CONDUMDL
        set   MOKEY = :new.MOKEY
       where  MOKEY = :old.MOKEY;
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