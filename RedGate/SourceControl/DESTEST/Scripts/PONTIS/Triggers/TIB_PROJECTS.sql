CREATE OR REPLACE TRIGGER pontis.TIB_PROJECTS before insert
on pontis.PROJECTS for each row




DISABLE declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of InsertChildParentExist constraint for the parent "PRJ_PROGRAMS"

    cursor cpk1_projects(var_progkey projects.progkey%TYPE) is
       select 1
       from   PRJ_PROGRAMS
       where  PROGKEY = var_progkey
        and   var_progkey is not null;

begin
    --  Parent "PRJ_PROGRAMS" must exist when inserting a child in "PROJECTS"
    if :new.PROGKEY is not null then
       open  cpk1_projects(:new.PROGKEY);
       fetch cpk1_projects into dummy;
       found := cpk1_projects%FOUND;
       close cpk1_projects;
       if not found then
        errno  := -20002;
        errmsg := 'Parent does not exist in "PRJ_PROGRAMS". Cannot create child in "PROJECTS".';
        raise integrity_error;
       end if;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/