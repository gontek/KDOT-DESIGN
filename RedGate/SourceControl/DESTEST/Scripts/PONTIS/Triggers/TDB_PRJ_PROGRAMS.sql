CREATE OR REPLACE TRIGGER pontis.TDB_PRJ_PROGRAMS before delete
on pontis.PRJ_PROGRAMS for each row




DISABLE declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of DeleteParentRestrict constraint for "PROJECTS"
    cursor cfk1_projects(var_progkey projects.progkey%TYPE) is
       select 1
       from   PROJECTS
       where  PROGKEY = var_progkey
        and   var_progkey is not null;

begin
    --  Cannot delete parent "PRJ_PROGRAMS" if children still exist in "PROJECTS"
    open  cfk1_projects(:old.PROGKEY);
    fetch cfk1_projects into dummy;
    found := cfk1_projects%FOUND;
    close cfk1_projects;
    if found then
        errno  := -20006;
        errmsg := 'Children still exist in "PROJECTS". Cannot delete parent "PRJ_PROGRAMS".';
        raise integrity_error;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/