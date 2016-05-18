CREATE OR REPLACE TRIGGER pontis.TAUR_UINSP_BRINSPFREQ
   AFTER UPDATE OF brinspfreq_kdot
   ON pontis.userinsp
   FOR EACH ROW
/*
----------------------------------------------------------------------------------------------------------------------------------------------
 -- Trigger: taur_uinsp_brinspfreq
 -- AUTO CALCULATE BRINSPFREQ for INSPEVNT from USERINSP.BRINSPFREQ_KDOT 
------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:
--  2006-01-18 Deb Kossler, needed the trigger to be able to update 99 to -1 in
--  the inspevnt table for KTA updates.  Used the osinspfreq trigger as a guide,
--  but left out the update to the inspevnt required field.
-----------------------------------------------------------------------------------------------------------------------------------------

-- (c) 2001, 2002 Copyright: Cambridge Systematics, Inc, Asset Management Group: All Rights Reserved
-- No distribution without express written permission of Cambridge Systematics, Inc., Cambridge MA

--    Cambridge Systematics
--    150 CambridgePark Drive, Suite 4000
--    Cambridge MA 02140
--    Phone: 617-354-0167
--    Fax:   616-354-1542
--    http://www.camsys.com
---------------------------------------------------------------------------------------------------------------------------------------------------
*/
   
    -- ARM 6/11/2002 - only fire if changed or set to NULL
   -- allow for set to null, which would mean the first comparison below would be indeterminate (FALSE).

   
 
  DISABLE WHEN (   (NEW.brinspfreq_kdot <> OLD.brinspfreq_kdot)
         OR NEW.brinspfreq_kdot IS NULL
        ) DECLARE
   
-- ARM 6/11/2002
-- Target variable for assigning KDOT decimal years to Pontis NBI months
   v_insp_freq_months   PLS_INTEGER; -- big to hold result, set to 99 if too large.
   
/*
--  get a default from coptions BRINSPFREQ if necessary
 function f_get_pontis_coption_value (opt_name in pontis.coptions.optionname%type)
      return pontis.coptions.optionval%type
   is
      ls_result   pontis.coptions.optionval%type;
*/
-- will be 24 if null returned from ksbms_pontis.util.f_get_pontis_coption_value()
-- COPTION  DEFbrinspfreq is defined in the Pontis 4.0 Technical Manual
-- Also OSINSPREQ will be Y if positive months are passed, N if NULL or 0 or negative months are passed
   v_default_months     inspevnt.brinspfreq%TYPE
   := NVL (
         ksbms_pontis_util.f_get_pontis_coption_value ('DEFbrinspfreq'),
         24
      ); -- INTEGER, 2 digits
BEGIN
   
    
--  ARM 6/11/2002
-- Explicit range check - must fit into 2 digits, must be > 0 and <=99   
--  if 0 months or negative, then set target to NULL e.g. -1 makes it NULL
      IF :NEW.brinspfreq_kdot IS NOT NULL
      THEN
         IF :NEW.brinspfreq_kdot <= 0
         THEN -- assume set to missing value e.g. -1, so set to NULL in target variable
            v_insp_freq_months := NULL;
         ELSE --:NEW.brinspfreq_kdot > 0
             -- ROUND TO NEAREST WHOLE, CONVERT TO INTEGER
             -- default months will be used if expression :NEW.brinspfreq_KDOT *  12.0 is NULL
            -- range limit check - multiply years times 12 to see if > 99
            -- ARM revised per Deb testing 6/11/2002

            -- calculate it
            v_insp_freq_months := TRUNC (
                                     ROUND (
                                        NVL (
                                           :NEW.brinspfreq_kdot * 12.0,
                                           v_default_months
                                        ),
                                        0
                                     )
                                  );

            -- might be > 99 months, so set to 99 
            IF v_insp_freq_months > 99
            THEN
               --ARM 6/11/2002
               v_insp_freq_months := -1; -- hard coded to identify bogus scheduling months
            END IF;

         END IF;

         
--               When changed to  a good months value, sets OSINSPREQ to 'Y' per NBI as well (maybe a  phony change if just changing frequency, but harmless)
         UPDATE inspevnt
            SET brinspfreq = v_insp_freq_months
          WHERE inspevnt.brkey = :OLD.brkey
            AND inspevnt.inspkey = :OLD.inspkey;
      ELSE 
      
         UPDATE inspevnt
            SET brinspfreq = NULL -- 'blank' per NBI
          WHERE inspevnt.brkey = :OLD.brkey
            AND inspevnt.inspkey = :OLD.inspkey;
            
      END IF;

END TAUR_UINSP_brinspfreq;
/