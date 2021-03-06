CREATE OR REPLACE TRIGGER pontis.TUB_ELEMDEFS before update
of ELEMKEY,
   ECATKEY,
   ETYPKEY,
   MATLKEY,
   PAIRCODE
on pontis.ELEMDEFS for each row




declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    seq NUMBER;
    --  Declaration of UpdateChildParentExist constraint for the parent "ELTYPDFS"
    cursor cpk1_elemdefs(var_ecatkey elemdefs.ecatkey%TYPE,
                                                var_etypkey elemdefs.etypkey%TYPE) is
       select 1
       from   ELTYPDFS
       where  ECATKEY = var_ecatkey
        and   ETYPKEY = var_etypkey
        and   var_ecatkey is not null
        and   var_etypkey is not null;
    --  Declaration of UpdateChildParentExist constraint for the parent "MATDEFS"
    cursor cpk2_elemdefs(var_matlkey elemdefs.matlkey%TYPE) is
       select 1
       from   MATDEFS
       where  MATLKEY = var_matlkey
        and   var_matlkey is not null;
    --  Declaration of UpdateChildParentExist constraint for the parent "METRIC_ENGLISH"
    cursor cpk3_elemdefs(var_paircode elemdefs.paircode%TYPE) is
       select 1
       from   METRIC_ENGLISH
       where  PAIRCODE = var_paircode
        and   var_paircode is not null;

begin
    seq := IntegrityPackage.GetNestLevel;
    --  Parent "ELTYPDFS" must exist when updating a child in "ELEMDEFS"
    if (:new.ECATKEY is not null) and
       (:new.ETYPKEY is not null) and (seq = 0) then
       open  cpk1_elemdefs(:new.ECATKEY,
                      :new.ETYPKEY);
       fetch cpk1_elemdefs into dummy;
       found := cpk1_elemdefs%FOUND;
                                    close cpk1_elemdefs;
                                    if not found then
                                     errno  := -20003;
                                     errmsg := 'Parent does not exist in "ELTYPDFS". Cannot update child in "ELEMDEFS".';
                                     raise integrity_error;
                                    end if;
                                 end if;

                                 --  Parent "MATDEFS" must exist when updating a child in "ELEMDEFS"
                                 if (:new.MATLKEY is not null) and (seq = 0) then
                                    open  cpk2_elemdefs(:new.MATLKEY);
                                    fetch cpk2_elemdefs into dummy;
                                    found := cpk2_elemdefs%FOUND;
       close cpk2_elemdefs;
       if not found then
        errno  := -20003;
        errmsg := 'Parent does not exist in "MATDEFS". Cannot update child in "ELEMDEFS".';
        raise integrity_error;
       end if;
    end if;

    --  Parent "METRIC_ENGLISH" must exist when updating a child in "ELEMDEFS"
    if (:new.PAIRCODE is not null) and (seq = 0) then
       open  cpk3_elemdefs(:new.PAIRCODE);
       fetch cpk3_elemdefs into dummy;
       found := cpk3_elemdefs%FOUND;
       close cpk3_elemdefs;
       if not found then
        errno  := -20003;
        errmsg := 'Parent does not exist in "METRIC_ENGLISH". Cannot update child in "ELEMDEFS".';
        raise integrity_error;
       end if;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/