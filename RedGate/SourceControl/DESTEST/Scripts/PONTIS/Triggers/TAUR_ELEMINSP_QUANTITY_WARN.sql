CREATE OR REPLACE TRIGGER pontis.TAUR_ELEMINSP_QUANTITY_WARN
  after insert or update of QUANTITY on pontis.ELEMINSP
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_ELEMINSP_QUANTITY_WARN
-- An after update trigger to let me know deck area needs to be updated
-----------------------------------------------------------------------------------------------------------------------------------------


--  2009-11-04 Added to the project by Deb, KDOT
-----------------------------------------------------------------------------------------------------------------------------------------
 
  DISABLE WHEN ( nvl(new.QUANTITY, -1 ) <>  nvl( old.QUANTITY, -1 ) ) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   
       
begin
     -- Get email_ratings_change_warn_list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_PONTIS_ADMINISTRATOR'),'deb@ksdot.org');
 
     -- specify conditions for email to be sent
 if ( :old.elemkey IN ('12', '13', '14', '18', '22', '26', '27', '28', '29', '30', '31', '32', 
     '38', '39', '40', '44', '48', '52', '53', '54', '55'))
  
 
   
   then
  
      -- send warning statement as mail message
     
       if ksbms_util.f_email( ls_email_list, 'A deck element quantity has changed from '||:old.quantity||' to ' ||:new.quantity||' for structure '||:old.brkey||' for element '|| :old.elemkey || ' on ' || to_char(sysdate)||'.  The bridge deck area might need to be recalculated and updated!', 'ATTENTION: A deck element quantity has been changed on '||:old.brkey||'!! Check the deck area data for this bridge.') then 
            raise lex_email_failed;
       end if;
    
   
     
    else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_ELEMINSP_QUANTITY_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_ELEMINSP_QUANTITY_WARN');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_ELEMINSP_QUANTITY_WARN failed');

end TAUR_ELEMINSP_QUANTITY_WARN;
/