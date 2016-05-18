CREATE OR REPLACE Trigger pontis.TAUR_UBRDG_POSTING_WARNING
  after update of posted_load_a,posted_load_b,posted_load_c on pontis.userbrdg
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_UBRDG_POSTING_WARNING
-- After update trigger to Bridge Eval staff that POSTING on a structure
-- was changed
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2009.08.26 Added to the project by Deb KDOT
-----------------------------------------------------------------------------------------------------------------------------------------
-- Generated 2002-02-26 at 09:26
  -- Updated by ARMarshall, ARM LLC 20150615 
  -- extend this to check for actually different values meeting or exceeding the tolerance percentage
  -- return immediately and don't send the warning.


  
when ((nvl( new.posted_load_a, -9 ) <>  nvl( old.posted_load_a, -9 ) ) or
      (nvl( new.posted_load_b, -9 ) <>  nvl( old.posted_load_b, -9 ) ) or
      (nvl( new.posted_load_c, -9 ) <>  nvl( old.posted_load_c, -9 ) ))
declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   ls_user                paramtrs.longdesc%type; 
begin
  
 -- new code
  IF Ksbms_Util.f_Numbers_Differ(Nvl(:Old.posted_load_a, -9),
                                 Nvl(:New.posted_load_a, -9),
                                 -- use the next function to load the tolerances from 
                                 -- the table Ds_Transfer_Delta_Tolerances
                                 Ksbms_Util.f_Get_Delta_Tolerance(Ptab => 'userbrdg',
                                                                  Pcol => 'posted_load_a'),
                                 FALSE) = FALSE THEN
    RETURN; -- not a real change
  END IF;
  
  IF Ksbms_Util.f_Numbers_Differ(Nvl(:Old.posted_load_b, -9),
                                 Nvl(:New.posted_load_b, -9),
                                 -- use the next function to load the tolerances from 
                                 -- the table Ds_Transfer_Delta_Tolerances
                                 Ksbms_Util.f_Get_Delta_Tolerance(Ptab => 'userbrdg',
                                                                  Pcol => 'posted_load_b'),
                                 FALSE) = FALSE THEN
    RETURN; -- not a real change
  END IF;
  
  IF Ksbms_Util.f_Numbers_Differ(Nvl(:Old.posted_load_c, -9),
                                 Nvl(:New.posted_load_c, -9),
                                 -- use the next function to load the tolerances from 
                                 -- the table Ds_Transfer_Delta_Tolerances
                                 Ksbms_Util.f_Get_Delta_Tolerance(Ptab => 'userbrdg',
                                                                  Pcol => 'posted_load_c'),
                                 FALSE) = FALSE THEN
    RETURN; -- not a real change
  END IF;
  -- end change 

     -- Get appropriate email list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_BRIDGEEVAL_PERSONNEL'),'deb@ksdot.org');
     ls_user := pontis.f_get_username;
       
     -- send deleted attachment statement as mail message
     
       if ksbms_util.f_email(
        ls_email_list,
         'A posting weight limit has changed for structure '
         ||:old.brkey
         ||' by user '
         || ls_user 
         || ' on ' 
         || to_char(sysdate)
         ||'.  Is this correct? Bob please also change Agency/Inspection/Structure/Posted Status from OPEN(1) to POSTED LOAD(7).', 
         'ATTENTION: A weight posting limitation has changed for Bridge '
         ||:old.brkey
 ) then 
   raise lex_email_failed;    
     
     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_UBRDG_POSTING_WARNING failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_UBRDG_POSTING_WARNING failed');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_UBRDG_POSTING_WARNING failed');

end TAUR_UBRDG_POSTING_WARNING;
/