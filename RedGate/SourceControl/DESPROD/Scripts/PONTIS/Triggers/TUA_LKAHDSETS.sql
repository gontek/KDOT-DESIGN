CREATE OR REPLACE TRIGGER pontis.TUA_LKAHDSETS after update
of LKAHDSETKEY
on pontis.LKAHDSETS for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
    IntegrityPackage.NextNestLevel;
    --  Modify parent code of "LKAHDSETS" for all children in "SCENARIO"
    if (updating('LKAHDSETKEY') and :old.LKAHDSETKEY != :new.LKAHDSETKEY) then
       update SCENARIO
        set   LKAHDSETKEY = :new.LKAHDSETKEY
       where  LKAHDSETKEY = :old.LKAHDSETKEY;
    end if;

    --  Modify parent code of "LKAHDSETS" for all children in "LKAHDRULE"
    if (updating('LKAHDSETKEY') and :old.LKAHDSETKEY != :new.LKAHDSETKEY) then
       update LKAHDRULE
        set   LKAHDSETKEY = :new.LKAHDSETKEY
       where  LKAHDSETKEY = :old.LKAHDSETKEY;
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