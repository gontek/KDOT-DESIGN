CREATE OR REPLACE TRIGGER pontis.Taur_Ds_Bridge_Length
  AFTER INSERT OR UPDATE OF Length ON pontis.Bridge
  FOR EACH ROW

  -----------------------------------------------------------------------------------------------------------------------------------------
  -- Trigger: taur_ds_BRIDGE_LENGTH
  -- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
  -----------------------------------------------------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------------------------------------------------
  -- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
  -----------------------------------------------------------------------------------------------------------------------------------------

  -----------------------------------------------------------------------------------------------------------------------------------------
  -- Revision History:

  --    2001.11.29  - Hoyt Nelson, CS -- Initial coding

  --    2001.11.30  - Hoyt Nelson, CS -- Added the 'calling trigger' argument (last in the parameter list) so we
  --                                     can identify the trigger that made the call, in ds_change_log.remarks.

  --    2001.12.03  - Hoyt Nelson, CS -- Added 'old.bridge_id' and transfer_map_key_id as parameters to f_pass_update_trigger_params().
  --                                     Also added code to consolidate duplicated "special cases" into single triggers.

  -----------------------------------------------------------------------------------------------------------------------------------------

  -- ?2001 Copyright: Cambridge Systematics, Inc, Asset Management Group: All Rights Reserved
  -- No distribution without express written permission of Cambridge Systematics, Inc., Cambridge MA

  --    Cambridge Systematics
  --    150 CambridgePark Drive, Suite 4000
  --    Cambridge MA 02140
  --    Phone: 617-354-0167
  --    Fax:   616-354-1542
  --    http://www.camsys.com

  -- Generated 2002-02-26 at 09:26
  -- Updated by ARMarshall, ARM LLC 20150615 
  -- extend this to check for actually different values meeting or exceeding the tolerance percentage
  -- return immediately if not and store nothing in the change log.

  
 WHEN (Nvl (New.Length, -9) <> Nvl (Old.Length, -9) AND Nvl
  (New.Length, -9) > 0.0) DECLARE
  Lb_Result    BOOLEAN;
  Ls_Bridge_Id Bridge.Bridge_Id%TYPE;
BEGIN
  -- new code
  IF Ksbms_Util.f_Numbers_Differ(Nvl(:Old.Length, -9),
                                 Nvl(:New.Length, -9),
                                 -- use the next function to load the tolerances from 
                                 -- the table Ds_Transfer_Delta_Tolerances
                                 Ksbms_Util.f_Get_Delta_Tolerance(Ptab => 'bridge',
                                                                  Pcol => 'length'),
                                 FALSE) = FALSE THEN
    RETURN; -- not a real change
  END IF;
  -- end change
  Ls_Bridge_Id := :New.Bridge_Id;
  Lb_Result    := Ksbms_Pontis.f_Pass_Update_Trigger_Params(Nvl(:New.Brkey,
                                                                '<MISSING>'),
                                                            'BRIDGE_ID',
                                                            'BRIDGE',
                                                            'LENGTH',
                                                            To_Char(:Old.Length),
                                                            To_Char(:New.Length),
                                                            1,
                                                            Nvl(Ls_Bridge_Id,
                                                                '<MISSING>'),
                                                            'taur_ds_BRIDGE_LENGTH');
  IF Lb_Result THEN
    Dbms_Output.Put_Line('taur_ds_BRIDGE_LENGTH failed');
  END IF;
END Taur_Ds_Bridge_Length;
/