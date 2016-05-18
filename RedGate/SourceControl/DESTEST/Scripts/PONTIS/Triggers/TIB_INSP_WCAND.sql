CREATE OR REPLACE TRIGGER pontis.TIB_INSP_WCAND before insert
on pontis.INSP_WCAND for each row




DISABLE declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    --  Declaration of InsertChildParentExist constraint for the parent "BRIDGE"

    cursor cpk1_insp_wcand(var_brkey insp_wcand.brkey%TYPE) is
       select 1
       from   BRIDGE
       where  BRKEY = var_brkey
        and   var_brkey is not null;
    --  Declaration of InsertChildParentExist constraint for the parent "STRUCTURE_UNIT"
--10/20/2000
-- RI between Structure_unit and Insp_wcand has been removed
--    cursor cpk2_insp_wcand(var_brkey insp_wcand.brkey%TYPE,
--                                              var_strunitkey insp_wcand.strunitkey%TYPE) is
--       select 1
--       from   STRUCTURE_UNIT
--       where  BRKEY = var_brkey
--        and   STRUNITKEY = var_strunitkey
--        and   var_brkey is not null
--        and   var_strunitkey is not null;
    --  Declaration of InsertChildParentExist constraint for the parent "INSPEVNT"

    cursor cpk3_insp_wcand(var_brkey insp_wcand.brkey%TYPE,
                                              var_inspkey insp_wcand.inspkey%TYPE) is
       select 1
       from   INSPEVNT
       where  BRKEY = var_brkey
        and   INSPKEY = var_inspkey
        and   var_brkey is not null
        and   var_inspkey is not null;

begin
    --  Parent "BRIDGE" must exist when inserting a child in "INSP_WCAND"
    if :new.BRKEY is not null then
       open  cpk1_insp_wcand(:new.BRKEY);
       fetch cpk1_insp_wcand into dummy;
       found := cpk1_insp_wcand%FOUND;
                                      close cpk1_insp_wcand;
                                      if not found then
                                       errno  := -20002;
                                       errmsg := 'Parent does not exist in "BRIDGE". Cannot create child in "INSP_WCAND".';
                                       raise integrity_error;
                                      end if;
                                   end if;

                                   --  Parent "STRUCTURE_UNIT" must exist when inserting a child in "INSP_WCAND"
--10/20/2000
-- RI between Structure_unit and Insp_wcand has been removed
--
--                                   if :new.BRKEY is not null and
--                                     :new.STRUNITKEY is not null then
--                                      open  cpk2_insp_wcand(:new.BRKEY,
--                                                     :new.STRUNITKEY);
--                                      fetch cpk2_insp_wcand into dummy;
--                                      found := cpk2_insp_wcand%FOUND;
--       close cpk2_insp_wcand;
--       if not found then
--        errno  := -20002;
--        errmsg := 'Parent does not exist in "STRUCTURE_UNIT". Cannot create child in "INSP_WCAND".';
--        raise integrity_error;
--       end if;
--  end if;

    --  Parent "INSPEVNT" must exist when inserting a child in "INSP_WCAND"
    if :new.BRKEY is not null and
       :new.INSPKEY is not null then
       open  cpk3_insp_wcand(:new.BRKEY,
                      :new.INSPKEY);
       fetch cpk3_insp_wcand into dummy;
       found := cpk3_insp_wcand%FOUND;
       close cpk3_insp_wcand;
       if not found then
        errno  := -20002;
        errmsg := 'Parent does not exist in "INSPEVNT". Cannot create child in "INSP_WCAND".';
        raise integrity_error;
       end if;
    end if;


--  Errors handling
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/