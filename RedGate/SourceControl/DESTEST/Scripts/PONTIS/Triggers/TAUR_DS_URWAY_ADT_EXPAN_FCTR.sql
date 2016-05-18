CREATE OR REPLACE TRIGGER pontis.taur_ds_URWAY_ADT_EXPAN_FCTR
   after insert or update of ADT_EXPAN_FCTR on pontis.USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_ADT_EXPAN_FCTR
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--    2008.02.12 - Kossler, D. KDOT -- Added the trigger to hold updates for a field that facilitates calculating adtfuture
-----------------------------------------------------------------------------------------------------------------------------------------

-- Generated 10/7/2014

 -- Updated by ARMarshall, ARM LLC 20150615 
  -- extend this to check for actually different values meeting or exceeding the tolerance percentage
  -- return immediately if not and store nothing in the change log.
 
 
 
  
 WHEN (nvl( new.ADT_EXPAN_FCTR, -1 ) <>  nvl( old.ADT_EXPAN_FCTR, -1 )) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
 -- new code
  IF Ksbms_Util.f_Numbers_Differ(Nvl(:Old.ADT_EXPAN_FCTR, -9),
                                 NVL(:New.ADT_EXPAN_FCTR,-9),
                                 -- use the next function to load the tolerances from 
                                 -- the table Ds_Transfer_Delta_Tolerances
                                 Ksbms_Util.f_Get_Delta_Tolerance(Ptab => 'userrway',
                                                                  Pcol => 'ADT_EXPAN_FCTR'),
                                 FALSE) = FALSE THEN
    RETURN; -- not a real change
  END IF;
  -- end change   
     ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    if :new.on_under <> '1' then
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, -1 ) || ',' || nvl( :new.feat_cross_type, -1 ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, -1 ) || ',' || nvl( :new.route_suffix, -1 ) || ',' || nvl( :new.route_unique_id, -1 ),
      'BRIDGE_ID,FEAT_CROSS_TYPE,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID',
      'USERRWAY',
      'ADT_EXPAN_FCTR',
      trim(upper(:old.ADT_EXPAN_FCTR)),
      trim(upper(:new.ADT_EXPAN_FCTR)),
      3,
      nvl( ls_bridge_id, -1 ),
      'taur_ds_URWAY_ADT_EXPAN_FCTR');
 ELSE
   lb_result := ksbms_pontis.f_pass_update_trigger_params(
  nvl( :new.brkey, -1 ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, -1 ) || ',' || nvl( :new.route_suffix, -1 ) || ',' || nvl( :new.route_unique_id, -1 ),
        'BRIDGE_ID,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID',
        'USERRWAY',
        'ADT_EXPAN_FCTR',
        trim(upper(:old.ADT_EXPAN_FCTR)),
        trim(upper(:new.ADT_EXPAN_FCTR)),
        4,
        nvl( ls_bridge_id, -1 ),
        'taur_ds_URWAY_ADT_EXPAN_FCTR');
  END IF;
   if lb_result
   then
      dbms_output.put_line( 'taur_ds_URWAY_ADT_EXPAN_FCTR failed' );
   end if;
end taur_ds_URWAY_ADT_EXPAN_FCTR;
/