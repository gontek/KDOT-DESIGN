CREATE OR REPLACE TRIGGER pontis.TUA_SCOPESETS after update
of SCOPESETKEY
on pontis.SCOPESETS for each row




DISABLE declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
    IntegrityPackage.NextNestLevel;
    --  Modify parent code of "SCOPESETS" for all children in "SCENARIO"
    if (updating('SCOPESETKEY') and :old.SCOPESETKEY != :new.SCOPESETKEY) then
       update SCENARIO
        set   SCOPESETKEY = :new.SCOPESETKEY
       where  SCOPESETKEY = :old.SCOPESETKEY;
    end if;

    --  Modify parent code of "SCOPESETS" for all children in "SCOPERULE"
    if (updating('SCOPESETKEY') and :old.SCOPESETKEY != :new.SCOPESETKEY) then
       update SCOPERULE
        set   SCOPESETKEY = :new.SCOPESETKEY
       where  SCOPESETKEY = :old.SCOPESETKEY;
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