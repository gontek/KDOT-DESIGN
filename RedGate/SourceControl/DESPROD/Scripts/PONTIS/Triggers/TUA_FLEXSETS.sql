CREATE OR REPLACE TRIGGER pontis.TUA_FLEXSETS after update
of FXSETKEY
on pontis.FLEXSETS for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
    IntegrityPackage.NextNestLevel;
    --  Modify parent code of "FLEXSETS" for all children in "SCENARIO"
    if (updating('FXSETKEY') and :old.FXSETKEY != :new.FXSETKEY) then
       update SCENARIO
        set   FXSETKEY = :new.FXSETKEY
       where  FXSETKEY = :old.FXSETKEY;
    end if;

    --  Modify parent code of "FLEXSETS" for all children in "FLEXACTIONS"
    if (updating('FXSETKEY') and :old.FXSETKEY != :new.FXSETKEY) then
       update FLEXACTIONS
        set   FXSETKEY = :new.FXSETKEY
       where  FXSETKEY = :old.FXSETKEY;
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