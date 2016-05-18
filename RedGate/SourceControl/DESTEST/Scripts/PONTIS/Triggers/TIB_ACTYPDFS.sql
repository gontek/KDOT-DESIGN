CREATE OR REPLACE TRIGGER pontis.TIB_ACTYPDFS before insert
on pontis.ACTYPDFS for each row




DISABLE declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of InsertChildParentExist constraint for the parent "METRIC_ENGLISH"

    cursor cpk1_actypdfs(var_paircode actypdfs.paircode%TYPE) is
       select 1
       from   METRIC_ENGLISH
       where  PAIRCODE = var_paircode
        and   var_paircode is not null;

begin
    --  Parent "METRIC_ENGLISH" must exist when inserting a child in "ACTYPDFS"
    if :new.PAIRCODE is not null then
       open  cpk1_actypdfs(:new.PAIRCODE);
       fetch cpk1_actypdfs into dummy;
       found := cpk1_actypdfs%FOUND;
       close cpk1_actypdfs;
       if not found then
        errno  := -20002;
        errmsg := 'Parent does not exist in "METRIC_ENGLISH". Cannot create child in "ACTYPDFS".';
        raise integrity_error;
       end if;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/