CREATE OR REPLACE TRIGGER pontis.TUB_DATADICT before update
of TABLE_NAME,
   COL_NAME,
   PAIRCODE
on pontis.DATADICT for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    seq NUMBER;
    --  Declaration of UpdateChildParentExist constraint for the parent "METRIC_ENGLISH"
    cursor cpk1_datadict(var_paircode datadict.paircode%TYPE) is
       select 1
       from   METRIC_ENGLISH
       where  PAIRCODE = var_paircode
        and   var_paircode is not null;

begin
    seq := IntegrityPackage.GetNestLevel;
    --  Parent "METRIC_ENGLISH" must exist when updating a child in "DATADICT"
    if (:new.PAIRCODE is not null) and (seq = 0) then
       open  cpk1_datadict(:new.PAIRCODE);
       fetch cpk1_datadict into dummy;
       found := cpk1_datadict%FOUND;
       close cpk1_datadict;
       if not found then
        errno  := -20003;
        errmsg := 'Parent does not exist in "METRIC_ENGLISH". Cannot update child in "DATADICT".';
        raise integrity_error;
       end if;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/