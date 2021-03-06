CREATE OR REPLACE TRIGGER pontis.TAUR_UINSP_CRTCL_FIND_WARN
  after update of crtcl_find_date on pontis.userinsp
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_UINSP_CRTCL_FIND_WARN
-- An after update trigger to generate an e-mail process to alert staff of a critical find during inspection.
------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2004-03-12 Added to the project by Deb, KDOT
-----------------------------------------------------------------------------------------------------------------------------------------
  WHEN ( nvl(new.crtcl_find_date, TO_DATE( '1901-01-01','YYYY-MM-DD' ) ) <>  nvl( old.crtcl_find_date, TO_DATE( '1901-01-01','YYYY-MM-DD' ) ) ) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   ls_crtcl_find_date userinsp.crtcl_find_date%type;
   
       
begin
     -- Get EMAIL_CRTCL_FIND_WARN_LIST from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_CRTCL_FIND_LIST'),'deb@ksdot.org');
 
  
       if ksbms_util.f_email(
        ls_email_list, 
        'A critical finding was noted on '
        ||:new.crtcl_find_date
        ||' by user '
        || USER 
        ||' and the following recommended actions need to be addressed: '
        ||:new.crtcl_comments,
          'ATTENTION:  A Critical Finding has been noted during inspection for Bridge '
          ||:old.brkey
          ) 
THEN 
      RAISE lex_email_failed;
END IF;
              
               
 
   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_UINSP_CRTCL_FIND_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_UINSP_CRTCL_FIND_WARN');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_UINSP_CRTCL_FIND_WARN failed');

end TAUR_UINSP_CRTCL_FIND_WARN;
/