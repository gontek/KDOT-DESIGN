CREATE OR REPLACE TRIGGER pontis.TDB_PRJ_FUNDSRC before delete
on pontis.PRJ_FUNDSRC for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of DeleteParentRestrict constraint for "PRJ_WITEMS"
    cursor cfk1_prj_witems(var_fskey prj_witems.fskey%TYPE) is
       select 1
       from   PRJ_WITEMS
       where  FSKEY = var_fskey
        and   var_fskey is not null;

begin
    --  Cannot delete parent "PRJ_FUNDSRC" if children still exist in "PRJ_WITEMS"
    open  cfk1_prj_witems(:old.FSKEY);
    fetch cfk1_prj_witems into dummy;
    found := cfk1_prj_witems%FOUND;
    close cfk1_prj_witems;
    if found then
        errno  := -20006;
        errmsg := 'Children still exist in "PRJ_WITEMS". Cannot delete parent "PRJ_FUNDSRC".';
        raise integrity_error;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/