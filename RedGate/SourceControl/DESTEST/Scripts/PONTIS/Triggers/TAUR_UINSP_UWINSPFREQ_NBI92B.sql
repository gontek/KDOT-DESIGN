CREATE OR REPLACE TRIGGER pontis.taur_uinsp_uwinspfreq_NBI92B
  AFTER UPDATE OF uwinspfreq_kdot,uwater_insp_typ ON pontis.userinsp
  FOR EACH ROW

DISABLE DECLARE

  -- ARM 6/11/2002
  -- Target variable for assigning KDOT decimal years to Pontis NBI months
  v_insp_freq_months PLS_INTEGER; -- big to hold result, set to 99 if too large.

   v_default_months inspevnt.uwinspfreq%TYPE := NVL(ksbms_pontis_util.f_get_pontis_coption_value('DEFUWINSPFREQ'),
                                                   -1); -- INTEGER, 2 digits
  v_insprequired   inspevnt.uwinspreq%TYPE := 'N'; -- default is YES
BEGIN

  -- ARM 6/11/2002 per Deb Kossler business rule (from Mitch Sothers)
  -- exclude all this stuff for underwater inspections that are not supposed to propagate to NBI fields

  IF :NEW.uwater_insp_typ not in ('3','4') THEN
  
    
        v_insp_freq_months := -1; -- set inspfreq to -1 to keep from triggering required field...
        v_insprequired     := 'N'; -- uw type doesn't quality, so required must be N per NBI
      ELSE
        --:NEW.unwater_insp_typ in ('3','4') sooooo
        -- ROUND TO NEAREST WHOLE, CONVERT TO INTEGER
        -- default months will be used if expression :NEW.UWINSPFREQ_KDOT *  12.0 is NULL
        -- range limit check - multiply years times 12 to see if > 99
        -- ARM revised per Deb testing 6/11/2002
      
        -- calculate it
        v_insp_freq_months := TRUNC(ROUND(NVL(:NEW.uwinspfreq_kdot * 12.0,
                                              v_default_months),
                                          0));
        v_insprequired := 'Y'; -- underwater inspection type qualitifies, so required must be Y per NBI
      
      END IF;
    
      -- ARMarshall,CS - 2005-06-07 - per Deb Kossler e-mail 5/27/2005      
      -- When changed to  a good months value, sets UWINSPREQ to 'Y' per NBI as well (maybe a  phony change if just changing frequency, but harmless)
      -- NOT SO HARMLESS - DON'T FIX FOR 1&2...
     
        UPDATE inspevnt
           SET uwinspfreq = v_insp_freq_months, uwinspreq = v_insprequired -- per NBI
         WHERE inspevnt.brkey = :OLD.brkey
           AND inspevnt.inspkey = :OLD.inspkey;
      
END taur_uinsp_uwinspfreq;
/