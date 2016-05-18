CREATE OR REPLACE TRIGGER pontis.TIB_SCENARIO before insert
on pontis.SCENARIO for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of InsertChildParentExist constraint for the parent "BUDGSETS"

    cursor cpk1_scenario(var_bukey scenario.bukey%TYPE) is
       select 1
       from   BUDGSETS
       where  BUKEY = var_bukey
        and   var_bukey is not null;
    --  Declaration of InsertChildParentExist constraint for the parent "COSTSETS"

    cursor cpk2_scenario(var_cokey scenario.cokey%TYPE) is
       select 1
       from   COSTSETS
       where  COKEY = var_cokey
        and   var_cokey is not null;
    --  Declaration of InsertChildParentExist constraint for the parent "IMPRSETS"

    cursor cpk3_scenario(var_imkey scenario.imkey%TYPE) is
       select 1
       from   IMPRSETS
       where  IMKEY = var_imkey
        and   var_imkey is not null;
    --  Declaration of InsertChildParentExist constraint for the parent "MRRMODLS"

    cursor cpk4_scenario(var_mokey scenario.mokey%TYPE) is
       select 1
       from   MRRMODLS
       where  MOKEY = var_mokey
        and   var_mokey is not null;
    --  Declaration of InsertChildParentExist constraint for the parent "POLSETS"

    cursor cpk5_scenario(var_pokey scenario.pokey%TYPE) is
       select 1
       from   POLSETS
       where  POKEY = var_pokey
        and   var_pokey is not null;
    --  Declaration of InsertChildParentExist constraint for the parent "SCOPESETS"

    cursor cpk6_scenario(var_scopesetkey scenario.scopesetkey%TYPE) is
       select 1
       from   SCOPESETS
       where  SCOPESETKEY = var_scopesetkey
        and   var_scopesetkey is not null;
    --  Declaration of InsertChildParentExist constraint for the parent "LKAHDSETS"

    cursor cpk7_scenario(var_lkahdsetkey scenario.lkahdsetkey%TYPE) is
       select 1
       from   LKAHDSETS
       where  LKAHDSETKEY = var_lkahdsetkey
        and   var_lkahdsetkey is not null;
    --  Declaration of InsertChildParentExist constraint for the parent "REHABSETS"

    cursor cpk8_scenario(var_rehabsetkey scenario.rehabsetkey%TYPE) is
       select 1
       from   REHABSETS
       where  REHABSETKEY = var_rehabsetkey
        and   var_rehabsetkey is not null;
    --  Declaration of InsertChildParentExist constraint for the parent "FLEXSETS"

    cursor cpk9_scenario(var_fxsetkey scenario.fxsetkey%TYPE) is
       select 1
       from   FLEXSETS
       where  FXSETKEY = var_fxsetkey
        and   var_fxsetkey is not null;

begin
    --  Parent "BUDGSETS" must exist when inserting a child in "SCENARIO"
    if :new.BUKEY is not null then
       open  cpk1_scenario(:new.BUKEY);
       fetch cpk1_scenario into dummy;
       found := cpk1_scenario%FOUND;
                                    close cpk1_scenario;
                                    if not found then
                                     errno  := -20002;
                                     errmsg := 'Parent does not exist in "BUDGSETS". Cannot create child in "SCENARIO".';
                                     raise integrity_error;
                                    end if;
                                 end if;

                                 --  Parent "COSTSETS" must exist when inserting a child in "SCENARIO"
                                 if :new.COKEY is not null then
                                    open  cpk2_scenario(:new.COKEY);
                                    fetch cpk2_scenario into dummy;
                                    found := cpk2_scenario%FOUND;
       close cpk2_scenario;
       if not found then
        errno  := -20002;
        errmsg := 'Parent does not exist in "COSTSETS". Cannot create child in "SCENARIO".';
        raise integrity_error;
       end if;
    end if;

    --  Parent "IMPRSETS" must exist when inserting a child in "SCENARIO"
    if :new.IMKEY is not null then
       open  cpk3_scenario(:new.IMKEY);
       fetch cpk3_scenario into dummy;
       found := cpk3_scenario%FOUND;
                                    close cpk3_scenario;
                                    if not found then
                                     errno  := -20002;
                                     errmsg := 'Parent does not exist in "IMPRSETS". Cannot create child in "SCENARIO".';
                                     raise integrity_error;
                                    end if;
                                 end if;

                                 --  Parent "MRRMODLS" must exist when inserting a child in "SCENARIO"
                                 if :new.MOKEY is not null then
                                    open  cpk4_scenario(:new.MOKEY);
                                    fetch cpk4_scenario into dummy;
                                    found := cpk4_scenario%FOUND;
       close cpk4_scenario;
       if not found then
        errno  := -20002;
        errmsg := 'Parent does not exist in "MRRMODLS". Cannot create child in "SCENARIO".';
        raise integrity_error;
       end if;
    end if;

    --  Parent "POLSETS" must exist when inserting a child in "SCENARIO"
    if :new.POKEY is not null then
       open  cpk5_scenario(:new.POKEY);
       fetch cpk5_scenario into dummy;
       found := cpk5_scenario%FOUND;
                                    close cpk5_scenario;
                                    if not found then
                                     errno  := -20002;
                                     errmsg := 'Parent does not exist in "POLSETS". Cannot create child in "SCENARIO".';
                                     raise integrity_error;
                                    end if;
                                 end if;

                                 --  Parent "SCOPESETS" must exist when inserting a child in "SCENARIO"
                                 if :new.SCOPESETKEY is not null then
                                    open  cpk6_scenario(:new.SCOPESETKEY);
                                    fetch cpk6_scenario into dummy;
                                    found := cpk6_scenario%FOUND;
       close cpk6_scenario;
       if not found then
        errno  := -20002;
        errmsg := 'Parent does not exist in "SCOPESETS". Cannot create child in "SCENARIO".';
        raise integrity_error;
       end if;
    end if;

    --  Parent "LKAHDSETS" must exist when inserting a child in "SCENARIO"
    if :new.LKAHDSETKEY is not null then
       open  cpk7_scenario(:new.LKAHDSETKEY);
       fetch cpk7_scenario into dummy;
       found := cpk7_scenario%FOUND;
                                    close cpk7_scenario;
                                    if not found then
                                     errno  := -20002;
                                     errmsg := 'Parent does not exist in "LKAHDSETS". Cannot create child in "SCENARIO".';
                                     raise integrity_error;
                                    end if;
                                 end if;

                                 --  Parent "REHABSETS" must exist when inserting a child in "SCENARIO"
                                 if :new.REHABSETKEY is not null then
                                    open  cpk8_scenario(:new.REHABSETKEY);
                                    fetch cpk8_scenario into dummy;
                                    found := cpk8_scenario%FOUND;
       close cpk8_scenario;
       if not found then
        errno  := -20002;
        errmsg := 'Parent does not exist in "REHABSETS". Cannot create child in "SCENARIO".';
        raise integrity_error;
       end if;
    end if;

    --  Parent "FLEXSETS" must exist when inserting a child in "SCENARIO"
    if :new.FXSETKEY is not null then
       open  cpk9_scenario(:new.FXSETKEY);
       fetch cpk9_scenario into dummy;
       found := cpk9_scenario%FOUND;
       close cpk9_scenario;
       if not found then
        errno  := -20002;
        errmsg := 'Parent does not exist in "FLEXSETS". Cannot create child in "SCENARIO".';
        raise integrity_error;
       end if;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/