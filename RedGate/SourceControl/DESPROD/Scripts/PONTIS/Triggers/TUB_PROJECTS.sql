CREATE OR REPLACE TRIGGER pontis.TUB_PROJECTS before update
of PROJKEY,
   PROGKEY
on pontis.PROJECTS for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    seq NUMBER;
    --  Declaration of UpdateChildParentExist constraint for the parent "PRJ_PROGRAMS"
    cursor cpk1_projects(var_progkey projects.progkey%TYPE) is
       select 1
       from   PRJ_PROGRAMS
       where  PROGKEY = var_progkey
        and   var_progkey is not null;

begin
    seq := IntegrityPackage.GetNestLevel;
    --  Parent "PRJ_PROGRAMS" must exist when updating a child in "PROJECTS"
    if (:new.PROGKEY is not null) and (seq = 0) then
       open  cpk1_projects(:new.PROGKEY);
       fetch cpk1_projects into dummy;
       found := cpk1_projects%FOUND;
       close cpk1_projects;
       if not found then
        errno  := -20003;
        errmsg := 'Parent does not exist in "PRJ_PROGRAMS". Cannot update child in "PROJECTS".';
        raise integrity_error;
       end if;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/