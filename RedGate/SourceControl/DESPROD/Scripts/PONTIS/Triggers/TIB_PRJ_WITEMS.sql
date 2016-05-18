CREATE OR REPLACE TRIGGER pontis.TIB_PRJ_WITEMS before insert
on pontis.PRJ_WITEMS for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of InsertChildParentExist constraint for the parent "PROJECTS"

    cursor cpk1_prj_witems(var_projkey prj_witems.projkey%TYPE) is
       select 1
       from   PROJECTS
       where  PROJKEY = var_projkey
        and   var_projkey is not null;
    --  Declaration of InsertChildParentExist constraint for the parent "BRIDGE"

    cursor cpk2_prj_witems(var_brkey prj_witems.brkey%TYPE) is
       select 1
       from   BRIDGE
       where  BRKEY = var_brkey
        and   var_brkey is not null;
    --  Declaration of InsertChildParentExist constraint for the parent "STRUCTURE_UNIT"

-- 10-27-20000 RI BETWEEN PRJ_WITEMS AND STRUCTURE_UNIT REMOVED
--    cursor cpk3_prj_witems(var_brkey prj_witems.brkey%TYPE,
--                                              var_strunitkey prj_witems.strunitkey%TYPE) is
--       select 1
--       from   STRUCTURE_UNIT
--       where  BRKEY = var_brkey
--        and   STRUNITKEY = var_strunitkey
--        and   var_brkey is not null
--        and   var_strunitkey is not null;
    --  Declaration of InsertChildParentExist constraint for the parent "PRJ_FUNDSRC"

    cursor cpk4_prj_witems(var_fskey prj_witems.fskey%TYPE) is
       select 1
       from   PRJ_FUNDSRC
       where  FSKEY = var_fskey
        and   var_fskey is not null;

begin
    --  Parent "PROJECTS" must exist when inserting a child in "PRJ_WITEMS"
    if :new.PROJKEY is not null then
       open  cpk1_prj_witems(:new.PROJKEY);
       fetch cpk1_prj_witems into dummy;
       found := cpk1_prj_witems%FOUND;
                                      close cpk1_prj_witems;
                                      if not found then
                                       errno  := -20002;
                                       errmsg := 'Parent does not exist in "PROJECTS". Cannot create child in "PRJ_WITEMS".';
                                       raise integrity_error;
                                      end if;
                                   end if;

                                   --  Parent "BRIDGE" must exist when inserting a child in "PRJ_WITEMS"
                                   if :new.BRKEY is not null then
                                      open  cpk2_prj_witems(:new.BRKEY);
                                      fetch cpk2_prj_witems into dummy;
                                      found := cpk2_prj_witems%FOUND;
       close cpk2_prj_witems;
       if not found then
        errno  := -20002;
        errmsg := 'Parent does not exist in "BRIDGE". Cannot create child in "PRJ_WITEMS".';
        raise integrity_error;
       end if;
    end if;

    --  Parent "STRUCTURE_UNIT" must exist when inserting a child in "PRJ_WITEMS"
-- 10-27-20000 RI BETWEEN PRJ_WITEMS AND STRUCTURE_UNIT REMOVED
--    if :new.BRKEY is not null and
--       :new.STRUNITKEY is not null then
--       open  cpk3_prj_witems(:new.BRKEY,
--                      :new.STRUNITKEY);
--       fetch cpk3_prj_witems into dummy;
--       found := cpk3_prj_witems%FOUND;
--                                      close cpk3_prj_witems;
--                                      if not found then
--                                       errno  := -20002;
--                                       errmsg := 'Parent does not exist in "STRUCTURE_UNIT". Cannot create child in "PRJ_WITEMS".';
--                                       raise integrity_error;
--                                      end if;
--                                   end if;

                                   --  Parent "PRJ_FUNDSRC" must exist when inserting a child in "PRJ_WITEMS"
                                   if :new.FSKEY is not null then
                                      open  cpk4_prj_witems(:new.FSKEY);
                                      fetch cpk4_prj_witems into dummy;
                                      found := cpk4_prj_witems%FOUND;
       close cpk4_prj_witems;
       if not found then
        errno  := -20002;
        errmsg := 'Parent does not exist in "PRJ_FUNDSRC". Cannot create child in "PRJ_WITEMS".';
        raise integrity_error;
       end if;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/