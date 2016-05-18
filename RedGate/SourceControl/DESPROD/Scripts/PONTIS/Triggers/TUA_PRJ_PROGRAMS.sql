CREATE OR REPLACE TRIGGER pontis.TUA_PRJ_PROGRAMS after update
of PROGKEY
on pontis.PRJ_PROGRAMS for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
    IntegrityPackage.NextNestLevel;
    --  Modify parent code of "PRJ_PROGRAMS" for all children in "PROJECTS"
    if (updating('PROGKEY') and :old.PROGKEY != :new.PROGKEY) then
       update PROJECTS
        set   PROGKEY = :new.PROGKEY
       where  PROGKEY = :old.PROGKEY;
    end if;

    --  Modify parent code of "PRJ_PROGRAMS" for all children in "PRJ_PROGFUND"
    if (updating('PROGKEY') and :old.PROGKEY != :new.PROGKEY) then
       update PRJ_PROGFUND
        set   PROGKEY = :new.PROGKEY
       where  PROGKEY = :old.PROGKEY;
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