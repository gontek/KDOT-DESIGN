CREATE OR REPLACE TRIGGER pontis.TUB_ACTYPDFS before update
of TKEY,
   PAIRCODE
on pontis.ACTYPDFS for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    seq NUMBER;
    --  Declaration of UpdateChildParentExist constraint for the parent "METRIC_ENGLISH"
    cursor cpk1_actypdfs(var_paircode actypdfs.paircode%TYPE) is
       select 1
       from   METRIC_ENGLISH
       where  PAIRCODE = var_paircode
        and   var_paircode is not null;

begin
    seq := IntegrityPackage.GetNestLevel;
    --  Parent "METRIC_ENGLISH" must exist when updating a child in "ACTYPDFS"
    if (:new.PAIRCODE is not null) and (seq = 0) then
       open  cpk1_actypdfs(:new.PAIRCODE);
       fetch cpk1_actypdfs into dummy;
       found := cpk1_actypdfs%FOUND;
       close cpk1_actypdfs;
       if not found then
        errno  := -20003;
        errmsg := 'Parent does not exist in "METRIC_ENGLISH". Cannot update child in "ACTYPDFS".';
        raise integrity_error;
       end if;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/