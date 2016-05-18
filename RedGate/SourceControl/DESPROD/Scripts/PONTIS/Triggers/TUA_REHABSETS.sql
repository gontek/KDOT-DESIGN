CREATE OR REPLACE TRIGGER pontis.TUA_REHABSETS after update
of REHABSETKEY
on pontis.REHABSETS for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
    IntegrityPackage.NextNestLevel;
    --  Modify parent code of "REHABSETS" for all children in "SCENARIO"
    if (updating('REHABSETKEY') and :old.REHABSETKEY != :new.REHABSETKEY) then
       update SCENARIO
        set   REHABSETKEY = :new.REHABSETKEY
       where  REHABSETKEY = :old.REHABSETKEY;
    end if;

    --  Modify parent code of "REHABSETS" for all children in "REHABRULE"
    if (updating('REHABSETKEY') and :old.REHABSETKEY != :new.REHABSETKEY) then
       update REHABRULE
        set   REHABSETKEY = :new.REHABSETKEY
       where  REHABSETKEY = :old.REHABSETKEY;
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