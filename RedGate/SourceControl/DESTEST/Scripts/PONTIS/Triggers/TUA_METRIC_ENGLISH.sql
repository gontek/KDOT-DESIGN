CREATE OR REPLACE TRIGGER pontis.TUA_METRIC_ENGLISH after update
of PAIRCODE
on pontis.METRIC_ENGLISH for each row




DISABLE declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
    IntegrityPackage.NextNestLevel;
    --  Modify parent code of "METRIC_ENGLISH" for all children in "ELEMDEFS"
    if (updating('PAIRCODE') and :old.PAIRCODE != :new.PAIRCODE) then
       update ELEMDEFS
        set   PAIRCODE = :new.PAIRCODE
       where  PAIRCODE = :old.PAIRCODE;
    end if;

    --  Modify parent code of "METRIC_ENGLISH" for all children in "DATADICT"
    if (updating('PAIRCODE') and :old.PAIRCODE != :new.PAIRCODE) then
       update DATADICT
        set   PAIRCODE = :new.PAIRCODE
       where  PAIRCODE = :old.PAIRCODE;
    end if;

    --  Modify parent code of "METRIC_ENGLISH" for all children in "ACTYPDFS"
    if (updating('PAIRCODE') and :old.PAIRCODE != :new.PAIRCODE) then
       update ACTYPDFS
        set   PAIRCODE = :new.PAIRCODE
       where  PAIRCODE = :old.PAIRCODE;
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