CREATE OR REPLACE TRIGGER pontis.TIUB_MULTIMEDIA_RI before insert or update
on pontis.MULTIMEDIA for each row


DISABLE declare
  badcontext_type_error exception;
  integrity_error exception;
  errno  integer;
  errmsg char(200);
  dummy  integer;
  found  boolean;
  --  Declaration of InsertChildParentExist constraint for the parent "BRIDGE"

  cursor cpk1_MULTIMEDIA(var_docrefkey MULTIMEDIA.DOCREFKEY%TYPE) is
    select 1
      from BRIDGE
     where DOCREFKEY = var_DOCREFKEY and var_DOCREFKEY is not null;
     
     
  --  Declaration of InsertChildParentExist constraint for the parent "INSPEVNT"
  cursor cpk2_MULTIMEDIA(var_DOCREFKEY MULTIMEDIA.DOCREFKEY%TYPE) is
    select 1
      from INSPEVNT
     where DOCREFKEY = var_DOCREFKEY  and
           var_DOCREFKEY is not null;
BEGIN
   
  -- 7/25/2003 - allowed CONTEXT - BRIDGE/INSPECTION - extend IFstatement if NEW contexts are supported, use CASE statement if 9i database
  <<choose_context>>
 IF :new.context =  'BRIDGE' THEN
        --  Parent "BRIDGE" DOCREFKEY must exist when inserting a child in "MULTIMEDIA"
        if :new.DOCREFKEY is not null then
          open cpk1_MULTIMEDIA(:new.DOCREFKEY);
          fetch cpk1_MULTIMEDIA
            into dummy;
          found := cpk1_MULTIMEDIA%FOUND;
          close cpk1_MULTIMEDIA;
          if not found then
            errno  := -20002;
            errmsg := 'Parent with DOCREFKEY = ' || :new.DOCREFKEY ||
                      ' does not exist in "BRIDGE". Cannot create child in "MULTIMEDIA".';
            raise integrity_error;
          end if;
        end if;
  ELSIF :new.context =  'INSPECTION' THEN
        --  Parent "INSPEVNT" DOCREFKEY must exist when inserting a child in "MULTIMEDIA"
        if :new.DOCREFKEY is not null  then
          open cpk2_MULTIMEDIA(:new.DOCREFKEY);
          fetch cpk2_MULTIMEDIA
            into dummy;
          found := cpk2_MULTIMEDIA%FOUND;
          close cpk2_MULTIMEDIA;
          if not found then
            errno  := -20002;
            errmsg := 'Parent with DOCREFKEY = ' || :new.DOCREFKEY ||
                      ' does not exist in "INSPEVNT". Cannot create child in "MULTIMEDIA".';
            raise integrity_error;
          end if;
        end if;
    ELSE
      -- BAD CONTEXT!!!
      errno  := -20002; -- generic number
      errmsg := 'Bad context type ='|| :new.context ||' for new "MULTIMEDIA" record.  Cannot create child in "MULTIMEDIA" - set CONTEXT to legal value';
      raise badcontext_type_error;
  END IF;

  --  Errors handling
exception

  when badcontext_type_error then
    raise_application_error(errno, errmsg);
  when integrity_error then
    raise_application_error(errno, errmsg);
  when others then
    -- report SQL error
    raise_application_error(sqlcode, sqlerrm);
  
end TIUB_MULTIMEDIA_RI;
/