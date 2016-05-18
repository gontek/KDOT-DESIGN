CREATE OR REPLACE TRIGGER pontis.TIB_DATADICT before insert
on pontis.DATADICT for each row




DISABLE declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of InsertChildParentExist constraint for the parent "METRIC_ENGLISH"

    cursor cpk1_datadict(var_paircode datadict.paircode%TYPE) is
       select 1
       from   METRIC_ENGLISH
       where  PAIRCODE = var_paircode
        and   var_paircode is not null;

begin
    --  Parent "METRIC_ENGLISH" must exist when inserting a child in "DATADICT"
    if :new.PAIRCODE is not null then
       open  cpk1_datadict(:new.PAIRCODE);
       fetch cpk1_datadict into dummy;
       found := cpk1_datadict%FOUND;
       close cpk1_datadict;
       if not found then
        errno  := -20002;
        errmsg := 'Parent does not exist in "METRIC_ENGLISH". Cannot create child in "DATADICT".';
        raise integrity_error;
       end if;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/