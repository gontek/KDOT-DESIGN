CREATE OR REPLACE TRIGGER pontis.TIUB_INSPEVNT_GEN_DOCREFKEY
  before insert or update on pontis.INSPEVNT
  for each row

DISABLE declare
  /*
  ======================================================================================================  
  TIUB_INSPEVNT_GEN_DOCREFKEY - PREUPDATE AND INSERT TRIGGER generates DOCREFKEY 
  for updated or inserted records on INSPEVNT
  ======================================================================================================
  -- REVISION HISTORY
  -- Created: 2003.06.06 - Allen R. Marshall, Cambridge Systematics, Inc.
  -- Initial Draft
  -- Revised: 2004.02.03 - Allen R. Marshall, Cambridge Systematics, Inc.
  -- uses a combination of BRKEY + INSPKEY + SYS_GUID() to generate DOCREFKEY values
  -- conveniently, this makes the DOCREFKEY searchable with wild cards to match a parent INSPEVNT record
  -- e.g. select from MULTIMEDIA WHERE DOCREFKEY LIKE BRKEY||INSPKEY||'%';
  -- Removed support for building DOCREFKEY from sequences.
  -- revised exception error messages
  -- if necessary, adjust constants for missing values in ls_missing_values to fixup more DOCREFKEY values
  -- NB - TRIGGER DOES NOT CHECK TO SEE IF THERE ARE DEPENDENT RECORDS IN MULTIMEDIA BEFORE CORRECTING PARENT
  ======================================================================================================
  */
  -- local variables here
  ls_dummy                INSPEVNT.DOCREFKEY%TYPE;
  ls_do_clientside_fixups COPTIONS.OPTIONVAL%TYPE;
  ls_missing_values       VARCHAR2(80) := '| |-1|-2|-3|-4|_|-|!|'; -- typical for Pontis, extend missings as necessary
 
  -- exceptions
  
  
  
  -- problems with generated DOCREFKEY
  DOCREFKEY_IS_NULL EXCEPTION;
  PRAGMA EXCEPTION_INIT(DOCREFKEY_IS_NULL, -20203);
  DOCREFKEY_EXISTS_ALREADY EXCEPTION;
  PRAGMA EXCEPTION_INIT(DOCREFKEY_EXISTS_ALREADY, -20204);
  -- must have the COPTION AUTOFIXUPDOCREFKEY set to something - row cannot be missing or error raised
  MISSING_COPTION EXCEPTION;
  PRAGMA EXCEPTION_INIT(MISSING_COPTION, -20205);-- good exception #s as of 2/4/2004 in Oracle 9i
   

begin

  -- See state of AUTOFIXUPDOCREFKEY, execute this trigger code if set to N or SERVER
  BEGIN
    <<OPTIONS_CHECK>>
  
    -- default is Y, fix on CLIENT SIDE, per Pontis convention - adjust as necessary
    -- we should never raise an exception here unless access to the COPTIONS table is not possible
    -- if that occurs,we use the WHEN OTHERS exception to trap the problem
     
    SELECT DISTINCT UPPER(NVL(OPTIONVAL, 'Y'))-- default of Y, uppercase result
      INTO ls_do_clientside_fixups
      FROM COPTIONS
     WHERE COPTIONS.OPTIONNAME = 'AUTOFIXDOCREFKEY';
     
     
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE MISSING_COPTION;
    WHEN OTHERS THEN
      RAISE;
  END OPTIONS_CHECK;

  if ls_do_clientside_fixups = 'N' or ls_do_clientside_fixups = 'SERVER' THEN
  
    -- fixup existing records without a docrefkey on the fly during UPDATE
    -- and generate a docrefkey for all new records
    -- the test is just to avoid overwriting a new DOCREFKEY passed from the application GUI
  
    -- step 1, generate new DOCREFKEY values for all new or updated records if necessary
    -- always generate if INSERTING, only fix if bad when UPDATING
    IF INSERTING OR 
       UPDATING AND (
       :new.DOCREFKEY IS NULL or 
       instr(ls_missing_values, '|' || TRIM(:new.DOCREFKEY) || '|', 1, 1) > 0 )
       THEN
      
      BEGIN
        <<INITIALIZE_DOCREFKEY>>
       /* Either a SEQUENCE number or a SYS_GUID() random string is an OK DOCREFKEY */
        /* Option 1 - Take the next sequence,  */
        /* Disabled by ALlen Marshall, CS - to enable, a sequence must be created and the code
        below that builds the DOCREFKEY by concatenation must be turned off
        */
        /*select S_GEN_NEW_PONTIS_DOCREFKEY.nextval
          into :new.DOCREFKEY
          from dual;*/
      
        /* Option 2 - Check again and if still null for some reason, take SYS_GUID() random stringset to SYS_GUID() if still null */
        
          SELECT :new.BRKEY||:new.INSPKEY||SYS_GUID() INTO :new.DOCREFKEY FROM DUAL;
      
        -- Give up, raise exception      
        IF :new.DOCREFKEY IS NULL THEN
          RAISE DOCREFKEY_IS_NULL;
        END IF;
      END INITIALIZE_DOCREFKEY;
  
    -- step 2, check that the new value is unique for the new record
    -- no record should be inserted or updated to conflict.
  
    BEGIN
      <<UNIQUE_CHECK>>
      SELECT DOCREFKEY
        INTO ls_dummy
        FROM INSPEVNT
       WHERE DOCREFKEY = :new.DOCREFKEY;
      IF ls_dummy IS NOT NULL THEN
        RAISE DOCREFKEY_EXISTS_ALREADY;
      END IF;
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
      
        NULL; -- do nothing
    
      WHEN OTHERS THEN
        -- propagate any errors including DOCREFKEY_EXISTS_ALREADY to the outer exception handler block
        RAISE;
    END UNIQUE_CHECK;
  
    END IF; -- DOCREFKEY IS BAD, SO FIX
  
  END IF; -- if ls_do_clientside_fixups = 'N' or ls_do_clientside_fixups = 'SERVER' THEN

EXCEPTION
 -- empty after all efforts
  WHEN DOCREFKEY_IS_NULL THEN
    BEGIN
      RAISE_APPLICATION_ERROR(-20203,
                              'Fatal: A new DOCREFKEY value could not be generated - Trigger TIUB_INSPEVNT_GEN_DOCREFKEY failed');
    END;
  -- duplicate somehow even though we are calling SYS_GUID()
  WHEN DOCREFKEY_EXISTS_ALREADY THEN
    BEGIN
      RAISE_APPLICATION_ERROR(-20204,
                              'Fatal: The new generated DOCREFKEY value exists in the database already - not unique - Trigger TIUB_INSPEVNT_GEN_DOCREFKEY failed');
    END;

  -- Pontis COPTION AUTOFIXUPDOCREFKEY is not accessible, probably because of table permission problems
  WHEN MISSING_COPTION THEN
    BEGIN
      RAISE_APPLICATION_ERROR(-20205,
                              'Fatal: The COPTION entry AUTOFIXDOCREFKEY is entirely missing from the database - check COPTIONS table access privileges.  Trigger TIUB_INSPEVNT_GEN_DOCREFKEY failed');
    END;
  
  WHEN OTHERS THEN
    BEGIN
      RAISE_APPLICATION_ERROR(-20299,
                              'Fatal: UNKNOWN ERROR condition occurred - Trigger TIUB_INSPEVNT_GEN_DOCREFKEY failed  ');
    END;
  
end TIUB_INSPEVNT_GEN_DOCREFKEY;
/