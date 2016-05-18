CREATE OR REPLACE TRIGGER pontis.TUA_PRJ_FUNDSRC after update
of FSKEY
on pontis.PRJ_FUNDSRC for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
    IntegrityPackage.NextNestLevel;
    --  Modify parent code of "PRJ_FUNDSRC" for all children in "PRJ_PRJFUND"
    if (updating('FSKEY') and :old.FSKEY != :new.FSKEY) then
       update PRJ_PRJFUND
        set   FSKEY = :new.FSKEY
       where  FSKEY = :old.FSKEY;
    end if;

    --  Modify parent code of "PRJ_FUNDSRC" for all children in "PRJ_PROGFUND"
    if (updating('FSKEY') and :old.FSKEY != :new.FSKEY) then
       update PRJ_PROGFUND
        set   FSKEY = :new.FSKEY
       where  FSKEY = :old.FSKEY;
    end if;

    --  Modify parent code of "PRJ_FUNDSRC" for all children in "PRJ_WITEMS"
    if (updating('FSKEY') and :old.FSKEY != :new.FSKEY) then
       update PRJ_WITEMS
        set   FSKEY = :new.FSKEY
       where  FSKEY = :old.FSKEY;
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