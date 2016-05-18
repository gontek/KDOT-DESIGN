CREATE OR REPLACE TRIGGER pontis.TAUR_UINSP_FCINSPFREQ
   AFTER UPDATE OF FCinspfreq_kdot
   ON pontis.userinsp
   FOR EACH ROW
/*
----------------------------------------------------------------------------------------------------------------------------------------------
 -- Trigger: taur_userinsp_FCinspfreq
 -- AUTO CALCULATE FCINSPFREQ and FCINSPREQ for INSPEVNT from USERINSP.FCINSPFREQ_KDOT ..
 -- sets FCINSPREQ (required) appropriately too, eliminating need for a separate trigger to do that.
------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:
--  2002.06.20      - Allen Marshall, CS - revised  FCINSPFREQ calculation trigger 
--  to follow logic of taur_userinsp_UWinspfreq per bug  #194
--  2001 Spring     - Rita Vaidya, CS -- Initial coding
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

   
 
  WHEN (   (NEW.FCinspfreq_kdot <> OLD.FCinspfreq_kdot)
         OR NEW.FCinspfreq_kdot IS NULL
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
-- COPTION  DEFFCINSPFREQ is defined in the Pontis 4.0 Technical Manual
-- Also FCINSPREQ will be Y if pFCitive months are passed, N if NULL or 0 or negative months are passed
   v_default_months     inspevnt.FCinspfreq%TYPE
   := NVL (
         ksbms_pontis_util.f_get_pontis_coption_value ('DEFFCINSPFREQ'),
         24
      ); -- INTEGER, 2 digits
   v_insprequired       inspevnt.FCinspreq%TYPE    := 'Y'; -- default is YES
BEGIN
   
    
--  ARM 6/11/2002
-- Explicit range check - must fit into 2 digits, must be > 0 and <=99   
--  if 0 months or negative, then set target to NULL e.g. -1 makes it NULL
      IF :NEW.FCinspfreq_kdot IS NOT NULL
      THEN
         IF :NEW.FCinspfreq_kdot <= 0
         THEN -- assume set to missing value e.g. -1, so set to NULL in target variable
            v_insp_freq_months := NULL;
            v_insprequired := 'N'; -- freq is null, so required must be N per NBI
         ELSE --:NEW.FCinspfreq_kdot > 0
             -- ROUND TO NEAREST WHOLE, CONVERT TO INTEGER
             -- default months will be used if expression :NEW.FCINSPFREQ_KDOT *  12.0 is NULL
            -- range limit check - multiply years times 12 to see if > 99
            -- ARM revised per Deb testing 6/11/2002

            -- calculate it
            v_insp_freq_months := TRUNC (
                                     ROUND (
                                        NVL (
                                           :NEW.FCinspfreq_kdot * 12.0,
                                           v_default_months
                                        ),
                                        0
                                     )
                                  );

            -- might be > 99 months, so set to 99 
            IF v_insp_freq_months > 99
            THEN
               --ARM 6/11/2002
               v_insp_freq_months := 99; -- hard coded to identify bogus scheduling months
            END IF;

            -- either for 99 or good value, the inspection is required
            v_insprequired := 'Y'; -- Freq is good, so required must be Y per NBI
         END IF;

         
--               When changed to  a good months value, sets FCINSPREQ to 'Y' per NBI as well (maybe a  phony change if just changing frequency, but harmless)
         UPDATE inspevnt
            SET FCinspfreq = v_insp_freq_months,
                FCinspreq = v_insprequired --  Y per NBI
          WHERE inspevnt.brkey = :OLD.brkey
            AND inspevnt.inspkey = :OLD.inspkey;
      ELSE -- :NEW.FCinspfreq_kdot IS NULL, target should be null, and 
         v_insprequired := 'N'; -- Freq is null, so required must be N per NBI

         
-- ARM 6/11/2002
--  new value IS NULL
--  when updated to NULL, assume this means don't do one, so recode to NBI specifications
-- Please note - auto-fixup of the related field FCINSPREQ.

         UPDATE inspevnt
            SET FCinspfreq = NULL, -- 'blank' per NBI
                FCinspreq = v_insprequired --  N per NBI
          WHERE inspevnt.brkey = :OLD.brkey
            AND inspevnt.inspkey = :OLD.inspkey;
      END IF;

END taur_uinsp_FCinspfreq;
-- OLD VERSION
/*create or replace trigger "PONTIS".TAUR_USERINSP_FCINSPFREQ

	AFTER UPDATE OF FCINSPFREQ_KDOT ON USERINSP

	FOR EACH ROW

	


DECLARE V_Insp_Freq_Years INSPEVNT.FCINSPFREQ%TYPE;

BEGIN

V_Insp_Freq_Years := :NEW.FCINSPFREQ_KDOT * 12.0;

UPDATE INSPEVNT
	SET FCINSPFREQ = V_Insp_Freq_Years
	WHERE
	INSPEVNT.BRKEY = :OLD.BRKEY and
	INSPEVNT.INSPKEY = :OLD.INSPKEY;

END TAUR_UINSP_FCINSPFREQ;
*/
/