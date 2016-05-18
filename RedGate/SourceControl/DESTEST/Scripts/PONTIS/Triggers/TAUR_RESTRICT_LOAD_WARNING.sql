CREATE OR REPLACE Trigger pontis.TAUR_RESTRICT_LOAD_WARNING
  after update of restrict_load on pontis.userbrdg
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_RESTRICT_LOAD_WARNING
-- After update trigger to Bridge Eval staff that load restriction on a structure
-- was changed
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2009.08.26 Added to the project by Deb KDOT
-----------------------------------------------------------------------------------------------------------------------------------------

  
when (nvl( new.RESTRICT_LOAD, -9 ) <>  nvl( old.RESTRICT_LOAD, -9 ) )
declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION; 
   ls_user                paramtrs.longdesc%type;
        
begin
   -- new code
  IF Ksbms_Util.f_Numbers_Differ(Nvl(:Old.RESTRICT_LOAD, -9),
                                 Nvl(:New.RESTRICT_LOAD, -9),
                                 -- use the next function to load the tolerances from 
                                 -- the table Ds_Transfer_Delta_Tolerances
                                 Ksbms_Util.f_Get_Delta_Tolerance(Ptab => 'userbrdg',
                                                                  Pcol => 'RESTRICT_LOAD'),
                                 FALSE) = FALSE THEN
    RETURN; -- not a real change
  END IF;
  -- end change  
     -- Get appropriate email list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_BRIDGEEVAL_PERSONNEL'),'deb@ksdot.org');
     ls_user := pontis.f_get_username;
       
     -- send deleted attachment statement as mail message
     
       if ksbms_util.f_email( ls_email_list, 'A load restriction for structure '||:old.brkey||' was changed by user '|| ls_user || ' on ' || to_char(sysdate)||'.  Bob please also change Agency/Inspection/Structure/Posted Status from OPEN(1) to POSTED OTHER(8).', 'ATTENTION: A load restriction was changed for Bridge '||:old.brkey ) then 
            raise lex_email_failed;    
     
     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger taur_restrict_load_warning failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger taur_restrict_load_warning failed');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger taur_restrict_load_warning failed');

end taur_restrict_load_warning;
/