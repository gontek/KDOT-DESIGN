CREATE OR REPLACE Trigger pontis.TAUR_DS_UBRDG_ORLOAD_HL93
    after insert or update of ORLOAD_HL93
    on pontis.USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_DS_UBRDG_ORLOAD_HL93
-- After update trigger to pass INV_HL93 LOAD RATING DATA TO CANSYS
-----------------------------------------------------------------------------------------------------------------------------------------
  -- Updated by ARMarshall, ARM LLC 20150615 
  -- extend this to check for actually different values meeting or exceeding the tolerance percentage
  -- return immediately if not and store nothing in the change log.


 
 
when (nvl( new.ORLOAD_HL93, -9 ) <>  nvl( old.ORLOAD_HL93, -9 ) )
declare
  lb_result    boolean;
  ls_bridge_id bridge.bridge_id%type;
begin

  -- new code
  IF Ksbms_Util.f_Numbers_Differ(Nvl(:Old.ORLOAD_HL93, -9),
                                 Nvl(:New.ORLOAD_HL93, -9),
                                 -- use the next function to load the tolerances from 
                                 -- the table Ds_Transfer_Delta_Tolerances
                                 Ksbms_Util.f_Get_Delta_Tolerance(Ptab => 'userbrdg',
                                                                  Pcol => 'orload_hl93'),
                                 FALSE) = FALSE THEN
    RETURN; -- not a real change
  END IF;
  -- end change 
  ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey(:new.brkey);
  lb_result    := ksbms_pontis.f_pass_update_trigger_params(nvl(:new.brkey,
                                                                '<MISSING>'),
                                                            'BRIDGE_ID',
                                                            'USERBRDG',
                                                            'ORLOAD_HL93',
                                                            TO_CHAR(:old.ORLOAD_HL93),
                                                            TO_CHAR(:new.ORLOAD_HL93),
                                                            1,
                                                            nvl(ls_bridge_id,
                                                                '<MISSING>'),
                                                            'TAUR_DS_UBRDG_ORLOAD_HL93');
  if lb_result then
    dbms_output.put_line('TAUR_DS_UBRDG_ORLOAD_HL93 failed');
  end if;
end TAUR_DS_UBRDG_ORLOAD_HL93;
/