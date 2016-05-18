CREATE OR REPLACE TRIGGER pontis.TUA_INSPEVNT after update
of BRKEY,
   INSPKEY
on pontis.INSPEVNT for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
begin
    IntegrityPackage.NextNestLevel;
    --  Modify parent code of "INSPEVNT" for all children in "ELEMINSP"
    if (updating('BRKEY') and :old.BRKEY != :new.BRKEY) or
       (updating('INSPKEY') and :old.INSPKEY != :new.INSPKEY) then
       update ELEMINSP
        set   BRKEY = :new.BRKEY,
              INSPKEY = :new.INSPKEY
       where  BRKEY = :old.BRKEY
        and   INSPKEY = :old.INSPKEY;
    end if;

    --  Modify parent code of "INSPEVNT" for all children in "INSP_WCAND"
    if (updating('BRKEY') and :old.BRKEY != :new.BRKEY) or
       (updating('INSPKEY') and :old.INSPKEY != :new.INSPKEY) then
       update INSP_WCAND
        set   BRKEY = :new.BRKEY,
              INSPKEY = :new.INSPKEY
       where  BRKEY = :old.BRKEY
        and   INSPKEY = :old.INSPKEY;
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