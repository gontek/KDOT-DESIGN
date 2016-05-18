CREATE OR REPLACE TRIGGER pontis.TDB_METRIC_ENGLISH before delete
on pontis.METRIC_ENGLISH for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of DeleteParentRestrict constraint for "ELEMDEFS"
    cursor cfk1_elemdefs(var_paircode elemdefs.paircode%TYPE) is
       select 1
       from   ELEMDEFS
       where  PAIRCODE = var_paircode
        and   var_paircode is not null;
    --  Declaration of DeleteParentRestrict constraint for "DATADICT"
    cursor cfk2_datadict(var_paircode datadict.paircode%TYPE) is
       select 1
       from   DATADICT
       where  PAIRCODE = var_paircode
        and   var_paircode is not null;
    --  Declaration of DeleteParentRestrict constraint for "ACTYPDFS"
    cursor cfk3_actypdfs(var_paircode actypdfs.paircode%TYPE) is
       select 1
       from   ACTYPDFS
       where  PAIRCODE = var_paircode
        and   var_paircode is not null;

begin
    --  Cannot delete parent "METRIC_ENGLISH" if children still exist in "ELEMDEFS"
    open  cfk1_elemdefs(:old.PAIRCODE);
    fetch cfk1_elemdefs into dummy;
    found := cfk1_elemdefs%FOUND;
                              close cfk1_elemdefs;
                              if found then
                                  errno  := -20006;
                                  errmsg := 'Children still exist in "ELEMDEFS". Cannot delete parent "METRIC_ENGLISH".';
                                  raise integrity_error;
                              end if;

                              --  Cannot delete parent "METRIC_ENGLISH" if children still exist in "DATADICT"
                              open  cfk2_datadict(:old.PAIRCODE);
                              fetch cfk2_datadict into dummy;
                              found := cfk2_datadict%FOUND;
    close cfk2_datadict;
    if found then
        errno  := -20006;
        errmsg := 'Children still exist in "DATADICT". Cannot delete parent "METRIC_ENGLISH".';
        raise integrity_error;
    end if;

    --  Cannot delete parent "METRIC_ENGLISH" if children still exist in "ACTYPDFS"
    open  cfk3_actypdfs(:old.PAIRCODE);
    fetch cfk3_actypdfs into dummy;
    found := cfk3_actypdfs%FOUND;
    close cfk3_actypdfs;
    if found then
        errno  := -20006;
        errmsg := 'Children still exist in "ACTYPDFS". Cannot delete parent "METRIC_ENGLISH".';
        raise integrity_error;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/