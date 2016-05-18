CREATE OR REPLACE package body pontis.ksbms_test is

   -- Last Mod: 02/21/2002 on Emperor

   procedure a_place_to_stash_trigger_code
   is
   begin
     null;
     
/*
     
create or replace trigger taur_ds_BRIDGE_BB_PCT
   after insert or update of BB_PCT on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_BB_PCT 
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

when ( nvl( new.BB_PCT, -9 ) <>  nvl( old.BB_PCT, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'BB_PCT', 
      TO_CHAR( :old.BB_PCT ), 
      TO_CHAR( :new.BB_PCT ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_BB_PCT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_BB_PCT failed' );
	 end if;
end taur_ds_BRIDGE_BB_PCT;
/
create or replace trigger taur_ds_BRIDGE_DECKWIDTH
   after insert or update of DECKWIDTH on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_DECKWIDTH 
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

when ( nvl( new.DECKWIDTH, -9 ) <>  nvl( old.DECKWIDTH, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'DECKWIDTH', 
      TO_CHAR( :old.DECKWIDTH ), 
      TO_CHAR( :new.DECKWIDTH ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_DECKWIDTH');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_DECKWIDTH failed' );
	 end if;
end taur_ds_BRIDGE_DECKWIDTH;
/
create or replace trigger taur_ds_BRIDGE_DISTRICT
   after insert or update of DISTRICT on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_DISTRICT 
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

when ( nvl( new.DISTRICT, '<MISSING>' ) <>  nvl( old.DISTRICT, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'DISTRICT', 
      :old.DISTRICT, 
      :new.DISTRICT,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_DISTRICT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_DISTRICT failed' );
	 end if;
end taur_ds_BRIDGE_DISTRICT;
/
create or replace trigger taur_ds_BRIDGE_FACILITY
   after insert or update of FACILITY on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_FACILITY 
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

when ( nvl( new.FACILITY, '<MISSING>' ) <>  nvl( old.FACILITY, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'FACILITY', 
      :old.FACILITY, 
      :new.FACILITY,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_FACILITY');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_FACILITY failed' );
	 end if;
end taur_ds_BRIDGE_FACILITY;
/
create or replace trigger taur_ds_BRIDGE_FEATINT
   after insert or update of FEATINT on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_FEATINT 
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

when ( nvl( new.FEATINT, '<MISSING>' ) <>  nvl( old.FEATINT, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'FEATINT', 
      :old.FEATINT, 
      :new.FEATINT,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_FEATINT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_FEATINT failed' );
	 end if;
end taur_ds_BRIDGE_FEATINT;
/
create or replace trigger taur_ds_BRIDGE_IRLOAD
   after insert or update of IRLOAD on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_IRLOAD 
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

when ( nvl( new.IRLOAD, -9 ) <>  nvl( old.IRLOAD, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'IRLOAD', 
      TO_CHAR( :old.IRLOAD ), 
      TO_CHAR( :new.IRLOAD ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_IRLOAD');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_IRLOAD failed' );
	 end if;
end taur_ds_BRIDGE_IRLOAD;
/
create or replace trigger taur_ds_BRIDGE_LENGTH
   after insert or update of LENGTH on BRIDGE for each row

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

when ( nvl( new.LENGTH, -9 ) <>  nvl( old.LENGTH, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'LENGTH', 
      TO_CHAR( :old.LENGTH ), 
      TO_CHAR( :new.LENGTH ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_LENGTH');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_LENGTH failed' );
	 end if;
end taur_ds_BRIDGE_LENGTH;
/
create or replace trigger taur_ds_BRIDGE_LFTCURBSW
   after insert or update of LFTCURBSW on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_LFTCURBSW 
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

when ( nvl( new.LFTCURBSW, -9 ) <>  nvl( old.LFTCURBSW, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'LFTCURBSW', 
      TO_CHAR( :old.LFTCURBSW ), 
      TO_CHAR( :new.LFTCURBSW ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_LFTCURBSW');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_LFTCURBSW failed' );
	 end if;
end taur_ds_BRIDGE_LFTCURBSW;
/
create or replace trigger taur_ds_BRIDGE_LOCATION
   after insert or update of LOCATION on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_LOCATION 
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

when ( nvl( new.LOCATION, '<MISSING>' ) <>  nvl( old.LOCATION, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'LOCATION', 
      :old.LOCATION, 
      :new.LOCATION,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_LOCATION');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_LOCATION failed' );
	 end if;
end taur_ds_BRIDGE_LOCATION;
/
create or replace trigger taur_ds_BRIDGE_NAVHC
   after insert or update of NAVHC on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_NAVHC 
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

when ( nvl( new.NAVHC, -9 ) <>  nvl( old.NAVHC, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'NAVHC', 
      TO_CHAR( :old.NAVHC ), 
      TO_CHAR( :new.NAVHC ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_NAVHC');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_NAVHC failed' );
	 end if;
end taur_ds_BRIDGE_NAVHC;
/
create or replace trigger taur_ds_BRIDGE_NAVVC
   after insert or update of NAVVC on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_NAVVC 
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

when ( nvl( new.NAVVC, -9 ) <>  nvl( old.NAVVC, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'NAVVC', 
      TO_CHAR( :old.NAVVC ), 
      TO_CHAR( :new.NAVVC ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_NAVVC');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_NAVVC failed' );
	 end if;
end taur_ds_BRIDGE_NAVVC;
/
create or replace trigger taur_ds_BRIDGE_ORLOAD
   after insert or update of ORLOAD on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_ORLOAD 
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

when ( nvl( new.ORLOAD, -9 ) <>  nvl( old.ORLOAD, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'ORLOAD', 
      TO_CHAR( :old.ORLOAD ), 
      TO_CHAR( :new.ORLOAD ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_ORLOAD');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_ORLOAD failed' );
	 end if;
end taur_ds_BRIDGE_ORLOAD;
/
create or replace trigger taur_ds_BRIDGE_PARALSTRUC
   after insert or update of PARALSTRUC on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_PARALSTRUC 
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

when ( nvl( new.PARALSTRUC, '<MISSING>' ) <>  nvl( old.PARALSTRUC, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'PARALSTRUC', 
      :old.PARALSTRUC, 
      :new.PARALSTRUC,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_PARALSTRUC');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_PARALSTRUC failed' );
	 end if;
end taur_ds_BRIDGE_PARALSTRUC;
/
create or replace trigger taur_ds_BRIDGE_RTCURBSW
   after insert or update of RTCURBSW on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_RTCURBSW 
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

when ( nvl( new.RTCURBSW, -9 ) <>  nvl( old.RTCURBSW, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'RTCURBSW', 
      TO_CHAR( :old.RTCURBSW ), 
      TO_CHAR( :new.RTCURBSW ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_RTCURBSW');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_RTCURBSW failed' );
	 end if;
end taur_ds_BRIDGE_RTCURBSW;
/
create or replace trigger taur_ds_BRIDGE_SKEW
   after insert or update of SKEW on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_SKEW 
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

when ( nvl( new.SKEW, -9 ) <>  nvl( old.SKEW, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'SKEW', 
      TO_CHAR( :old.SKEW ), 
      TO_CHAR( :new.SKEW ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_SKEW');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_SKEW failed' );
	 end if;
end taur_ds_BRIDGE_SKEW;
/
create or replace trigger taur_ds_BRIDGE_STRFLARED
   after insert or update of STRFLARED on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_STRFLARED 
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

when ( nvl( new.STRFLARED, '<MISSING>' ) <>  nvl( old.STRFLARED, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'STRFLARED', 
      :old.STRFLARED, 
      :new.STRFLARED,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_STRFLARED');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_STRFLARED failed' );
	 end if;
end taur_ds_BRIDGE_STRFLARED;
/
create or replace trigger taur_ds_BRIDGE_STRUCT_NUM
   after insert or update of STRUCT_NUM on BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_STRUCT_NUM 
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

when ( nvl( new.STRUCT_NUM, '<MISSING>' ) <>  nvl( old.STRUCT_NUM, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'BRIDGE', 
      'STRUCT_NUM', 
      :old.STRUCT_NUM, 
      :new.STRUCT_NUM,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_STRUCT_NUM');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_STRUCT_NUM failed' );
	 end if;
end taur_ds_BRIDGE_STRUCT_NUM;
/
create or replace trigger taur_ds_INSPEVNT_AENDRATING
   after insert or update of AENDRATING on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_AENDRATING 
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

when ( nvl( new.AENDRATING, '<MISSING>' ) <>  nvl( old.AENDRATING, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'AENDRATING', 
      :old.AENDRATING, 
      :new.AENDRATING,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_AENDRATING');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_AENDRATING failed' );
	 end if;
end taur_ds_INSPEVNT_AENDRATING;
/
create or replace trigger taur_ds_INSPEVNT_APPRALIGN
   after insert or update of APPRALIGN on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_APPRALIGN 
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

when ( nvl( new.APPRALIGN, '<MISSING>' ) <>  nvl( old.APPRALIGN, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'APPRALIGN', 
      :old.APPRALIGN, 
      :new.APPRALIGN,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_APPRALIGN');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_APPRALIGN failed' );
	 end if;
end taur_ds_INSPEVNT_APPRALIGN;
/
create or replace trigger taur_ds_INSPEVNT_ARAILRATIN
   after insert or update of ARAILRATIN on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_ARAILRATIN 
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

when ( nvl( new.ARAILRATIN, '<MISSING>' ) <>  nvl( old.ARAILRATIN, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'ARAILRATIN', 
      :old.ARAILRATIN, 
      :new.ARAILRATIN,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_ARAILRATIN');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_ARAILRATIN failed' );
	 end if;
end taur_ds_INSPEVNT_ARAILRATIN;
/
create or replace trigger taur_ds_INSPEVNT_CHANRATING
   after insert or update of CHANRATING on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_CHANRATING 
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

when ( nvl( new.CHANRATING, '<MISSING>' ) <>  nvl( old.CHANRATING, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'CHANRATING', 
      :old.CHANRATING, 
      :new.CHANRATING,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_CHANRATING');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_CHANRATING failed' );
	 end if;
end taur_ds_INSPEVNT_CHANRATING;
/
create or replace trigger taur_ds_INSPEVNT_CULVRATING
   after insert or update of CULVRATING on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_CULVRATING 
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

when ( nvl( new.CULVRATING, '<MISSING>' ) <>  nvl( old.CULVRATING, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'CULVRATING', 
      :old.CULVRATING, 
      :new.CULVRATING,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_CULVRATING');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_CULVRATING failed' );
	 end if;
end taur_ds_INSPEVNT_CULVRATING;
/
create or replace trigger taur_ds_INSPEVNT_DECKGEOM
   after insert or update of DECKGEOM on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_DECKGEOM 
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

when ( nvl( new.DECKGEOM, '<MISSING>' ) <>  nvl( old.DECKGEOM, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'DECKGEOM', 
      :old.DECKGEOM, 
      :new.DECKGEOM,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_DECKGEOM');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_DECKGEOM failed' );
	 end if;
end taur_ds_INSPEVNT_DECKGEOM;
/
create or replace trigger taur_ds_INSPEVNT_DKRATING
   after insert or update of DKRATING on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_DKRATING 
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

when ( nvl( new.DKRATING, '<MISSING>' ) <>  nvl( old.DKRATING, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'DKRATING', 
      :old.DKRATING, 
      :new.DKRATING,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_DKRATING');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_DKRATING failed' );
	 end if;
end taur_ds_INSPEVNT_DKRATING;
/
create or replace trigger taur_ds_INSPEVNT_FCLASTINSP
   after insert or update of FCLASTINSP on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_FCLASTINSP 
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

when ( nvl( new.FCLASTINSP, TO_DATE( '1901-01-01', 'YYYY-MM-DD' ) ) <>  nvl( old.FCLASTINSP, TO_DATE( '1901-01-01', 'YYYY-MM-DD' ) ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'FCLASTINSP', 
      TO_CHAR( :old.FCLASTINSP, 'YYYY-MM-DD' ), 
      TO_CHAR( :new.FCLASTINSP, 'YYYY-MM-DD' ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_FCLASTINSP');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_FCLASTINSP failed' );
	 end if;
end taur_ds_INSPEVNT_FCLASTINSP;
/
create or replace trigger taur_ds_INSPEVNT_INSPDATE
   after insert or update of INSPDATE on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_INSPDATE 
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

when ( nvl( new.INSPDATE, TO_DATE( '1901-01-01', 'YYYY-MM-DD' ) ) <>  nvl( old.INSPDATE, TO_DATE( '1901-01-01', 'YYYY-MM-DD' ) ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'INSPDATE', 
      TO_CHAR( :old.INSPDATE, 'YYYY-MM-DD' ), 
      TO_CHAR( :new.INSPDATE, 'YYYY-MM-DD' ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_INSPDATE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_INSPDATE failed' );
	 end if;
end taur_ds_INSPEVNT_INSPDATE;
/
create or replace trigger taur_ds_INSPEVNT_OSLASTINSP
   after insert or update of OSLASTINSP on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_OSLASTINSP 
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

when ( nvl( new.OSLASTINSP, TO_DATE( '1901-01-01', 'YYYY-MM-DD' ) ) <>  nvl( old.OSLASTINSP, TO_DATE( '1901-01-01', 'YYYY-MM-DD' ) ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'OSLASTINSP', 
      TO_CHAR( :old.OSLASTINSP, 'YYYY-MM-DD' ), 
      TO_CHAR( :new.OSLASTINSP, 'YYYY-MM-DD' ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_OSLASTINSP');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_OSLASTINSP failed' );
	 end if;
end taur_ds_INSPEVNT_OSLASTINSP;
/
create or replace trigger taur_ds_INSPEVNT_RAILRATING
   after insert or update of RAILRATING on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_RAILRATING 
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

when ( nvl( new.RAILRATING, '<MISSING>' ) <>  nvl( old.RAILRATING, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'RAILRATING', 
      :old.RAILRATING, 
      :new.RAILRATING,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_RAILRATING');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_RAILRATING failed' );
	 end if;
end taur_ds_INSPEVNT_RAILRATING;
/
create or replace trigger taur_ds_INSPEVNT_SCOURCRIT
   after insert or update of SCOURCRIT on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_SCOURCRIT 
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

when ( nvl( new.SCOURCRIT, '<MISSING>' ) <>  nvl( old.SCOURCRIT, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRKEY', 
      'INSPEVNT', 
      'SCOURCRIT', 
      :old.SCOURCRIT, 
      :new.SCOURCRIT,
      7,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_SCOURCRIT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_SCOURCRIT failed' );
	 end if;
end taur_ds_INSPEVNT_SCOURCRIT;
/
create or replace trigger taur_ds_INSPEVNT_STRRATING
   after insert or update of STRRATING on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_STRRATING 
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

when ( nvl( new.STRRATING, '<MISSING>' ) <>  nvl( old.STRRATING, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'STRRATING', 
      :old.STRRATING, 
      :new.STRRATING,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_STRRATING');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_STRRATING failed' );
	 end if;
end taur_ds_INSPEVNT_STRRATING;
/
create or replace trigger taur_ds_INSPEVNT_SUBRATING
   after insert or update of SUBRATING on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_SUBRATING 
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

when ( nvl( new.SUBRATING, '<MISSING>' ) <>  nvl( old.SUBRATING, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'SUBRATING', 
      :old.SUBRATING, 
      :new.SUBRATING,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_SUBRATING');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_SUBRATING failed' );
	 end if;
end taur_ds_INSPEVNT_SUBRATING;
/
create or replace trigger taur_ds_INSPEVNT_SUPRATING
   after insert or update of SUPRATING on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_SUPRATING 
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

when ( nvl( new.SUPRATING, '<MISSING>' ) <>  nvl( old.SUPRATING, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'SUPRATING', 
      :old.SUPRATING, 
      :new.SUPRATING,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_SUPRATING');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_SUPRATING failed' );
	 end if;
end taur_ds_INSPEVNT_SUPRATING;
/
create or replace trigger taur_ds_INSPEVNT_TRANSRATIN
   after insert or update of TRANSRATIN on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_TRANSRATIN 
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

when ( nvl( new.TRANSRATIN, '<MISSING>' ) <>  nvl( old.TRANSRATIN, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'TRANSRATIN', 
      :old.TRANSRATIN, 
      :new.TRANSRATIN,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_TRANSRATIN');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_TRANSRATIN failed' );
	 end if;
end taur_ds_INSPEVNT_TRANSRATIN;
/
create or replace trigger taur_ds_INSPEVNT_UNDERCLR
   after insert or update of UNDERCLR on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_UNDERCLR 
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

when ( nvl( new.UNDERCLR, '<MISSING>' ) <>  nvl( old.UNDERCLR, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'UNDERCLR', 
      :old.UNDERCLR, 
      :new.UNDERCLR,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_UNDERCLR');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_UNDERCLR failed' );
	 end if;
end taur_ds_INSPEVNT_UNDERCLR;
/
create or replace trigger taur_ds_INSPEVNT_UWLASTINSP
   after insert or update of UWLASTINSP on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_UWLASTINSP 
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

when ( nvl( new.UWLASTINSP, TO_DATE( '1901-01-01', 'YYYY-MM-DD' ) ) <>  nvl( old.UWLASTINSP, TO_DATE( '1901-01-01', 'YYYY-MM-DD' ) ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'UWLASTINSP', 
      TO_CHAR( :old.UWLASTINSP, 'YYYY-MM-DD' ), 
      TO_CHAR( :new.UWLASTINSP, 'YYYY-MM-DD' ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_UWLASTINSP');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_UWLASTINSP failed' );
	 end if;
end taur_ds_INSPEVNT_UWLASTINSP;
/
create or replace trigger taur_ds_INSPEVNT_WATERADEQ
   after insert or update of WATERADEQ on INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_WATERADEQ 
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

when ( nvl( new.WATERADEQ, '<MISSING>' ) <>  nvl( old.WATERADEQ, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'INSPEVNT', 
      'WATERADEQ', 
      :old.WATERADEQ, 
      :new.WATERADEQ,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_WATERADEQ');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_WATERADEQ failed' );
	 end if;
end taur_ds_INSPEVNT_WATERADEQ;
/
create or replace trigger taur_ds_ROADWAY_CRIT_FEAT
   after insert or update of CRIT_FEAT on ROADWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_ROADWAY_CRIT_FEAT 
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

when ( nvl( new.CRIT_FEAT, '<MISSING>' ) <>  nvl( old.CRIT_FEAT, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( null, :new.on_under ) || ',' || nvl( null, '<MISSING>' ) || ',' || nvl( null, '<MISSING>' ) || ',' || nvl( null, '<MISSING>' ), 
      'BRIDGE_ID,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
      'ROADWAY', 
      'CRIT_FEAT', 
      :old.CRIT_FEAT, 
      :new.CRIT_FEAT,
      4,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_ROADWAY_CRIT_FEAT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_ROADWAY_CRIT_FEAT failed' );
	 end if;
end taur_ds_ROADWAY_CRIT_FEAT;
/
create or replace trigger taur_ds_ROADWAY_ROADWAY_NAME
   after insert or update of ROADWAY_NAME on ROADWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_ROADWAY_ROADWAY_NAME 
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

when ( nvl( new.ROADWAY_NAME, '<MISSING>' ) <>  nvl( old.ROADWAY_NAME, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( null, :new.on_under ) || ',' || nvl( null, '<MISSING>' ) || ',' || nvl( null, '<MISSING>' ) || ',' || nvl( null, '<MISSING>' ), 
      'BRIDGE_ID,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
      'ROADWAY', 
      'ROADWAY_NAME', 
      :old.ROADWAY_NAME, 
      :new.ROADWAY_NAME,
      4,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_ROADWAY_ROADWAY_NAME');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_ROADWAY_ROADWAY_NAME failed' );
	 end if;
end taur_ds_ROADWAY_ROADWAY_NAME;
/
create or replace trigger taur_ds_ROADWAY_ROADWIDTH
   after insert or update of ROADWIDTH on ROADWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_ROADWAY_ROADWIDTH 
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

when ( nvl( new.ROADWIDTH, -9 ) <>  nvl( old.ROADWIDTH, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( null, :new.on_under ) || ',' || nvl( null, '<MISSING>' ) || ',' || nvl( null, '<MISSING>' ) || ',' || nvl( null, '<MISSING>' ), 
      'BRIDGE_ID,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
      'ROADWAY', 
      'ROADWIDTH', 
      TO_CHAR( :old.ROADWIDTH ), 
      TO_CHAR( :new.ROADWIDTH ),
      4,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_ROADWAY_ROADWIDTH');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_ROADWAY_ROADWIDTH failed' );
	 end if;
end taur_ds_ROADWAY_ROADWIDTH;
/
create or replace trigger taur_ds_PSTRUNIT_STRUNITLABEL
   after insert or update of STRUNITLABEL on STRUCTURE_UNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_PSTRUNIT_STRUNITLABEL 
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

when ( nvl( new.STRUNITLABEL, '<MISSING>' ) <>  nvl( old.STRUNITLABEL, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( :new.strunitlabel, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'STRUCTURE_UNIT', 
      'STRUNITLABEL', 
      :old.STRUNITLABEL, 
      :new.STRUNITLABEL,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_PSTRUNIT_STRUNITLABEL');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_PSTRUNIT_STRUNITLABEL failed' );
	 end if;
end taur_ds_PSTRUNIT_STRUNITLABEL;
/
create or replace trigger taur_ds_PSTRUNIT_STRUNITTYPE
   after insert or update of STRUNITTYPE on STRUCTURE_UNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_PSTRUNIT_STRUNITTYPE 
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

when ( nvl( new.STRUNITTYPE, '<MISSING>' ) <>  nvl( old.STRUNITTYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( :new.strunitlabel, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'STRUCTURE_UNIT', 
      'STRUNITTYPE', 
      :old.STRUNITTYPE, 
      :new.STRUNITTYPE,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_PSTRUNIT_STRUNITTYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_PSTRUNIT_STRUNITTYPE failed' );
	 end if;
end taur_ds_PSTRUNIT_STRUNITTYPE;
/
create or replace trigger taur_ds_UBRDG_ATTACH_DESC_1
   after insert or update of ATTACH_DESC_1 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ATTACH_DESC_1 
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

when ( nvl( new.ATTACH_DESC_1, '<MISSING>' ) <>  nvl( old.ATTACH_DESC_1, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ATTACH_DESC_1', 
      :old.ATTACH_DESC_1, 
      :new.ATTACH_DESC_1,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ATTACH_DESC_1');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ATTACH_DESC_1 failed' );
	 end if;
end taur_ds_UBRDG_ATTACH_DESC_1;
/
create or replace trigger taur_ds_UBRDG_ATTACH_DESC_2
   after insert or update of ATTACH_DESC_2 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ATTACH_DESC_2 
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

when ( nvl( new.ATTACH_DESC_2, '<MISSING>' ) <>  nvl( old.ATTACH_DESC_2, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ATTACH_DESC_2', 
      :old.ATTACH_DESC_2, 
      :new.ATTACH_DESC_2,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ATTACH_DESC_2');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ATTACH_DESC_2 failed' );
	 end if;
end taur_ds_UBRDG_ATTACH_DESC_2;
/
create or replace trigger taur_ds_UBRDG_ATTACH_DESC_3
   after insert or update of ATTACH_DESC_3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ATTACH_DESC_3 
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

when ( nvl( new.ATTACH_DESC_3, '<MISSING>' ) <>  nvl( old.ATTACH_DESC_3, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ATTACH_DESC_3', 
      :old.ATTACH_DESC_3, 
      :new.ATTACH_DESC_3,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ATTACH_DESC_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ATTACH_DESC_3 failed' );
	 end if;
end taur_ds_UBRDG_ATTACH_DESC_3;
/
create or replace trigger taur_ds_UBRDG_ATTACH_TYPE_1
   after insert or update of ATTACH_TYPE_1 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ATTACH_TYPE_1 
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

when ( nvl( new.ATTACH_TYPE_1, '<MISSING>' ) <>  nvl( old.ATTACH_TYPE_1, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ATTACH_TYPE_1', 
      :old.ATTACH_TYPE_1, 
      :new.ATTACH_TYPE_1,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ATTACH_TYPE_1');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ATTACH_TYPE_1 failed' );
	 end if;
end taur_ds_UBRDG_ATTACH_TYPE_1;
/
create or replace trigger taur_ds_UBRDG_ATTACH_TYPE_2
   after insert or update of ATTACH_TYPE_2 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ATTACH_TYPE_2 
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

when ( nvl( new.ATTACH_TYPE_2, '<MISSING>' ) <>  nvl( old.ATTACH_TYPE_2, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ATTACH_TYPE_2', 
      :old.ATTACH_TYPE_2, 
      :new.ATTACH_TYPE_2,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ATTACH_TYPE_2');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ATTACH_TYPE_2 failed' );
	 end if;
end taur_ds_UBRDG_ATTACH_TYPE_2;
/
create or replace trigger taur_ds_UBRDG_ATTACH_TYPE_3
   after insert or update of ATTACH_TYPE_3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ATTACH_TYPE_3 
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

when ( nvl( new.ATTACH_TYPE_3, '<MISSING>' ) <>  nvl( old.ATTACH_TYPE_3, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ATTACH_TYPE_3', 
      :old.ATTACH_TYPE_3, 
      :new.ATTACH_TYPE_3,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ATTACH_TYPE_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ATTACH_TYPE_3 failed' );
	 end if;
end taur_ds_UBRDG_ATTACH_TYPE_3;
/
create or replace trigger taur_ds_UBRDG_BOX_HEIGHT_CULV
   after insert or update of BOX_HEIGHT_CULV on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_BOX_HEIGHT_CULV 
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

when ( nvl( new.BOX_HEIGHT_CULV, -9 ) <>  nvl( old.BOX_HEIGHT_CULV, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'BOX_HEIGHT_CULV', 
      TO_CHAR( :old.BOX_HEIGHT_CULV ), 
      TO_CHAR( :new.BOX_HEIGHT_CULV ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_BOX_HEIGHT_CULV');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_BOX_HEIGHT_CULV failed' );
	 end if;
end taur_ds_UBRDG_BOX_HEIGHT_CULV;
/
create or replace trigger taur_ds_UBRDG_BRIDGEMED_KDOT
   after insert or update of BRIDGEMED_KDOT on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_BRIDGEMED_KDOT 
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

when ( nvl( new.BRIDGEMED_KDOT, '<MISSING>' ) <>  nvl( old.BRIDGEMED_KDOT, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'BRIDGEMED_KDOT', 
      :old.BRIDGEMED_KDOT, 
      :new.BRIDGEMED_KDOT,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_BRIDGEMED_KDOT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_BRIDGEMED_KDOT failed' );
	 end if;
end taur_ds_UBRDG_BRIDGEMED_KDOT;
/
create or replace trigger taur_ds_UBRDG_CULV_FILL_DEPTH
   after insert or update of CULV_FILL_DEPTH on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_CULV_FILL_DEPTH 
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

when ( nvl( new.CULV_FILL_DEPTH, -9 ) <>  nvl( old.CULV_FILL_DEPTH, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'CULV_FILL_DEPTH', 
      TO_CHAR( :old.CULV_FILL_DEPTH ), 
      TO_CHAR( :new.CULV_FILL_DEPTH ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_CULV_FILL_DEPTH');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_CULV_FILL_DEPTH failed' );
	 end if;
end taur_ds_UBRDG_CULV_FILL_DEPTH;
/
create or replace trigger taur_ds_UBRDG_CULV_WING_TYPE
   after insert or update of CULV_WING_TYPE on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_CULV_WING_TYPE 
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

when ( nvl( new.CULV_WING_TYPE, '<MISSING>' ) <>  nvl( old.CULV_WING_TYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'CULV_WING_TYPE', 
      :old.CULV_WING_TYPE, 
      :new.CULV_WING_TYPE,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_CULV_WING_TYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_CULV_WING_TYPE failed' );
	 end if;
end taur_ds_UBRDG_CULV_WING_TYPE;
/
create or replace trigger taur_ds_UBRDG_CUSTODIAN_KDOT
   after insert or update of CUSTODIAN_KDOT on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_CUSTODIAN_KDOT 
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

when ( nvl( new.CUSTODIAN_KDOT, '<MISSING>' ) <>  nvl( old.CUSTODIAN_KDOT, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'CUSTODIAN_KDOT', 
      :old.CUSTODIAN_KDOT, 
      :new.CUSTODIAN_KDOT,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_CUSTODIAN_KDOT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_CUSTODIAN_KDOT failed' );
	 end if;
end taur_ds_UBRDG_CUSTODIAN_KDOT;
/
create or replace trigger taur_ds_UBRDG_DESIGNLOAD_KDOT
   after insert or update of DESIGNLOAD_KDOT on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_DESIGNLOAD_KDOT 
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

when ( nvl( new.DESIGNLOAD_KDOT, -9 ) <>  nvl( old.DESIGNLOAD_KDOT, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'DESIGNLOAD_KDOT', 
      TO_CHAR( :old.DESIGNLOAD_KDOT ), 
      TO_CHAR( :new.DESIGNLOAD_KDOT ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_DESIGNLOAD_KDOT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_DESIGNLOAD_KDOT failed' );
	 end if;
end taur_ds_UBRDG_DESIGNLOAD_KDOT;
/
create or replace trigger taur_ds_UBRDG_DESIGNLOAD_TYPE
   after insert or update of DESIGNLOAD_TYPE on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_DESIGNLOAD_TYPE 
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

when ( nvl( new.DESIGNLOAD_TYPE, '<MISSING>' ) <>  nvl( old.DESIGNLOAD_TYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'DESIGNLOAD_TYPE', 
      :old.DESIGNLOAD_TYPE, 
      :new.DESIGNLOAD_TYPE,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_DESIGNLOAD_TYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_DESIGNLOAD_TYPE failed' );
	 end if;
end taur_ds_UBRDG_DESIGNLOAD_TYPE;
/
create or replace trigger taur_ds_UBRDG_DESIGN_REF_POST
   after insert or update of DESIGN_REF_POST on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_DESIGN_REF_POST 
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

when ( nvl( new.DESIGN_REF_POST, -9 ) <>  nvl( old.DESIGN_REF_POST, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'DESIGN_REF_POST', 
      TO_CHAR( :old.DESIGN_REF_POST ), 
      TO_CHAR( :new.DESIGN_REF_POST ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_DESIGN_REF_POST');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_DESIGN_REF_POST failed' );
	 end if;
end taur_ds_UBRDG_DESIGN_REF_POST;
/
create or replace trigger taur_ds_UBRDG_FUNCTION_TYPE
   after insert or update of FUNCTION_TYPE on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_FUNCTION_TYPE 
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

when ( nvl( new.FUNCTION_TYPE, '<MISSING>' ) <>  nvl( old.FUNCTION_TYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRKEY', 
      'USERBRDG', 
      'FUNCTION_TYPE', 
      :old.FUNCTION_TYPE, 
      :new.FUNCTION_TYPE,
      8,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_FUNCTION_TYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_FUNCTION_TYPE failed' );
	 end if;
end taur_ds_UBRDG_FUNCTION_TYPE;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_ADJ_3
   after insert or update of IRLOAD_ADJ_3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_ADJ_3 
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

when ( nvl( new.IRLOAD_ADJ_3, -9 ) <>  nvl( old.IRLOAD_ADJ_3, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_ADJ_3', 
      TO_CHAR( :old.IRLOAD_ADJ_3 ), 
      TO_CHAR( :new.IRLOAD_ADJ_3 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_ADJ_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_ADJ_3 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_ADJ_3;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_ADJ_3S2
   after insert or update of IRLOAD_ADJ_3S2 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_ADJ_3S2 
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

when ( nvl( new.IRLOAD_ADJ_3S2, -9 ) <>  nvl( old.IRLOAD_ADJ_3S2, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_ADJ_3S2', 
      TO_CHAR( :old.IRLOAD_ADJ_3S2 ), 
      TO_CHAR( :new.IRLOAD_ADJ_3S2 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_ADJ_3S2');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_ADJ_3S2 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_ADJ_3S2;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_ADJ_3_3
   after insert or update of IRLOAD_ADJ_3_3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_ADJ_3_3 
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

when ( nvl( new.IRLOAD_ADJ_3_3, -9 ) <>  nvl( old.IRLOAD_ADJ_3_3, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_ADJ_3_3', 
      TO_CHAR( :old.IRLOAD_ADJ_3_3 ), 
      TO_CHAR( :new.IRLOAD_ADJ_3_3 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_ADJ_3_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_ADJ_3_3 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_ADJ_3_3;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_ADJ_H
   after insert or update of IRLOAD_ADJ_H on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_ADJ_H 
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

when ( nvl( new.IRLOAD_ADJ_H, -9 ) <>  nvl( old.IRLOAD_ADJ_H, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_ADJ_H', 
      TO_CHAR( :old.IRLOAD_ADJ_H ), 
      TO_CHAR( :new.IRLOAD_ADJ_H ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_ADJ_H');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_ADJ_H failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_ADJ_H;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_ADJ_T130
   after insert or update of IRLOAD_ADJ_T130 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_ADJ_T130 
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

when ( nvl( new.IRLOAD_ADJ_T130, -9 ) <>  nvl( old.IRLOAD_ADJ_T130, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_ADJ_T130', 
      TO_CHAR( :old.IRLOAD_ADJ_T130 ), 
      TO_CHAR( :new.IRLOAD_ADJ_T130 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_ADJ_T130');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_ADJ_T130 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_ADJ_T130;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_ADJ_T170
   after insert or update of IRLOAD_ADJ_T170 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_ADJ_T170 
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

when ( nvl( new.IRLOAD_ADJ_T170, -9 ) <>  nvl( old.IRLOAD_ADJ_T170, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_ADJ_T170', 
      TO_CHAR( :old.IRLOAD_ADJ_T170 ), 
      TO_CHAR( :new.IRLOAD_ADJ_T170 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_ADJ_T170');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_ADJ_T170 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_ADJ_T170;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_LFD_3
   after insert or update of IRLOAD_LFD_3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_LFD_3 
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

when ( nvl( new.IRLOAD_LFD_3, -9 ) <>  nvl( old.IRLOAD_LFD_3, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_LFD_3', 
      TO_CHAR( :old.IRLOAD_LFD_3 ), 
      TO_CHAR( :new.IRLOAD_LFD_3 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_LFD_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_LFD_3 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_LFD_3;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_LFD_3S2
   after insert or update of IRLOAD_LFD_3S2 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_LFD_3S2 
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

when ( nvl( new.IRLOAD_LFD_3S2, -9 ) <>  nvl( old.IRLOAD_LFD_3S2, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_LFD_3S2', 
      TO_CHAR( :old.IRLOAD_LFD_3S2 ), 
      TO_CHAR( :new.IRLOAD_LFD_3S2 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_LFD_3S2');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_LFD_3S2 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_LFD_3S2;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_LFD_3_3
   after insert or update of IRLOAD_LFD_3_3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_LFD_3_3 
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

when ( nvl( new.IRLOAD_LFD_3_3, -9 ) <>  nvl( old.IRLOAD_LFD_3_3, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_LFD_3_3', 
      TO_CHAR( :old.IRLOAD_LFD_3_3 ), 
      TO_CHAR( :new.IRLOAD_LFD_3_3 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_LFD_3_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_LFD_3_3 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_LFD_3_3;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_LFD_H
   after insert or update of IRLOAD_LFD_H on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_LFD_H 
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

when ( nvl( new.IRLOAD_LFD_H, -9 ) <>  nvl( old.IRLOAD_LFD_H, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_LFD_H', 
      TO_CHAR( :old.IRLOAD_LFD_H ), 
      TO_CHAR( :new.IRLOAD_LFD_H ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_LFD_H');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_LFD_H failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_LFD_H;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_LFD_HS
   after insert or update of IRLOAD_LFD_HS on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_LFD_HS 
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

when ( nvl( new.IRLOAD_LFD_HS, -9 ) <>  nvl( old.IRLOAD_LFD_HS, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_LFD_HS', 
      TO_CHAR( :old.IRLOAD_LFD_HS ), 
      TO_CHAR( :new.IRLOAD_LFD_HS ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_LFD_HS');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_LFD_HS failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_LFD_HS;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_LFD_T130
   after insert or update of IRLOAD_LFD_T130 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_LFD_T130 
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

when ( nvl( new.IRLOAD_LFD_T130, -9 ) <>  nvl( old.IRLOAD_LFD_T130, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_LFD_T130', 
      TO_CHAR( :old.IRLOAD_LFD_T130 ), 
      TO_CHAR( :new.IRLOAD_LFD_T130 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_LFD_T130');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_LFD_T130 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_LFD_T130;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_LFD_T170
   after insert or update of IRLOAD_LFD_T170 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_LFD_T170 
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

when ( nvl( new.IRLOAD_LFD_T170, -9 ) <>  nvl( old.IRLOAD_LFD_T170, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_LFD_T170', 
      TO_CHAR( :old.IRLOAD_LFD_T170 ), 
      TO_CHAR( :new.IRLOAD_LFD_T170 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_LFD_T170');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_LFD_T170 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_LFD_T170;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_WSD_3
   after insert or update of IRLOAD_WSD_3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_WSD_3 
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

when ( nvl( new.IRLOAD_WSD_3, -9 ) <>  nvl( old.IRLOAD_WSD_3, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_WSD_3', 
      TO_CHAR( :old.IRLOAD_WSD_3 ), 
      TO_CHAR( :new.IRLOAD_WSD_3 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_WSD_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_WSD_3 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_WSD_3;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_WSD_3S2
   after insert or update of IRLOAD_WSD_3S2 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_WSD_3S2 
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

when ( nvl( new.IRLOAD_WSD_3S2, -9 ) <>  nvl( old.IRLOAD_WSD_3S2, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_WSD_3S2', 
      TO_CHAR( :old.IRLOAD_WSD_3S2 ), 
      TO_CHAR( :new.IRLOAD_WSD_3S2 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_WSD_3S2');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_WSD_3S2 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_WSD_3S2;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_WSD_3_3
   after insert or update of IRLOAD_WSD_3_3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_WSD_3_3 
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

when ( nvl( new.IRLOAD_WSD_3_3, -9 ) <>  nvl( old.IRLOAD_WSD_3_3, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_WSD_3_3', 
      TO_CHAR( :old.IRLOAD_WSD_3_3 ), 
      TO_CHAR( :new.IRLOAD_WSD_3_3 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_WSD_3_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_WSD_3_3 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_WSD_3_3;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_WSD_H
   after insert or update of IRLOAD_WSD_H on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_WSD_H 
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

when ( nvl( new.IRLOAD_WSD_H, -9 ) <>  nvl( old.IRLOAD_WSD_H, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_WSD_H', 
      TO_CHAR( :old.IRLOAD_WSD_H ), 
      TO_CHAR( :new.IRLOAD_WSD_H ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_WSD_H');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_WSD_H failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_WSD_H;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_WSD_HS
   after insert or update of IRLOAD_WSD_HS on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_WSD_HS 
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

when ( nvl( new.IRLOAD_WSD_HS, -9 ) <>  nvl( old.IRLOAD_WSD_HS, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_WSD_HS', 
      TO_CHAR( :old.IRLOAD_WSD_HS ), 
      TO_CHAR( :new.IRLOAD_WSD_HS ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_WSD_HS');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_WSD_HS failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_WSD_HS;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_WSD_T130
   after insert or update of IRLOAD_WSD_T130 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_WSD_T130 
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

when ( nvl( new.IRLOAD_WSD_T130, -9 ) <>  nvl( old.IRLOAD_WSD_T130, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_WSD_T130', 
      TO_CHAR( :old.IRLOAD_WSD_T130 ), 
      TO_CHAR( :new.IRLOAD_WSD_T130 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_WSD_T130');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_WSD_T130 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_WSD_T130;
/
create or replace trigger taur_ds_UBRDG_IRLOAD_WSD_T170
   after insert or update of IRLOAD_WSD_T170 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_IRLOAD_WSD_T170 
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

when ( nvl( new.IRLOAD_WSD_T170, -9 ) <>  nvl( old.IRLOAD_WSD_T170, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'IRLOAD_WSD_T170', 
      TO_CHAR( :old.IRLOAD_WSD_T170 ), 
      TO_CHAR( :new.IRLOAD_WSD_T170 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_IRLOAD_WSD_T170');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_IRLOAD_WSD_T170 failed' );
	 end if;
end taur_ds_UBRDG_IRLOAD_WSD_T170;
/
create or replace trigger taur_ds_UBRDG_MAINT_AREA
   after insert or update of MAINT_AREA on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_MAINT_AREA 
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

when ( nvl( new.MAINT_AREA, '<MISSING>' ) <>  nvl( old.MAINT_AREA, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'MAINT_AREA', 
      :old.MAINT_AREA, 
      :new.MAINT_AREA,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_MAINT_AREA');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_MAINT_AREA failed' );
	 end if;
end taur_ds_UBRDG_MAINT_AREA;
/
create or replace trigger taur_ds_UBRDG_MEDIAN_WIDTH
   after insert or update of MEDIAN_WIDTH on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_MEDIAN_WIDTH 
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

when ( nvl( new.MEDIAN_WIDTH, -9 ) <>  nvl( old.MEDIAN_WIDTH, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'MEDIAN_WIDTH', 
      TO_CHAR( :old.MEDIAN_WIDTH ), 
      TO_CHAR( :new.MEDIAN_WIDTH ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_MEDIAN_WIDTH');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_MEDIAN_WIDTH failed' );
	 end if;
end taur_ds_UBRDG_MEDIAN_WIDTH;
/
create or replace trigger taur_ds_UBRDG_ORIENTATION
   after insert or update of ORIENTATION on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORIENTATION 
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

when ( nvl( new.ORIENTATION, '<MISSING>' ) <>  nvl( old.ORIENTATION, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORIENTATION', 
      :old.ORIENTATION, 
      :new.ORIENTATION,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORIENTATION');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORIENTATION failed' );
	 end if;
end taur_ds_UBRDG_ORIENTATION;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_ADJ_3
   after insert or update of ORLOAD_ADJ_3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_ADJ_3 
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

when ( nvl( new.ORLOAD_ADJ_3, -9 ) <>  nvl( old.ORLOAD_ADJ_3, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_ADJ_3', 
      TO_CHAR( :old.ORLOAD_ADJ_3 ), 
      TO_CHAR( :new.ORLOAD_ADJ_3 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_ADJ_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_ADJ_3 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_ADJ_3;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_ADJ_3S2
   after insert or update of ORLOAD_ADJ_3S2 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_ADJ_3S2 
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

when ( nvl( new.ORLOAD_ADJ_3S2, -9 ) <>  nvl( old.ORLOAD_ADJ_3S2, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_ADJ_3S2', 
      TO_CHAR( :old.ORLOAD_ADJ_3S2 ), 
      TO_CHAR( :new.ORLOAD_ADJ_3S2 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_ADJ_3S2');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_ADJ_3S2 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_ADJ_3S2;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_ADJ_3_3
   after insert or update of ORLOAD_ADJ_3_3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_ADJ_3_3 
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

when ( nvl( new.ORLOAD_ADJ_3_3, -9 ) <>  nvl( old.ORLOAD_ADJ_3_3, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_ADJ_3_3', 
      TO_CHAR( :old.ORLOAD_ADJ_3_3 ), 
      TO_CHAR( :new.ORLOAD_ADJ_3_3 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_ADJ_3_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_ADJ_3_3 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_ADJ_3_3;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_ADJ_H
   after insert or update of ORLOAD_ADJ_H on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_ADJ_H 
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

when ( nvl( new.ORLOAD_ADJ_H, -9 ) <>  nvl( old.ORLOAD_ADJ_H, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_ADJ_H', 
      TO_CHAR( :old.ORLOAD_ADJ_H ), 
      TO_CHAR( :new.ORLOAD_ADJ_H ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_ADJ_H');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_ADJ_H failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_ADJ_H;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_ADJ_T130
   after insert or update of ORLOAD_ADJ_T130 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_ADJ_T130 
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

when ( nvl( new.ORLOAD_ADJ_T130, -9 ) <>  nvl( old.ORLOAD_ADJ_T130, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_ADJ_T130', 
      TO_CHAR( :old.ORLOAD_ADJ_T130 ), 
      TO_CHAR( :new.ORLOAD_ADJ_T130 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_ADJ_T130');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_ADJ_T130 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_ADJ_T130;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_ADJ_T170
   after insert or update of ORLOAD_ADJ_T170 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_ADJ_T170 
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

when ( nvl( new.ORLOAD_ADJ_T170, -9 ) <>  nvl( old.ORLOAD_ADJ_T170, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_ADJ_T170', 
      TO_CHAR( :old.ORLOAD_ADJ_T170 ), 
      TO_CHAR( :new.ORLOAD_ADJ_T170 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_ADJ_T170');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_ADJ_T170 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_ADJ_T170;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_LFD_3
   after insert or update of ORLOAD_LFD_3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_LFD_3 
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

when ( nvl( new.ORLOAD_LFD_3, -9 ) <>  nvl( old.ORLOAD_LFD_3, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_LFD_3', 
      TO_CHAR( :old.ORLOAD_LFD_3 ), 
      TO_CHAR( :new.ORLOAD_LFD_3 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_LFD_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_LFD_3 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_LFD_3;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_LFD_3S2
   after insert or update of ORLOAD_LFD_3S2 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_LFD_3S2 
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

when ( nvl( new.ORLOAD_LFD_3S2, -9 ) <>  nvl( old.ORLOAD_LFD_3S2, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_LFD_3S2', 
      TO_CHAR( :old.ORLOAD_LFD_3S2 ), 
      TO_CHAR( :new.ORLOAD_LFD_3S2 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_LFD_3S2');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_LFD_3S2 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_LFD_3S2;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_LFD_3_3
   after insert or update of ORLOAD_LFD_3_3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_LFD_3_3 
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

when ( nvl( new.ORLOAD_LFD_3_3, -9 ) <>  nvl( old.ORLOAD_LFD_3_3, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_LFD_3_3', 
      TO_CHAR( :old.ORLOAD_LFD_3_3 ), 
      TO_CHAR( :new.ORLOAD_LFD_3_3 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_LFD_3_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_LFD_3_3 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_LFD_3_3;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_LFD_H
   after insert or update of ORLOAD_LFD_H on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_LFD_H 
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

when ( nvl( new.ORLOAD_LFD_H, -9 ) <>  nvl( old.ORLOAD_LFD_H, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_LFD_H', 
      TO_CHAR( :old.ORLOAD_LFD_H ), 
      TO_CHAR( :new.ORLOAD_LFD_H ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_LFD_H');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_LFD_H failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_LFD_H;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_LFD_HS
   after insert or update of ORLOAD_LFD_HS on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_LFD_HS 
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

when ( nvl( new.ORLOAD_LFD_HS, -9 ) <>  nvl( old.ORLOAD_LFD_HS, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_LFD_HS', 
      TO_CHAR( :old.ORLOAD_LFD_HS ), 
      TO_CHAR( :new.ORLOAD_LFD_HS ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_LFD_HS');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_LFD_HS failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_LFD_HS;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_LFD_T130
   after insert or update of ORLOAD_LFD_T130 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_LFD_T130 
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

when ( nvl( new.ORLOAD_LFD_T130, -9 ) <>  nvl( old.ORLOAD_LFD_T130, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_LFD_T130', 
      TO_CHAR( :old.ORLOAD_LFD_T130 ), 
      TO_CHAR( :new.ORLOAD_LFD_T130 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_LFD_T130');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_LFD_T130 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_LFD_T130;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_LFD_T170
   after insert or update of ORLOAD_LFD_T170 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_LFD_T170 
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

when ( nvl( new.ORLOAD_LFD_T170, -9 ) <>  nvl( old.ORLOAD_LFD_T170, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_LFD_T170', 
      TO_CHAR( :old.ORLOAD_LFD_T170 ), 
      TO_CHAR( :new.ORLOAD_LFD_T170 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_LFD_T170');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_LFD_T170 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_LFD_T170;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_WSD_3
   after insert or update of ORLOAD_WSD_3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_WSD_3 
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

when ( nvl( new.ORLOAD_WSD_3, -9 ) <>  nvl( old.ORLOAD_WSD_3, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_WSD_3', 
      TO_CHAR( :old.ORLOAD_WSD_3 ), 
      TO_CHAR( :new.ORLOAD_WSD_3 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_WSD_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_WSD_3 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_WSD_3;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_WSD_3S2
   after insert or update of ORLOAD_WSD_3S2 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_WSD_3S2 
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

when ( nvl( new.ORLOAD_WSD_3S2, -9 ) <>  nvl( old.ORLOAD_WSD_3S2, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_WSD_3S2', 
      TO_CHAR( :old.ORLOAD_WSD_3S2 ), 
      TO_CHAR( :new.ORLOAD_WSD_3S2 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_WSD_3S2');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_WSD_3S2 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_WSD_3S2;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_WSD_3_3
   after insert or update of ORLOAD_WSD_3_3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_WSD_3_3 
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

when ( nvl( new.ORLOAD_WSD_3_3, -9 ) <>  nvl( old.ORLOAD_WSD_3_3, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_WSD_3_3', 
      TO_CHAR( :old.ORLOAD_WSD_3_3 ), 
      TO_CHAR( :new.ORLOAD_WSD_3_3 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_WSD_3_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_WSD_3_3 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_WSD_3_3;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_WSD_H
   after insert or update of ORLOAD_WSD_H on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_WSD_H 
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

when ( nvl( new.ORLOAD_WSD_H, -9 ) <>  nvl( old.ORLOAD_WSD_H, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_WSD_H', 
      TO_CHAR( :old.ORLOAD_WSD_H ), 
      TO_CHAR( :new.ORLOAD_WSD_H ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_WSD_H');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_WSD_H failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_WSD_H;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_WSD_HS
   after insert or update of ORLOAD_WSD_HS on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_WSD_HS 
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

when ( nvl( new.ORLOAD_WSD_HS, -9 ) <>  nvl( old.ORLOAD_WSD_HS, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_WSD_HS', 
      TO_CHAR( :old.ORLOAD_WSD_HS ), 
      TO_CHAR( :new.ORLOAD_WSD_HS ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_WSD_HS');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_WSD_HS failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_WSD_HS;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_WSD_T130
   after insert or update of ORLOAD_WSD_T130 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_WSD_T130 
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

when ( nvl( new.ORLOAD_WSD_T130, -9 ) <>  nvl( old.ORLOAD_WSD_T130, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_WSD_T130', 
      TO_CHAR( :old.ORLOAD_WSD_T130 ), 
      TO_CHAR( :new.ORLOAD_WSD_T130 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_WSD_T130');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_WSD_T130 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_WSD_T130;
/
create or replace trigger taur_ds_UBRDG_ORLOAD_WSD_T170
   after insert or update of ORLOAD_WSD_T170 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ORLOAD_WSD_T170 
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

when ( nvl( new.ORLOAD_WSD_T170, -9 ) <>  nvl( old.ORLOAD_WSD_T170, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ORLOAD_WSD_T170', 
      TO_CHAR( :old.ORLOAD_WSD_T170 ), 
      TO_CHAR( :new.ORLOAD_WSD_T170 ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ORLOAD_WSD_T170');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ORLOAD_WSD_T170 failed' );
	 end if;
end taur_ds_UBRDG_ORLOAD_WSD_T170;
/
create or replace trigger taur_ds_UBRDG_OWNER_KDOT
   after insert or update of OWNER_KDOT on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_OWNER_KDOT 
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

when ( nvl( new.OWNER_KDOT, '<MISSING>' ) <>  nvl( old.OWNER_KDOT, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'OWNER_KDOT', 
      :old.OWNER_KDOT, 
      :new.OWNER_KDOT,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_OWNER_KDOT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_OWNER_KDOT failed' );
	 end if;
end taur_ds_UBRDG_OWNER_KDOT;
/
create or replace trigger taur_ds_UBRDG_POSTED_LOAD_A
   after insert or update of POSTED_LOAD_A on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_POSTED_LOAD_A 
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

when ( nvl( new.POSTED_LOAD_A, '<MISSING>' ) <>  nvl( old.POSTED_LOAD_A, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'POSTED_LOAD_A', 
      :old.POSTED_LOAD_A, 
      :new.POSTED_LOAD_A,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_POSTED_LOAD_A');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_POSTED_LOAD_A failed' );
	 end if;
end taur_ds_UBRDG_POSTED_LOAD_A;
/
create or replace trigger taur_ds_UBRDG_POSTED_LOAD_B
   after insert or update of POSTED_LOAD_B on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_POSTED_LOAD_B 
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

when ( nvl( new.POSTED_LOAD_B, '<MISSING>' ) <>  nvl( old.POSTED_LOAD_B, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'POSTED_LOAD_B', 
      :old.POSTED_LOAD_B, 
      :new.POSTED_LOAD_B,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_POSTED_LOAD_B');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_POSTED_LOAD_B failed' );
	 end if;
end taur_ds_UBRDG_POSTED_LOAD_B;
/
create or replace trigger taur_ds_UBRDG_POSTED_LOAD_C
   after insert or update of POSTED_LOAD_C on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_POSTED_LOAD_C 
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

when ( nvl( new.POSTED_LOAD_C, '<MISSING>' ) <>  nvl( old.POSTED_LOAD_C, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'POSTED_LOAD_C', 
      :old.POSTED_LOAD_C, 
      :new.POSTED_LOAD_C,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_POSTED_LOAD_C');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_POSTED_LOAD_C failed' );
	 end if;
end taur_ds_UBRDG_POSTED_LOAD_C;
/
create or replace trigger taur_ds_UBRDG_POSTED_SIGN_TYPE
   after insert or update of POSTED_SIGN_TYPE on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_POSTED_SIGN_TYPE 
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

when ( nvl( new.POSTED_SIGN_TYPE, '<MISSING>' ) <>  nvl( old.POSTED_SIGN_TYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'POSTED_SIGN_TYPE', 
      :old.POSTED_SIGN_TYPE, 
      :new.POSTED_SIGN_TYPE,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_POSTED_SIGN_TYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_POSTED_SIGN_TYPE failed' );
	 end if;
end taur_ds_UBRDG_POSTED_SIGN_TYPE;
/
create or replace trigger taur_ds_UBRDG_RATING_ADJ
   after insert or update of RATING_ADJ on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_RATING_ADJ 
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

when ( nvl( new.RATING_ADJ, '<MISSING>' ) <>  nvl( old.RATING_ADJ, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'RATING_ADJ', 
      :old.RATING_ADJ, 
      :new.RATING_ADJ,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_RATING_ADJ');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_RATING_ADJ failed' );
	 end if;
end taur_ds_UBRDG_RATING_ADJ;
/
create or replace trigger taur_ds_UBRDG_RATING_COMMENT
   after insert or update of RATING_COMMENT on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_RATING_COMMENT 
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

when ( nvl( new.RATING_COMMENT, '<MISSING>' ) <>  nvl( old.RATING_COMMENT, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'RATING_COMMENT', 
      :old.RATING_COMMENT, 
      :new.RATING_COMMENT,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_RATING_COMMENT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_RATING_COMMENT failed' );
	 end if;
end taur_ds_UBRDG_RATING_COMMENT;
/
create or replace trigger taur_ds_UBRDG_RESTRICT_LOAD
   after insert or update of RESTRICT_LOAD on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_RESTRICT_LOAD 
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

when ( nvl( new.RESTRICT_LOAD, -9 ) <>  nvl( old.RESTRICT_LOAD, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'RESTRICT_LOAD', 
      TO_CHAR( :old.RESTRICT_LOAD ), 
      TO_CHAR( :new.RESTRICT_LOAD ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_RESTRICT_LOAD');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_RESTRICT_LOAD failed' );
	 end if;
end taur_ds_UBRDG_RESTRICT_LOAD;
/
create or replace trigger taur_ds_UBRDG_ROAD_TYPE_SIGN
   after insert or update of ROAD_TYPE_SIGN on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ROAD_TYPE_SIGN 
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

when ( nvl( new.ROAD_TYPE_SIGN, '<MISSING>' ) <>  nvl( old.ROAD_TYPE_SIGN, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ROAD_TYPE_SIGN', 
      :old.ROAD_TYPE_SIGN, 
      :new.ROAD_TYPE_SIGN,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ROAD_TYPE_SIGN');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ROAD_TYPE_SIGN failed' );
	 end if;
end taur_ds_UBRDG_ROAD_TYPE_SIGN;
/
create or replace trigger taur_ds_UBRDG_ROT_ANGLE_DEG
   after insert or update of ROT_ANGLE_DEG on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ROT_ANGLE_DEG 
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

when ( nvl( new.ROT_ANGLE_DEG, -9 ) <>  nvl( old.ROT_ANGLE_DEG, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ROT_ANGLE_DEG', 
      TO_CHAR( :old.ROT_ANGLE_DEG ), 
      TO_CHAR( :new.ROT_ANGLE_DEG ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ROT_ANGLE_DEG');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ROT_ANGLE_DEG failed' );
	 end if;
end taur_ds_UBRDG_ROT_ANGLE_DEG;
/
create or replace trigger taur_ds_UBRDG_ROT_ANGLE_MIN
   after insert or update of ROT_ANGLE_MIN on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ROT_ANGLE_MIN 
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

when ( nvl( new.ROT_ANGLE_MIN, -9 ) <>  nvl( old.ROT_ANGLE_MIN, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ROT_ANGLE_MIN', 
      TO_CHAR( :old.ROT_ANGLE_MIN ), 
      TO_CHAR( :new.ROT_ANGLE_MIN ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ROT_ANGLE_MIN');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ROT_ANGLE_MIN failed' );
	 end if;
end taur_ds_UBRDG_ROT_ANGLE_MIN;
/
create or replace trigger taur_ds_UBRDG_ROT_DIRECTION
   after insert or update of ROT_DIRECTION on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ROT_DIRECTION 
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

when ( nvl( new.ROT_DIRECTION, '<MISSING>' ) <>  nvl( old.ROT_DIRECTION, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'ROT_DIRECTION', 
      :old.ROT_DIRECTION, 
      :new.ROT_DIRECTION,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ROT_DIRECTION');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ROT_DIRECTION failed' );
	 end if;
end taur_ds_UBRDG_ROT_DIRECTION;
/
create or replace trigger taur_ds_UBRDG_SIGN_TYPE_Q1
   after insert or update of SIGN_TYPE_Q1 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_SIGN_TYPE_Q1 
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

when ( nvl( new.SIGN_TYPE_Q1, '<MISSING>' ) <>  nvl( old.SIGN_TYPE_Q1, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'SIGN_TYPE_Q1', 
      :old.SIGN_TYPE_Q1, 
      :new.SIGN_TYPE_Q1,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_SIGN_TYPE_Q1');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_SIGN_TYPE_Q1 failed' );
	 end if;
end taur_ds_UBRDG_SIGN_TYPE_Q1;
/
create or replace trigger taur_ds_UBRDG_SIGN_TYPE_Q2
   after insert or update of SIGN_TYPE_Q2 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_SIGN_TYPE_Q2 
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

when ( nvl( new.SIGN_TYPE_Q2, '<MISSING>' ) <>  nvl( old.SIGN_TYPE_Q2, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'SIGN_TYPE_Q2', 
      :old.SIGN_TYPE_Q2, 
      :new.SIGN_TYPE_Q2,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_SIGN_TYPE_Q2');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_SIGN_TYPE_Q2 failed' );
	 end if;
end taur_ds_UBRDG_SIGN_TYPE_Q2;
/
create or replace trigger taur_ds_UBRDG_SIGN_TYPE_Q3
   after insert or update of SIGN_TYPE_Q3 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_SIGN_TYPE_Q3 
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

when ( nvl( new.SIGN_TYPE_Q3, '<MISSING>' ) <>  nvl( old.SIGN_TYPE_Q3, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'SIGN_TYPE_Q3', 
      :old.SIGN_TYPE_Q3, 
      :new.SIGN_TYPE_Q3,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_SIGN_TYPE_Q3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_SIGN_TYPE_Q3 failed' );
	 end if;
end taur_ds_UBRDG_SIGN_TYPE_Q3;
/
create or replace trigger taur_ds_UBRDG_SIGN_TYPE_Q4
   after insert or update of SIGN_TYPE_Q4 on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_SIGN_TYPE_Q4 
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

when ( nvl( new.SIGN_TYPE_Q4, '<MISSING>' ) <>  nvl( old.SIGN_TYPE_Q4, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'SIGN_TYPE_Q4', 
      :old.SIGN_TYPE_Q4, 
      :new.SIGN_TYPE_Q4,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_SIGN_TYPE_Q4');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_SIGN_TYPE_Q4 failed' );
	 end if;
end taur_ds_UBRDG_SIGN_TYPE_Q4;
/
create or replace trigger taur_ds_UBRDG_SKEW_DIRECTION
   after insert or update of SKEW_DIRECTION on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_SKEW_DIRECTION 
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

when ( nvl( new.SKEW_DIRECTION, '<MISSING>' ) <>  nvl( old.SKEW_DIRECTION, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'SKEW_DIRECTION', 
      :old.SKEW_DIRECTION, 
      :new.SKEW_DIRECTION,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_SKEW_DIRECTION');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_SKEW_DIRECTION failed' );
	 end if;
end taur_ds_UBRDG_SKEW_DIRECTION;
/
create or replace trigger taur_ds_UBRDG_SKEW_MINUTES
   after insert or update of SKEW_MINUTES on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_SKEW_MINUTES 
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

when ( nvl( new.SKEW_MINUTES, -9 ) <>  nvl( old.SKEW_MINUTES, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'SKEW_MINUTES', 
      TO_CHAR( :old.SKEW_MINUTES ), 
      TO_CHAR( :new.SKEW_MINUTES ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_SKEW_MINUTES');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_SKEW_MINUTES failed' );
	 end if;
end taur_ds_UBRDG_SKEW_MINUTES;
/
create or replace trigger taur_ds_UBRDG_STREAM_SIGN
   after insert or update of STREAM_SIGN on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_STREAM_SIGN 
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

when ( nvl( new.STREAM_SIGN, '<MISSING>' ) <>  nvl( old.STREAM_SIGN, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'STREAM_SIGN', 
      :old.STREAM_SIGN, 
      :new.STREAM_SIGN,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_STREAM_SIGN');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_STREAM_SIGN failed' );
	 end if;
end taur_ds_UBRDG_STREAM_SIGN;
/
create or replace trigger taur_ds_UBRDG_SUPER_PAINT_SYS
   after insert or update of SUPER_PAINT_SYS on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_SUPER_PAINT_SYS 
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

when ( nvl( new.SUPER_PAINT_SYS, '<MISSING>' ) <>  nvl( old.SUPER_PAINT_SYS, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'SUPER_PAINT_SYS', 
      :old.SUPER_PAINT_SYS, 
      :new.SUPER_PAINT_SYS,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_SUPER_PAINT_SYS');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_SUPER_PAINT_SYS failed' );
	 end if;
end taur_ds_UBRDG_SUPER_PAINT_SYS;
/
create or replace trigger taur_ds_UBRDG_SUPRSTRUCT_TOS
   after insert or update of SUPRSTRUCT_TOS on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_SUPRSTRUCT_TOS 
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

when ( nvl( new.SUPRSTRUCT_TOS, -9 ) <>  nvl( old.SUPRSTRUCT_TOS, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'SUPRSTRUCT_TOS', 
      TO_CHAR( :old.SUPRSTRUCT_TOS ), 
      TO_CHAR( :new.SUPRSTRUCT_TOS ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_SUPRSTRUCT_TOS');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_SUPRSTRUCT_TOS failed' );
	 end if;
end taur_ds_UBRDG_SUPRSTRUCT_TOS;
/
create or replace trigger taur_ds_UBRDG_VERT_CLR_SIGN
   after insert or update of VERT_CLR_SIGN on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_VERT_CLR_SIGN 
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

when ( nvl( new.VERT_CLR_SIGN, '<MISSING>' ) <>  nvl( old.VERT_CLR_SIGN, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'VERT_CLR_SIGN', 
      :old.VERT_CLR_SIGN, 
      :new.VERT_CLR_SIGN,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_VERT_CLR_SIGN');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_VERT_CLR_SIGN failed' );
	 end if;
end taur_ds_UBRDG_VERT_CLR_SIGN;
/
create or replace trigger taur_ds_UBRDG_VERT_UNDR_SIGN
   after insert or update of VERT_UNDR_SIGN on USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_VERT_UNDR_SIGN 
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

when ( nvl( new.VERT_UNDR_SIGN, '<MISSING>' ) <>  nvl( old.VERT_UNDR_SIGN, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERBRDG', 
      'VERT_UNDR_SIGN', 
      :old.VERT_UNDR_SIGN, 
      :new.VERT_UNDR_SIGN,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_VERT_UNDR_SIGN');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_VERT_UNDR_SIGN failed' );
	 end if;
end taur_ds_UBRDG_VERT_UNDR_SIGN;
/
create or replace trigger taur_ds_UINSP_BRINSPFREQ_KDOT
   after insert or update of BRINSPFREQ_KDOT on USERINSP for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UINSP_BRINSPFREQ_KDOT 
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

when ( nvl( new.BRINSPFREQ_KDOT, -9 ) <>  nvl( old.BRINSPFREQ_KDOT, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'USERINSP', 
      'BRINSPFREQ_KDOT', 
      TO_CHAR( :old.BRINSPFREQ_KDOT ), 
      TO_CHAR( :new.BRINSPFREQ_KDOT ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UINSP_BRINSPFREQ_KDOT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UINSP_BRINSPFREQ_KDOT failed' );
	 end if;
end taur_ds_UINSP_BRINSPFREQ_KDOT;
/
create or replace trigger taur_ds_UINSP_COND_INDEX
   after insert or update of COND_INDEX on USERINSP for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UINSP_COND_INDEX 
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

when ( nvl( new.COND_INDEX, -9 ) <>  nvl( old.COND_INDEX, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'USERINSP', 
      'COND_INDEX', 
      TO_CHAR( :old.COND_INDEX ), 
      TO_CHAR( :new.COND_INDEX ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UINSP_COND_INDEX');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UINSP_COND_INDEX failed' );
	 end if;
end taur_ds_UINSP_COND_INDEX;
/
create or replace trigger taur_ds_UINSP_FCINSPFREQ_KDOT
   after insert or update of FCINSPFREQ_KDOT on USERINSP for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UINSP_FCINSPFREQ_KDOT 
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

when ( nvl( new.FCINSPFREQ_KDOT, -9 ) <>  nvl( old.FCINSPFREQ_KDOT, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'USERINSP', 
      'FCINSPFREQ_KDOT', 
      TO_CHAR( :old.FCINSPFREQ_KDOT ), 
      TO_CHAR( :new.FCINSPFREQ_KDOT ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UINSP_FCINSPFREQ_KDOT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UINSP_FCINSPFREQ_KDOT failed' );
	 end if;
end taur_ds_UINSP_FCINSPFREQ_KDOT;
/
create or replace trigger taur_ds_UINSP_OPPOSTCL_KDOT
   after insert or update of OPPOSTCL_KDOT on USERINSP for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UINSP_OPPOSTCL_KDOT 
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

when ( nvl( new.OPPOSTCL_KDOT, '<MISSING>' ) <>  nvl( old.OPPOSTCL_KDOT, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'USERINSP', 
      'OPPOSTCL_KDOT', 
      :old.OPPOSTCL_KDOT, 
      :new.OPPOSTCL_KDOT,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UINSP_OPPOSTCL_KDOT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UINSP_OPPOSTCL_KDOT failed' );
	 end if;
end taur_ds_UINSP_OPPOSTCL_KDOT;
/
create or replace trigger taur_ds_UINSP_OSINSPFREQ_KDOT
   after insert or update of OSINSPFREQ_KDOT on USERINSP for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UINSP_OSINSPFREQ_KDOT 
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

when ( nvl( new.OSINSPFREQ_KDOT, -9 ) <>  nvl( old.OSINSPFREQ_KDOT, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'USERINSP', 
      'OSINSPFREQ_KDOT', 
      TO_CHAR( :old.OSINSPFREQ_KDOT ), 
      TO_CHAR( :new.OSINSPFREQ_KDOT ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UINSP_OSINSPFREQ_KDOT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UINSP_OSINSPFREQ_KDOT failed' );
	 end if;
end taur_ds_UINSP_OSINSPFREQ_KDOT;
/
create or replace trigger taur_ds_UINSP_PAINT_COND
   after insert or update of PAINT_COND on USERINSP for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UINSP_PAINT_COND 
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

when ( nvl( new.PAINT_COND, '<MISSING>' ) <>  nvl( old.PAINT_COND, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'USERINSP', 
      'PAINT_COND', 
      :old.PAINT_COND, 
      :new.PAINT_COND,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UINSP_PAINT_COND');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UINSP_PAINT_COND failed' );
	 end if;
end taur_ds_UINSP_PAINT_COND;
/
create or replace trigger taur_ds_UINSP_UWATER_INSP_TYP
   after insert or update of UWATER_INSP_TYP on USERINSP for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UINSP_UWATER_INSP_TYP 
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

when ( nvl( new.UWATER_INSP_TYP, '<MISSING>' ) <>  nvl( old.UWATER_INSP_TYP, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'USERINSP', 
      'UWATER_INSP_TYP', 
      :old.UWATER_INSP_TYP, 
      :new.UWATER_INSP_TYP,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UINSP_UWATER_INSP_TYP');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UINSP_UWATER_INSP_TYP failed' );
	 end if;
end taur_ds_UINSP_UWATER_INSP_TYP;
/
create or replace trigger taur_ds_UINSP_UWINSPFREQ_KDOT
   after insert or update of UWINSPFREQ_KDOT on USERINSP for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UINSP_UWINSPFREQ_KDOT 
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

when ( nvl( new.UWINSPFREQ_KDOT, -9 ) <>  nvl( old.UWINSPFREQ_KDOT, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ), 
      'BRIDGE_ID,INSPKEY', 
      'USERINSP', 
      'UWINSPFREQ_KDOT', 
      TO_CHAR( :old.UWINSPFREQ_KDOT ), 
      TO_CHAR( :new.UWINSPFREQ_KDOT ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UINSP_UWINSPFREQ_KDOT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UINSP_UWINSPFREQ_KDOT failed' );
	 end if;
end taur_ds_UINSP_UWINSPFREQ_KDOT;
/
create or replace trigger taur_ds_URWAY_AROADWIDTH_FAR
   after insert or update of AROADWIDTH_FAR on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_AROADWIDTH_FAR 
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

when ( nvl( new.AROADWIDTH_FAR, -9 ) <>  nvl( old.AROADWIDTH_FAR, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERRWAY', 
      'AROADWIDTH_FAR', 
      TO_CHAR( :old.AROADWIDTH_FAR ), 
      TO_CHAR( :new.AROADWIDTH_FAR ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_AROADWIDTH_FAR');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_AROADWIDTH_FAR failed' );
	 end if;
end taur_ds_URWAY_AROADWIDTH_FAR;
/
create or replace trigger taur_ds_URWAY_AROADWIDTH_NEAR
   after insert or update of AROADWIDTH_NEAR on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_AROADWIDTH_NEAR 
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

when ( nvl( new.AROADWIDTH_NEAR, -9 ) <>  nvl( old.AROADWIDTH_NEAR, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERRWAY', 
      'AROADWIDTH_NEAR', 
      TO_CHAR( :old.AROADWIDTH_NEAR ), 
      TO_CHAR( :new.AROADWIDTH_NEAR ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_AROADWIDTH_NEAR');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_AROADWIDTH_NEAR failed' );
	 end if;
end taur_ds_URWAY_AROADWIDTH_NEAR;
/
create or replace trigger taur_ds_URWAY_BERM_PROT
   after insert or update of BERM_PROT on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_BERM_PROT 
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

when ( nvl( new.BERM_PROT, '<MISSING>' ) <>  nvl( old.BERM_PROT, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERRWAY', 
      'BERM_PROT', 
      :old.BERM_PROT, 
      :new.BERM_PROT,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_BERM_PROT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_BERM_PROT failed' );
	 end if;
end taur_ds_URWAY_BERM_PROT;
/
create or replace trigger taur_ds_URWAY_CHAN_PROT_LEFT
   after insert or update of CHAN_PROT_LEFT on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_CHAN_PROT_LEFT 
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

when ( nvl( new.CHAN_PROT_LEFT, '<MISSING>' ) <>  nvl( old.CHAN_PROT_LEFT, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.feat_cross_type, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ), 
      'BRIDGE_ID,FEAT_CROSS_TYPE,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
      'USERRWAY', 
      'CHAN_PROT_LEFT', 
      :old.CHAN_PROT_LEFT, 
      :new.CHAN_PROT_LEFT,
      3,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_CHAN_PROT_LEFT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_CHAN_PROT_LEFT failed' );
	 end if;
end taur_ds_URWAY_CHAN_PROT_LEFT;
/
create or replace trigger taur_ds_URWAY_CHAN_PROT_RIGHT
   after insert or update of CHAN_PROT_RIGHT on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_CHAN_PROT_RIGHT 
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

when ( nvl( new.CHAN_PROT_RIGHT, '<MISSING>' ) <>  nvl( old.CHAN_PROT_RIGHT, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.feat_cross_type, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ), 
      'BRIDGE_ID,FEAT_CROSS_TYPE,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
      'USERRWAY', 
      'CHAN_PROT_RIGHT', 
      :old.CHAN_PROT_RIGHT, 
      :new.CHAN_PROT_RIGHT,
      3,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_CHAN_PROT_RIGHT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_CHAN_PROT_RIGHT failed' );
	 end if;
end taur_ds_URWAY_CHAN_PROT_RIGHT;
/
create or replace trigger taur_ds_URWAY_CLR_ROUTE
   after insert or update of CLR_ROUTE on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_CLR_ROUTE 
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

when ( nvl( new.CLR_ROUTE, '<MISSING>' ) <>  nvl( old.CLR_ROUTE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    if :new.on_under = '1' then
       lb_result := ksbms_pontis.f_pass_update_trigger_params( 
          nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
          'BRIDGE_ID,CLR_ROUTE', 
          'USERRWAY', 
          'CLR_ROUTE', 
          :old.CLR_ROUTE, 
          :new.CLR_ROUTE,
          5,
          nvl( ls_bridge_id, '<MISSING>' ),
          'taur_ds_URWAY_CLR_ROUTE');
    else
        lb_result := ksbms_pontis.f_pass_update_trigger_params( 
          nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
          'BRIDGE_ID,CLR_ROUTE', 
          'USERRWAY', 
          'CLR_ROUTE', 
          :old.CLR_ROUTE, 
          :new.CLR_ROUTE,
          6,
          nvl( ls_bridge_id, '<MISSING>' ),
          'taur_ds_URWAY_CLR_ROUTE');
    end if;
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_CLR_ROUTE failed' );
	 end if;
end taur_ds_URWAY_CLR_ROUTE;
/
create or replace trigger taur_ds_URWAY_FEAT_CROSS_TYPE
   after insert or update of FEAT_CROSS_TYPE on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_FEAT_CROSS_TYPE 
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

when ( nvl( new.FEAT_CROSS_TYPE, '<MISSING>' ) <>  nvl( old.FEAT_CROSS_TYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.feat_cross_type, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ), 
      'BRIDGE_ID,FEAT_CROSS_TYPE,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
      'USERRWAY', 
      'FEAT_CROSS_TYPE', 
      :old.FEAT_CROSS_TYPE, 
      :new.FEAT_CROSS_TYPE,
      3,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_FEAT_CROSS_TYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_FEAT_CROSS_TYPE failed' );
	 end if;
end taur_ds_URWAY_FEAT_CROSS_TYPE;
/
create or replace trigger taur_ds_URWAY_FEAT_DESC_TYPE
   after insert or update of FEAT_DESC_TYPE on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_FEAT_DESC_TYPE 
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

when ( nvl( new.FEAT_DESC_TYPE, '<MISSING>' ) <>  nvl( old.FEAT_DESC_TYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.feat_cross_type, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ), 
      'BRIDGE_ID,FEAT_CROSS_TYPE,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
      'USERRWAY', 
      'FEAT_DESC_TYPE', 
      :old.FEAT_DESC_TYPE, 
      :new.FEAT_DESC_TYPE,
      3,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_FEAT_DESC_TYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_FEAT_DESC_TYPE failed' );
	 end if;
end taur_ds_URWAY_FEAT_DESC_TYPE;
/
create or replace trigger taur_ds_URWAY_HCLRULT_E
   after insert or update of HCLRULT_E on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_HCLRULT_E 
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

when ( nvl( new.HCLRULT_E, -9 ) <>  nvl( old.HCLRULT_E, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'HCLRULT_E', 
      TO_CHAR( :old.HCLRULT_E ), 
      TO_CHAR( :new.HCLRULT_E ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_HCLRULT_E');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_HCLRULT_E failed' );
	 end if;
end taur_ds_URWAY_HCLRULT_E;
/
create or replace trigger taur_ds_URWAY_HCLRULT_N
   after insert or update of HCLRULT_N on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_HCLRULT_N 
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

when ( nvl( new.HCLRULT_N, -9 ) <>  nvl( old.HCLRULT_N, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'HCLRULT_N', 
      TO_CHAR( :old.HCLRULT_N ), 
      TO_CHAR( :new.HCLRULT_N ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_HCLRULT_N');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_HCLRULT_N failed' );
	 end if;
end taur_ds_URWAY_HCLRULT_N;
/
create or replace trigger taur_ds_URWAY_HCLRULT_S
   after insert or update of HCLRULT_S on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_HCLRULT_S 
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

when ( nvl( new.HCLRULT_S, -9 ) <>  nvl( old.HCLRULT_S, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'HCLRULT_S', 
      TO_CHAR( :old.HCLRULT_S ), 
      TO_CHAR( :new.HCLRULT_S ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_HCLRULT_S');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_HCLRULT_S failed' );
	 end if;
end taur_ds_URWAY_HCLRULT_S;
/
create or replace trigger taur_ds_URWAY_HCLRULT_W
   after insert or update of HCLRULT_W on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_HCLRULT_W 
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

when ( nvl( new.HCLRULT_W, -9 ) <>  nvl( old.HCLRULT_W, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'HCLRULT_W', 
      TO_CHAR( :old.HCLRULT_W ), 
      TO_CHAR( :new.HCLRULT_W ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_HCLRULT_W');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_HCLRULT_W failed' );
	 end if;
end taur_ds_URWAY_HCLRULT_W;
/
create or replace trigger taur_ds_URWAY_HCLRURT_E
   after insert or update of HCLRURT_E on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_HCLRURT_E 
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

when ( nvl( new.HCLRURT_E, -9 ) <>  nvl( old.HCLRURT_E, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'HCLRURT_E', 
      TO_CHAR( :old.HCLRURT_E ), 
      TO_CHAR( :new.HCLRURT_E ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_HCLRURT_E');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_HCLRURT_E failed' );
	 end if;
end taur_ds_URWAY_HCLRURT_E;
/
create or replace trigger taur_ds_URWAY_HCLRURT_N
   after insert or update of HCLRURT_N on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_HCLRURT_N 
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

when ( nvl( new.HCLRURT_N, -9 ) <>  nvl( old.HCLRURT_N, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'HCLRURT_N', 
      TO_CHAR( :old.HCLRURT_N ), 
      TO_CHAR( :new.HCLRURT_N ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_HCLRURT_N');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_HCLRURT_N failed' );
	 end if;
end taur_ds_URWAY_HCLRURT_N;
/
create or replace trigger taur_ds_URWAY_HCLRURT_S
   after insert or update of HCLRURT_S on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_HCLRURT_S 
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

when ( nvl( new.HCLRURT_S, -9 ) <>  nvl( old.HCLRURT_S, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'HCLRURT_S', 
      TO_CHAR( :old.HCLRURT_S ), 
      TO_CHAR( :new.HCLRURT_S ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_HCLRURT_S');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_HCLRURT_S failed' );
	 end if;
end taur_ds_URWAY_HCLRURT_S;
/
create or replace trigger taur_ds_URWAY_HCLRURT_W
   after insert or update of HCLRURT_W on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_HCLRURT_W 
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

when ( nvl( new.HCLRURT_W, -9 ) <>  nvl( old.HCLRURT_W, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'HCLRURT_W', 
      TO_CHAR( :old.HCLRURT_W ), 
      TO_CHAR( :new.HCLRURT_W ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_HCLRURT_W');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_HCLRURT_W failed' );
	 end if;
end taur_ds_URWAY_HCLRURT_W;
/
create or replace trigger taur_ds_URWAY_HCLR_E
   after insert or update of HCLR_E on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_HCLR_E 
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

when ( nvl( new.HCLR_E, -9 ) <>  nvl( old.HCLR_E, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'HCLR_E', 
      TO_CHAR( :old.HCLR_E ), 
      TO_CHAR( :new.HCLR_E ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_HCLR_E');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_HCLR_E failed' );
	 end if;
end taur_ds_URWAY_HCLR_E;
/
create or replace trigger taur_ds_URWAY_HCLR_N
   after insert or update of HCLR_N on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_HCLR_N 
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

when ( nvl( new.HCLR_N, -9 ) <>  nvl( old.HCLR_N, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'HCLR_N', 
      TO_CHAR( :old.HCLR_N ), 
      TO_CHAR( :new.HCLR_N ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_HCLR_N');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_HCLR_N failed' );
	 end if;
end taur_ds_URWAY_HCLR_N;
/
create or replace trigger taur_ds_URWAY_HCLR_S
   after insert or update of HCLR_S on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_HCLR_S 
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

when ( nvl( new.HCLR_S, -9 ) <>  nvl( old.HCLR_S, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'HCLR_S', 
      TO_CHAR( :old.HCLR_S ), 
      TO_CHAR( :new.HCLR_S ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_HCLR_S');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_HCLR_S failed' );
	 end if;
end taur_ds_URWAY_HCLR_S;
/
create or replace trigger taur_ds_URWAY_HCLR_W
   after insert or update of HCLR_W on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_HCLR_W 
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

when ( nvl( new.HCLR_W, -9 ) <>  nvl( old.HCLR_W, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'HCLR_W', 
      TO_CHAR( :old.HCLR_W ), 
      TO_CHAR( :new.HCLR_W ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_HCLR_W');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_HCLR_W failed' );
	 end if;
end taur_ds_URWAY_HCLR_W;
/
create or replace trigger taur_ds_URWAY_MAINT_RTE_ID
   after insert or update of MAINT_RTE_ID on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_MAINT_RTE_ID 
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

when ( nvl( new.MAINT_RTE_ID, '<MISSING>' ) <>  nvl( old.MAINT_RTE_ID, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERRWAY', 
      'MAINT_RTE_ID', 
      :old.MAINT_RTE_ID, 
      :new.MAINT_RTE_ID,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_MAINT_RTE_ID');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_MAINT_RTE_ID failed' );
	 end if;
end taur_ds_URWAY_MAINT_RTE_ID;
/
create or replace trigger taur_ds_URWAY_MAINT_RTE_NUM
   after insert or update of MAINT_RTE_NUM on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_MAINT_RTE_NUM 
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

when ( nvl( new.MAINT_RTE_NUM, '<MISSING>' ) <>  nvl( old.MAINT_RTE_NUM, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERRWAY', 
      'MAINT_RTE_NUM', 
      :old.MAINT_RTE_NUM, 
      :new.MAINT_RTE_NUM,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_MAINT_RTE_NUM');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_MAINT_RTE_NUM failed' );
	 end if;
end taur_ds_URWAY_MAINT_RTE_NUM;
/
create or replace trigger taur_ds_URWAY_MAINT_RTE_PREFIX
   after insert or update of MAINT_RTE_PREFIX on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_MAINT_RTE_PREFIX 
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

when ( nvl( new.MAINT_RTE_PREFIX, '<MISSING>' ) <>  nvl( old.MAINT_RTE_PREFIX, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERRWAY', 
      'MAINT_RTE_PREFIX', 
      :old.MAINT_RTE_PREFIX, 
      :new.MAINT_RTE_PREFIX,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_MAINT_RTE_PREFIX');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_MAINT_RTE_PREFIX failed' );
	 end if;
end taur_ds_URWAY_MAINT_RTE_PREFIX;
/
create or replace trigger taur_ds_URWAY_MAINT_RTE_SUFFIX
   after insert or update of MAINT_RTE_SUFFIX on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_MAINT_RTE_SUFFIX 
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

when ( nvl( new.MAINT_RTE_SUFFIX, '<MISSING>' ) <>  nvl( old.MAINT_RTE_SUFFIX, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ), 
      'BRIDGE_ID', 
      'USERRWAY', 
      'MAINT_RTE_SUFFIX', 
      :old.MAINT_RTE_SUFFIX, 
      :new.MAINT_RTE_SUFFIX,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_MAINT_RTE_SUFFIX');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_MAINT_RTE_SUFFIX failed' );
	 end if;
end taur_ds_URWAY_MAINT_RTE_SUFFIX;
/
create or replace trigger taur_ds_URWAY_ROAD_CROSS_NAME
   after insert or update of ROAD_CROSS_NAME on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_ROAD_CROSS_NAME 
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

when ( nvl( new.ROAD_CROSS_NAME, '<MISSING>' ) <>  nvl( old.ROAD_CROSS_NAME, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.feat_cross_type, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ), 
      'BRIDGE_ID,FEAT_CROSS_TYPE,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
      'USERRWAY', 
      'ROAD_CROSS_NAME', 
      :old.ROAD_CROSS_NAME, 
      :new.ROAD_CROSS_NAME,
      3,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_ROAD_CROSS_NAME');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_ROAD_CROSS_NAME failed' );
	 end if;
end taur_ds_URWAY_ROAD_CROSS_NAME;
/
create or replace trigger taur_ds_URWAY_ROUTE_NUM
   after insert or update of ROUTE_NUM on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_ROUTE_NUM 
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

when ( nvl( new.ROUTE_NUM, '<MISSING>' ) <>  nvl( old.ROUTE_NUM, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    if :new.on_under <> '1' then
       lb_result := ksbms_pontis.f_pass_update_trigger_params( 
          nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.feat_cross_type, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ), 
          'BRIDGE_ID,FEAT_CROSS_TYPE,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
          'USERRWAY', 
          'ROUTE_NUM', 
          :old.ROUTE_NUM, 
          :new.ROUTE_NUM,
          3,
          nvl( ls_bridge_id, '<MISSING>' ),
          'taur_ds_URWAY_ROUTE_NUM');
    else
        lb_result := ksbms_pontis.f_pass_update_trigger_params( 
          nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ), 
          'BRIDGE_ID,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
          'USERRWAY', 
          'ROUTE_NUM', 
          :old.ROUTE_NUM, 
          :new.ROUTE_NUM,
          4,
          nvl( ls_bridge_id, '<MISSING>' ),
          'taur_ds_URWAY_ROUTE_NUM');
    end if;
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_ROUTE_NUM failed' );
	 end if;
end taur_ds_URWAY_ROUTE_NUM;
/
create or replace trigger taur_ds_URWAY_ROUTE_PREFIX
   after insert or update of ROUTE_PREFIX on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_ROUTE_PREFIX 
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

when ( nvl( new.ROUTE_PREFIX, '<MISSING>' ) <>  nvl( old.ROUTE_PREFIX, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    if :new.on_under <> '1' then
       lb_result := ksbms_pontis.f_pass_update_trigger_params( 
          nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.feat_cross_type, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ), 
          'BRIDGE_ID,FEAT_CROSS_TYPE,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
          'USERRWAY', 
          'ROUTE_PREFIX', 
          :old.ROUTE_PREFIX, 
          :new.ROUTE_PREFIX,
          3,
          nvl( ls_bridge_id, '<MISSING>' ),
          'taur_ds_URWAY_ROUTE_PREFIX');
    else
        lb_result := ksbms_pontis.f_pass_update_trigger_params( 
          nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ), 
          'BRIDGE_ID,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
          'USERRWAY', 
          'ROUTE_PREFIX', 
          :old.ROUTE_PREFIX, 
          :new.ROUTE_PREFIX,
          4,
          nvl( ls_bridge_id, '<MISSING>' ),
          'taur_ds_URWAY_ROUTE_PREFIX');
    end if;
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_ROUTE_PREFIX failed' );
	 end if;
end taur_ds_URWAY_ROUTE_PREFIX;
/
create or replace trigger taur_ds_URWAY_ROUTE_SUFFIX
   after insert or update of ROUTE_SUFFIX on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_ROUTE_SUFFIX 
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

when ( nvl( new.ROUTE_SUFFIX, '<MISSING>' ) <>  nvl( old.ROUTE_SUFFIX, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    if :new.on_under <> '1' then
       lb_result := ksbms_pontis.f_pass_update_trigger_params( 
          nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.feat_cross_type, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ), 
          'BRIDGE_ID,FEAT_CROSS_TYPE,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
          'USERRWAY', 
          'ROUTE_SUFFIX', 
          :old.ROUTE_SUFFIX, 
          :new.ROUTE_SUFFIX,
          3,
          nvl( ls_bridge_id, '<MISSING>' ),
          'taur_ds_URWAY_ROUTE_SUFFIX');
    else
        lb_result := ksbms_pontis.f_pass_update_trigger_params( 
          nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ), 
          'BRIDGE_ID,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
          'USERRWAY', 
          'ROUTE_SUFFIX', 
          :old.ROUTE_SUFFIX, 
          :new.ROUTE_SUFFIX,
          4,
          nvl( ls_bridge_id, '<MISSING>' ),
          'taur_ds_URWAY_ROUTE_SUFFIX');
    end if;
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_ROUTE_SUFFIX failed' );
	 end if;
end taur_ds_URWAY_ROUTE_SUFFIX;
/
create or replace trigger taur_ds_URWAY_ROUTE_UNIQUE_ID
   after insert or update of ROUTE_UNIQUE_ID on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_ROUTE_UNIQUE_ID 
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

when ( nvl( new.ROUTE_UNIQUE_ID, '<MISSING>' ) <>  nvl( old.ROUTE_UNIQUE_ID, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    if :new.on_under <> '1' then
       lb_result := ksbms_pontis.f_pass_update_trigger_params( 
          nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.feat_cross_type, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ), 
          'BRIDGE_ID,FEAT_CROSS_TYPE,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
          'USERRWAY', 
          'ROUTE_UNIQUE_ID', 
          :old.ROUTE_UNIQUE_ID, 
          :new.ROUTE_UNIQUE_ID,
          3,
          nvl( ls_bridge_id, '<MISSING>' ),
          'taur_ds_URWAY_ROUTE_UNIQUE_ID');
    else
        lb_result := ksbms_pontis.f_pass_update_trigger_params( 
          nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ), 
          'BRIDGE_ID,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
          'USERRWAY', 
          'ROUTE_UNIQUE_ID', 
          :old.ROUTE_UNIQUE_ID, 
          :new.ROUTE_UNIQUE_ID,
          4,
          nvl( ls_bridge_id, '<MISSING>' ),
          'taur_ds_URWAY_ROUTE_UNIQUE_ID');
    end if;
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_ROUTE_UNIQUE_ID failed' );
	 end if;
end taur_ds_URWAY_ROUTE_UNIQUE_ID;
/
create or replace trigger taur_ds_URWAY_TRANS_LANES
   after insert or update of TRANS_LANES on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_TRANS_LANES 
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

when ( nvl( new.TRANS_LANES, -9 ) <>  nvl( old.TRANS_LANES, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ), 
      'BRIDGE_ID,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID', 
      'USERRWAY', 
      'TRANS_LANES', 
      TO_CHAR( :old.TRANS_LANES ), 
      TO_CHAR( :new.TRANS_LANES ),
      4,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_TRANS_LANES');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_TRANS_LANES failed' );
	 end if;
end taur_ds_URWAY_TRANS_LANES;
/
create or replace trigger taur_ds_URWAY_VCLRINV_E
   after insert or update of VCLRINV_E on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_VCLRINV_E 
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

when ( nvl( new.VCLRINV_E, -9 ) <>  nvl( old.VCLRINV_E, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'VCLRINV_E', 
      TO_CHAR( :old.VCLRINV_E ), 
      TO_CHAR( :new.VCLRINV_E ),
      5,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_VCLRINV_E');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_VCLRINV_E failed' );
	 end if;
end taur_ds_URWAY_VCLRINV_E;
/
create or replace trigger taur_ds_URWAY_VCLRINV_N
   after insert or update of VCLRINV_N on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_VCLRINV_N 
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

when ( nvl( new.VCLRINV_N, -9 ) <>  nvl( old.VCLRINV_N, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'VCLRINV_N', 
      TO_CHAR( :old.VCLRINV_N ), 
      TO_CHAR( :new.VCLRINV_N ),
      5,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_VCLRINV_N');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_VCLRINV_N failed' );
	 end if;
end taur_ds_URWAY_VCLRINV_N;
/
create or replace trigger taur_ds_URWAY_VCLRINV_S
   after insert or update of VCLRINV_S on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_VCLRINV_S 
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

when ( nvl( new.VCLRINV_S, -9 ) <>  nvl( old.VCLRINV_S, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'VCLRINV_S', 
      TO_CHAR( :old.VCLRINV_S ), 
      TO_CHAR( :new.VCLRINV_S ),
      5,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_VCLRINV_S');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_VCLRINV_S failed' );
	 end if;
end taur_ds_URWAY_VCLRINV_S;
/
create or replace trigger taur_ds_URWAY_VCLRINV_W
   after insert or update of VCLRINV_W on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_VCLRINV_W 
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

when ( nvl( new.VCLRINV_W, -9 ) <>  nvl( old.VCLRINV_W, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'VCLRINV_W', 
      TO_CHAR( :old.VCLRINV_W ), 
      TO_CHAR( :new.VCLRINV_W ),
      5,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_VCLRINV_W');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_VCLRINV_W failed' );
	 end if;
end taur_ds_URWAY_VCLRINV_W;
/
create or replace trigger taur_ds_URWAY_VCLR_E
   after insert or update of VCLR_E on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_VCLR_E 
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

when ( nvl( new.VCLR_E, -9 ) <>  nvl( old.VCLR_E, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'VCLR_E', 
      TO_CHAR( :old.VCLR_E ), 
      TO_CHAR( :new.VCLR_E ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_VCLR_E');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_VCLR_E failed' );
	 end if;
end taur_ds_URWAY_VCLR_E;
/
create or replace trigger taur_ds_URWAY_VCLR_N
   after insert or update of VCLR_N on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_VCLR_N 
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

when ( nvl( new.VCLR_N, -9 ) <>  nvl( old.VCLR_N, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'VCLR_N', 
      TO_CHAR( :old.VCLR_N ), 
      TO_CHAR( :new.VCLR_N ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_VCLR_N');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_VCLR_N failed' );
	 end if;
end taur_ds_URWAY_VCLR_N;
/
create or replace trigger taur_ds_URWAY_VCLR_S
   after insert or update of VCLR_S on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_VCLR_S 
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

when ( nvl( new.VCLR_S, -9 ) <>  nvl( old.VCLR_S, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'VCLR_S', 
      TO_CHAR( :old.VCLR_S ), 
      TO_CHAR( :new.VCLR_S ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_VCLR_S');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_VCLR_S failed' );
	 end if;
end taur_ds_URWAY_VCLR_S;
/
create or replace trigger taur_ds_URWAY_VCLR_W
   after insert or update of VCLR_W on USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_VCLR_W 
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

when ( nvl( new.VCLR_W, -9 ) <>  nvl( old.VCLR_W, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.clr_route, :new.on_under ), 
      'BRIDGE_ID,CLR_ROUTE', 
      'USERRWAY', 
      'VCLR_W', 
      TO_CHAR( :old.VCLR_W ), 
      TO_CHAR( :new.VCLR_W ),
      6,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_VCLR_W');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_VCLR_W failed' );
	 end if;
end taur_ds_URWAY_VCLR_W;
/
create or replace trigger taur_ds_USTR_ABUT_FOOT_FAR
   after insert or update of ABUT_FOOT_FAR on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_ABUT_FOOT_FAR 
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

when ( nvl( new.ABUT_FOOT_FAR, '<MISSING>' ) <>  nvl( old.ABUT_FOOT_FAR, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'ABUT_FOOT_FAR', 
      :old.ABUT_FOOT_FAR, 
      :new.ABUT_FOOT_FAR,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_ABUT_FOOT_FAR');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_ABUT_FOOT_FAR failed' );
	 end if;
end taur_ds_USTR_ABUT_FOOT_FAR;
/
create or replace trigger taur_ds_USTR_ABUT_FOOT_NEAR
   after insert or update of ABUT_FOOT_NEAR on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_ABUT_FOOT_NEAR 
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

when ( nvl( new.ABUT_FOOT_NEAR, '<MISSING>' ) <>  nvl( old.ABUT_FOOT_NEAR, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'ABUT_FOOT_NEAR', 
      :old.ABUT_FOOT_NEAR, 
      :new.ABUT_FOOT_NEAR,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_ABUT_FOOT_NEAR');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_ABUT_FOOT_NEAR failed' );
	 end if;
end taur_ds_USTR_ABUT_FOOT_NEAR;
/
create or replace trigger taur_ds_USTR_ABUT_TYPE_FAR
   after insert or update of ABUT_TYPE_FAR on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_ABUT_TYPE_FAR 
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

when ( nvl( new.ABUT_TYPE_FAR, '<MISSING>' ) <>  nvl( old.ABUT_TYPE_FAR, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'ABUT_TYPE_FAR', 
      :old.ABUT_TYPE_FAR, 
      :new.ABUT_TYPE_FAR,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_ABUT_TYPE_FAR');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_ABUT_TYPE_FAR failed' );
	 end if;
end taur_ds_USTR_ABUT_TYPE_FAR;
/
create or replace trigger taur_ds_USTR_ABUT_TYPE_NEAR
   after insert or update of ABUT_TYPE_NEAR on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_ABUT_TYPE_NEAR 
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

when ( nvl( new.ABUT_TYPE_NEAR, '<MISSING>' ) <>  nvl( old.ABUT_TYPE_NEAR, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'ABUT_TYPE_NEAR', 
      :old.ABUT_TYPE_NEAR, 
      :new.ABUT_TYPE_NEAR,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_ABUT_TYPE_NEAR');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_ABUT_TYPE_NEAR failed' );
	 end if;
end taur_ds_USTR_ABUT_TYPE_NEAR;
/
create or replace trigger taur_ds_USTR_BEARING_TYPE
   after insert or update of BEARING_TYPE on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_BEARING_TYPE 
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

when ( nvl( new.BEARING_TYPE, '<MISSING>' ) <>  nvl( old.BEARING_TYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'BEARING_TYPE', 
      :old.BEARING_TYPE, 
      :new.BEARING_TYPE,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_BEARING_TYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_BEARING_TYPE failed' );
	 end if;
end taur_ds_USTR_BEARING_TYPE;
/
create or replace trigger taur_ds_USTR_DECKSEAL
   after insert or update of DECKSEAL on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_DECKSEAL 
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

when ( nvl( new.DECKSEAL, '<MISSING>' ) <>  nvl( old.DECKSEAL, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'DECKSEAL', 
      :old.DECKSEAL, 
      :new.DECKSEAL,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_DECKSEAL');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_DECKSEAL failed' );
	 end if;
end taur_ds_USTR_DECKSEAL;
/
create or replace trigger taur_ds_USTR_DECK_MATRL
   after insert or update of DECK_MATRL on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_DECK_MATRL 
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

when ( nvl( new.DECK_MATRL, '<MISSING>' ) <>  nvl( old.DECK_MATRL, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'DECK_MATRL', 
      :old.DECK_MATRL, 
      :new.DECK_MATRL,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_DECK_MATRL');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_DECK_MATRL failed' );
	 end if;
end taur_ds_USTR_DECK_MATRL;
/
create or replace trigger taur_ds_USTR_DECK_THICK
   after insert or update of DECK_THICK on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_DECK_THICK 
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

when ( nvl( new.DECK_THICK, -9 ) <>  nvl( old.DECK_THICK, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'DECK_THICK', 
      TO_CHAR( :old.DECK_THICK ), 
      TO_CHAR( :new.DECK_THICK ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_DECK_THICK');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_DECK_THICK failed' );
	 end if;
end taur_ds_USTR_DECK_THICK;
/
create or replace trigger taur_ds_USTR_DKMEMBTYPE
   after insert or update of DKMEMBTYPE on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_DKMEMBTYPE 
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

when ( nvl( new.DKMEMBTYPE, '<MISSING>' ) <>  nvl( old.DKMEMBTYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'DKMEMBTYPE', 
      :old.DKMEMBTYPE, 
      :new.DKMEMBTYPE,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_DKMEMBTYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_DKMEMBTYPE failed' );
	 end if;
end taur_ds_USTR_DKMEMBTYPE;
/
create or replace trigger taur_ds_USTR_DKPROTECT
   after insert or update of DKPROTECT on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_DKPROTECT 
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

when ( nvl( new.DKPROTECT, '<MISSING>' ) <>  nvl( old.DKPROTECT, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'DKPROTECT', 
      :old.DKPROTECT, 
      :new.DKPROTECT,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_DKPROTECT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_DKPROTECT failed' );
	 end if;
end taur_ds_USTR_DKPROTECT;
/
create or replace trigger taur_ds_USTR_DKSURFTYPE
   after insert or update of DKSURFTYPE on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_DKSURFTYPE 
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

when ( nvl( new.DKSURFTYPE, '<MISSING>' ) <>  nvl( old.DKSURFTYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'DKSURFTYPE', 
      :old.DKSURFTYPE, 
      :new.DKSURFTYPE,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_DKSURFTYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_DKSURFTYPE failed' );
	 end if;
end taur_ds_USTR_DKSURFTYPE;
/
create or replace trigger taur_ds_USTR_DK_DRAIN_SYS
   after insert or update of DK_DRAIN_SYS on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_DK_DRAIN_SYS 
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

when ( nvl( new.DK_DRAIN_SYS, '<MISSING>' ) <>  nvl( old.DK_DRAIN_SYS, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'DK_DRAIN_SYS', 
      :old.DK_DRAIN_SYS, 
      :new.DK_DRAIN_SYS,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_DK_DRAIN_SYS');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_DK_DRAIN_SYS failed' );
	 end if;
end taur_ds_USTR_DK_DRAIN_SYS;
/
create or replace trigger taur_ds_USTR_EXPAN_DEV_FAR
   after insert or update of EXPAN_DEV_FAR on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_EXPAN_DEV_FAR 
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

when ( nvl( new.EXPAN_DEV_FAR, '<MISSING>' ) <>  nvl( old.EXPAN_DEV_FAR, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'EXPAN_DEV_FAR', 
      :old.EXPAN_DEV_FAR, 
      :new.EXPAN_DEV_FAR,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_EXPAN_DEV_FAR');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_EXPAN_DEV_FAR failed' );
	 end if;
end taur_ds_USTR_EXPAN_DEV_FAR;
/
create or replace trigger taur_ds_USTR_EXPAN_DEV_NEAR
   after insert or update of EXPAN_DEV_NEAR on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_EXPAN_DEV_NEAR 
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

when ( nvl( new.EXPAN_DEV_NEAR, '<MISSING>' ) <>  nvl( old.EXPAN_DEV_NEAR, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'EXPAN_DEV_NEAR', 
      :old.EXPAN_DEV_NEAR, 
      :new.EXPAN_DEV_NEAR,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_EXPAN_DEV_NEAR');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_EXPAN_DEV_NEAR failed' );
	 end if;
end taur_ds_USTR_EXPAN_DEV_NEAR;
/
create or replace trigger taur_ds_USTR_HINGE_TYPE
   after insert or update of HINGE_TYPE on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_HINGE_TYPE 
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

when ( nvl( new.HINGE_TYPE, '<MISSING>' ) <>  nvl( old.HINGE_TYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'HINGE_TYPE', 
      :old.HINGE_TYPE, 
      :new.HINGE_TYPE,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_HINGE_TYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_HINGE_TYPE failed' );
	 end if;
end taur_ds_USTR_HINGE_TYPE;
/
create or replace trigger taur_ds_USTR_LENGTH
   after insert or update of LENGTH on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_LENGTH 
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

when ( nvl( new.LENGTH, -9 ) <>  nvl( old.LENGTH, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'LENGTH', 
      TO_CHAR( :old.LENGTH ), 
      TO_CHAR( :new.LENGTH ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_LENGTH');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_LENGTH failed' );
	 end if;
end taur_ds_USTR_LENGTH;
/
create or replace trigger taur_ds_USTR_LEN_SPAN_GRP_1
   after insert or update of LEN_SPAN_GRP_1 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_LEN_SPAN_GRP_1 
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

when ( nvl( new.LEN_SPAN_GRP_1, -9 ) <>  nvl( old.LEN_SPAN_GRP_1, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'LEN_SPAN_GRP_1', 
      TO_CHAR( :old.LEN_SPAN_GRP_1 ), 
      TO_CHAR( :new.LEN_SPAN_GRP_1 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_LEN_SPAN_GRP_1');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_LEN_SPAN_GRP_1 failed' );
	 end if;
end taur_ds_USTR_LEN_SPAN_GRP_1;
/
create or replace trigger taur_ds_USTR_LEN_SPAN_GRP_10
   after insert or update of LEN_SPAN_GRP_10 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_LEN_SPAN_GRP_10 
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

when ( nvl( new.LEN_SPAN_GRP_10, -9 ) <>  nvl( old.LEN_SPAN_GRP_10, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'LEN_SPAN_GRP_10', 
      TO_CHAR( :old.LEN_SPAN_GRP_10 ), 
      TO_CHAR( :new.LEN_SPAN_GRP_10 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_LEN_SPAN_GRP_10');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_LEN_SPAN_GRP_10 failed' );
	 end if;
end taur_ds_USTR_LEN_SPAN_GRP_10;
/
create or replace trigger taur_ds_USTR_LEN_SPAN_GRP_2
   after insert or update of LEN_SPAN_GRP_2 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_LEN_SPAN_GRP_2 
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

when ( nvl( new.LEN_SPAN_GRP_2, -9 ) <>  nvl( old.LEN_SPAN_GRP_2, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'LEN_SPAN_GRP_2', 
      TO_CHAR( :old.LEN_SPAN_GRP_2 ), 
      TO_CHAR( :new.LEN_SPAN_GRP_2 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_LEN_SPAN_GRP_2');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_LEN_SPAN_GRP_2 failed' );
	 end if;
end taur_ds_USTR_LEN_SPAN_GRP_2;
/
create or replace trigger taur_ds_USTR_LEN_SPAN_GRP_3
   after insert or update of LEN_SPAN_GRP_3 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_LEN_SPAN_GRP_3 
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

when ( nvl( new.LEN_SPAN_GRP_3, -9 ) <>  nvl( old.LEN_SPAN_GRP_3, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'LEN_SPAN_GRP_3', 
      TO_CHAR( :old.LEN_SPAN_GRP_3 ), 
      TO_CHAR( :new.LEN_SPAN_GRP_3 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_LEN_SPAN_GRP_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_LEN_SPAN_GRP_3 failed' );
	 end if;
end taur_ds_USTR_LEN_SPAN_GRP_3;
/
create or replace trigger taur_ds_USTR_LEN_SPAN_GRP_4
   after insert or update of LEN_SPAN_GRP_4 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_LEN_SPAN_GRP_4 
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

when ( nvl( new.LEN_SPAN_GRP_4, -9 ) <>  nvl( old.LEN_SPAN_GRP_4, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'LEN_SPAN_GRP_4', 
      TO_CHAR( :old.LEN_SPAN_GRP_4 ), 
      TO_CHAR( :new.LEN_SPAN_GRP_4 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_LEN_SPAN_GRP_4');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_LEN_SPAN_GRP_4 failed' );
	 end if;
end taur_ds_USTR_LEN_SPAN_GRP_4;
/
create or replace trigger taur_ds_USTR_LEN_SPAN_GRP_5
   after insert or update of LEN_SPAN_GRP_5 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_LEN_SPAN_GRP_5 
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

when ( nvl( new.LEN_SPAN_GRP_5, -9 ) <>  nvl( old.LEN_SPAN_GRP_5, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'LEN_SPAN_GRP_5', 
      TO_CHAR( :old.LEN_SPAN_GRP_5 ), 
      TO_CHAR( :new.LEN_SPAN_GRP_5 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_LEN_SPAN_GRP_5');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_LEN_SPAN_GRP_5 failed' );
	 end if;
end taur_ds_USTR_LEN_SPAN_GRP_5;
/
create or replace trigger taur_ds_USTR_LEN_SPAN_GRP_6
   after insert or update of LEN_SPAN_GRP_6 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_LEN_SPAN_GRP_6 
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

when ( nvl( new.LEN_SPAN_GRP_6, -9 ) <>  nvl( old.LEN_SPAN_GRP_6, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'LEN_SPAN_GRP_6', 
      TO_CHAR( :old.LEN_SPAN_GRP_6 ), 
      TO_CHAR( :new.LEN_SPAN_GRP_6 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_LEN_SPAN_GRP_6');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_LEN_SPAN_GRP_6 failed' );
	 end if;
end taur_ds_USTR_LEN_SPAN_GRP_6;
/
create or replace trigger taur_ds_USTR_LEN_SPAN_GRP_7
   after insert or update of LEN_SPAN_GRP_7 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_LEN_SPAN_GRP_7 
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

when ( nvl( new.LEN_SPAN_GRP_7, -9 ) <>  nvl( old.LEN_SPAN_GRP_7, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'LEN_SPAN_GRP_7', 
      TO_CHAR( :old.LEN_SPAN_GRP_7 ), 
      TO_CHAR( :new.LEN_SPAN_GRP_7 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_LEN_SPAN_GRP_7');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_LEN_SPAN_GRP_7 failed' );
	 end if;
end taur_ds_USTR_LEN_SPAN_GRP_7;
/
create or replace trigger taur_ds_USTR_LEN_SPAN_GRP_8
   after insert or update of LEN_SPAN_GRP_8 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_LEN_SPAN_GRP_8 
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

when ( nvl( new.LEN_SPAN_GRP_8, -9 ) <>  nvl( old.LEN_SPAN_GRP_8, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'LEN_SPAN_GRP_8', 
      TO_CHAR( :old.LEN_SPAN_GRP_8 ), 
      TO_CHAR( :new.LEN_SPAN_GRP_8 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_LEN_SPAN_GRP_8');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_LEN_SPAN_GRP_8 failed' );
	 end if;
end taur_ds_USTR_LEN_SPAN_GRP_8;
/
create or replace trigger taur_ds_USTR_LEN_SPAN_GRP_9
   after insert or update of LEN_SPAN_GRP_9 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_LEN_SPAN_GRP_9 
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

when ( nvl( new.LEN_SPAN_GRP_9, -9 ) <>  nvl( old.LEN_SPAN_GRP_9, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'LEN_SPAN_GRP_9', 
      TO_CHAR( :old.LEN_SPAN_GRP_9 ), 
      TO_CHAR( :new.LEN_SPAN_GRP_9 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_LEN_SPAN_GRP_9');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_LEN_SPAN_GRP_9 failed' );
	 end if;
end taur_ds_USTR_LEN_SPAN_GRP_9;
/
create or replace trigger taur_ds_USTR_NUM_GIRDERS
   after insert or update of NUM_GIRDERS on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_NUM_GIRDERS 
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

when ( nvl( new.NUM_GIRDERS, -9 ) <>  nvl( old.NUM_GIRDERS, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'NUM_GIRDERS', 
      TO_CHAR( :old.NUM_GIRDERS ), 
      TO_CHAR( :new.NUM_GIRDERS ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_NUM_GIRDERS');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_NUM_GIRDERS failed' );
	 end if;
end taur_ds_USTR_NUM_GIRDERS;
/
create or replace trigger taur_ds_USTR_NUM_SPANS_GRP_1
   after insert or update of NUM_SPANS_GRP_1 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_NUM_SPANS_GRP_1 
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

when ( nvl( new.NUM_SPANS_GRP_1, -9 ) <>  nvl( old.NUM_SPANS_GRP_1, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'NUM_SPANS_GRP_1', 
      TO_CHAR( :old.NUM_SPANS_GRP_1 ), 
      TO_CHAR( :new.NUM_SPANS_GRP_1 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_NUM_SPANS_GRP_1');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_NUM_SPANS_GRP_1 failed' );
	 end if;
end taur_ds_USTR_NUM_SPANS_GRP_1;
/
create or replace trigger taur_ds_USTR_NUM_SPANS_GRP_10
   after insert or update of NUM_SPANS_GRP_10 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_NUM_SPANS_GRP_10 
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

when ( nvl( new.NUM_SPANS_GRP_10, -9 ) <>  nvl( old.NUM_SPANS_GRP_10, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'NUM_SPANS_GRP_10', 
      TO_CHAR( :old.NUM_SPANS_GRP_10 ), 
      TO_CHAR( :new.NUM_SPANS_GRP_10 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_NUM_SPANS_GRP_10');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_NUM_SPANS_GRP_10 failed' );
	 end if;
end taur_ds_USTR_NUM_SPANS_GRP_10;
/
create or replace trigger taur_ds_USTR_NUM_SPANS_GRP_2
   after insert or update of NUM_SPANS_GRP_2 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_NUM_SPANS_GRP_2 
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

when ( nvl( new.NUM_SPANS_GRP_2, -9 ) <>  nvl( old.NUM_SPANS_GRP_2, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'NUM_SPANS_GRP_2', 
      TO_CHAR( :old.NUM_SPANS_GRP_2 ), 
      TO_CHAR( :new.NUM_SPANS_GRP_2 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_NUM_SPANS_GRP_2');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_NUM_SPANS_GRP_2 failed' );
	 end if;
end taur_ds_USTR_NUM_SPANS_GRP_2;
/
create or replace trigger taur_ds_USTR_NUM_SPANS_GRP_3
   after insert or update of NUM_SPANS_GRP_3 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_NUM_SPANS_GRP_3 
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

when ( nvl( new.NUM_SPANS_GRP_3, -9 ) <>  nvl( old.NUM_SPANS_GRP_3, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'NUM_SPANS_GRP_3', 
      TO_CHAR( :old.NUM_SPANS_GRP_3 ), 
      TO_CHAR( :new.NUM_SPANS_GRP_3 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_NUM_SPANS_GRP_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_NUM_SPANS_GRP_3 failed' );
	 end if;
end taur_ds_USTR_NUM_SPANS_GRP_3;
/
create or replace trigger taur_ds_USTR_NUM_SPANS_GRP_4
   after insert or update of NUM_SPANS_GRP_4 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_NUM_SPANS_GRP_4 
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

when ( nvl( new.NUM_SPANS_GRP_4, -9 ) <>  nvl( old.NUM_SPANS_GRP_4, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'NUM_SPANS_GRP_4', 
      TO_CHAR( :old.NUM_SPANS_GRP_4 ), 
      TO_CHAR( :new.NUM_SPANS_GRP_4 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_NUM_SPANS_GRP_4');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_NUM_SPANS_GRP_4 failed' );
	 end if;
end taur_ds_USTR_NUM_SPANS_GRP_4;
/
create or replace trigger taur_ds_USTR_NUM_SPANS_GRP_5
   after insert or update of NUM_SPANS_GRP_5 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_NUM_SPANS_GRP_5 
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

when ( nvl( new.NUM_SPANS_GRP_5, -9 ) <>  nvl( old.NUM_SPANS_GRP_5, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'NUM_SPANS_GRP_5', 
      TO_CHAR( :old.NUM_SPANS_GRP_5 ), 
      TO_CHAR( :new.NUM_SPANS_GRP_5 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_NUM_SPANS_GRP_5');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_NUM_SPANS_GRP_5 failed' );
	 end if;
end taur_ds_USTR_NUM_SPANS_GRP_5;
/
create or replace trigger taur_ds_USTR_NUM_SPANS_GRP_6
   after insert or update of NUM_SPANS_GRP_6 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_NUM_SPANS_GRP_6 
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

when ( nvl( new.NUM_SPANS_GRP_6, -9 ) <>  nvl( old.NUM_SPANS_GRP_6, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'NUM_SPANS_GRP_6', 
      TO_CHAR( :old.NUM_SPANS_GRP_6 ), 
      TO_CHAR( :new.NUM_SPANS_GRP_6 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_NUM_SPANS_GRP_6');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_NUM_SPANS_GRP_6 failed' );
	 end if;
end taur_ds_USTR_NUM_SPANS_GRP_6;
/
create or replace trigger taur_ds_USTR_NUM_SPANS_GRP_7
   after insert or update of NUM_SPANS_GRP_7 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_NUM_SPANS_GRP_7 
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

when ( nvl( new.NUM_SPANS_GRP_7, -9 ) <>  nvl( old.NUM_SPANS_GRP_7, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'NUM_SPANS_GRP_7', 
      TO_CHAR( :old.NUM_SPANS_GRP_7 ), 
      TO_CHAR( :new.NUM_SPANS_GRP_7 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_NUM_SPANS_GRP_7');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_NUM_SPANS_GRP_7 failed' );
	 end if;
end taur_ds_USTR_NUM_SPANS_GRP_7;
/
create or replace trigger taur_ds_USTR_NUM_SPANS_GRP_8
   after insert or update of NUM_SPANS_GRP_8 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_NUM_SPANS_GRP_8 
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

when ( nvl( new.NUM_SPANS_GRP_8, -9 ) <>  nvl( old.NUM_SPANS_GRP_8, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'NUM_SPANS_GRP_8', 
      TO_CHAR( :old.NUM_SPANS_GRP_8 ), 
      TO_CHAR( :new.NUM_SPANS_GRP_8 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_NUM_SPANS_GRP_8');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_NUM_SPANS_GRP_8 failed' );
	 end if;
end taur_ds_USTR_NUM_SPANS_GRP_8;
/
create or replace trigger taur_ds_USTR_NUM_SPANS_GRP_9
   after insert or update of NUM_SPANS_GRP_9 on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_NUM_SPANS_GRP_9 
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

when ( nvl( new.NUM_SPANS_GRP_9, -9 ) <>  nvl( old.NUM_SPANS_GRP_9, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'NUM_SPANS_GRP_9', 
      TO_CHAR( :old.NUM_SPANS_GRP_9 ), 
      TO_CHAR( :new.NUM_SPANS_GRP_9 ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_NUM_SPANS_GRP_9');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_NUM_SPANS_GRP_9 failed' );
	 end if;
end taur_ds_USTR_NUM_SPANS_GRP_9;
/
create or replace trigger taur_ds_USTR_PIER_FOOT_TYPE
   after insert or update of PIER_FOOT_TYPE on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_PIER_FOOT_TYPE 
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

when ( nvl( new.PIER_FOOT_TYPE, '<MISSING>' ) <>  nvl( old.PIER_FOOT_TYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'PIER_FOOT_TYPE', 
      :old.PIER_FOOT_TYPE, 
      :new.PIER_FOOT_TYPE,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_PIER_FOOT_TYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_PIER_FOOT_TYPE failed' );
	 end if;
end taur_ds_USTR_PIER_FOOT_TYPE;
/
create or replace trigger taur_ds_USTR_PIER_TYPE
   after insert or update of PIER_TYPE on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_PIER_TYPE 
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

when ( nvl( new.PIER_TYPE, '<MISSING>' ) <>  nvl( old.PIER_TYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'PIER_TYPE', 
      :old.PIER_TYPE, 
      :new.PIER_TYPE,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_PIER_TYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_PIER_TYPE failed' );
	 end if;
end taur_ds_USTR_PIER_TYPE;
/
create or replace trigger taur_ds_USTR_RAIL_TYPE
   after insert or update of RAIL_TYPE on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_RAIL_TYPE 
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

when ( nvl( new.RAIL_TYPE, '<MISSING>' ) <>  nvl( old.RAIL_TYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'RAIL_TYPE', 
      :old.RAIL_TYPE, 
      :new.RAIL_TYPE,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_RAIL_TYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_RAIL_TYPE failed' );
	 end if;
end taur_ds_USTR_RAIL_TYPE;
/
create or replace trigger taur_ds_USTR_SUPER_DESIGN_TY
   after insert or update of SUPER_DESIGN_TY on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_SUPER_DESIGN_TY 
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

when ( nvl( new.SUPER_DESIGN_TY, '<MISSING>' ) <>  nvl( old.SUPER_DESIGN_TY, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'SUPER_DESIGN_TY', 
      :old.SUPER_DESIGN_TY, 
      :new.SUPER_DESIGN_TY,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_SUPER_DESIGN_TY');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_SUPER_DESIGN_TY failed' );
	 end if;
end taur_ds_USTR_SUPER_DESIGN_TY;
/
create or replace trigger taur_ds_USTR_UNIT_MATERIAL
   after insert or update of UNIT_MATERIAL on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_UNIT_MATERIAL 
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

when ( nvl( new.UNIT_MATERIAL, '<MISSING>' ) <>  nvl( old.UNIT_MATERIAL, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'UNIT_MATERIAL', 
      :old.UNIT_MATERIAL, 
      :new.UNIT_MATERIAL,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_UNIT_MATERIAL');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_UNIT_MATERIAL failed' );
	 end if;
end taur_ds_USTR_UNIT_MATERIAL;
/
create or replace trigger taur_ds_USTR_UNIT_TYPE
   after insert or update of UNIT_TYPE on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_UNIT_TYPE 
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

when ( nvl( new.UNIT_TYPE, '<MISSING>' ) <>  nvl( old.UNIT_TYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'UNIT_TYPE', 
      :old.UNIT_TYPE, 
      :new.UNIT_TYPE,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_UNIT_TYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_UNIT_TYPE failed' );
	 end if;
end taur_ds_USTR_UNIT_TYPE;
/
create or replace trigger taur_ds_USTR_WEAR_THICK
   after insert or update of WEAR_THICK on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_WEAR_THICK 
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

when ( nvl( new.WEAR_THICK, -9 ) <>  nvl( old.WEAR_THICK, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'WEAR_THICK', 
      TO_CHAR( :old.WEAR_THICK ), 
      TO_CHAR( :new.WEAR_THICK ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_WEAR_THICK');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_WEAR_THICK failed' );
	 end if;
end taur_ds_USTR_WEAR_THICK;
/
create or replace trigger taur_ds_USTR_WIDE_DESIGN_TY
   after insert or update of WIDE_DESIGN_TY on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_WIDE_DESIGN_TY 
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

when ( nvl( new.WIDE_DESIGN_TY, '<MISSING>' ) <>  nvl( old.WIDE_DESIGN_TY, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'WIDE_DESIGN_TY', 
      :old.WIDE_DESIGN_TY, 
      :new.WIDE_DESIGN_TY,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_WIDE_DESIGN_TY');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_WIDE_DESIGN_TY failed' );
	 end if;
end taur_ds_USTR_WIDE_DESIGN_TY;
/
create or replace trigger taur_ds_USTR_WIDE_MATERIAL
   after insert or update of WIDE_MATERIAL on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_WIDE_MATERIAL 
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

when ( nvl( new.WIDE_MATERIAL, '<MISSING>' ) <>  nvl( old.WIDE_MATERIAL, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'WIDE_MATERIAL', 
      :old.WIDE_MATERIAL, 
      :new.WIDE_MATERIAL,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_WIDE_MATERIAL');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_WIDE_MATERIAL failed' );
	 end if;
end taur_ds_USTR_WIDE_MATERIAL;
/
create or replace trigger taur_ds_USTR_WIDE_NUM_GIRDERS
   after insert or update of WIDE_NUM_GIRDERS on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_WIDE_NUM_GIRDERS 
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

when ( nvl( new.WIDE_NUM_GIRDERS, -9 ) <>  nvl( old.WIDE_NUM_GIRDERS, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'WIDE_NUM_GIRDERS', 
      TO_CHAR( :old.WIDE_NUM_GIRDERS ), 
      TO_CHAR( :new.WIDE_NUM_GIRDERS ),
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_WIDE_NUM_GIRDERS');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_WIDE_NUM_GIRDERS failed' );
	 end if;
end taur_ds_USTR_WIDE_NUM_GIRDERS;
/
create or replace trigger taur_ds_USTR_WIDE_TYPE
   after insert or update of WIDE_TYPE on USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_USTR_WIDE_TYPE 
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

when ( nvl( new.WIDE_TYPE, '<MISSING>' ) <>  nvl( old.WIDE_TYPE, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params( 
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ), 
      'BRIDGE_ID,STRUNITLABEL', 
      'USERSTRUNIT', 
      'WIDE_TYPE', 
      :old.WIDE_TYPE, 
      :new.WIDE_TYPE,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_USTR_WIDE_TYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_USTR_WIDE_TYPE failed' );
	 end if;
end taur_ds_USTR_WIDE_TYPE;
/
*/
   end a_place_to_stash_trigger_code;
   
   -- The POST-2/16/2002 version that does NOT change keys
   function f_test_triggers
      return boolean
   is

		-- Declarations
		v_WIDE_TYPE USERSTRUNIT.WIDE_TYPE%TYPE;
		v_WIDE_NUM_GIRDERS USERSTRUNIT.WIDE_NUM_GIRDERS%TYPE;
		v_WIDE_MATERIAL USERSTRUNIT.WIDE_MATERIAL%TYPE;
		v_WIDE_DESIGN_TY USERSTRUNIT.WIDE_DESIGN_TY%TYPE;
		v_WEAR_THICK USERSTRUNIT.WEAR_THICK%TYPE;
		v_UNIT_TYPE USERSTRUNIT.UNIT_TYPE%TYPE;
		v_UNIT_MATERIAL USERSTRUNIT.UNIT_MATERIAL%TYPE;
		v_SUPER_DESIGN_TY USERSTRUNIT.SUPER_DESIGN_TY%TYPE;
		v_RAIL_TYPE USERSTRUNIT.RAIL_TYPE%TYPE;
		v_PIER_TYPE USERSTRUNIT.PIER_TYPE%TYPE;
		v_PIER_FOOT_TYPE USERSTRUNIT.PIER_FOOT_TYPE%TYPE;
		v_NUM_SPANS_GRP_9 USERSTRUNIT.NUM_SPANS_GRP_9%TYPE;
		v_NUM_SPANS_GRP_8 USERSTRUNIT.NUM_SPANS_GRP_8%TYPE;
		v_NUM_SPANS_GRP_7 USERSTRUNIT.NUM_SPANS_GRP_7%TYPE;
		v_NUM_SPANS_GRP_6 USERSTRUNIT.NUM_SPANS_GRP_6%TYPE;
		v_NUM_SPANS_GRP_5 USERSTRUNIT.NUM_SPANS_GRP_5%TYPE;
		v_NUM_SPANS_GRP_4 USERSTRUNIT.NUM_SPANS_GRP_4%TYPE;
		v_NUM_SPANS_GRP_3 USERSTRUNIT.NUM_SPANS_GRP_3%TYPE;
		v_NUM_SPANS_GRP_2 USERSTRUNIT.NUM_SPANS_GRP_2%TYPE;
		v_NUM_SPANS_GRP_10 USERSTRUNIT.NUM_SPANS_GRP_10%TYPE;
		v_NUM_SPANS_GRP_1 USERSTRUNIT.NUM_SPANS_GRP_1%TYPE;
		v_NUM_GIRDERS USERSTRUNIT.NUM_GIRDERS%TYPE;
		v_LEN_SPAN_GRP_9 USERSTRUNIT.LEN_SPAN_GRP_9%TYPE;
		v_LEN_SPAN_GRP_8 USERSTRUNIT.LEN_SPAN_GRP_8%TYPE;
		v_LEN_SPAN_GRP_7 USERSTRUNIT.LEN_SPAN_GRP_7%TYPE;
		v_LEN_SPAN_GRP_6 USERSTRUNIT.LEN_SPAN_GRP_6%TYPE;
		v_LEN_SPAN_GRP_5 USERSTRUNIT.LEN_SPAN_GRP_5%TYPE;
		v_LEN_SPAN_GRP_4 USERSTRUNIT.LEN_SPAN_GRP_4%TYPE;
		v_LEN_SPAN_GRP_3 USERSTRUNIT.LEN_SPAN_GRP_3%TYPE;
		v_LEN_SPAN_GRP_2 USERSTRUNIT.LEN_SPAN_GRP_2%TYPE;
		v_LEN_SPAN_GRP_10 USERSTRUNIT.LEN_SPAN_GRP_10%TYPE;
		v_LEN_SPAN_GRP_1 USERSTRUNIT.LEN_SPAN_GRP_1%TYPE;
		v_LENGTH USERSTRUNIT.LENGTH%TYPE;
		v_HINGE_TYPE USERSTRUNIT.HINGE_TYPE%TYPE;
		v_EXPAN_DEV_NEAR USERSTRUNIT.EXPAN_DEV_NEAR%TYPE;
		v_EXPAN_DEV_FAR USERSTRUNIT.EXPAN_DEV_FAR%TYPE;
		v_DK_DRAIN_SYS USERSTRUNIT.DK_DRAIN_SYS%TYPE;
		v_DKSURFTYPE USERSTRUNIT.DKSURFTYPE%TYPE;
		v_DKPROTECT USERSTRUNIT.DKPROTECT%TYPE;
		v_DKMEMBTYPE USERSTRUNIT.DKMEMBTYPE%TYPE;
		v_DECK_THICK USERSTRUNIT.DECK_THICK%TYPE;
		v_DECK_MATRL USERSTRUNIT.DECK_MATRL%TYPE;
		v_DECKSEAL USERSTRUNIT.DECKSEAL%TYPE;
		v_BEARING_TYPE USERSTRUNIT.BEARING_TYPE%TYPE;
		v_ABUT_TYPE_NEAR USERSTRUNIT.ABUT_TYPE_NEAR%TYPE;
		v_ABUT_TYPE_FAR USERSTRUNIT.ABUT_TYPE_FAR%TYPE;
		v_ABUT_FOOT_NEAR USERSTRUNIT.ABUT_FOOT_NEAR%TYPE;
		v_ABUT_FOOT_FAR USERSTRUNIT.ABUT_FOOT_FAR%TYPE;
		
		
		v_VCLR_W USERRWAY.VCLR_W%TYPE;
		v_VCLR_S USERRWAY.VCLR_S%TYPE;
		v_VCLR_N USERRWAY.VCLR_N%TYPE;
		v_VCLR_E USERRWAY.VCLR_E%TYPE;
		v_VCLRINV_W USERRWAY.VCLRINV_W%TYPE;
		v_VCLRINV_S USERRWAY.VCLRINV_S%TYPE;
		v_VCLRINV_N USERRWAY.VCLRINV_N%TYPE;
		v_VCLRINV_E USERRWAY.VCLRINV_E%TYPE;
		v_TRANS_LANES USERRWAY.TRANS_LANES%TYPE;
		v_ROUTE_UNIQUE_ID USERRWAY.ROUTE_UNIQUE_ID%TYPE;
		v_ROUTE_SUFFIX USERRWAY.ROUTE_SUFFIX%TYPE;
		v_ROUTE_PREFIX USERRWAY.ROUTE_PREFIX%TYPE;
		v_ROUTE_NUM USERRWAY.ROUTE_NUM%TYPE;
		v_ROAD_CROSS_NAME USERRWAY.ROAD_CROSS_NAME%TYPE;
		v_MAINT_RTE_SUFFIX USERRWAY.MAINT_RTE_SUFFIX%TYPE;
		v_MAINT_RTE_PREFIX USERRWAY.MAINT_RTE_PREFIX%TYPE;
		v_MAINT_RTE_NUM USERRWAY.MAINT_RTE_NUM%TYPE;
		v_MAINT_RTE_ID USERRWAY.MAINT_RTE_ID%TYPE;
		v_HCLR_W USERRWAY.HCLR_W%TYPE;
		v_HCLR_S USERRWAY.HCLR_S%TYPE;
		v_HCLR_N USERRWAY.HCLR_N%TYPE;
		v_HCLR_E USERRWAY.HCLR_E%TYPE;
		v_HCLRURT_W USERRWAY.HCLRURT_W%TYPE;
		v_HCLRURT_S USERRWAY.HCLRURT_S%TYPE;
		v_HCLRURT_N USERRWAY.HCLRURT_N%TYPE;
		v_HCLRURT_E USERRWAY.HCLRURT_E%TYPE;
		v_HCLRULT_W USERRWAY.HCLRULT_W%TYPE;
		v_HCLRULT_S USERRWAY.HCLRULT_S%TYPE;
		v_HCLRULT_N USERRWAY.HCLRULT_N%TYPE;
		v_HCLRULT_E USERRWAY.HCLRULT_E%TYPE;
		v_FEAT_DESC_TYPE USERRWAY.FEAT_DESC_TYPE%TYPE;
		v_FEAT_CROSS_TYPE USERRWAY.FEAT_CROSS_TYPE%TYPE;
		v_CLR_ROUTE USERRWAY.CLR_ROUTE%TYPE;
		v_CHAN_PROT_RIGHT USERRWAY.CHAN_PROT_RIGHT%TYPE;
		v_CHAN_PROT_LEFT USERRWAY.CHAN_PROT_LEFT%TYPE;
		v_BERM_PROT USERRWAY.BERM_PROT%TYPE;
		v_AROADWIDTH_NEAR USERRWAY.AROADWIDTH_NEAR%TYPE;
		v_AROADWIDTH_FAR USERRWAY.AROADWIDTH_FAR%TYPE;
		
		
		v_UWINSPFREQ_KDOT USERINSP.UWINSPFREQ_KDOT%TYPE;
		v_UWATER_INSP_TYP USERINSP.UWATER_INSP_TYP%TYPE;
		v_PAINT_COND USERINSP.PAINT_COND%TYPE;
		v_OSINSPFREQ_KDOT USERINSP.OSINSPFREQ_KDOT%TYPE;
		v_OPPOSTCL_KDOT USERINSP.OPPOSTCL_KDOT%TYPE;
		v_FCINSPFREQ_KDOT USERINSP.FCINSPFREQ_KDOT%TYPE;
		v_COND_INDEX USERINSP.COND_INDEX%TYPE;
		v_BRINSPFREQ_KDOT USERINSP.BRINSPFREQ_KDOT%TYPE;
		
		
		v_VERT_UNDR_SIGN USERBRDG.VERT_UNDR_SIGN%TYPE;
		v_VERT_CLR_SIGN USERBRDG.VERT_CLR_SIGN%TYPE;
		v_SUPRSTRUCT_TOS USERBRDG.SUPRSTRUCT_TOS%TYPE;
		v_SUPER_PAINT_SYS USERBRDG.SUPER_PAINT_SYS%TYPE;
		v_STREAM_SIGN USERBRDG.STREAM_SIGN%TYPE;
		v_SKEW_MINUTES USERBRDG.SKEW_MINUTES%TYPE;
		v_SKEW_DIRECTION USERBRDG.SKEW_DIRECTION%TYPE;
		v_SIGN_TYPE_Q4 USERBRDG.SIGN_TYPE_Q4%TYPE;
		v_SIGN_TYPE_Q3 USERBRDG.SIGN_TYPE_Q3%TYPE;
		v_SIGN_TYPE_Q2 USERBRDG.SIGN_TYPE_Q2%TYPE;
		v_SIGN_TYPE_Q1 USERBRDG.SIGN_TYPE_Q1%TYPE;
		v_ROT_DIRECTION USERBRDG.ROT_DIRECTION%TYPE;
		v_ROT_ANGLE_MIN USERBRDG.ROT_ANGLE_MIN%TYPE;
		v_ROT_ANGLE_DEG USERBRDG.ROT_ANGLE_DEG%TYPE;
		v_ROAD_TYPE_SIGN USERBRDG.ROAD_TYPE_SIGN%TYPE;
		v_RESTRICT_LOAD USERBRDG.RESTRICT_LOAD%TYPE;
		v_RATING_COMMENT USERBRDG.RATING_COMMENT%TYPE;
		v_RATING_ADJ USERBRDG.RATING_ADJ%TYPE;
		v_POSTED_SIGN_TYPE USERBRDG.POSTED_SIGN_TYPE%TYPE;
		v_POSTED_LOAD_C USERBRDG.POSTED_LOAD_C%TYPE;
		v_POSTED_LOAD_B USERBRDG.POSTED_LOAD_B%TYPE;
		v_POSTED_LOAD_A USERBRDG.POSTED_LOAD_A%TYPE;
		v_OWNER_KDOT USERBRDG.OWNER_KDOT%TYPE;
		v_ORLOAD_WSD_T170 USERBRDG.ORLOAD_WSD_T170%TYPE;
		v_ORLOAD_WSD_T130 USERBRDG.ORLOAD_WSD_T130%TYPE;
		v_ORLOAD_WSD_HS USERBRDG.ORLOAD_WSD_HS%TYPE;
		v_ORLOAD_WSD_H USERBRDG.ORLOAD_WSD_H%TYPE;
		v_ORLOAD_WSD_3_3 USERBRDG.ORLOAD_WSD_3_3%TYPE;
		v_ORLOAD_WSD_3S2 USERBRDG.ORLOAD_WSD_3S2%TYPE;
		v_ORLOAD_WSD_3 USERBRDG.ORLOAD_WSD_3%TYPE;
		v_ORLOAD_LFD_T170 USERBRDG.ORLOAD_LFD_T170%TYPE;
		v_ORLOAD_LFD_T130 USERBRDG.ORLOAD_LFD_T130%TYPE;
		v_ORLOAD_LFD_HS USERBRDG.ORLOAD_LFD_HS%TYPE;
		v_ORLOAD_LFD_H USERBRDG.ORLOAD_LFD_H%TYPE;
		v_ORLOAD_LFD_3_3 USERBRDG.ORLOAD_LFD_3_3%TYPE;
		v_ORLOAD_LFD_3S2 USERBRDG.ORLOAD_LFD_3S2%TYPE;
		v_ORLOAD_LFD_3 USERBRDG.ORLOAD_LFD_3%TYPE;
		v_ORLOAD_ADJ_T170 USERBRDG.ORLOAD_ADJ_T170%TYPE;
		v_ORLOAD_ADJ_T130 USERBRDG.ORLOAD_ADJ_T130%TYPE;
		v_ORLOAD_ADJ_H USERBRDG.ORLOAD_ADJ_H%TYPE;
		v_ORLOAD_ADJ_3_3 USERBRDG.ORLOAD_ADJ_3_3%TYPE;
		v_ORLOAD_ADJ_3S2 USERBRDG.ORLOAD_ADJ_3S2%TYPE;
		v_ORLOAD_ADJ_3 USERBRDG.ORLOAD_ADJ_3%TYPE;
		v_ORIENTATION USERBRDG.ORIENTATION%TYPE;
		v_MEDIAN_WIDTH USERBRDG.MEDIAN_WIDTH%TYPE;
		v_MAINT_AREA USERBRDG.MAINT_AREA%TYPE;
		v_IRLOAD_WSD_T170 USERBRDG.IRLOAD_WSD_T170%TYPE;
		v_IRLOAD_WSD_T130 USERBRDG.IRLOAD_WSD_T130%TYPE;
		v_IRLOAD_WSD_HS USERBRDG.IRLOAD_WSD_HS%TYPE;
		v_IRLOAD_WSD_H USERBRDG.IRLOAD_WSD_H%TYPE;
		v_IRLOAD_WSD_3_3 USERBRDG.IRLOAD_WSD_3_3%TYPE;
		v_IRLOAD_WSD_3S2 USERBRDG.IRLOAD_WSD_3S2%TYPE;
		v_IRLOAD_WSD_3 USERBRDG.IRLOAD_WSD_3%TYPE;
		v_IRLOAD_LFD_T170 USERBRDG.IRLOAD_LFD_T170%TYPE;
		v_IRLOAD_LFD_T130 USERBRDG.IRLOAD_LFD_T130%TYPE;
		v_IRLOAD_LFD_HS USERBRDG.IRLOAD_LFD_HS%TYPE;
		v_IRLOAD_LFD_H USERBRDG.IRLOAD_LFD_H%TYPE;
		v_IRLOAD_LFD_3_3 USERBRDG.IRLOAD_LFD_3_3%TYPE;
		v_IRLOAD_LFD_3S2 USERBRDG.IRLOAD_LFD_3S2%TYPE;
		v_IRLOAD_LFD_3 USERBRDG.IRLOAD_LFD_3%TYPE;
		v_IRLOAD_ADJ_T170 USERBRDG.IRLOAD_ADJ_T170%TYPE;
		v_IRLOAD_ADJ_T130 USERBRDG.IRLOAD_ADJ_T130%TYPE;
		v_IRLOAD_ADJ_H USERBRDG.IRLOAD_ADJ_H%TYPE;
		v_IRLOAD_ADJ_3_3 USERBRDG.IRLOAD_ADJ_3_3%TYPE;
		v_IRLOAD_ADJ_3S2 USERBRDG.IRLOAD_ADJ_3S2%TYPE;
		v_IRLOAD_ADJ_3 USERBRDG.IRLOAD_ADJ_3%TYPE;
		v_FUNCTION_TYPE USERBRDG.FUNCTION_TYPE%TYPE;
		v_DESIGN_REF_POST USERBRDG.DESIGN_REF_POST%TYPE;
		v_DESIGNLOAD_TYPE USERBRDG.DESIGNLOAD_TYPE%TYPE;
		v_DESIGNLOAD_KDOT USERBRDG.DESIGNLOAD_KDOT%TYPE;
		v_CUSTODIAN_KDOT USERBRDG.CUSTODIAN_KDOT%TYPE;
		v_CULV_WING_TYPE USERBRDG.CULV_WING_TYPE%TYPE;
		v_CULV_FILL_DEPTH USERBRDG.CULV_FILL_DEPTH%TYPE;
		v_BRIDGEMED_KDOT USERBRDG.BRIDGEMED_KDOT%TYPE;
		v_BOX_HEIGHT_CULV USERBRDG.BOX_HEIGHT_CULV%TYPE;
		v_ATTACH_TYPE_3 USERBRDG.ATTACH_TYPE_3%TYPE;
		v_ATTACH_TYPE_2 USERBRDG.ATTACH_TYPE_2%TYPE;
		v_ATTACH_TYPE_1 USERBRDG.ATTACH_TYPE_1%TYPE;
		v_ATTACH_DESC_3 USERBRDG.ATTACH_DESC_3%TYPE;
		v_ATTACH_DESC_2 USERBRDG.ATTACH_DESC_2%TYPE;
		v_ATTACH_DESC_1 USERBRDG.ATTACH_DESC_1%TYPE;
		
		
		v_STRUNITTYPE STRUCTURE_UNIT.STRUNITTYPE%TYPE;
		v_STRUNITLABEL STRUCTURE_UNIT.STRUNITLABEL%TYPE;
		
		
		v_ROADWIDTH ROADWAY.ROADWIDTH%TYPE;
		v_ROADWAY_NAME ROADWAY.ROADWAY_NAME%TYPE;
		v_CRIT_FEAT ROADWAY.CRIT_FEAT%TYPE;
		
		
		v_WATERADEQ INSPEVNT.WATERADEQ%TYPE;
		v_UWLASTINSP INSPEVNT.UWLASTINSP%TYPE;
		v_UNDERCLR INSPEVNT.UNDERCLR%TYPE;
		v_TRANSRATIN INSPEVNT.TRANSRATIN%TYPE;
		v_SUPRATING INSPEVNT.SUPRATING%TYPE;
		v_SUBRATING INSPEVNT.SUBRATING%TYPE;
		v_STRRATING INSPEVNT.STRRATING%TYPE;
		v_SCOURCRIT INSPEVNT.SCOURCRIT%TYPE;
		v_RAILRATING INSPEVNT.RAILRATING%TYPE;
		v_OSLASTINSP INSPEVNT.OSLASTINSP%TYPE;
		v_INSPDATE INSPEVNT.INSPDATE%TYPE;
		v_FCLASTINSP INSPEVNT.FCLASTINSP%TYPE;
		v_DKRATING INSPEVNT.DKRATING%TYPE;
		v_DECKGEOM INSPEVNT.DECKGEOM%TYPE;
		v_CULVRATING INSPEVNT.CULVRATING%TYPE;
		v_CHANRATING INSPEVNT.CHANRATING%TYPE;
		v_ARAILRATIN INSPEVNT.ARAILRATIN%TYPE;
		v_APPRALIGN INSPEVNT.APPRALIGN%TYPE;
		v_AENDRATING INSPEVNT.AENDRATING%TYPE;
		
		
		v_STRUCT_NUM BRIDGE.STRUCT_NUM%TYPE;
		v_STRFLARED BRIDGE.STRFLARED%TYPE;
		v_SKEW BRIDGE.SKEW%TYPE;
		v_RTCURBSW BRIDGE.RTCURBSW%TYPE;
		v_PARALSTRUC BRIDGE.PARALSTRUC%TYPE;
		v_ORLOAD BRIDGE.ORLOAD%TYPE;
		v_NAVVC BRIDGE.NAVVC%TYPE;
		v_NAVHC BRIDGE.NAVHC%TYPE;
		v_LOCATION BRIDGE.LOCATION%TYPE;
		v_LFTCURBSW BRIDGE.LFTCURBSW%TYPE;
		v_BRIDGE_LENGTH BRIDGE.LENGTH%TYPE;
		v_IRLOAD BRIDGE.IRLOAD%TYPE;
		v_FEATINT BRIDGE.FEATINT%TYPE;
		v_FACILITY BRIDGE.FACILITY%TYPE;
		v_DISTRICT BRIDGE.DISTRICT%TYPE;
		v_DECKWIDTH BRIDGE.DECKWIDTH%TYPE;
		v_BB_PCT BRIDGE.BB_PCT%TYPE;
		
		ls_brkey bridge.brkey%type := '105528';
    ls_inspkey inspevnt.inspkey%type := 'NACB';
    
    
		begin
    		
    -- So 'NACA' is the most recent INSPDATE (so merge doesn't remove those records)
    delete from inspevnt
    where brkey = ls_brkey
      and inspkey <> ls_inspkey;    
		
    delete from userinsp
    where brkey = ls_brkey
      and inspkey <> ls_inspkey;    
      
    -- empty out the change log and keyvals tables
    -- this requires delete privilege TEMPORARILY granted to user Pontis
    dbms_output.put_line( 'User PONTIS is purging change log and lookup keyvals tables! (privilege temporary)' );
    delete from ksbms_robot.ds_change_log;
    delete from ds_lookup_keyvals;
    delete from ksbms_robot.ds_change_log_temp;
    delete from ksbms_robot.ds_lookup_keyvals_temp;
      
    -- and empty out the change log and lookup keyvals, to remove the deletes!
    --delete from ds_change_log;
    --delete from ds_lookup_keyvals;
    
		  select pontis.USERSTRUNIT.WIDE_TYPE,
					pontis.USERSTRUNIT.WIDE_NUM_GIRDERS,
					pontis.USERSTRUNIT.WIDE_MATERIAL,
					pontis.USERSTRUNIT.WIDE_DESIGN_TY,
					pontis.USERSTRUNIT.WEAR_THICK,
					pontis.USERSTRUNIT.UNIT_TYPE,
					pontis.USERSTRUNIT.UNIT_MATERIAL,
					pontis.USERSTRUNIT.SUPER_DESIGN_TY,
					pontis.USERSTRUNIT.RAIL_TYPE,
					pontis.USERSTRUNIT.PIER_TYPE,
					pontis.USERSTRUNIT.PIER_FOOT_TYPE,
					pontis.USERSTRUNIT.NUM_SPANS_GRP_9,
					pontis.USERSTRUNIT.NUM_SPANS_GRP_8,
					pontis.USERSTRUNIT.NUM_SPANS_GRP_7,
					pontis.USERSTRUNIT.NUM_SPANS_GRP_6,
					pontis.USERSTRUNIT.NUM_SPANS_GRP_5,
					pontis.USERSTRUNIT.NUM_SPANS_GRP_4,
					pontis.USERSTRUNIT.NUM_SPANS_GRP_3,
					pontis.USERSTRUNIT.NUM_SPANS_GRP_2,
					pontis.USERSTRUNIT.NUM_SPANS_GRP_10,
					pontis.USERSTRUNIT.NUM_SPANS_GRP_1,
					pontis.USERSTRUNIT.NUM_GIRDERS,
					pontis.USERSTRUNIT.LEN_SPAN_GRP_9,
					pontis.USERSTRUNIT.LEN_SPAN_GRP_8,
					pontis.USERSTRUNIT.LEN_SPAN_GRP_7,
					pontis.USERSTRUNIT.LEN_SPAN_GRP_6,
					pontis.USERSTRUNIT.LEN_SPAN_GRP_5,
					pontis.USERSTRUNIT.LEN_SPAN_GRP_4,
					pontis.USERSTRUNIT.LEN_SPAN_GRP_3,
					pontis.USERSTRUNIT.LEN_SPAN_GRP_2,
					pontis.USERSTRUNIT.LEN_SPAN_GRP_10,
					pontis.USERSTRUNIT.LEN_SPAN_GRP_1,
					pontis.USERSTRUNIT.LENGTH,
					pontis.USERSTRUNIT.HINGE_TYPE,
					pontis.USERSTRUNIT.EXPAN_DEV_NEAR,
					pontis.USERSTRUNIT.EXPAN_DEV_FAR,
					pontis.USERSTRUNIT.DK_DRAIN_SYS,
					pontis.USERSTRUNIT.DKSURFTYPE,
					pontis.USERSTRUNIT.DKPROTECT,
					pontis.USERSTRUNIT.DKMEMBTYPE,
					pontis.USERSTRUNIT.DECK_THICK,
					pontis.USERSTRUNIT.DECK_MATRL,
					pontis.USERSTRUNIT.DECKSEAL,
					pontis.USERSTRUNIT.BEARING_TYPE,
					pontis.USERSTRUNIT.ABUT_TYPE_NEAR,
					pontis.USERSTRUNIT.ABUT_TYPE_FAR,
					pontis.USERSTRUNIT.ABUT_FOOT_NEAR,
					pontis.USERSTRUNIT.ABUT_FOOT_FAR
			 into v_WIDE_TYPE,
					v_WIDE_NUM_GIRDERS,
					v_WIDE_MATERIAL,
					v_WIDE_DESIGN_TY,
					v_WEAR_THICK,
					v_UNIT_TYPE,
					v_UNIT_MATERIAL,
					v_SUPER_DESIGN_TY,
					v_RAIL_TYPE,
					v_PIER_TYPE,
					v_PIER_FOOT_TYPE,
					v_NUM_SPANS_GRP_9,
					v_NUM_SPANS_GRP_8,
					v_NUM_SPANS_GRP_7,
					v_NUM_SPANS_GRP_6,
					v_NUM_SPANS_GRP_5,
					v_NUM_SPANS_GRP_4,
					v_NUM_SPANS_GRP_3,
					v_NUM_SPANS_GRP_2,
					v_NUM_SPANS_GRP_10,
					v_NUM_SPANS_GRP_1,
					v_NUM_GIRDERS,
					v_LEN_SPAN_GRP_9,
					v_LEN_SPAN_GRP_8,
					v_LEN_SPAN_GRP_7,
					v_LEN_SPAN_GRP_6,
					v_LEN_SPAN_GRP_5,
					v_LEN_SPAN_GRP_4,
					v_LEN_SPAN_GRP_3,
					v_LEN_SPAN_GRP_2,
					v_LEN_SPAN_GRP_10,
					v_LEN_SPAN_GRP_1,
					v_LENGTH,
					v_HINGE_TYPE,
					v_EXPAN_DEV_NEAR,
					v_EXPAN_DEV_FAR,
					v_DK_DRAIN_SYS,
					v_DKSURFTYPE,
					v_DKPROTECT,
					v_DKMEMBTYPE,
					v_DECK_THICK,
					v_DECK_MATRL,
					v_DECKSEAL,
					v_BEARING_TYPE,
					v_ABUT_TYPE_NEAR,
					v_ABUT_TYPE_FAR,
					v_ABUT_FOOT_NEAR,
					v_ABUT_FOOT_FAR
			 from pontis.USERSTRUNIT
			where pontis.USERSTRUNIT.brkey = ls_brkey and USERSTRUNIT.strunitkey = 1;
		
		
		if v_WIDE_TYPE = 'A' then
			v_WIDE_TYPE := 'B';
		else
			v_WIDE_TYPE := 'A';
		end if;
		
		if v_WIDE_NUM_GIRDERS = 1 then
			v_WIDE_NUM_GIRDERS := 2;
		else
			v_WIDE_NUM_GIRDERS := 1;
		end if;
		
		if v_WIDE_MATERIAL = 'A' then
			v_WIDE_MATERIAL := 'B';
		else
			v_WIDE_MATERIAL := 'A';
		end if;
		
		if v_WIDE_DESIGN_TY = 'A' then
			v_WIDE_DESIGN_TY := 'B';
		else
			v_WIDE_DESIGN_TY := 'A';
		end if;
		
		if v_WEAR_THICK = 1 then
			v_WEAR_THICK := 2;
		else
			v_WEAR_THICK := 1;
		end if;
		
		if v_UNIT_TYPE = 'A' then
			v_UNIT_TYPE := 'B';
		else
			v_UNIT_TYPE := 'A';
		end if;
		
		if v_UNIT_MATERIAL = 'A' then
			v_UNIT_MATERIAL := 'B';
		else
			v_UNIT_MATERIAL := 'A';
		end if;
		
		if v_SUPER_DESIGN_TY = 'A' then
			v_SUPER_DESIGN_TY := 'B';
		else
			v_SUPER_DESIGN_TY := 'A';
		end if;
		
		if v_RAIL_TYPE = 'A' then
			v_RAIL_TYPE := 'B';
		else
			v_RAIL_TYPE := 'A';
		end if;
		
		if v_PIER_TYPE = 'A' then
			v_PIER_TYPE := 'B';
		else
			v_PIER_TYPE := 'A';
		end if;
		
		if v_PIER_FOOT_TYPE = 'A' then
			v_PIER_FOOT_TYPE := 'B';
		else
			v_PIER_FOOT_TYPE := 'A';
		end if;
		
		if v_NUM_SPANS_GRP_9 = 1 then
			v_NUM_SPANS_GRP_9 := 2;
		else
			v_NUM_SPANS_GRP_9 := 1;
		end if;
		
		if v_NUM_SPANS_GRP_8 = 1 then
			v_NUM_SPANS_GRP_8 := 2;
		else
			v_NUM_SPANS_GRP_8 := 1;
		end if;
		
		if v_NUM_SPANS_GRP_7 = 1 then
			v_NUM_SPANS_GRP_7 := 2;
		else
			v_NUM_SPANS_GRP_7 := 1;
		end if;
		
		if v_NUM_SPANS_GRP_6 = 1 then
			v_NUM_SPANS_GRP_6 := 2;
		else
			v_NUM_SPANS_GRP_6 := 1;
		end if;
		
		if v_NUM_SPANS_GRP_5 = 1 then
			v_NUM_SPANS_GRP_5 := 2;
		else
			v_NUM_SPANS_GRP_5 := 1;
		end if;
		
		if v_NUM_SPANS_GRP_4 = 1 then
			v_NUM_SPANS_GRP_4 := 2;
		else
			v_NUM_SPANS_GRP_4 := 1;
		end if;
		
		if v_NUM_SPANS_GRP_3 = 1 then
			v_NUM_SPANS_GRP_3 := 2;
		else
			v_NUM_SPANS_GRP_3 := 1;
		end if;
		
		if v_NUM_SPANS_GRP_2 = 1 then
			v_NUM_SPANS_GRP_2 := 2;
		else
			v_NUM_SPANS_GRP_2 := 1;
		end if;
		
		if v_NUM_SPANS_GRP_10 = 1 then
			v_NUM_SPANS_GRP_10 := 2;
		else
			v_NUM_SPANS_GRP_10 := 1;
		end if;
		
		if v_NUM_SPANS_GRP_1 = 1 then
			v_NUM_SPANS_GRP_1 := 2;
		else
			v_NUM_SPANS_GRP_1 := 1;
		end if;
		
		if v_NUM_GIRDERS = 1 then
			v_NUM_GIRDERS := 2;
		else
			v_NUM_GIRDERS := 1;
		end if;
		
		if v_LEN_SPAN_GRP_9 = 1 then
			v_LEN_SPAN_GRP_9 := 2;
		else
			v_LEN_SPAN_GRP_9 := 1;
		end if;
		
		if v_LEN_SPAN_GRP_8 = 1 then
			v_LEN_SPAN_GRP_8 := 2;
		else
			v_LEN_SPAN_GRP_8 := 1;
		end if;
		
		if v_LEN_SPAN_GRP_7 = 1 then
			v_LEN_SPAN_GRP_7 := 2;
		else
			v_LEN_SPAN_GRP_7 := 1;
		end if;
		
		if v_LEN_SPAN_GRP_6 = 1 then
			v_LEN_SPAN_GRP_6 := 2;
		else
			v_LEN_SPAN_GRP_6 := 1;
		end if;
		
		if v_LEN_SPAN_GRP_5 = 1 then
			v_LEN_SPAN_GRP_5 := 2;
		else
			v_LEN_SPAN_GRP_5 := 1;
		end if;
		
		if v_LEN_SPAN_GRP_4 = 1 then
			v_LEN_SPAN_GRP_4 := 2;
		else
			v_LEN_SPAN_GRP_4 := 1;
		end if;
		
		if v_LEN_SPAN_GRP_3 = 1 then
			v_LEN_SPAN_GRP_3 := 2;
		else
			v_LEN_SPAN_GRP_3 := 1;
		end if;
		
		if v_LEN_SPAN_GRP_2 = 1 then
			v_LEN_SPAN_GRP_2 := 2;
		else
			v_LEN_SPAN_GRP_2 := 1;
		end if;
		
		if v_LEN_SPAN_GRP_10 = 1 then
			v_LEN_SPAN_GRP_10 := 2;
		else
			v_LEN_SPAN_GRP_10 := 1;
		end if;
		
		if v_LEN_SPAN_GRP_1 = 1 then
			v_LEN_SPAN_GRP_1 := 2;
		else
			v_LEN_SPAN_GRP_1 := 1;
		end if;
		
		if v_LENGTH = 1 then
			v_LENGTH := 2;
		else
			v_LENGTH := 1;
		end if;
		
		if v_HINGE_TYPE = 'A' then
			v_HINGE_TYPE := 'B';
		else
			v_HINGE_TYPE := 'A';
		end if;
		
		if v_EXPAN_DEV_NEAR = 'A' then
			v_EXPAN_DEV_NEAR := 'B';
		else
			v_EXPAN_DEV_NEAR := 'A';
		end if;
		
		if v_EXPAN_DEV_FAR = 'A' then
			v_EXPAN_DEV_FAR := 'B';
		else
			v_EXPAN_DEV_FAR := 'A';
		end if;
		
		if v_DK_DRAIN_SYS = 'A' then
			v_DK_DRAIN_SYS := 'B';
		else
			v_DK_DRAIN_SYS := 'A';
		end if;
		
		if v_DKSURFTYPE = 'A' then
			v_DKSURFTYPE := 'B';
		else
			v_DKSURFTYPE := 'A';
		end if;
		
		if v_DKPROTECT = 'A' then
			v_DKPROTECT := 'B';
		else
			v_DKPROTECT := 'A';
		end if;
		
		if v_DKMEMBTYPE = 'A' then
			v_DKMEMBTYPE := 'B';
		else
			v_DKMEMBTYPE := 'A';
		end if;
		
		if v_DECK_THICK = 1 then
			v_DECK_THICK := 2;
		else
			v_DECK_THICK := 1;
		end if;
		
		if v_DECK_MATRL = 'A' then
			v_DECK_MATRL := 'B';
		else
			v_DECK_MATRL := 'A';
		end if;
		
		if v_DECKSEAL = 'A' then
			v_DECKSEAL := 'B';
		else
			v_DECKSEAL := 'A';
		end if;
		
		if v_BEARING_TYPE = 'A' then
			v_BEARING_TYPE := 'B';
		else
			v_BEARING_TYPE := 'A';
		end if;
		
		if v_ABUT_TYPE_NEAR = 'A' then
			v_ABUT_TYPE_NEAR := 'B';
		else
			v_ABUT_TYPE_NEAR := 'A';
		end if;
		
		if v_ABUT_TYPE_FAR = 'A' then
			v_ABUT_TYPE_FAR := 'B';
		else
			v_ABUT_TYPE_FAR := 'A';
		end if;
		
		if v_ABUT_FOOT_NEAR = 'A' then
			v_ABUT_FOOT_NEAR := 'B';
		else
			v_ABUT_FOOT_NEAR := 'A';
		end if;
		
		if v_ABUT_FOOT_FAR = 'A' then
			v_ABUT_FOOT_FAR := 'B';
		else
			v_ABUT_FOOT_FAR := 'A';
		end if;
		
		
		  update pontis.USERSTRUNIT
			  set WIDE_TYPE = v_WIDE_TYPE,
					WIDE_NUM_GIRDERS = v_WIDE_NUM_GIRDERS,
					WIDE_MATERIAL = v_WIDE_MATERIAL,
					WIDE_DESIGN_TY = v_WIDE_DESIGN_TY,
					WEAR_THICK = v_WEAR_THICK,
					UNIT_TYPE = v_UNIT_TYPE,
					UNIT_MATERIAL = v_UNIT_MATERIAL,
					SUPER_DESIGN_TY = v_SUPER_DESIGN_TY,
					RAIL_TYPE = v_RAIL_TYPE,
					PIER_TYPE = v_PIER_TYPE,
					PIER_FOOT_TYPE = v_PIER_FOOT_TYPE,
					NUM_SPANS_GRP_9 = v_NUM_SPANS_GRP_9,
					NUM_SPANS_GRP_8 = v_NUM_SPANS_GRP_8,
					NUM_SPANS_GRP_7 = v_NUM_SPANS_GRP_7,
					NUM_SPANS_GRP_6 = v_NUM_SPANS_GRP_6,
					NUM_SPANS_GRP_5 = v_NUM_SPANS_GRP_5,
					NUM_SPANS_GRP_4 = v_NUM_SPANS_GRP_4,
					NUM_SPANS_GRP_3 = v_NUM_SPANS_GRP_3,
					NUM_SPANS_GRP_2 = v_NUM_SPANS_GRP_2,
					NUM_SPANS_GRP_10 = v_NUM_SPANS_GRP_10,
					NUM_SPANS_GRP_1 = v_NUM_SPANS_GRP_1,
					NUM_GIRDERS = v_NUM_GIRDERS,
					LEN_SPAN_GRP_9 = v_LEN_SPAN_GRP_9,
					LEN_SPAN_GRP_8 = v_LEN_SPAN_GRP_8,
					LEN_SPAN_GRP_7 = v_LEN_SPAN_GRP_7,
					LEN_SPAN_GRP_6 = v_LEN_SPAN_GRP_6,
					LEN_SPAN_GRP_5 = v_LEN_SPAN_GRP_5,
					LEN_SPAN_GRP_4 = v_LEN_SPAN_GRP_4,
					LEN_SPAN_GRP_3 = v_LEN_SPAN_GRP_3,
					LEN_SPAN_GRP_2 = v_LEN_SPAN_GRP_2,
					LEN_SPAN_GRP_10 = v_LEN_SPAN_GRP_10,
					LEN_SPAN_GRP_1 = v_LEN_SPAN_GRP_1,
					LENGTH = v_LENGTH,
					HINGE_TYPE = v_HINGE_TYPE,
					EXPAN_DEV_NEAR = v_EXPAN_DEV_NEAR,
					EXPAN_DEV_FAR = v_EXPAN_DEV_FAR,
					DK_DRAIN_SYS = v_DK_DRAIN_SYS,
					DKSURFTYPE = v_DKSURFTYPE,
					DKPROTECT = v_DKPROTECT,
					DKMEMBTYPE = v_DKMEMBTYPE,
					DECK_THICK = v_DECK_THICK,
					DECK_MATRL = v_DECK_MATRL,
					DECKSEAL = v_DECKSEAL,
					BEARING_TYPE = v_BEARING_TYPE,
					ABUT_TYPE_NEAR = v_ABUT_TYPE_NEAR,
					ABUT_TYPE_FAR = v_ABUT_TYPE_FAR,
					ABUT_FOOT_NEAR = v_ABUT_FOOT_NEAR,
					ABUT_FOOT_FAR = v_ABUT_FOOT_FAR
			where pontis.USERSTRUNIT.brkey = ls_brkey and USERSTRUNIT.strunitkey = 1;
		
		
		
		  select pontis.USERRWAY.VCLR_W,
					pontis.USERRWAY.VCLR_S,
					pontis.USERRWAY.VCLR_N,
					pontis.USERRWAY.VCLR_E,
					pontis.USERRWAY.VCLRINV_W,
					pontis.USERRWAY.VCLRINV_S,
					pontis.USERRWAY.VCLRINV_N,
					pontis.USERRWAY.VCLRINV_E,
					pontis.USERRWAY.TRANS_LANES,
					pontis.USERRWAY.ROUTE_UNIQUE_ID,
					pontis.USERRWAY.ROUTE_SUFFIX,
					pontis.USERRWAY.ROUTE_PREFIX,
					pontis.USERRWAY.ROUTE_NUM,
					pontis.USERRWAY.ROAD_CROSS_NAME,
					pontis.USERRWAY.MAINT_RTE_SUFFIX,
					pontis.USERRWAY.MAINT_RTE_PREFIX,
					pontis.USERRWAY.MAINT_RTE_NUM,
					pontis.USERRWAY.MAINT_RTE_ID,
					pontis.USERRWAY.HCLR_W,
					pontis.USERRWAY.HCLR_S,
					pontis.USERRWAY.HCLR_N,
					pontis.USERRWAY.HCLR_E,
					pontis.USERRWAY.HCLRURT_W,
					pontis.USERRWAY.HCLRURT_S,
					pontis.USERRWAY.HCLRURT_N,
					pontis.USERRWAY.HCLRURT_E,
					pontis.USERRWAY.HCLRULT_W,
					pontis.USERRWAY.HCLRULT_S,
					pontis.USERRWAY.HCLRULT_N,
					pontis.USERRWAY.HCLRULT_E,
					pontis.USERRWAY.FEAT_DESC_TYPE,
					pontis.USERRWAY.FEAT_CROSS_TYPE,
					pontis.USERRWAY.CLR_ROUTE,
					pontis.USERRWAY.CHAN_PROT_RIGHT,
					pontis.USERRWAY.CHAN_PROT_LEFT,
					pontis.USERRWAY.BERM_PROT,
					pontis.USERRWAY.AROADWIDTH_NEAR,
					pontis.USERRWAY.AROADWIDTH_FAR
			 into v_VCLR_W,
					v_VCLR_S,
					v_VCLR_N,
					v_VCLR_E,
					v_VCLRINV_W,
					v_VCLRINV_S,
					v_VCLRINV_N,
					v_VCLRINV_E,
					v_TRANS_LANES,
					v_ROUTE_UNIQUE_ID,
					v_ROUTE_SUFFIX,
					v_ROUTE_PREFIX,
					v_ROUTE_NUM,
					v_ROAD_CROSS_NAME,
					v_MAINT_RTE_SUFFIX,
					v_MAINT_RTE_PREFIX,
					v_MAINT_RTE_NUM,
					v_MAINT_RTE_ID,
					v_HCLR_W,
					v_HCLR_S,
					v_HCLR_N,
					v_HCLR_E,
					v_HCLRURT_W,
					v_HCLRURT_S,
					v_HCLRURT_N,
					v_HCLRURT_E,
					v_HCLRULT_W,
					v_HCLRULT_S,
					v_HCLRULT_N,
					v_HCLRULT_E,
					v_FEAT_DESC_TYPE,
					v_FEAT_CROSS_TYPE,
					v_CLR_ROUTE,
					v_CHAN_PROT_RIGHT,
					v_CHAN_PROT_LEFT,
					v_BERM_PROT,
					v_AROADWIDTH_NEAR,
					v_AROADWIDTH_FAR
			 from pontis.USERRWAY
			where pontis.USERRWAY.brkey = ls_brkey and USERRWAY.on_under = '1';
		
		
		if v_VCLR_W = 1 then
			v_VCLR_W := 2;
		else
			v_VCLR_W := 1;
		end if;
		
		if v_VCLR_S = 1 then
			v_VCLR_S := 2;
		else
			v_VCLR_S := 1;
		end if;
		
		if v_VCLR_N = 1 then
			v_VCLR_N := 2;
		else
			v_VCLR_N := 1;
		end if;
		
		if v_VCLR_E = 1 then
			v_VCLR_E := 2;
		else
			v_VCLR_E := 1;
		end if;
		
		if v_VCLRINV_W = 1 then
			v_VCLRINV_W := 2;
		else
			v_VCLRINV_W := 1;
		end if;
		
		if v_VCLRINV_S = 1 then
			v_VCLRINV_S := 2;
		else
			v_VCLRINV_S := 1;
		end if;
		
		if v_VCLRINV_N = 1 then
			v_VCLRINV_N := 2;
		else
			v_VCLRINV_N := 1;
		end if;
		
		if v_VCLRINV_E = 1 then
			v_VCLRINV_E := 2;
		else
			v_VCLRINV_E := 1;
		end if;
		
		if v_TRANS_LANES = 1 then
			v_TRANS_LANES := 2;
		else
			v_TRANS_LANES := 1;
		end if;
		
		if v_ROAD_CROSS_NAME = 'A' then
			v_ROAD_CROSS_NAME := 'B';
		else
			v_ROAD_CROSS_NAME := 'A';
		end if;
		
		if v_MAINT_RTE_SUFFIX = 'A' then
			v_MAINT_RTE_SUFFIX := 'B';
		else
			v_MAINT_RTE_SUFFIX := 'A';
		end if;
		
		if v_MAINT_RTE_PREFIX = 'A' then
			v_MAINT_RTE_PREFIX := 'B';
		else
			v_MAINT_RTE_PREFIX := 'A';
		end if;
		
		if v_MAINT_RTE_NUM = 'A' then
			v_MAINT_RTE_NUM := 'B';
		else
			v_MAINT_RTE_NUM := 'A';
		end if;
		
		if v_MAINT_RTE_ID = 'A' then
			v_MAINT_RTE_ID := 'B';
		else
			v_MAINT_RTE_ID := 'A';
		end if;
		
		if v_HCLR_W = 1 then
			v_HCLR_W := 2;
		else
			v_HCLR_W := 1;
		end if;
		
		if v_HCLR_S = 1 then
			v_HCLR_S := 2;
		else
			v_HCLR_S := 1;
		end if;
		
		if v_HCLR_N = 1 then
			v_HCLR_N := 2;
		else
			v_HCLR_N := 1;
		end if;
		
		if v_HCLR_E = 1 then
			v_HCLR_E := 2;
		else
			v_HCLR_E := 1;
		end if;
		
		if v_HCLRURT_W = 1 then
			v_HCLRURT_W := 2;
		else
			v_HCLRURT_W := 1;
		end if;
		
		if v_HCLRURT_S = 1 then
			v_HCLRURT_S := 2;
		else
			v_HCLRURT_S := 1;
		end if;
		
		if v_HCLRURT_N = 1 then
			v_HCLRURT_N := 2;
		else
			v_HCLRURT_N := 1;
		end if;
		
		if v_HCLRURT_E = 1 then
			v_HCLRURT_E := 2;
		else
			v_HCLRURT_E := 1;
		end if;
		
		if v_HCLRULT_W = 1 then
			v_HCLRULT_W := 2;
		else
			v_HCLRULT_W := 1;
		end if;
		
		if v_HCLRULT_S = 1 then
			v_HCLRULT_S := 2;
		else
			v_HCLRULT_S := 1;
		end if;
		
		if v_HCLRULT_N = 1 then
			v_HCLRULT_N := 2;
		else
			v_HCLRULT_N := 1;
		end if;
		
		if v_HCLRULT_E = 1 then
			v_HCLRULT_E := 2;
		else
			v_HCLRULT_E := 1;
		end if;
		
		if v_FEAT_DESC_TYPE = 'A' then
			v_FEAT_DESC_TYPE := 'B';
		else
			v_FEAT_DESC_TYPE := 'A';
		end if;
		
		if v_CHAN_PROT_RIGHT = 'A' then
			v_CHAN_PROT_RIGHT := 'B';
		else
			v_CHAN_PROT_RIGHT := 'A';
		end if;
		
		if v_CHAN_PROT_LEFT = 'A' then
			v_CHAN_PROT_LEFT := 'B';
		else
			v_CHAN_PROT_LEFT := 'A';
		end if;
		
		if v_BERM_PROT = 'A' then
			v_BERM_PROT := 'B';
		else
			v_BERM_PROT := 'A';
		end if;
		
		if v_AROADWIDTH_NEAR = 1 then
			v_AROADWIDTH_NEAR := 2;
		else
			v_AROADWIDTH_NEAR := 1;
		end if;
		
		if v_AROADWIDTH_FAR = 1 then
			v_AROADWIDTH_FAR := 2;
		else
			v_AROADWIDTH_FAR := 1;
		end if;
		
		
		  update pontis.USERRWAY
			  set VCLR_W = v_VCLR_W,
					VCLR_S = v_VCLR_S,
					VCLR_N = v_VCLR_N,
					VCLR_E = v_VCLR_E,
					VCLRINV_W = v_VCLRINV_W,
					VCLRINV_S = v_VCLRINV_S,
					VCLRINV_N = v_VCLRINV_N,
					VCLRINV_E = v_VCLRINV_E,
					TRANS_LANES = v_TRANS_LANES,
					ROUTE_UNIQUE_ID = v_ROUTE_UNIQUE_ID,
					ROUTE_SUFFIX = v_ROUTE_SUFFIX,
					ROUTE_PREFIX = v_ROUTE_PREFIX,
					ROUTE_NUM = v_ROUTE_NUM,
					ROAD_CROSS_NAME = v_ROAD_CROSS_NAME,
					MAINT_RTE_SUFFIX = v_MAINT_RTE_SUFFIX,
					MAINT_RTE_PREFIX = v_MAINT_RTE_PREFIX,
					MAINT_RTE_NUM = v_MAINT_RTE_NUM,
					MAINT_RTE_ID = v_MAINT_RTE_ID,
					HCLR_W = v_HCLR_W,
					HCLR_S = v_HCLR_S,
					HCLR_N = v_HCLR_N,
					HCLR_E = v_HCLR_E,
					HCLRURT_W = v_HCLRURT_W,
					HCLRURT_S = v_HCLRURT_S,
					HCLRURT_N = v_HCLRURT_N,
					HCLRURT_E = v_HCLRURT_E,
					HCLRULT_W = v_HCLRULT_W,
					HCLRULT_S = v_HCLRULT_S,
					HCLRULT_N = v_HCLRULT_N,
					HCLRULT_E = v_HCLRULT_E,
					FEAT_DESC_TYPE = v_FEAT_DESC_TYPE,
					FEAT_CROSS_TYPE = v_FEAT_CROSS_TYPE,
					CLR_ROUTE = v_CLR_ROUTE,
					CHAN_PROT_RIGHT = v_CHAN_PROT_RIGHT,
					CHAN_PROT_LEFT = v_CHAN_PROT_LEFT,
					BERM_PROT = v_BERM_PROT,
					AROADWIDTH_NEAR = v_AROADWIDTH_NEAR,
					AROADWIDTH_FAR = v_AROADWIDTH_FAR
			where pontis.USERRWAY.brkey = ls_brkey and USERRWAY.on_under = '1';
		
		
		
		  select pontis.USERRWAY.VCLR_W,
					pontis.USERRWAY.VCLR_S,
					pontis.USERRWAY.VCLR_N,
					pontis.USERRWAY.VCLR_E,
					pontis.USERRWAY.VCLRINV_W,
					pontis.USERRWAY.VCLRINV_S,
					pontis.USERRWAY.VCLRINV_N,
					pontis.USERRWAY.VCLRINV_E,
					pontis.USERRWAY.TRANS_LANES,
					pontis.USERRWAY.ROUTE_UNIQUE_ID,
					pontis.USERRWAY.ROUTE_SUFFIX,
					pontis.USERRWAY.ROUTE_PREFIX,
					pontis.USERRWAY.ROUTE_NUM,
					pontis.USERRWAY.ROAD_CROSS_NAME,
					pontis.USERRWAY.MAINT_RTE_SUFFIX,
					pontis.USERRWAY.MAINT_RTE_PREFIX,
					pontis.USERRWAY.MAINT_RTE_NUM,
					pontis.USERRWAY.MAINT_RTE_ID,
					pontis.USERRWAY.HCLR_W,
					pontis.USERRWAY.HCLR_S,
					pontis.USERRWAY.HCLR_N,
					pontis.USERRWAY.HCLR_E,
					pontis.USERRWAY.HCLRURT_W,
					pontis.USERRWAY.HCLRURT_S,
					pontis.USERRWAY.HCLRURT_N,
					pontis.USERRWAY.HCLRURT_E,
					pontis.USERRWAY.HCLRULT_W,
					pontis.USERRWAY.HCLRULT_S,
					pontis.USERRWAY.HCLRULT_N,
					pontis.USERRWAY.HCLRULT_E,
					pontis.USERRWAY.FEAT_DESC_TYPE,
					pontis.USERRWAY.FEAT_CROSS_TYPE,
					pontis.USERRWAY.CLR_ROUTE,
					pontis.USERRWAY.CHAN_PROT_RIGHT,
					pontis.USERRWAY.CHAN_PROT_LEFT,
					pontis.USERRWAY.BERM_PROT,
					pontis.USERRWAY.AROADWIDTH_NEAR,
					pontis.USERRWAY.AROADWIDTH_FAR
			 into v_VCLR_W,
					v_VCLR_S,
					v_VCLR_N,
					v_VCLR_E,
					v_VCLRINV_W,
					v_VCLRINV_S,
					v_VCLRINV_N,
					v_VCLRINV_E,
					v_TRANS_LANES,
					v_ROUTE_UNIQUE_ID,
					v_ROUTE_SUFFIX,
					v_ROUTE_PREFIX,
					v_ROUTE_NUM,
					v_ROAD_CROSS_NAME,
					v_MAINT_RTE_SUFFIX,
					v_MAINT_RTE_PREFIX,
					v_MAINT_RTE_NUM,
					v_MAINT_RTE_ID,
					v_HCLR_W,
					v_HCLR_S,
					v_HCLR_N,
					v_HCLR_E,
					v_HCLRURT_W,
					v_HCLRURT_S,
					v_HCLRURT_N,
					v_HCLRURT_E,
					v_HCLRULT_W,
					v_HCLRULT_S,
					v_HCLRULT_N,
					v_HCLRULT_E,
					v_FEAT_DESC_TYPE,
					v_FEAT_CROSS_TYPE,
					v_CLR_ROUTE,
					v_CHAN_PROT_RIGHT,
					v_CHAN_PROT_LEFT,
					v_BERM_PROT,
					v_AROADWIDTH_NEAR,
					v_AROADWIDTH_FAR
			 from pontis.USERRWAY
			where pontis.USERRWAY.brkey = ls_brkey and USERRWAY.on_under = '2';
		if v_VCLR_W = 1 then
			v_VCLR_W := 2;
		else
			v_VCLR_W := 1;
		end if;
		
		if v_VCLR_S = 1 then
			v_VCLR_S := 2;
		else
			v_VCLR_S := 1;
		end if;
		
		if v_VCLR_N = 1 then
			v_VCLR_N := 2;
		else
			v_VCLR_N := 1;
		end if;
		
		if v_VCLR_E = 1 then
			v_VCLR_E := 2;
		else
			v_VCLR_E := 1;
		end if;
		
		if v_VCLRINV_W = 1 then
			v_VCLRINV_W := 2;
		else
			v_VCLRINV_W := 1;
		end if;
		
		if v_VCLRINV_S = 1 then
			v_VCLRINV_S := 2;
		else
			v_VCLRINV_S := 1;
		end if;
		
		if v_VCLRINV_N = 1 then
			v_VCLRINV_N := 2;
		else
			v_VCLRINV_N := 1;
		end if;
		
		if v_VCLRINV_E = 1 then
			v_VCLRINV_E := 2;
		else
			v_VCLRINV_E := 1;
		end if;
		
		if v_TRANS_LANES = 1 then
			v_TRANS_LANES := 2;
		else
			v_TRANS_LANES := 1;
		end if;
		
		if v_ROAD_CROSS_NAME = 'A' then
			v_ROAD_CROSS_NAME := 'B';
		else
			v_ROAD_CROSS_NAME := 'A';
		end if;
		
		if v_MAINT_RTE_SUFFIX = 'A' then
			v_MAINT_RTE_SUFFIX := 'B';
		else
			v_MAINT_RTE_SUFFIX := 'A';
		end if;
		
		if v_MAINT_RTE_PREFIX = 'A' then
			v_MAINT_RTE_PREFIX := 'B';
		else
			v_MAINT_RTE_PREFIX := 'A';
		end if;
		
		if v_MAINT_RTE_NUM = 'A' then
			v_MAINT_RTE_NUM := 'B';
		else
			v_MAINT_RTE_NUM := 'A';
		end if;
		
		if v_MAINT_RTE_ID = 'A' then
			v_MAINT_RTE_ID := 'B';
		else
			v_MAINT_RTE_ID := 'A';
		end if;
		
		if v_HCLR_W = 1 then
			v_HCLR_W := 2;
		else
			v_HCLR_W := 1;
		end if;
		
		if v_HCLR_S = 1 then
			v_HCLR_S := 2;
		else
			v_HCLR_S := 1;
		end if;
		
		if v_HCLR_N = 1 then
			v_HCLR_N := 2;
		else
			v_HCLR_N := 1;
		end if;
		
		if v_HCLR_E = 1 then
			v_HCLR_E := 2;
		else
			v_HCLR_E := 1;
		end if;
		
		if v_HCLRURT_W = 1 then
			v_HCLRURT_W := 2;
		else
			v_HCLRURT_W := 1;
		end if;
		
		if v_HCLRURT_S = 1 then
			v_HCLRURT_S := 2;
		else
			v_HCLRURT_S := 1;
		end if;
		
		if v_HCLRURT_N = 1 then
			v_HCLRURT_N := 2;
		else
			v_HCLRURT_N := 1;
		end if;
		
		if v_HCLRURT_E = 1 then
			v_HCLRURT_E := 2;
		else
			v_HCLRURT_E := 1;
		end if;
		
		if v_HCLRULT_W = 1 then
			v_HCLRULT_W := 2;
		else
			v_HCLRULT_W := 1;
		end if;
		
		if v_HCLRULT_S = 1 then
			v_HCLRULT_S := 2;
		else
			v_HCLRULT_S := 1;
		end if;
		
		if v_HCLRULT_N = 1 then
			v_HCLRULT_N := 2;
		else
			v_HCLRULT_N := 1;
		end if;
		
		if v_HCLRULT_E = 1 then
			v_HCLRULT_E := 2;
		else
			v_HCLRULT_E := 1;
		end if;
		
		if v_FEAT_DESC_TYPE = 'A' then
			v_FEAT_DESC_TYPE := 'B';
		else
			v_FEAT_DESC_TYPE := 'A';
		end if;
		
		if v_CHAN_PROT_RIGHT = 'A' then
			v_CHAN_PROT_RIGHT := 'B';
		else
			v_CHAN_PROT_RIGHT := 'A';
		end if;
		
		if v_CHAN_PROT_LEFT = 'A' then
			v_CHAN_PROT_LEFT := 'B';
		else
			v_CHAN_PROT_LEFT := 'A';
		end if;
		
		if v_BERM_PROT = 'A' then
			v_BERM_PROT := 'B';
		else
			v_BERM_PROT := 'A';
		end if;
		
		if v_AROADWIDTH_NEAR = 1 then
			v_AROADWIDTH_NEAR := 2;
		else
			v_AROADWIDTH_NEAR := 1;
		end if;
		
		if v_AROADWIDTH_FAR = 1 then
			v_AROADWIDTH_FAR := 2;
		else
			v_AROADWIDTH_FAR := 1;
		end if;
		
		
		  update pontis.USERRWAY
			  set VCLR_W = v_VCLR_W,
					VCLR_S = v_VCLR_S,
					VCLR_N = v_VCLR_N,
					VCLR_E = v_VCLR_E,
					VCLRINV_W = v_VCLRINV_W,
					VCLRINV_S = v_VCLRINV_S,
					VCLRINV_N = v_VCLRINV_N,
					VCLRINV_E = v_VCLRINV_E,
					TRANS_LANES = v_TRANS_LANES,
					ROUTE_UNIQUE_ID = v_ROUTE_UNIQUE_ID,
					ROUTE_SUFFIX = v_ROUTE_SUFFIX,
					ROUTE_PREFIX = v_ROUTE_PREFIX,
					ROUTE_NUM = v_ROUTE_NUM,
					ROAD_CROSS_NAME = v_ROAD_CROSS_NAME,
					MAINT_RTE_SUFFIX = v_MAINT_RTE_SUFFIX,
					MAINT_RTE_PREFIX = v_MAINT_RTE_PREFIX,
					MAINT_RTE_NUM = v_MAINT_RTE_NUM,
					MAINT_RTE_ID = v_MAINT_RTE_ID,
					HCLR_W = v_HCLR_W,
					HCLR_S = v_HCLR_S,
					HCLR_N = v_HCLR_N,
					HCLR_E = v_HCLR_E,
					HCLRURT_W = v_HCLRURT_W,
					HCLRURT_S = v_HCLRURT_S,
					HCLRURT_N = v_HCLRURT_N,
					HCLRURT_E = v_HCLRURT_E,
					HCLRULT_W = v_HCLRULT_W,
					HCLRULT_S = v_HCLRULT_S,
					HCLRULT_N = v_HCLRULT_N,
					HCLRULT_E = v_HCLRULT_E,
					FEAT_DESC_TYPE = v_FEAT_DESC_TYPE,
					FEAT_CROSS_TYPE = v_FEAT_CROSS_TYPE,
					CLR_ROUTE = v_CLR_ROUTE,
					CHAN_PROT_RIGHT = v_CHAN_PROT_RIGHT,
					CHAN_PROT_LEFT = v_CHAN_PROT_LEFT,
					BERM_PROT = v_BERM_PROT,
					AROADWIDTH_NEAR = v_AROADWIDTH_NEAR,
					AROADWIDTH_FAR = v_AROADWIDTH_FAR
			where pontis.USERRWAY.brkey = ls_brkey and USERRWAY.on_under = '2';
		
		
		
		  select pontis.USERINSP.UWINSPFREQ_KDOT,
					pontis.USERINSP.UWATER_INSP_TYP,
					pontis.USERINSP.PAINT_COND,
					pontis.USERINSP.OSINSPFREQ_KDOT,
					pontis.USERINSP.OPPOSTCL_KDOT,
					pontis.USERINSP.FCINSPFREQ_KDOT,
					pontis.USERINSP.COND_INDEX,
					pontis.USERINSP.BRINSPFREQ_KDOT
			 into v_UWINSPFREQ_KDOT,
					v_UWATER_INSP_TYP,
					v_PAINT_COND,
					v_OSINSPFREQ_KDOT,
					v_OPPOSTCL_KDOT,
					v_FCINSPFREQ_KDOT,
					v_COND_INDEX,
					v_BRINSPFREQ_KDOT
			 from pontis.USERINSP
			where pontis.USERINSP.brkey = ls_brkey and USERINSP.inspkey = ls_inspkey;
		
		
		if v_UWINSPFREQ_KDOT = 1 then
			v_UWINSPFREQ_KDOT := 2;
		else
			v_UWINSPFREQ_KDOT := 1;
		end if;
		
		if v_UWATER_INSP_TYP = 'A' then
			v_UWATER_INSP_TYP := 'B';
		else
			v_UWATER_INSP_TYP := 'A';
		end if;
		
		if v_PAINT_COND = 'A' then
			v_PAINT_COND := 'B';
		else
			v_PAINT_COND := 'A';
		end if;
		
		if v_OSINSPFREQ_KDOT = 1 then
			v_OSINSPFREQ_KDOT := 2;
		else
			v_OSINSPFREQ_KDOT := 1;
		end if;
		
		if v_OPPOSTCL_KDOT = 'A' then
			v_OPPOSTCL_KDOT := 'B';
		else
			v_OPPOSTCL_KDOT := 'A';
		end if;
		
		if v_FCINSPFREQ_KDOT = 1 then
			v_FCINSPFREQ_KDOT := 2;
		else
			v_FCINSPFREQ_KDOT := 1;
		end if;
		
		if v_COND_INDEX = 1 then
			v_COND_INDEX := 2;
		else
			v_COND_INDEX := 1;
		end if;
		
		if v_BRINSPFREQ_KDOT = 1 then
			v_BRINSPFREQ_KDOT := 2;
		else
			v_BRINSPFREQ_KDOT := 1;
		end if;
		
		
		  update pontis.USERINSP
			  set UWINSPFREQ_KDOT = v_UWINSPFREQ_KDOT,
					UWATER_INSP_TYP = v_UWATER_INSP_TYP,
					PAINT_COND = v_PAINT_COND,
					OSINSPFREQ_KDOT = v_OSINSPFREQ_KDOT,
					OPPOSTCL_KDOT = v_OPPOSTCL_KDOT,
					FCINSPFREQ_KDOT = v_FCINSPFREQ_KDOT,
					COND_INDEX = v_COND_INDEX,
					BRINSPFREQ_KDOT = v_BRINSPFREQ_KDOT
			where pontis.USERINSP.brkey = ls_brkey and USERINSP.inspkey = ls_inspkey;
		
		
		
		  select pontis.USERBRDG.VERT_UNDR_SIGN,
					pontis.USERBRDG.VERT_CLR_SIGN,
					pontis.USERBRDG.SUPRSTRUCT_TOS,
					pontis.USERBRDG.SUPER_PAINT_SYS,
					pontis.USERBRDG.STREAM_SIGN,
					pontis.USERBRDG.SKEW_MINUTES,
					pontis.USERBRDG.SKEW_DIRECTION,
					pontis.USERBRDG.SIGN_TYPE_Q4,
					pontis.USERBRDG.SIGN_TYPE_Q3,
					pontis.USERBRDG.SIGN_TYPE_Q2,
					pontis.USERBRDG.SIGN_TYPE_Q1,
					pontis.USERBRDG.ROT_DIRECTION,
					pontis.USERBRDG.ROT_ANGLE_MIN,
					pontis.USERBRDG.ROT_ANGLE_DEG,
					pontis.USERBRDG.ROAD_TYPE_SIGN,
					pontis.USERBRDG.RESTRICT_LOAD,
					pontis.USERBRDG.RATING_COMMENT,
					pontis.USERBRDG.RATING_ADJ,
					pontis.USERBRDG.POSTED_SIGN_TYPE,
					pontis.USERBRDG.POSTED_LOAD_C,
					pontis.USERBRDG.POSTED_LOAD_B,
					pontis.USERBRDG.POSTED_LOAD_A,
					pontis.USERBRDG.OWNER_KDOT,
					pontis.USERBRDG.ORLOAD_WSD_T170,
					pontis.USERBRDG.ORLOAD_WSD_T130,
					pontis.USERBRDG.ORLOAD_WSD_HS,
					pontis.USERBRDG.ORLOAD_WSD_H,
					pontis.USERBRDG.ORLOAD_WSD_3_3,
					pontis.USERBRDG.ORLOAD_WSD_3S2,
					pontis.USERBRDG.ORLOAD_WSD_3,
					pontis.USERBRDG.ORLOAD_LFD_T170,
					pontis.USERBRDG.ORLOAD_LFD_T130,
					pontis.USERBRDG.ORLOAD_LFD_HS,
					pontis.USERBRDG.ORLOAD_LFD_H,
					pontis.USERBRDG.ORLOAD_LFD_3_3,
					pontis.USERBRDG.ORLOAD_LFD_3S2,
					pontis.USERBRDG.ORLOAD_LFD_3,
					pontis.USERBRDG.ORLOAD_ADJ_T170,
					pontis.USERBRDG.ORLOAD_ADJ_T130,
					pontis.USERBRDG.ORLOAD_ADJ_H,
					pontis.USERBRDG.ORLOAD_ADJ_3_3,
					pontis.USERBRDG.ORLOAD_ADJ_3S2,
					pontis.USERBRDG.ORLOAD_ADJ_3,
					pontis.USERBRDG.ORIENTATION,
					pontis.USERBRDG.MEDIAN_WIDTH,
					pontis.USERBRDG.MAINT_AREA,
					pontis.USERBRDG.IRLOAD_WSD_T170,
					pontis.USERBRDG.IRLOAD_WSD_T130,
					pontis.USERBRDG.IRLOAD_WSD_HS,
					pontis.USERBRDG.IRLOAD_WSD_H,
					pontis.USERBRDG.IRLOAD_WSD_3_3,
					pontis.USERBRDG.IRLOAD_WSD_3S2,
					pontis.USERBRDG.IRLOAD_WSD_3,
					pontis.USERBRDG.IRLOAD_LFD_T170,
					pontis.USERBRDG.IRLOAD_LFD_T130,
					pontis.USERBRDG.IRLOAD_LFD_HS,
					pontis.USERBRDG.IRLOAD_LFD_H,
					pontis.USERBRDG.IRLOAD_LFD_3_3,
					pontis.USERBRDG.IRLOAD_LFD_3S2,
					pontis.USERBRDG.IRLOAD_LFD_3,
					pontis.USERBRDG.IRLOAD_ADJ_T170,
					pontis.USERBRDG.IRLOAD_ADJ_T130,
					pontis.USERBRDG.IRLOAD_ADJ_H,
					pontis.USERBRDG.IRLOAD_ADJ_3_3,
					pontis.USERBRDG.IRLOAD_ADJ_3S2,
					pontis.USERBRDG.IRLOAD_ADJ_3,
					pontis.USERBRDG.FUNCTION_TYPE,
					pontis.USERBRDG.DESIGN_REF_POST,
					pontis.USERBRDG.DESIGNLOAD_TYPE,
					pontis.USERBRDG.DESIGNLOAD_KDOT,
					pontis.USERBRDG.CUSTODIAN_KDOT,
					pontis.USERBRDG.CULV_WING_TYPE,
					pontis.USERBRDG.CULV_FILL_DEPTH,
					pontis.USERBRDG.BRIDGEMED_KDOT,
					pontis.USERBRDG.BOX_HEIGHT_CULV,
					pontis.USERBRDG.ATTACH_TYPE_3,
					pontis.USERBRDG.ATTACH_TYPE_2,
					pontis.USERBRDG.ATTACH_TYPE_1,
					pontis.USERBRDG.ATTACH_DESC_3,
					pontis.USERBRDG.ATTACH_DESC_2,
					pontis.USERBRDG.ATTACH_DESC_1
			 into v_VERT_UNDR_SIGN,
					v_VERT_CLR_SIGN,
					v_SUPRSTRUCT_TOS,
					v_SUPER_PAINT_SYS,
					v_STREAM_SIGN,
					v_SKEW_MINUTES,
					v_SKEW_DIRECTION,
					v_SIGN_TYPE_Q4,
					v_SIGN_TYPE_Q3,
					v_SIGN_TYPE_Q2,
					v_SIGN_TYPE_Q1,
					v_ROT_DIRECTION,
					v_ROT_ANGLE_MIN,
					v_ROT_ANGLE_DEG,
					v_ROAD_TYPE_SIGN,
					v_RESTRICT_LOAD,
					v_RATING_COMMENT,
					v_RATING_ADJ,
					v_POSTED_SIGN_TYPE,
					v_POSTED_LOAD_C,
					v_POSTED_LOAD_B,
					v_POSTED_LOAD_A,
					v_OWNER_KDOT,
					v_ORLOAD_WSD_T170,
					v_ORLOAD_WSD_T130,
					v_ORLOAD_WSD_HS,
					v_ORLOAD_WSD_H,
					v_ORLOAD_WSD_3_3,
					v_ORLOAD_WSD_3S2,
					v_ORLOAD_WSD_3,
					v_ORLOAD_LFD_T170,
					v_ORLOAD_LFD_T130,
					v_ORLOAD_LFD_HS,
					v_ORLOAD_LFD_H,
					v_ORLOAD_LFD_3_3,
					v_ORLOAD_LFD_3S2,
					v_ORLOAD_LFD_3,
					v_ORLOAD_ADJ_T170,
					v_ORLOAD_ADJ_T130,
					v_ORLOAD_ADJ_H,
					v_ORLOAD_ADJ_3_3,
					v_ORLOAD_ADJ_3S2,
					v_ORLOAD_ADJ_3,
					v_ORIENTATION,
					v_MEDIAN_WIDTH,
					v_MAINT_AREA,
					v_IRLOAD_WSD_T170,
					v_IRLOAD_WSD_T130,
					v_IRLOAD_WSD_HS,
					v_IRLOAD_WSD_H,
					v_IRLOAD_WSD_3_3,
					v_IRLOAD_WSD_3S2,
					v_IRLOAD_WSD_3,
					v_IRLOAD_LFD_T170,
					v_IRLOAD_LFD_T130,
					v_IRLOAD_LFD_HS,
					v_IRLOAD_LFD_H,
					v_IRLOAD_LFD_3_3,
					v_IRLOAD_LFD_3S2,
					v_IRLOAD_LFD_3,
					v_IRLOAD_ADJ_T170,
					v_IRLOAD_ADJ_T130,
					v_IRLOAD_ADJ_H,
					v_IRLOAD_ADJ_3_3,
					v_IRLOAD_ADJ_3S2,
					v_IRLOAD_ADJ_3,
					v_FUNCTION_TYPE,
					v_DESIGN_REF_POST,
					v_DESIGNLOAD_TYPE,
					v_DESIGNLOAD_KDOT,
					v_CUSTODIAN_KDOT,
					v_CULV_WING_TYPE,
					v_CULV_FILL_DEPTH,
					v_BRIDGEMED_KDOT,
					v_BOX_HEIGHT_CULV,
					v_ATTACH_TYPE_3,
					v_ATTACH_TYPE_2,
					v_ATTACH_TYPE_1,
					v_ATTACH_DESC_3,
					v_ATTACH_DESC_2,
					v_ATTACH_DESC_1
			 from pontis.USERBRDG
			where pontis.USERBRDG.brkey = ls_brkey;
		
		
		if v_VERT_UNDR_SIGN = 'A' then
			v_VERT_UNDR_SIGN := 'B';
		else
			v_VERT_UNDR_SIGN := 'A';
		end if;
		
		if v_VERT_CLR_SIGN = 'A' then
			v_VERT_CLR_SIGN := 'B';
		else
			v_VERT_CLR_SIGN := 'A';
		end if;
		
		if v_SUPRSTRUCT_TOS = 1 then
			v_SUPRSTRUCT_TOS := 2;
		else
			v_SUPRSTRUCT_TOS := 1;
		end if;
		
		if v_SUPER_PAINT_SYS = 'A' then
			v_SUPER_PAINT_SYS := 'B';
		else
			v_SUPER_PAINT_SYS := 'A';
		end if;
		
		if v_STREAM_SIGN = 'A' then
			v_STREAM_SIGN := 'B';
		else
			v_STREAM_SIGN := 'A';
		end if;
		
		if v_SKEW_MINUTES = 1 then
			v_SKEW_MINUTES := 2;
		else
			v_SKEW_MINUTES := 1;
		end if;
		
		if v_SKEW_DIRECTION = 'A' then
			v_SKEW_DIRECTION := 'B';
		else
			v_SKEW_DIRECTION := 'A';
		end if;
		
		if v_SIGN_TYPE_Q4 = 'A' then
			v_SIGN_TYPE_Q4 := 'B';
		else
			v_SIGN_TYPE_Q4 := 'A';
		end if;
		
		if v_SIGN_TYPE_Q3 = 'A' then
			v_SIGN_TYPE_Q3 := 'B';
		else
			v_SIGN_TYPE_Q3 := 'A';
		end if;
		
		if v_SIGN_TYPE_Q2 = 'A' then
			v_SIGN_TYPE_Q2 := 'B';
		else
			v_SIGN_TYPE_Q2 := 'A';
		end if;
		
		if v_SIGN_TYPE_Q1 = 'A' then
			v_SIGN_TYPE_Q1 := 'B';
		else
			v_SIGN_TYPE_Q1 := 'A';
		end if;
		
		if v_ROT_DIRECTION = 'A' then
			v_ROT_DIRECTION := 'B';
		else
			v_ROT_DIRECTION := 'A';
		end if;
		
		if v_ROT_ANGLE_MIN = 1 then
			v_ROT_ANGLE_MIN := 2;
		else
			v_ROT_ANGLE_MIN := 1;
		end if;
		
		if v_ROT_ANGLE_DEG = 1 then
			v_ROT_ANGLE_DEG := 2;
		else
			v_ROT_ANGLE_DEG := 1;
		end if;
		
		if v_ROAD_TYPE_SIGN = 'A' then
			v_ROAD_TYPE_SIGN := 'B';
		else
			v_ROAD_TYPE_SIGN := 'A';
		end if;
		
		if v_RESTRICT_LOAD = 1 then
			v_RESTRICT_LOAD := 2;
		else
			v_RESTRICT_LOAD := 1;
		end if;
		
		if v_RATING_COMMENT = 'A' then
			v_RATING_COMMENT := 'B';
		else
			v_RATING_COMMENT := 'A';
		end if;
		
		if v_RATING_ADJ = 'A' then
			v_RATING_ADJ := 'B';
		else
			v_RATING_ADJ := 'A';
		end if;
		
		if v_POSTED_SIGN_TYPE = 'A' then
			v_POSTED_SIGN_TYPE := 'B';
		else
			v_POSTED_SIGN_TYPE := 'A';
		end if;
		
		if v_POSTED_LOAD_C = 'A' then
			v_POSTED_LOAD_C := 'B';
		else
			v_POSTED_LOAD_C := 'A';
		end if;
		
		if v_POSTED_LOAD_B = 'A' then
			v_POSTED_LOAD_B := 'B';
		else
			v_POSTED_LOAD_B := 'A';
		end if;
		
		if v_POSTED_LOAD_A = 'A' then
			v_POSTED_LOAD_A := 'B';
		else
			v_POSTED_LOAD_A := 'A';
		end if;
		
		if v_OWNER_KDOT = 'A' then
			v_OWNER_KDOT := 'B';
		else
			v_OWNER_KDOT := 'A';
		end if;
		
		if v_ORLOAD_WSD_T170 = 1 then
			v_ORLOAD_WSD_T170 := 2;
		else
			v_ORLOAD_WSD_T170 := 1;
		end if;
		
		if v_ORLOAD_WSD_T130 = 1 then
			v_ORLOAD_WSD_T130 := 2;
		else
			v_ORLOAD_WSD_T130 := 1;
		end if;
		
		if v_ORLOAD_WSD_HS = 1 then
			v_ORLOAD_WSD_HS := 2;
		else
			v_ORLOAD_WSD_HS := 1;
		end if;
		
		if v_ORLOAD_WSD_H = 1 then
			v_ORLOAD_WSD_H := 2;
		else
			v_ORLOAD_WSD_H := 1;
		end if;
		
		if v_ORLOAD_WSD_3_3 = 1 then
			v_ORLOAD_WSD_3_3 := 2;
		else
			v_ORLOAD_WSD_3_3 := 1;
		end if;
		
		if v_ORLOAD_WSD_3S2 = 1 then
			v_ORLOAD_WSD_3S2 := 2;
		else
			v_ORLOAD_WSD_3S2 := 1;
		end if;
		
		if v_ORLOAD_WSD_3 = 1 then
			v_ORLOAD_WSD_3 := 2;
		else
			v_ORLOAD_WSD_3 := 1;
		end if;
		
		if v_ORLOAD_LFD_T170 = 1 then
			v_ORLOAD_LFD_T170 := 2;
		else
			v_ORLOAD_LFD_T170 := 1;
		end if;
		
		if v_ORLOAD_LFD_T130 = 1 then
			v_ORLOAD_LFD_T130 := 2;
		else
			v_ORLOAD_LFD_T130 := 1;
		end if;
		
		if v_ORLOAD_LFD_HS = 1 then
			v_ORLOAD_LFD_HS := 2;
		else
			v_ORLOAD_LFD_HS := 1;
		end if;
		
		if v_ORLOAD_LFD_H = 1 then
			v_ORLOAD_LFD_H := 2;
		else
			v_ORLOAD_LFD_H := 1;
		end if;
		
		if v_ORLOAD_LFD_3_3 = 1 then
			v_ORLOAD_LFD_3_3 := 2;
		else
			v_ORLOAD_LFD_3_3 := 1;
		end if;
		
		if v_ORLOAD_LFD_3S2 = 1 then
			v_ORLOAD_LFD_3S2 := 2;
		else
			v_ORLOAD_LFD_3S2 := 1;
		end if;
		
		if v_ORLOAD_LFD_3 = 1 then
			v_ORLOAD_LFD_3 := 2;
		else
			v_ORLOAD_LFD_3 := 1;
		end if;
		
		if v_ORLOAD_ADJ_T170 = 1 then
			v_ORLOAD_ADJ_T170 := 2;
		else
			v_ORLOAD_ADJ_T170 := 1;
		end if;
		
		if v_ORLOAD_ADJ_T130 = 1 then
			v_ORLOAD_ADJ_T130 := 2;
		else
			v_ORLOAD_ADJ_T130 := 1;
		end if;
		
		if v_ORLOAD_ADJ_H = 1 then
			v_ORLOAD_ADJ_H := 2;
		else
			v_ORLOAD_ADJ_H := 1;
		end if;
		
		if v_ORLOAD_ADJ_3_3 = 1 then
			v_ORLOAD_ADJ_3_3 := 2;
		else
			v_ORLOAD_ADJ_3_3 := 1;
		end if;
		
		if v_ORLOAD_ADJ_3S2 = 1 then
			v_ORLOAD_ADJ_3S2 := 2;
		else
			v_ORLOAD_ADJ_3S2 := 1;
		end if;
		
		if v_ORLOAD_ADJ_3 = 1 then
			v_ORLOAD_ADJ_3 := 2;
		else
			v_ORLOAD_ADJ_3 := 1;
		end if;
		
		if v_ORIENTATION = 'A' then
			v_ORIENTATION := 'B';
		else
			v_ORIENTATION := 'A';
		end if;
		
		if v_MEDIAN_WIDTH = 1 then
			v_MEDIAN_WIDTH := 2;
		else
			v_MEDIAN_WIDTH := 1;
		end if;
		
		if v_MAINT_AREA = 'A' then
			v_MAINT_AREA := 'B';
		else
			v_MAINT_AREA := 'A';
		end if;
		
		if v_IRLOAD_WSD_T170 = 1 then
			v_IRLOAD_WSD_T170 := 2;
		else
			v_IRLOAD_WSD_T170 := 1;
		end if;
		
		if v_IRLOAD_WSD_T130 = 1 then
			v_IRLOAD_WSD_T130 := 2;
		else
			v_IRLOAD_WSD_T130 := 1;
		end if;
		
		if v_IRLOAD_WSD_HS = 1 then
			v_IRLOAD_WSD_HS := 2;
		else
			v_IRLOAD_WSD_HS := 1;
		end if;
		
		if v_IRLOAD_WSD_H = 1 then
			v_IRLOAD_WSD_H := 2;
		else
			v_IRLOAD_WSD_H := 1;
		end if;
		
		if v_IRLOAD_WSD_3_3 = 1 then
			v_IRLOAD_WSD_3_3 := 2;
		else
			v_IRLOAD_WSD_3_3 := 1;
		end if;
		
		if v_IRLOAD_WSD_3S2 = 1 then
			v_IRLOAD_WSD_3S2 := 2;
		else
			v_IRLOAD_WSD_3S2 := 1;
		end if;
		
		if v_IRLOAD_WSD_3 = 1 then
			v_IRLOAD_WSD_3 := 2;
		else
			v_IRLOAD_WSD_3 := 1;
		end if;
		
		if v_IRLOAD_LFD_T170 = 1 then
			v_IRLOAD_LFD_T170 := 2;
		else
			v_IRLOAD_LFD_T170 := 1;
		end if;
		
		if v_IRLOAD_LFD_T130 = 1 then
			v_IRLOAD_LFD_T130 := 2;
		else
			v_IRLOAD_LFD_T130 := 1;
		end if;
		
		if v_IRLOAD_LFD_HS = 1 then
			v_IRLOAD_LFD_HS := 2;
		else
			v_IRLOAD_LFD_HS := 1;
		end if;
		
		if v_IRLOAD_LFD_H = 1 then
			v_IRLOAD_LFD_H := 2;
		else
			v_IRLOAD_LFD_H := 1;
		end if;
		
		if v_IRLOAD_LFD_3_3 = 1 then
			v_IRLOAD_LFD_3_3 := 2;
		else
			v_IRLOAD_LFD_3_3 := 1;
		end if;
		
		if v_IRLOAD_LFD_3S2 = 1 then
			v_IRLOAD_LFD_3S2 := 2;
		else
			v_IRLOAD_LFD_3S2 := 1;
		end if;
		
		if v_IRLOAD_LFD_3 = 1 then
			v_IRLOAD_LFD_3 := 2;
		else
			v_IRLOAD_LFD_3 := 1;
		end if;
		
		if v_IRLOAD_ADJ_T170 = 1 then
			v_IRLOAD_ADJ_T170 := 2;
		else
			v_IRLOAD_ADJ_T170 := 1;
		end if;
		
		if v_IRLOAD_ADJ_T130 = 1 then
			v_IRLOAD_ADJ_T130 := 2;
		else
			v_IRLOAD_ADJ_T130 := 1;
		end if;
		
		if v_IRLOAD_ADJ_H = 1 then
			v_IRLOAD_ADJ_H := 2;
		else
			v_IRLOAD_ADJ_H := 1;
		end if;
		
		if v_IRLOAD_ADJ_3_3 = 1 then
			v_IRLOAD_ADJ_3_3 := 2;
		else
			v_IRLOAD_ADJ_3_3 := 1;
		end if;
		
		if v_IRLOAD_ADJ_3S2 = 1 then
			v_IRLOAD_ADJ_3S2 := 2;
		else
			v_IRLOAD_ADJ_3S2 := 1;
		end if;
		
		if v_IRLOAD_ADJ_3 = 1 then
			v_IRLOAD_ADJ_3 := 2;
		else
			v_IRLOAD_ADJ_3 := 1;
		end if;
		
		if v_FUNCTION_TYPE = 'A' then
			v_FUNCTION_TYPE := 'B';
		else
			v_FUNCTION_TYPE := 'A';
		end if;
		
		if v_DESIGN_REF_POST = 1 then
			v_DESIGN_REF_POST := 2;
		else
			v_DESIGN_REF_POST := 1;
		end if;
		
		if v_DESIGNLOAD_TYPE = '1' then
			v_DESIGNLOAD_TYPE := '2';
		else
			v_DESIGNLOAD_TYPE := '1';
		end if;
		
		if v_DESIGNLOAD_KDOT = 1 then
			v_DESIGNLOAD_KDOT := 2;
		else
			v_DESIGNLOAD_KDOT := 1;
		end if;
		
		if v_CUSTODIAN_KDOT = 'A' then
			v_CUSTODIAN_KDOT := 'B';
		else
			v_CUSTODIAN_KDOT := 'A';
		end if;
		
		if v_CULV_WING_TYPE = 'A' then
			v_CULV_WING_TYPE := 'B';
		else
			v_CULV_WING_TYPE := 'A';
		end if;
		
		if v_CULV_FILL_DEPTH = 1 then
			v_CULV_FILL_DEPTH := 2;
		else
			v_CULV_FILL_DEPTH := 1;
		end if;
		
		if v_BRIDGEMED_KDOT = '1' then
			v_BRIDGEMED_KDOT := '2';
		else
			v_BRIDGEMED_KDOT := '1';
		end if;
		
		if v_BOX_HEIGHT_CULV = 1 then
			v_BOX_HEIGHT_CULV := 2;
		else
			v_BOX_HEIGHT_CULV := 1;
		end if;
		
		if v_ATTACH_TYPE_3 = 'A' then
			v_ATTACH_TYPE_3 := 'B';
		else
			v_ATTACH_TYPE_3 := 'A';
		end if;
		
		if v_ATTACH_TYPE_2 = 'A' then
			v_ATTACH_TYPE_2 := 'B';
		else
			v_ATTACH_TYPE_2 := 'A';
		end if;
		
		if v_ATTACH_TYPE_1 = 'A' then
			v_ATTACH_TYPE_1 := 'B';
		else
			v_ATTACH_TYPE_1 := 'A';
		end if;
		
		if v_ATTACH_DESC_3 = 'A' then
			v_ATTACH_DESC_3 := 'B';
		else
			v_ATTACH_DESC_3 := 'A';
		end if;
		
		if v_ATTACH_DESC_2 = 'A' then
			v_ATTACH_DESC_2 := 'B';
		else
			v_ATTACH_DESC_2 := 'A';
		end if;
		
		if v_ATTACH_DESC_1 = 'A' then
			v_ATTACH_DESC_1 := 'B';
		else
			v_ATTACH_DESC_1 := 'A';
		end if;
		
		
		  update pontis.USERBRDG
			  set VERT_UNDR_SIGN = v_VERT_UNDR_SIGN,
					VERT_CLR_SIGN = v_VERT_CLR_SIGN,
					SUPRSTRUCT_TOS = v_SUPRSTRUCT_TOS,
					SUPER_PAINT_SYS = v_SUPER_PAINT_SYS,
					STREAM_SIGN = v_STREAM_SIGN,
					SKEW_MINUTES = v_SKEW_MINUTES,
					SKEW_DIRECTION = v_SKEW_DIRECTION,
					SIGN_TYPE_Q4 = v_SIGN_TYPE_Q4,
					SIGN_TYPE_Q3 = v_SIGN_TYPE_Q3,
					SIGN_TYPE_Q2 = v_SIGN_TYPE_Q2,
					SIGN_TYPE_Q1 = v_SIGN_TYPE_Q1,
					ROT_DIRECTION = v_ROT_DIRECTION,
					ROT_ANGLE_MIN = v_ROT_ANGLE_MIN,
					ROT_ANGLE_DEG = v_ROT_ANGLE_DEG,
					ROAD_TYPE_SIGN = v_ROAD_TYPE_SIGN,
					RESTRICT_LOAD = v_RESTRICT_LOAD,
					RATING_COMMENT = v_RATING_COMMENT,
					RATING_ADJ = v_RATING_ADJ,
					POSTED_SIGN_TYPE = v_POSTED_SIGN_TYPE,
					POSTED_LOAD_C = v_POSTED_LOAD_C,
					POSTED_LOAD_B = v_POSTED_LOAD_B,
					POSTED_LOAD_A = v_POSTED_LOAD_A,
					OWNER_KDOT = v_OWNER_KDOT,
					ORLOAD_WSD_T170 = v_ORLOAD_WSD_T170,
					ORLOAD_WSD_T130 = v_ORLOAD_WSD_T130,
					ORLOAD_WSD_HS = v_ORLOAD_WSD_HS,
					ORLOAD_WSD_H = v_ORLOAD_WSD_H,
					ORLOAD_WSD_3_3 = v_ORLOAD_WSD_3_3,
					ORLOAD_WSD_3S2 = v_ORLOAD_WSD_3S2,
					ORLOAD_WSD_3 = v_ORLOAD_WSD_3,
					ORLOAD_LFD_T170 = v_ORLOAD_LFD_T170,
					ORLOAD_LFD_T130 = v_ORLOAD_LFD_T130,
					ORLOAD_LFD_HS = v_ORLOAD_LFD_HS,
					ORLOAD_LFD_H = v_ORLOAD_LFD_H,
					ORLOAD_LFD_3_3 = v_ORLOAD_LFD_3_3,
					ORLOAD_LFD_3S2 = v_ORLOAD_LFD_3S2,
					ORLOAD_LFD_3 = v_ORLOAD_LFD_3,
					ORLOAD_ADJ_T170 = v_ORLOAD_ADJ_T170,
					ORLOAD_ADJ_T130 = v_ORLOAD_ADJ_T130,
					ORLOAD_ADJ_H = v_ORLOAD_ADJ_H,
					ORLOAD_ADJ_3_3 = v_ORLOAD_ADJ_3_3,
					ORLOAD_ADJ_3S2 = v_ORLOAD_ADJ_3S2,
					ORLOAD_ADJ_3 = v_ORLOAD_ADJ_3,
					ORIENTATION = v_ORIENTATION,
					MEDIAN_WIDTH = v_MEDIAN_WIDTH,
					MAINT_AREA = v_MAINT_AREA,
					IRLOAD_WSD_T170 = v_IRLOAD_WSD_T170,
					IRLOAD_WSD_T130 = v_IRLOAD_WSD_T130,
					IRLOAD_WSD_HS = v_IRLOAD_WSD_HS,
					IRLOAD_WSD_H = v_IRLOAD_WSD_H,
					IRLOAD_WSD_3_3 = v_IRLOAD_WSD_3_3,
					IRLOAD_WSD_3S2 = v_IRLOAD_WSD_3S2,
					IRLOAD_WSD_3 = v_IRLOAD_WSD_3,
					IRLOAD_LFD_T170 = v_IRLOAD_LFD_T170,
					IRLOAD_LFD_T130 = v_IRLOAD_LFD_T130,
					IRLOAD_LFD_HS = v_IRLOAD_LFD_HS,
					IRLOAD_LFD_H = v_IRLOAD_LFD_H,
					IRLOAD_LFD_3_3 = v_IRLOAD_LFD_3_3,
					IRLOAD_LFD_3S2 = v_IRLOAD_LFD_3S2,
					IRLOAD_LFD_3 = v_IRLOAD_LFD_3,
					IRLOAD_ADJ_T170 = v_IRLOAD_ADJ_T170,
					IRLOAD_ADJ_T130 = v_IRLOAD_ADJ_T130,
					IRLOAD_ADJ_H = v_IRLOAD_ADJ_H,
					IRLOAD_ADJ_3_3 = v_IRLOAD_ADJ_3_3,
					IRLOAD_ADJ_3S2 = v_IRLOAD_ADJ_3S2,
					IRLOAD_ADJ_3 = v_IRLOAD_ADJ_3,
					FUNCTION_TYPE = v_FUNCTION_TYPE,
					DESIGN_REF_POST = v_DESIGN_REF_POST,
					DESIGNLOAD_TYPE = v_DESIGNLOAD_TYPE,
					DESIGNLOAD_KDOT = v_DESIGNLOAD_KDOT,
					CUSTODIAN_KDOT = v_CUSTODIAN_KDOT,
					CULV_WING_TYPE = v_CULV_WING_TYPE,
					CULV_FILL_DEPTH = v_CULV_FILL_DEPTH,
					BRIDGEMED_KDOT = v_BRIDGEMED_KDOT,
					BOX_HEIGHT_CULV = v_BOX_HEIGHT_CULV,
					ATTACH_TYPE_3 = v_ATTACH_TYPE_3,
					ATTACH_TYPE_2 = v_ATTACH_TYPE_2,
					ATTACH_TYPE_1 = v_ATTACH_TYPE_1,
					ATTACH_DESC_3 = v_ATTACH_DESC_3,
					ATTACH_DESC_2 = v_ATTACH_DESC_2,
					ATTACH_DESC_1 = v_ATTACH_DESC_1
			where pontis.USERBRDG.brkey = ls_brkey;
		
		
		
		  select pontis.STRUCTURE_UNIT.STRUNITTYPE,
					pontis.STRUCTURE_UNIT.STRUNITLABEL
			 into v_STRUNITTYPE,
					v_STRUNITLABEL
			 from pontis.STRUCTURE_UNIT
			where pontis.STRUCTURE_UNIT.brkey = ls_brkey and STRUCTURE_UNIT.strunitkey = 1;
		
		
		if v_STRUNITTYPE = 'A' then
			v_STRUNITTYPE := 'B';
		else
			v_STRUNITTYPE := 'A';
		end if;
		
		
		  update pontis.STRUCTURE_UNIT
			  set STRUNITTYPE = v_STRUNITTYPE,
					STRUNITLABEL = v_STRUNITLABEL
			where pontis.STRUCTURE_UNIT.brkey = ls_brkey and STRUCTURE_UNIT.strunitkey = 1;
		
		
		
		  select pontis.ROADWAY.ROADWIDTH,
					pontis.ROADWAY.ROADWAY_NAME,
					pontis.ROADWAY.CRIT_FEAT
			 into v_ROADWIDTH,
					v_ROADWAY_NAME,
					v_CRIT_FEAT
			 from pontis.ROADWAY
			where pontis.ROADWAY.brkey = ls_brkey and ROADWAY.on_under = '1';
		
		
		if v_ROADWIDTH = 1 then
			v_ROADWIDTH := 2;
		else
			v_ROADWIDTH := 1;
		end if;
		
		if v_ROADWAY_NAME = 'A' then
			v_ROADWAY_NAME := 'B';
		else
			v_ROADWAY_NAME := 'A';
		end if;
		
		if v_CRIT_FEAT = 'A' then
			v_CRIT_FEAT := 'B';
		else
			v_CRIT_FEAT := 'A';
		end if;
		
		
		  update pontis.ROADWAY
			  set ROADWIDTH = v_ROADWIDTH,
					ROADWAY_NAME = v_ROADWAY_NAME,
					CRIT_FEAT = v_CRIT_FEAT
			where pontis.ROADWAY.brkey = ls_brkey and ROADWAY.on_under = '1';
		
		
		
		  select pontis.ROADWAY.ROADWIDTH,
					pontis.ROADWAY.ROADWAY_NAME,
					pontis.ROADWAY.CRIT_FEAT
			 into v_ROADWIDTH,
					v_ROADWAY_NAME,
					v_CRIT_FEAT
			 from pontis.ROADWAY
			where pontis.ROADWAY.brkey = ls_brkey and ROADWAY.on_under = '2';
		if v_ROADWIDTH = 1 then
			v_ROADWIDTH := 2;
		else
			v_ROADWIDTH := 1;
		end if;
		
		if v_ROADWAY_NAME = 'A' then
			v_ROADWAY_NAME := 'B';
		else
			v_ROADWAY_NAME := 'A';
		end if;
		
		if v_CRIT_FEAT = 'A' then
			v_CRIT_FEAT := 'B';
		else
			v_CRIT_FEAT := 'A';
		end if;
		
		
		  update pontis.ROADWAY
			  set ROADWIDTH = v_ROADWIDTH,
					ROADWAY_NAME = v_ROADWAY_NAME,
					CRIT_FEAT = v_CRIT_FEAT
			where pontis.ROADWAY.brkey = ls_brkey and ROADWAY.on_under = '2';
		
		
		
		  select pontis.INSPEVNT.WATERADEQ,
					pontis.INSPEVNT.UWLASTINSP,
					pontis.INSPEVNT.UNDERCLR,
					pontis.INSPEVNT.TRANSRATIN,
					pontis.INSPEVNT.SUPRATING,
					pontis.INSPEVNT.SUBRATING,
					pontis.INSPEVNT.STRRATING,
					pontis.INSPEVNT.SCOURCRIT,
					pontis.INSPEVNT.RAILRATING,
					pontis.INSPEVNT.OSLASTINSP,
					pontis.INSPEVNT.INSPDATE,
					pontis.INSPEVNT.FCLASTINSP,
					pontis.INSPEVNT.DKRATING,
					pontis.INSPEVNT.DECKGEOM,
					pontis.INSPEVNT.CULVRATING,
					pontis.INSPEVNT.CHANRATING,
					pontis.INSPEVNT.ARAILRATIN,
					pontis.INSPEVNT.APPRALIGN,
					pontis.INSPEVNT.AENDRATING
			 into v_WATERADEQ,
					v_UWLASTINSP,
					v_UNDERCLR,
					v_TRANSRATIN,
					v_SUPRATING,
					v_SUBRATING,
					v_STRRATING,
					v_SCOURCRIT,
					v_RAILRATING,
					v_OSLASTINSP,
					v_INSPDATE,
					v_FCLASTINSP,
					v_DKRATING,
					v_DECKGEOM,
					v_CULVRATING,
					v_CHANRATING,
					v_ARAILRATIN,
					v_APPRALIGN,
					v_AENDRATING
			 from pontis.INSPEVNT
			where pontis.INSPEVNT.brkey = ls_brkey and INSPEVNT.inspkey = ls_inspkey;
		
		
		if v_WATERADEQ = 'A' then
			v_WATERADEQ := 'B';
		else
			v_WATERADEQ := 'A';
		end if;
		
		v_UWLASTINSP := v_UWLASTINSP + 1;
		
		if v_UNDERCLR = 'A' then
			v_UNDERCLR := 'B';
		else
			v_UNDERCLR := 'A';
		end if;
		
		if v_TRANSRATIN = 'A' then
			v_TRANSRATIN := 'B';
		else
			v_TRANSRATIN := 'A';
		end if;
		
		if v_SUPRATING = 'A' then
			v_SUPRATING := 'B';
		else
			v_SUPRATING := 'A';
		end if;
		
		if v_SUBRATING = 'A' then
			v_SUBRATING := 'B';
		else
			v_SUBRATING := 'A';
		end if;
		
		if v_STRRATING = 'A' then
			v_STRRATING := 'B';
		else
			v_STRRATING := 'A';
		end if;
		
		if v_SCOURCRIT = 'A' then
			v_SCOURCRIT := 'B';
		else
			v_SCOURCRIT := 'A';
		end if;
		
		if v_RAILRATING = 'A' then
			v_RAILRATING := 'B';
		else
			v_RAILRATING := 'A';
		end if;
		
		v_OSLASTINSP := v_OSLASTINSP + 1;
		
		v_INSPDATE := v_INSPDATE + 1;
		
		v_FCLASTINSP := v_FCLASTINSP + 1;
		
		if v_DKRATING = 'A' then
			v_DKRATING := 'B';
		else
			v_DKRATING := 'A';
		end if;
		
		if v_DECKGEOM = 'A' then
			v_DECKGEOM := 'B';
		else
			v_DECKGEOM := 'A';
		end if;
		
		if v_CULVRATING = 'A' then
			v_CULVRATING := 'B';
		else
			v_CULVRATING := 'A';
		end if;
		
		if v_CHANRATING = 'A' then
			v_CHANRATING := 'B';
		else
			v_CHANRATING := 'A';
		end if;
		
		if v_ARAILRATIN = 'A' then
			v_ARAILRATIN := 'B';
		else
			v_ARAILRATIN := 'A';
		end if;
		
		if v_APPRALIGN = 'A' then
			v_APPRALIGN := 'B';
		else
			v_APPRALIGN := 'A';
		end if;
		
		if v_AENDRATING = 'A' then
			v_AENDRATING := 'B';
		else
			v_AENDRATING := 'A';
		end if;
		
		
		  update pontis.INSPEVNT
			  set WATERADEQ = v_WATERADEQ,
					UWLASTINSP = v_UWLASTINSP,
					UNDERCLR = v_UNDERCLR,
					TRANSRATIN = v_TRANSRATIN,
					SUPRATING = v_SUPRATING,
					SUBRATING = v_SUBRATING,
					STRRATING = v_STRRATING,
					SCOURCRIT = v_SCOURCRIT,
					RAILRATING = v_RAILRATING,
					OSLASTINSP = v_OSLASTINSP,
					INSPDATE = v_INSPDATE,
					FCLASTINSP = v_FCLASTINSP,
					DKRATING = v_DKRATING,
					DECKGEOM = v_DECKGEOM,
					CULVRATING = v_CULVRATING,
					CHANRATING = v_CHANRATING,
					ARAILRATIN = v_ARAILRATIN,
					APPRALIGN = v_APPRALIGN,
					AENDRATING = v_AENDRATING
			where pontis.INSPEVNT.brkey = ls_brkey and INSPEVNT.inspkey = ls_inspkey;

		
		
		  select pontis.BRIDGE.STRUCT_NUM,
					pontis.BRIDGE.STRFLARED,
					pontis.BRIDGE.SKEW,
					pontis.BRIDGE.RTCURBSW,
					pontis.BRIDGE.PARALSTRUC,
					pontis.BRIDGE.ORLOAD,
					pontis.BRIDGE.NAVVC,
					pontis.BRIDGE.NAVHC,
					pontis.BRIDGE.LOCATION,
					pontis.BRIDGE.LFTCURBSW,
					pontis.BRIDGE.LENGTH,
					pontis.BRIDGE.IRLOAD,
					pontis.BRIDGE.FEATINT,
					pontis.BRIDGE.FACILITY,
					pontis.BRIDGE.DISTRICT,
					pontis.BRIDGE.DECKWIDTH,
					pontis.BRIDGE.BB_PCT
			 into v_STRUCT_NUM,
					v_STRFLARED,
					v_SKEW,
					v_RTCURBSW,
					v_PARALSTRUC,
					v_ORLOAD,
					v_NAVVC,
					v_NAVHC,
					v_LOCATION,
					v_LFTCURBSW,
					v_BRIDGE_LENGTH,
					v_IRLOAD,
					v_FEATINT,
					v_FACILITY,
					v_DISTRICT,
					v_DECKWIDTH,
					v_BB_PCT
			 from pontis.BRIDGE
			where pontis.BRIDGE.brkey = ls_brkey;
		
		
		if v_STRUCT_NUM = 'A' then
			v_STRUCT_NUM := 'C';
		else
			v_STRUCT_NUM := 'A';
		end if;
		
		if v_STRFLARED = 'A' then
			v_STRFLARED := 'B';
		else
			v_STRFLARED := 'A';
		end if;
		
		if v_SKEW = 1 then
			v_SKEW := 2;
		else
			v_SKEW := 1;
		end if;
		
		if v_RTCURBSW = 1 then
			v_RTCURBSW := 2;
		else
			v_RTCURBSW := 1;
		end if;
		
		if v_PARALSTRUC = 'A' then
			v_PARALSTRUC := 'B';
		else
			v_PARALSTRUC := 'A';
		end if;
		
		if v_ORLOAD = 1 then
			v_ORLOAD := 2;
		else
			v_ORLOAD := 1;
		end if;
		
		if v_NAVVC = 1 then
			v_NAVVC := 2;
		else
			v_NAVVC := 1;
		end if;
		
		if v_NAVHC = 1 then
			v_NAVHC := 2;
		else
			v_NAVHC := 1;
		end if;
		
		if v_LOCATION = 'A' then
			v_LOCATION := 'B';
		else
			v_LOCATION := 'A';
		end if;
		
		if v_LFTCURBSW = 1 then
			v_LFTCURBSW := 2;
		else
			v_LFTCURBSW := 1;
		end if;
		
		if v_BRIDGE_LENGTH = 1 then
			v_BRIDGE_LENGTH := 2;
		else
			v_BRIDGE_LENGTH := 1;
		end if;
		
		if v_IRLOAD = 1 then
			v_IRLOAD := 2;
		else
			v_IRLOAD := 1;
		end if;
		
		if v_FEATINT = 'A' then
			v_FEATINT := 'B';
		else
			v_FEATINT := 'A';
		end if;
		
		if v_FACILITY = 'A' then
			v_FACILITY := 'B';
		else
			v_FACILITY := 'A';
		end if;
		
		if v_DISTRICT = 'A' then
			v_DISTRICT := 'B';
		else
			v_DISTRICT := 'A';
		end if;
		
		if v_DECKWIDTH = 1 then
			v_DECKWIDTH := 2;
		else
			v_DECKWIDTH := 1;
		end if;
		
		if v_BB_PCT = 1 then
			v_BB_PCT := 2;
		else
			v_BB_PCT := 1;
		end if;
		
		
		  update pontis.BRIDGE
			  set STRUCT_NUM = v_STRUCT_NUM,
					STRFLARED = v_STRFLARED,
					SKEW = v_SKEW,
					RTCURBSW = v_RTCURBSW,
					PARALSTRUC = v_PARALSTRUC,
					ORLOAD = v_ORLOAD,
					NAVVC = v_NAVVC,
					NAVHC = v_NAVHC,
					LOCATION = v_LOCATION,
					LFTCURBSW = v_LFTCURBSW,
					LENGTH = v_BRIDGE_LENGTH,
					IRLOAD = v_IRLOAD,
					FEATINT = v_FEATINT,
					FACILITY = v_FACILITY,
					DISTRICT = v_DISTRICT,
					DECKWIDTH = v_DECKWIDTH,
					BB_PCT = v_BB_PCT
			where pontis.BRIDGE.brkey = ls_brkey;
		
		
       
       COMMIT;
       -- How many records are there?
       declare
           li_count pls_integer;
       begin
           select count(*) into li_count from ds_change_log;
           dbms_output.put_line( 'There are ' || to_char( li_count ) || ' DS_CHANGE_LOG records' );
           select count(*) into li_count from ds_lookup_keyvals;
           dbms_output.put_line( 'There are ' || to_char( li_count ) || ' DS_LOOKUP_KEYVALS records' );
       end;

      return false; -- It worked!
   end f_test_triggers;

   -- The pre-2/16/2002 version that changed keys
   function f_test_triggers_bak
      return boolean
   is
      /* Test script
      declare
        -- Boolean parameters are translated from/to integers:
        -- 0/1/null <--> false/true/null
        result boolean;
      begin
        -- Call the function
        result := ksbms_pontis.f_test_triggers_bak;
        -- Convert false/true/null to 0/1/null
        :result := sys.diutil.bool_to_int(result);
      end;
      */
      
      -- Declarations
      v_wide_type          userstrunit.wide_type%type;
      v_wide_num_girders   userstrunit.wide_num_girders%type;
      v_wide_material      userstrunit.wide_material%type;
      v_wide_design_ty     userstrunit.wide_design_ty%type;
      v_wear_thick         userstrunit.wear_thick%type;
      v_unit_type          userstrunit.unit_type%type;
      v_unit_material      userstrunit.unit_material%type;
      v_super_design_ty    userstrunit.super_design_ty%type;
      v_rail_type          userstrunit.rail_type%type;
      v_pier_type          userstrunit.pier_type%type;
      v_pier_foot_type     userstrunit.pier_foot_type%type;
      v_num_spans_grp_9    userstrunit.num_spans_grp_9%type;
      v_num_spans_grp_8    userstrunit.num_spans_grp_8%type;
      v_num_spans_grp_7    userstrunit.num_spans_grp_7%type;
      v_num_spans_grp_6    userstrunit.num_spans_grp_6%type;
      v_num_spans_grp_5    userstrunit.num_spans_grp_5%type;
      v_num_spans_grp_4    userstrunit.num_spans_grp_4%type;
      v_num_spans_grp_3    userstrunit.num_spans_grp_3%type;
      v_num_spans_grp_2    userstrunit.num_spans_grp_2%type;
      v_num_spans_grp_10   userstrunit.num_spans_grp_10%type;
      v_num_spans_grp_1    userstrunit.num_spans_grp_1%type;
      v_num_girders        userstrunit.num_girders%type;
      v_len_span_grp_9     userstrunit.len_span_grp_9%type;
      v_len_span_grp_8     userstrunit.len_span_grp_8%type;
      v_len_span_grp_7     userstrunit.len_span_grp_7%type;
      v_len_span_grp_6     userstrunit.len_span_grp_6%type;
      v_len_span_grp_5     userstrunit.len_span_grp_5%type;
      v_len_span_grp_4     userstrunit.len_span_grp_4%type;
      v_len_span_grp_3     userstrunit.len_span_grp_3%type;
      v_len_span_grp_2     userstrunit.len_span_grp_2%type;
      v_len_span_grp_10    userstrunit.len_span_grp_10%type;
      v_len_span_grp_1     userstrunit.len_span_grp_1%type;
      v_length             userstrunit.length%type;
      v_hinge_type         userstrunit.hinge_type%type;
      v_expan_dev_near     userstrunit.expan_dev_near%type;
      v_expan_dev_far      userstrunit.expan_dev_far%type;
      v_dk_drain_sys       userstrunit.dk_drain_sys%type;
      v_dksurftype         userstrunit.dksurftype%type;
      v_dkprotect          userstrunit.dkprotect%type;
      v_dkmembtype         userstrunit.dkmembtype%type;
      v_deck_thick         userstrunit.deck_thick%type;
      v_deck_matrl         userstrunit.deck_matrl%type;
      v_deckseal           userstrunit.deckseal%type;
      v_bearing_type       userstrunit.bearing_type%type;
      v_abut_type_near     userstrunit.abut_type_near%type;
      v_abut_type_far      userstrunit.abut_type_far%type;
      v_abut_foot_near     userstrunit.abut_foot_near%type;
      v_abut_foot_far      userstrunit.abut_foot_far%type;
      v_vclr_w             userrway.vclr_w%type;
      v_vclr_s             userrway.vclr_s%type;
      v_vclr_n             userrway.vclr_n%type;
      v_vclr_e             userrway.vclr_e%type;
      v_vclrinv_w          userrway.vclrinv_w%type;
      v_vclrinv_s          userrway.vclrinv_s%type;
      v_vclrinv_n          userrway.vclrinv_n%type;
      v_vclrinv_e          userrway.vclrinv_e%type;
      v_trans_lanes        userrway.trans_lanes%type;
      v_route_unique_id    userrway.route_unique_id%type;
      v_route_suffix       userrway.route_suffix%type;
      v_route_prefix       userrway.route_prefix%type;
      v_route_num          userrway.route_num%type;
      v_road_cross_name    userrway.road_cross_name%type;
      v_maint_rte_suffix   userrway.maint_rte_suffix%type;
      v_maint_rte_prefix   userrway.maint_rte_prefix%type;
      v_maint_rte_num      userrway.maint_rte_num%type;
      v_maint_rte_id       userrway.maint_rte_id%type;
      v_hclr_w             userrway.hclr_w%type;
      v_hclr_s             userrway.hclr_s%type;
      v_hclr_n             userrway.hclr_n%type;
      v_hclr_e             userrway.hclr_e%type;
      v_hclrurt_w          userrway.hclrurt_w%type;
      v_hclrurt_s          userrway.hclrurt_s%type;
      v_hclrurt_n          userrway.hclrurt_n%type;
      v_hclrurt_e          userrway.hclrurt_e%type;
      v_hclrult_w          userrway.hclrult_w%type;
      v_hclrult_s          userrway.hclrult_s%type;
      v_hclrult_n          userrway.hclrult_n%type;
      v_hclrult_e          userrway.hclrult_e%type;
      v_feat_desc_type     userrway.feat_desc_type%type;
      v_feat_cross_type    userrway.feat_cross_type%type;
      v_clr_route          userrway.clr_route%type;
      v_chan_prot_right    userrway.chan_prot_right%type;
      v_chan_prot_left     userrway.chan_prot_left%type;
      v_berm_prot          userrway.berm_prot%type;
      v_aroadwidth_near    userrway.aroadwidth_near%type;
      v_aroadwidth_far     userrway.aroadwidth_far%type;
      v_uwinspfreq_kdot    userinsp.uwinspfreq_kdot%type;
      v_uwater_insp_typ    userinsp.uwater_insp_typ%type;
      v_paint_cond         userinsp.paint_cond%type;
      v_osinspfreq_kdot    userinsp.osinspfreq_kdot%type;
      v_oppostcl_kdot      userinsp.oppostcl_kdot%type;
      v_fcinspfreq_kdot    userinsp.fcinspfreq_kdot%type;
      v_cond_index         userinsp.cond_index%type;
      v_brinspfreq_kdot    userinsp.brinspfreq_kdot%type;
      v_vert_undr_sign     userbrdg.vert_undr_sign%type;
      v_vert_clr_sign      userbrdg.vert_clr_sign%type;
      v_suprstruct_tos     userbrdg.suprstruct_tos%type;
      v_super_paint_sys    userbrdg.super_paint_sys%type;
      v_stream_sign        userbrdg.stream_sign%type;
      v_skew_minutes       userbrdg.skew_minutes%type;
      v_skew_direction     userbrdg.skew_direction%type;
      v_sign_type_q4       userbrdg.sign_type_q4%type;
      v_sign_type_q3       userbrdg.sign_type_q3%type;
      v_sign_type_q2       userbrdg.sign_type_q2%type;
      v_sign_type_q1       userbrdg.sign_type_q1%type;
      v_rot_direction      userbrdg.rot_direction%type;
      v_rot_angle_min      userbrdg.rot_angle_min%type;
      v_rot_angle_deg      userbrdg.rot_angle_deg%type;
      v_road_type_sign     userbrdg.road_type_sign%type;
      v_restrict_load      userbrdg.restrict_load%type;
      v_rating_comment     userbrdg.rating_comment%type;
      v_rating_adj         userbrdg.rating_adj%type;
      v_posted_sign_type   userbrdg.posted_sign_type%type;
      v_posted_load_c      userbrdg.posted_load_c%type;
      v_posted_load_b      userbrdg.posted_load_b%type;
      v_posted_load_a      userbrdg.posted_load_a%type;
      v_owner_kdot         userbrdg.owner_kdot%type;
      v_orload_wsd_t170    userbrdg.orload_wsd_t170%type;
      v_orload_wsd_t130    userbrdg.orload_wsd_t130%type;
      v_orload_wsd_hs      userbrdg.orload_wsd_hs%type;
      v_orload_wsd_h       userbrdg.orload_wsd_h%type;
      v_orload_wsd_3_3     userbrdg.orload_wsd_3_3%type;
      v_orload_wsd_3s2     userbrdg.orload_wsd_3s2%type;
      v_orload_wsd_3       userbrdg.orload_wsd_3%type;
      v_orload_lfd_t130    userbrdg.orload_lfd_t130%type;
      v_orload_lfd_hs      userbrdg.orload_lfd_hs%type;
      v_orload_lfd_h       userbrdg.orload_lfd_h%type;
      v_orload_lfd_3_3     userbrdg.orload_lfd_3_3%type;
      v_orload_lfd_3s2     userbrdg.orload_lfd_3s2%type;
      v_orload_lfd_3       userbrdg.orload_lfd_3%type;
      v_orload_lfd_t170     userbrdg.orload_lfd_t170%type;
      v_orload_adj_t170    userbrdg.orload_adj_t170%type;
      v_orload_adj_t130    userbrdg.orload_adj_t130%type;
      v_orload_adj_h       userbrdg.orload_adj_h%type;
      v_orload_adj_3_3     userbrdg.orload_adj_3_3%type;
      v_orload_adj_3s2     userbrdg.orload_adj_3s2%type;
      v_orload_adj_3       userbrdg.orload_adj_3%type;
      v_orientation        userbrdg.orientation%type;
      v_median_width       userbrdg.median_width%type;
      v_maint_area         userbrdg.maint_area%type;
      v_irload_wsd_t170    userbrdg.irload_wsd_t170%type;
      v_irload_wsd_t130    userbrdg.irload_wsd_t130%type;
      v_irload_wsd_hs      userbrdg.irload_wsd_hs%type;
      v_irload_wsd_h       userbrdg.irload_wsd_h%type;
      v_irload_wsd_3_3     userbrdg.irload_wsd_3_3%type;
      v_irload_wsd_3s2     userbrdg.irload_wsd_3s2%type;
      v_irload_wsd_3       userbrdg.irload_wsd_3%type;
      v_irload_lfd_t170    userbrdg.irload_lfd_t170%type;
      v_irload_lfd_t130    userbrdg.irload_lfd_t130%type;
      v_irload_lfd_hs      userbrdg.irload_lfd_hs%type;
      v_irload_lfd_h       userbrdg.irload_lfd_h%type;
      v_irload_lfd_3_3     userbrdg.irload_lfd_3_3%type;
      v_irload_lfd_3s2     userbrdg.irload_lfd_3s2%type;
      v_irload_lfd_3       userbrdg.irload_lfd_3%type;
      v_irload_adj_t170    userbrdg.irload_adj_t170%type;
      v_irload_adj_t130    userbrdg.irload_adj_t130%type;
      v_irload_adj_h       userbrdg.irload_adj_h%type;
      v_irload_adj_3_3     userbrdg.irload_adj_3_3%type;
      v_irload_adj_3s2     userbrdg.irload_adj_3s2%type;
      v_irload_adj_3       userbrdg.irload_adj_3%type;
      v_function_type      userbrdg.function_type%type;
      v_design_ref_post    userbrdg.design_ref_post%type;
      v_designload_type    userbrdg.designload_type%type;
      v_designload_kdot    userbrdg.designload_kdot%type;
      v_custodian_kdot     userbrdg.custodian_kdot%type;
      v_culv_wing_type     userbrdg.culv_wing_type%type;
      v_culv_fill_depth    userbrdg.culv_fill_depth%type;
      v_bridgemed_kdot     userbrdg.bridgemed_kdot%type;
      v_box_height_culv    userbrdg.box_height_culv%type;
      v_attach_type_3      userbrdg.attach_type_3%type;
      v_attach_type_2      userbrdg.attach_type_2%type;
      v_attach_type_1      userbrdg.attach_type_1%type;
      v_attach_desc_3      userbrdg.attach_desc_3%type;
      v_attach_desc_2      userbrdg.attach_desc_2%type;
      v_attach_desc_1      userbrdg.attach_desc_1%type;
      v_strunittype        structure_unit.strunittype%type;
      v_strunitlabel       structure_unit.strunitlabel%type;
      v_roadwidth          roadway.roadwidth%type;
      v_roadway_name       roadway.roadway_name%type;
      v_crit_feat          roadway.crit_feat%type;
      v_wateradeq          inspevnt.wateradeq%type;
      v_uwlastinsp         inspevnt.uwlastinsp%type;
      v_underclr           inspevnt.underclr%type;
      v_transratin         inspevnt.transratin%type;
      v_suprating          inspevnt.suprating%type;
      v_subrating          inspevnt.subrating%type;
      v_strrating          inspevnt.strrating%type;
      v_scourcrit          inspevnt.scourcrit%type;
      v_railrating         inspevnt.railrating%type;
      v_oslastinsp         inspevnt.oslastinsp%type;
      v_inspdate           inspevnt.inspdate%type;
      v_fclastinsp         inspevnt.fclastinsp%type;
      v_dkrating           inspevnt.dkrating%type;
      v_deckgeom           inspevnt.deckgeom%type;
      v_culvrating         inspevnt.culvrating%type;
      v_chanrating         inspevnt.chanrating%type;
      v_arailratin         inspevnt.arailratin%type;
      v_appralign          inspevnt.appralign%type;
      v_aendrating         inspevnt.aendrating%type;
      v_struct_num         bridge.struct_num%type;
      v_strflared          bridge.strflared%type;
      v_skew               bridge.skew%type;
      v_rtcurbsw           bridge.rtcurbsw%type;
      v_paralstruc         bridge.paralstruc%type;
      v_orload             bridge.orload%type;
      v_navvc              bridge.navvc%type;
      v_navhc              bridge.navhc%type;
      v_location           bridge.location%type;
      v_lftcurbsw          bridge.lftcurbsw%type;
      v_bridge_length      bridge.length%type;
      v_irload             bridge.irload%type;
      v_featint            bridge.featint%type;
      v_facility           bridge.facility%type;
      v_district           bridge.district%type;
      v_deckwidth          bridge.deckwidth%type;
      v_bb_pct             bridge.bb_pct%type;


		ls_brkey bridge.brkey%type := '105528';
    ls_inspkey inspevnt.inspkey%type := 'QIDY';

   BEGIN
      
      select pontis.userstrunit.wide_type,
             pontis.userstrunit.wide_num_girders,
             pontis.userstrunit.wide_material,
             pontis.userstrunit.wide_design_ty,
             pontis.userstrunit.wear_thick,
             pontis.userstrunit.unit_type,
             pontis.userstrunit.unit_material,
             pontis.userstrunit.super_design_ty,
             pontis.userstrunit.rail_type,
             pontis.userstrunit.pier_type,
             pontis.userstrunit.pier_foot_type,
             pontis.userstrunit.num_spans_grp_9,
             pontis.userstrunit.num_spans_grp_8,
             pontis.userstrunit.num_spans_grp_7,
             pontis.userstrunit.num_spans_grp_6,
             pontis.userstrunit.num_spans_grp_5,
             pontis.userstrunit.num_spans_grp_4,
             pontis.userstrunit.num_spans_grp_3,
             pontis.userstrunit.num_spans_grp_2,
             pontis.userstrunit.num_spans_grp_10,
             pontis.userstrunit.num_spans_grp_1,
             pontis.userstrunit.num_girders,
             pontis.userstrunit.len_span_grp_9,
             pontis.userstrunit.len_span_grp_8,
             pontis.userstrunit.len_span_grp_7,
             pontis.userstrunit.len_span_grp_6,
             pontis.userstrunit.len_span_grp_5,
             pontis.userstrunit.len_span_grp_4,
             pontis.userstrunit.len_span_grp_3,
             pontis.userstrunit.len_span_grp_2,
             pontis.userstrunit.len_span_grp_10,
             pontis.userstrunit.len_span_grp_1,
             pontis.userstrunit.length,
             pontis.userstrunit.hinge_type,
             pontis.userstrunit.expan_dev_near,
             pontis.userstrunit.expan_dev_far,
             pontis.userstrunit.dk_drain_sys,
             pontis.userstrunit.dksurftype,
             pontis.userstrunit.dkprotect,
             pontis.userstrunit.dkmembtype,
             pontis.userstrunit.deck_thick,
             pontis.userstrunit.deck_matrl,
             pontis.userstrunit.deckseal,
             pontis.userstrunit.bearing_type,
             pontis.userstrunit.abut_type_near,
             pontis.userstrunit.abut_type_far,
             pontis.userstrunit.abut_foot_near,
             pontis.userstrunit.abut_foot_far
        into v_wide_type,
             v_wide_num_girders,
             v_wide_material,
             v_wide_design_ty,
             v_wear_thick,
             v_unit_type,
             v_unit_material,
             v_super_design_ty,
             v_rail_type,
             v_pier_type,
             v_pier_foot_type,
             v_num_spans_grp_9,
             v_num_spans_grp_8,
             v_num_spans_grp_7,
             v_num_spans_grp_6,
             v_num_spans_grp_5,
             v_num_spans_grp_4,
             v_num_spans_grp_3,
             v_num_spans_grp_2,
             v_num_spans_grp_10,
             v_num_spans_grp_1,
             v_num_girders,
             v_len_span_grp_9,
             v_len_span_grp_8,
             v_len_span_grp_7,
             v_len_span_grp_6,
             v_len_span_grp_5,
             v_len_span_grp_4,
             v_len_span_grp_3,
             v_len_span_grp_2,
             v_len_span_grp_10,
             v_len_span_grp_1,
             v_length,
             v_hinge_type,
             v_expan_dev_near,
             v_expan_dev_far,
             v_dk_drain_sys,
             v_dksurftype,
             v_dkprotect,
             v_dkmembtype,
             v_deck_thick,
             v_deck_matrl,
             v_deckseal,
             v_bearing_type,
             v_abut_type_near,
             v_abut_type_far,
             v_abut_foot_near,
             v_abut_foot_far
        from pontis.userstrunit
       where pontis.userstrunit.brkey = ls_brkey and userstrunit.strunitkey = 1;

      if v_wide_type = 'A'
      then
         v_wide_type := 'B';
      else
         v_wide_type := 'A';
      end if;

      if v_wide_num_girders = 1
      then
         v_wide_num_girders := 2;
      else
         v_wide_num_girders := 1;
      end if;

      if v_wide_material = 'A'
      then
         v_wide_material := 'B';
      else
         v_wide_material := 'A';
      end if;

      if v_wide_design_ty = 'A'
      then
         v_wide_design_ty := 'B';
      else
         v_wide_design_ty := 'A';
      end if;

      if v_wear_thick = 1
      then
         v_wear_thick := 2;
      else
         v_wear_thick := 1;
      end if;

      if v_unit_type = 'A'
      then
         v_unit_type := 'B';
      else
         v_unit_type := 'A';
      end if;

      if v_unit_material = 'A'
      then
         v_unit_material := 'B';
      else
         v_unit_material := 'A';
      end if;

      if v_super_design_ty = 'A'
      then
         v_super_design_ty := 'B';
      else
         v_super_design_ty := 'A';
      end if;

      if v_rail_type = 'A'
      then
         v_rail_type := 'B';
      else
         v_rail_type := 'A';
      end if;

      if v_pier_type = 'A'
      then
         v_pier_type := 'B';
      else
         v_pier_type := 'A';
      end if;

      if v_pier_foot_type = 'A'
      then
         v_pier_foot_type := 'B';
      else
         v_pier_foot_type := 'A';
      end if;

      if v_num_spans_grp_9 = 1
      then
         v_num_spans_grp_9 := 2;
      else
         v_num_spans_grp_9 := 1;
      end if;

      if v_num_spans_grp_8 = 1
      then
         v_num_spans_grp_8 := 2;
      else
         v_num_spans_grp_8 := 1;
      end if;

      if v_num_spans_grp_7 = 1
      then
         v_num_spans_grp_7 := 2;
      else
         v_num_spans_grp_7 := 1;
      end if;

      if v_num_spans_grp_6 = 1
      then
         v_num_spans_grp_6 := 2;
      else
         v_num_spans_grp_6 := 1;
      end if;

      if v_num_spans_grp_5 = 1
      then
         v_num_spans_grp_5 := 2;
      else
         v_num_spans_grp_5 := 1;
      end if;

      if v_num_spans_grp_4 = 1
      then
         v_num_spans_grp_4 := 2;
      else
         v_num_spans_grp_4 := 1;
      end if;

      if v_num_spans_grp_3 = 1
      then
         v_num_spans_grp_3 := 2;
      else
         v_num_spans_grp_3 := 1;
      end if;

      if v_num_spans_grp_2 = 1
      then
         v_num_spans_grp_2 := 2;
      else
         v_num_spans_grp_2 := 1;
      end if;

      if v_num_spans_grp_10 = 1
      then
         v_num_spans_grp_10 := 2;
      else
         v_num_spans_grp_10 := 1;
      end if;

      if v_num_spans_grp_1 = 1
      then
         v_num_spans_grp_1 := 2;
      else
         v_num_spans_grp_1 := 1;
      end if;

      if v_num_girders = 1
      then
         v_num_girders := 2;
      else
         v_num_girders := 1;
      end if;

      if v_len_span_grp_9 = 1
      then
         v_len_span_grp_9 := 2;
      else
         v_len_span_grp_9 := 1;
      end if;

      if v_len_span_grp_8 = 1
      then
         v_len_span_grp_8 := 2;
      else
         v_len_span_grp_8 := 1;
      end if;

      if v_len_span_grp_7 = 1
      then
         v_len_span_grp_7 := 2;
      else
         v_len_span_grp_7 := 1;
      end if;

      if v_len_span_grp_6 = 1
      then
         v_len_span_grp_6 := 2;
      else
         v_len_span_grp_6 := 1;
      end if;

      if v_len_span_grp_5 = 1
      then
         v_len_span_grp_5 := 2;
      else
         v_len_span_grp_5 := 1;
      end if;

      if v_len_span_grp_4 = 1
      then
         v_len_span_grp_4 := 2;
      else
         v_len_span_grp_4 := 1;
      end if;

      if v_len_span_grp_3 = 1
      then
         v_len_span_grp_3 := 2;
      else
         v_len_span_grp_3 := 1;
      end if;

      if v_len_span_grp_2 = 1
      then
         v_len_span_grp_2 := 2;
      else
         v_len_span_grp_2 := 1;
      end if;

      if v_len_span_grp_10 = 1
      then
         v_len_span_grp_10 := 2;
      else
         v_len_span_grp_10 := 1;
      end if;

      if v_len_span_grp_1 = 1
      then
         v_len_span_grp_1 := 2;
      else
         v_len_span_grp_1 := 1;
      end if;

      if v_length = 1
      then
         v_length := 2;
      else
         v_length := 1;
      end if;

      if v_hinge_type = 'A'
      then
         v_hinge_type := 'B';
      else
         v_hinge_type := 'A';
      end if;

      if v_expan_dev_near = 'A'
      then
         v_expan_dev_near := 'B';
      else
         v_expan_dev_near := 'A';
      end if;

      if v_expan_dev_far = 'A'
      then
         v_expan_dev_far := 'B';
      else
         v_expan_dev_far := 'A';
      end if;

      if v_dk_drain_sys = 'A'
      then
         v_dk_drain_sys := 'B';
      else
         v_dk_drain_sys := 'A';
      end if;

      if v_dksurftype = 'A'
      then
         v_dksurftype := 'B';
      else
         v_dksurftype := 'A';
      end if;

      if v_dkprotect = 'A'
      then
         v_dkprotect := 'B';
      else
         v_dkprotect := 'A';
      end if;

      if v_dkmembtype = 'A'
      then
         v_dkmembtype := 'B';
      else
         v_dkmembtype := 'A';
      end if;

      if v_deck_thick = 1
      then
         v_deck_thick := 2;
      else
         v_deck_thick := 1;
      end if;

      if v_deck_matrl = 'A'
      then
         v_deck_matrl := 'B';
      else
         v_deck_matrl := 'A';
      end if;

      if v_deckseal = 'A'
      then
         v_deckseal := 'B';
      else
         v_deckseal := 'A';
      end if;

      if v_bearing_type = 'A'
      then
         v_bearing_type := 'B';
      else
         v_bearing_type := 'A';
      end if;

      if v_abut_type_near = 'A'
      then
         v_abut_type_near := 'B';
      else
         v_abut_type_near := 'A';
      end if;

      if v_abut_type_far = 'A'
      then
         v_abut_type_far := 'B';
      else
         v_abut_type_far := 'A';
      end if;

      if v_abut_foot_near = 'A'
      then
         v_abut_foot_near := 'B';
      else
         v_abut_foot_near := 'A';
      end if;

      if v_abut_foot_far = 'A'
      then
         v_abut_foot_far := 'B';
      else
         v_abut_foot_far := 'A';
      end if;

      update pontis.userstrunit
         set wide_type = v_wide_type,
             wide_num_girders = v_wide_num_girders,
             wide_material = v_wide_material,
             wide_design_ty = v_wide_design_ty,
             wear_thick = v_wear_thick,
             unit_type = v_unit_type,
             unit_material = v_unit_material,
             super_design_ty = v_super_design_ty,
             rail_type = v_rail_type,
             pier_type = v_pier_type,
             pier_foot_type = v_pier_foot_type,
             num_spans_grp_9 = v_num_spans_grp_9,
             num_spans_grp_8 = v_num_spans_grp_8,
             num_spans_grp_7 = v_num_spans_grp_7,
             num_spans_grp_6 = v_num_spans_grp_6,
             num_spans_grp_5 = v_num_spans_grp_5,
             num_spans_grp_4 = v_num_spans_grp_4,
             num_spans_grp_3 = v_num_spans_grp_3,
             num_spans_grp_2 = v_num_spans_grp_2,
             num_spans_grp_10 = v_num_spans_grp_10,
             num_spans_grp_1 = v_num_spans_grp_1,
             num_girders = v_num_girders,
             len_span_grp_9 = v_len_span_grp_9,
             len_span_grp_8 = v_len_span_grp_8,
             len_span_grp_7 = v_len_span_grp_7,
             len_span_grp_6 = v_len_span_grp_6,
             len_span_grp_5 = v_len_span_grp_5,
             len_span_grp_4 = v_len_span_grp_4,
             len_span_grp_3 = v_len_span_grp_3,
             len_span_grp_2 = v_len_span_grp_2,
             len_span_grp_10 = v_len_span_grp_10,
             len_span_grp_1 = v_len_span_grp_1,
             length = v_length,
             hinge_type = v_hinge_type,
             expan_dev_near = v_expan_dev_near,
             expan_dev_far = v_expan_dev_far,
             dk_drain_sys = v_dk_drain_sys,
             dksurftype = v_dksurftype,
             dkprotect = v_dkprotect,
             dkmembtype = v_dkmembtype,
             deck_thick = v_deck_thick,
             deck_matrl = v_deck_matrl,
             deckseal = v_deckseal,
             bearing_type = v_bearing_type,
             abut_type_near = v_abut_type_near,
             abut_type_far = v_abut_type_far,
             abut_foot_near = v_abut_foot_near,
             abut_foot_far = v_abut_foot_far
       where pontis.userstrunit.brkey = ls_brkey and userstrunit.strunitkey = 1;

      select pontis.userrway.vclr_w,
             pontis.userrway.vclr_s,
             pontis.userrway.vclr_n,
             pontis.userrway.vclr_e,
             pontis.userrway.vclrinv_w,
             pontis.userrway.vclrinv_s,
             pontis.userrway.vclrinv_n,
             pontis.userrway.vclrinv_e,
             pontis.userrway.trans_lanes,
             pontis.userrway.route_unique_id,
             pontis.userrway.route_suffix,
             pontis.userrway.route_prefix,
             pontis.userrway.route_num,
             pontis.userrway.road_cross_name,
             pontis.userrway.maint_rte_suffix,
             pontis.userrway.maint_rte_prefix,
             pontis.userrway.maint_rte_num,
             pontis.userrway.maint_rte_id,
             pontis.userrway.hclr_w,
             pontis.userrway.hclr_s,
             pontis.userrway.hclr_n,
             pontis.userrway.hclr_e,
             pontis.userrway.hclrurt_w,
             pontis.userrway.hclrurt_s,
             pontis.userrway.hclrurt_n,
             pontis.userrway.hclrurt_e,
             pontis.userrway.hclrult_w,
             pontis.userrway.hclrult_s,
             pontis.userrway.hclrult_n,
             pontis.userrway.hclrult_e,
             pontis.userrway.feat_desc_type,
             pontis.userrway.feat_cross_type,
             pontis.userrway.clr_route,
             pontis.userrway.chan_prot_right,
             pontis.userrway.chan_prot_left,
             pontis.userrway.berm_prot,
             pontis.userrway.aroadwidth_near,
             pontis.userrway.aroadwidth_far
        into v_vclr_w,
             v_vclr_s,
             v_vclr_n,
             v_vclr_e,
             v_vclrinv_w,
             v_vclrinv_s,
             v_vclrinv_n,
             v_vclrinv_e,
             v_trans_lanes,
             v_route_unique_id,
             v_route_suffix,
             v_route_prefix,
             v_route_num,
             v_road_cross_name,
             v_maint_rte_suffix,
             v_maint_rte_prefix,
             v_maint_rte_num,
             v_maint_rte_id,
             v_hclr_w,
             v_hclr_s,
             v_hclr_n,
             v_hclr_e,
             v_hclrurt_w,
             v_hclrurt_s,
             v_hclrurt_n,
             v_hclrurt_e,
             v_hclrult_w,
             v_hclrult_s,
             v_hclrult_n,
             v_hclrult_e,
             v_feat_desc_type,
             v_feat_cross_type,
             v_clr_route,
             v_chan_prot_right,
             v_chan_prot_left,
             v_berm_prot,
             v_aroadwidth_near,
             v_aroadwidth_far
        from pontis.userrway
       where pontis.userrway.brkey = ls_brkey and userrway.on_under = '1';

      if v_vclr_w = 1
      then
         v_vclr_w := 2;
      else
         v_vclr_w := 1;
      end if;

      if v_vclr_s = 1
      then
         v_vclr_s := 2;
      else
         v_vclr_s := 1;
      end if;

      if v_vclr_n = 1
      then
         v_vclr_n := 2;
      else
         v_vclr_n := 1;
      end if;

      if v_vclr_e = 1
      then
         v_vclr_e := 2;
      else
         v_vclr_e := 1;
      end if;

      if v_vclrinv_w = 1
      then
         v_vclrinv_w := 2;
      else
         v_vclrinv_w := 1;
      end if;

      if v_vclrinv_s = 1
      then
         v_vclrinv_s := 2;
      else
         v_vclrinv_s := 1;
      end if;

      if v_vclrinv_n = 1
      then
         v_vclrinv_n := 2;
      else
         v_vclrinv_n := 1;
      end if;

      if v_vclrinv_e = 1
      then
         v_vclrinv_e := 2;
      else
         v_vclrinv_e := 1;
      end if;

      if v_trans_lanes = 1
      then
         v_trans_lanes := 2;
      else
         v_trans_lanes := 1;
      end if;

      if v_route_unique_id = 'A'
      then
         v_route_unique_id := 'B';
      else
         v_route_unique_id := 'A';
      end if;

      if v_route_suffix = 'A'
      then
         v_route_suffix := 'B';
      else
         v_route_suffix := 'A';
      end if;

      if v_route_prefix = 'A'
      then
         v_route_prefix := 'B';
      else
         v_route_prefix := 'A';
      end if;

      if v_route_num = 'A'
      then
         v_route_num := 'B';
      else
         v_route_num := 'A';
      end if;

      if v_road_cross_name = 'A'
      then
         v_road_cross_name := 'B';
      else
         v_road_cross_name := 'A';
      end if;

      if v_maint_rte_suffix = 'A'
      then
         v_maint_rte_suffix := 'B';
      else
         v_maint_rte_suffix := 'A';
      end if;

      if v_maint_rte_prefix = 'A'
      then
         v_maint_rte_prefix := 'B';
      else
         v_maint_rte_prefix := 'A';
      end if;

      if v_maint_rte_num = 'A'
      then
         v_maint_rte_num := 'B';
      else
         v_maint_rte_num := 'A';
      end if;

      if v_maint_rte_id = 'A'
      then
         v_maint_rte_id := 'B';
      else
         v_maint_rte_id := 'A';
      end if;

      if v_hclr_w = 1
      then
         v_hclr_w := 2;
      else
         v_hclr_w := 1;
      end if;

      if v_hclr_s = 1
      then
         v_hclr_s := 2;
      else
         v_hclr_s := 1;
      end if;

      if v_hclr_n = 1
      then
         v_hclr_n := 2;
      else
         v_hclr_n := 1;
      end if;

      if v_hclr_e = 1
      then
         v_hclr_e := 2;
      else
         v_hclr_e := 1;
      end if;

      if v_hclrurt_w = 1
      then
         v_hclrurt_w := 2;
      else
         v_hclrurt_w := 1;
      end if;

      if v_hclrurt_s = 1
      then
         v_hclrurt_s := 2;
      else
         v_hclrurt_s := 1;
      end if;

      if v_hclrurt_n = 1
      then
         v_hclrurt_n := 2;
      else
         v_hclrurt_n := 1;
      end if;

      if v_hclrurt_e = 1
      then
         v_hclrurt_e := 2;
      else
         v_hclrurt_e := 1;
      end if;

      if v_hclrult_w = 1
      then
         v_hclrult_w := 2;
      else
         v_hclrult_w := 1;
      end if;

      if v_hclrult_s = 1
      then
         v_hclrult_s := 2;
      else
         v_hclrult_s := 1;
      end if;

      if v_hclrult_n = 1
      then
         v_hclrult_n := 2;
      else
         v_hclrult_n := 1;
      end if;

      if v_hclrult_e = 1
      then
         v_hclrult_e := 2;
      else
         v_hclrult_e := 1;
      end if;

      if v_feat_desc_type = 'A'
      then
         v_feat_desc_type := 'B';
      else
         v_feat_desc_type := 'A';
      end if;

      if v_feat_cross_type = 'A'
      then
         v_feat_cross_type := 'B';
      else
         v_feat_cross_type := 'A';
      end if;

      if v_clr_route = 'A'
      then
         v_clr_route := 'B';
      else
         v_clr_route := 'A';
      end if;

      if v_chan_prot_right = 'A'
      then
         v_chan_prot_right := 'B';
      else
         v_chan_prot_right := 'A';
      end if;

      if v_chan_prot_left = 'A'
      then
         v_chan_prot_left := 'B';
      else
         v_chan_prot_left := 'A';
      end if;

      if v_berm_prot = 'A'
      then
         v_berm_prot := 'B';
      else
         v_berm_prot := 'A';
      end if;

      if v_aroadwidth_near = 1
      then
         v_aroadwidth_near := 2;
      else
         v_aroadwidth_near := 1;
      end if;

      if v_aroadwidth_far = 1
      then
         v_aroadwidth_far := 2;
      else
         v_aroadwidth_far := 1;
      end if;

      update pontis.userrway
         set vclr_w = v_vclr_w,
             vclr_s = v_vclr_s,
             vclr_n = v_vclr_n,
             vclr_e = v_vclr_e,
             vclrinv_w = v_vclrinv_w,
             vclrinv_s = v_vclrinv_s,
             vclrinv_n = v_vclrinv_n,
             vclrinv_e = v_vclrinv_e,
             trans_lanes = v_trans_lanes,
             route_unique_id = v_route_unique_id,
             route_suffix = v_route_suffix,
             route_prefix = v_route_prefix,
             route_num = v_route_num,
             road_cross_name = v_road_cross_name,
             maint_rte_suffix = v_maint_rte_suffix,
             maint_rte_prefix = v_maint_rte_prefix,
             maint_rte_num = v_maint_rte_num,
             maint_rte_id = v_maint_rte_id,
             hclr_w = v_hclr_w,
             hclr_s = v_hclr_s,
             hclr_n = v_hclr_n,
             hclr_e = v_hclr_e,
             hclrurt_w = v_hclrurt_w,
             hclrurt_s = v_hclrurt_s,
             hclrurt_n = v_hclrurt_n,
             hclrurt_e = v_hclrurt_e,
             hclrult_w = v_hclrult_w,
             hclrult_s = v_hclrult_s,
             hclrult_n = v_hclrult_n,
             hclrult_e = v_hclrult_e,
             feat_desc_type = v_feat_desc_type,
             feat_cross_type = v_feat_cross_type,
             clr_route = v_clr_route,
             chan_prot_right = v_chan_prot_right,
             chan_prot_left = v_chan_prot_left,
             berm_prot = v_berm_prot,
             aroadwidth_near = v_aroadwidth_near,
             aroadwidth_far = v_aroadwidth_far
       where pontis.userrway.brkey = ls_brkey and userrway.on_under = '1';

      select pontis.userrway.vclr_w,
             pontis.userrway.vclr_s,
             pontis.userrway.vclr_n,
             pontis.userrway.vclr_e,
             pontis.userrway.vclrinv_w,
             pontis.userrway.vclrinv_s,
             pontis.userrway.vclrinv_n,
             pontis.userrway.vclrinv_e,
             pontis.userrway.trans_lanes,
             pontis.userrway.route_unique_id,
             pontis.userrway.route_suffix,
             pontis.userrway.route_prefix,
             pontis.userrway.route_num,
             pontis.userrway.road_cross_name,
             pontis.userrway.maint_rte_suffix,
             pontis.userrway.maint_rte_prefix,
             pontis.userrway.maint_rte_num,
             pontis.userrway.maint_rte_id,
             pontis.userrway.hclr_w,
             pontis.userrway.hclr_s,
             pontis.userrway.hclr_n,
             pontis.userrway.hclr_e,
             pontis.userrway.hclrurt_w,
             pontis.userrway.hclrurt_s,
             pontis.userrway.hclrurt_n,
             pontis.userrway.hclrurt_e,
             pontis.userrway.hclrult_w,
             pontis.userrway.hclrult_s,
             pontis.userrway.hclrult_n,
             pontis.userrway.hclrult_e,
             pontis.userrway.feat_desc_type,
             pontis.userrway.feat_cross_type,
             pontis.userrway.clr_route,
             pontis.userrway.chan_prot_right,
             pontis.userrway.chan_prot_left,
             pontis.userrway.berm_prot,
             pontis.userrway.aroadwidth_near,
             pontis.userrway.aroadwidth_far
        into v_vclr_w,
             v_vclr_s,
             v_vclr_n,
             v_vclr_e,
             v_vclrinv_w,
             v_vclrinv_s,
             v_vclrinv_n,
             v_vclrinv_e,
             v_trans_lanes,
             v_route_unique_id,
             v_route_suffix,
             v_route_prefix,
             v_route_num,
             v_road_cross_name,
             v_maint_rte_suffix,
             v_maint_rte_prefix,
             v_maint_rte_num,
             v_maint_rte_id,
             v_hclr_w,
             v_hclr_s,
             v_hclr_n,
             v_hclr_e,
             v_hclrurt_w,
             v_hclrurt_s,
             v_hclrurt_n,
             v_hclrurt_e,
             v_hclrult_w,
             v_hclrult_s,
             v_hclrult_n,
             v_hclrult_e,
             v_feat_desc_type,
             v_feat_cross_type,
             v_clr_route,
             v_chan_prot_right,
             v_chan_prot_left,
             v_berm_prot,
             v_aroadwidth_near,
             v_aroadwidth_far
        from pontis.userrway
       where pontis.userrway.brkey = ls_brkey and userrway.on_under = '2';

      if v_vclr_w = 1
      then
         v_vclr_w := 2;
      else
         v_vclr_w := 1;
      end if;

      if v_vclr_s = 1
      then
         v_vclr_s := 2;
      else
         v_vclr_s := 1;
      end if;

      if v_vclr_n = 1
      then
         v_vclr_n := 2;
      else
         v_vclr_n := 1;
      end if;

      if v_vclr_e = 1
      then
         v_vclr_e := 2;
      else
         v_vclr_e := 1;
      end if;

      if v_vclrinv_w = 1
      then
         v_vclrinv_w := 2;
      else
         v_vclrinv_w := 1;
      end if;

      if v_vclrinv_s = 1
      then
         v_vclrinv_s := 2;
      else
         v_vclrinv_s := 1;
      end if;

      if v_vclrinv_n = 1
      then
         v_vclrinv_n := 2;
      else
         v_vclrinv_n := 1;
      end if;

      if v_vclrinv_e = 1
      then
         v_vclrinv_e := 2;
      else
         v_vclrinv_e := 1;
      end if;

      if v_trans_lanes = 1
      then
         v_trans_lanes := 2;
      else
         v_trans_lanes := 1;
      end if;

      if v_route_unique_id = 'A'
      then
         v_route_unique_id := 'B';
      else
         v_route_unique_id := 'A';
      end if;

      if v_route_suffix = 'A'
      then
         v_route_suffix := 'B';
      else
         v_route_suffix := 'A';
      end if;

      if v_route_prefix = 'A'
      then
         v_route_prefix := 'B';
      else
         v_route_prefix := 'A';
      end if;

      if v_route_num = 'A'
      then
         v_route_num := 'B';
      else
         v_route_num := 'A';
      end if;

      if v_road_cross_name = 'A'
      then
         v_road_cross_name := 'B';
      else
         v_road_cross_name := 'A';
      end if;

      if v_maint_rte_suffix = 'A'
      then
         v_maint_rte_suffix := 'B';
      else
         v_maint_rte_suffix := 'A';
      end if;

      if v_maint_rte_prefix = 'A'
      then
         v_maint_rte_prefix := 'B';
      else
         v_maint_rte_prefix := 'A';
      end if;

      if v_maint_rte_num = 'A'
      then
         v_maint_rte_num := 'B';
      else
         v_maint_rte_num := 'A';
      end if;

      if v_maint_rte_id = 'A'
      then
         v_maint_rte_id := 'B';
      else
         v_maint_rte_id := 'A';
      end if;

      if v_hclr_w = 1
      then
         v_hclr_w := 2;
      else
         v_hclr_w := 1;
      end if;

      if v_hclr_s = 1
      then
         v_hclr_s := 2;
      else
         v_hclr_s := 1;
      end if;

      if v_hclr_n = 1
      then
         v_hclr_n := 2;
      else
         v_hclr_n := 1;
      end if;

      if v_hclr_e = 1
      then
         v_hclr_e := 2;
      else
         v_hclr_e := 1;
      end if;

      if v_hclrurt_w = 1
      then
         v_hclrurt_w := 2;
      else
         v_hclrurt_w := 1;
      end if;

      if v_hclrurt_s = 1
      then
         v_hclrurt_s := 2;
      else
         v_hclrurt_s := 1;
      end if;

      if v_hclrurt_n = 1
      then
         v_hclrurt_n := 2;
      else
         v_hclrurt_n := 1;
      end if;

      if v_hclrurt_e = 1
      then
         v_hclrurt_e := 2;
      else
         v_hclrurt_e := 1;
      end if;

      if v_hclrult_w = 1
      then
         v_hclrult_w := 2;
      else
         v_hclrult_w := 1;
      end if;

      if v_hclrult_s = 1
      then
         v_hclrult_s := 2;
      else
         v_hclrult_s := 1;
      end if;

      if v_hclrult_n = 1
      then
         v_hclrult_n := 2;
      else
         v_hclrult_n := 1;
      end if;

      if v_hclrult_e = 1
      then
         v_hclrult_e := 2;
      else
         v_hclrult_e := 1;
      end if;

      if v_feat_desc_type = 'A'
      then
         v_feat_desc_type := 'B';
      else
         v_feat_desc_type := 'A';
      end if;

      if v_feat_cross_type = 'A'
      then
         v_feat_cross_type := 'B';
      else
         v_feat_cross_type := 'A';
      end if;

      if v_clr_route = 'A'
      then
         v_clr_route := 'B';
      else
         v_clr_route := 'A';
      end if;

      if v_chan_prot_right = 'A'
      then
         v_chan_prot_right := 'B';
      else
         v_chan_prot_right := 'A';
      end if;

      if v_chan_prot_left = 'A'
      then
         v_chan_prot_left := 'B';
      else
         v_chan_prot_left := 'A';
      end if;

      if v_berm_prot = 'A'
      then
         v_berm_prot := 'B';
      else
         v_berm_prot := 'A';
      end if;

      if v_aroadwidth_near = 1
      then
         v_aroadwidth_near := 2;
      else
         v_aroadwidth_near := 1;
      end if;

      if v_aroadwidth_far = 1
      then
         v_aroadwidth_far := 2;
      else
         v_aroadwidth_far := 1;
      end if;

      update pontis.userrway
         set vclr_w = v_vclr_w,
             vclr_s = v_vclr_s,
             vclr_n = v_vclr_n,
             vclr_e = v_vclr_e,
             vclrinv_w = v_vclrinv_w,
             vclrinv_s = v_vclrinv_s,
             vclrinv_n = v_vclrinv_n,
             vclrinv_e = v_vclrinv_e,
             trans_lanes = v_trans_lanes,
             route_unique_id = v_route_unique_id,
             route_suffix = v_route_suffix,
             route_prefix = v_route_prefix,
             route_num = v_route_num,
             road_cross_name = v_road_cross_name,
             maint_rte_suffix = v_maint_rte_suffix,
             maint_rte_prefix = v_maint_rte_prefix,
             maint_rte_num = v_maint_rte_num,
             maint_rte_id = v_maint_rte_id,
             hclr_w = v_hclr_w,
             hclr_s = v_hclr_s,
             hclr_n = v_hclr_n,
             hclr_e = v_hclr_e,
             hclrurt_w = v_hclrurt_w,
             hclrurt_s = v_hclrurt_s,
             hclrurt_n = v_hclrurt_n,
             hclrurt_e = v_hclrurt_e,
             hclrult_w = v_hclrult_w,
             hclrult_s = v_hclrult_s,
             hclrult_n = v_hclrult_n,
             hclrult_e = v_hclrult_e,
             feat_desc_type = v_feat_desc_type,
             feat_cross_type = v_feat_cross_type,
             clr_route = v_clr_route,
             chan_prot_right = v_chan_prot_right,
             chan_prot_left = v_chan_prot_left,
             berm_prot = v_berm_prot,
             aroadwidth_near = v_aroadwidth_near,
             aroadwidth_far = v_aroadwidth_far
       where pontis.userrway.brkey = ls_brkey and userrway.on_under = '2';

      select pontis.userinsp.uwinspfreq_kdot,
             pontis.userinsp.uwater_insp_typ,
             pontis.userinsp.paint_cond,
             pontis.userinsp.osinspfreq_kdot,
             pontis.userinsp.oppostcl_kdot,
             pontis.userinsp.fcinspfreq_kdot,
             pontis.userinsp.cond_index,
             pontis.userinsp.brinspfreq_kdot
        into v_uwinspfreq_kdot,
             v_uwater_insp_typ,
             v_paint_cond,
             v_osinspfreq_kdot,
             v_oppostcl_kdot,
             v_fcinspfreq_kdot,
             v_cond_index,
             v_brinspfreq_kdot
        from pontis.userinsp
       where pontis.userinsp.brkey = ls_brkey and userinsp.inspkey = ls_inspkey;

      if v_uwinspfreq_kdot = 1
      then
         v_uwinspfreq_kdot := 2;
      else
         v_uwinspfreq_kdot := 1;
      end if;

      if v_uwater_insp_typ = 'A'
      then
         v_uwater_insp_typ := 'B';
      else
         v_uwater_insp_typ := 'A';
      end if;

      if v_paint_cond = 'A'
      then
         v_paint_cond := 'B';
      else
         v_paint_cond := 'A';
      end if;

      if v_osinspfreq_kdot = 1
      then
         v_osinspfreq_kdot := 2;
      else
         v_osinspfreq_kdot := 1;
      end if;

      if v_oppostcl_kdot = 'A'
      then
         v_oppostcl_kdot := 'B';
      else
         v_oppostcl_kdot := 'A';
      end if;

      if v_fcinspfreq_kdot = 1
      then
         v_fcinspfreq_kdot := 2;
      else
         v_fcinspfreq_kdot := 1;
      end if;

      if v_cond_index = 1
      then
         v_cond_index := 2;
      else
         v_cond_index := 1;
      end if;

      if v_brinspfreq_kdot = 1
      then
         v_brinspfreq_kdot := 2;
      else
         v_brinspfreq_kdot := 1;
      end if;

      update pontis.userinsp
         set uwinspfreq_kdot = v_uwinspfreq_kdot,
             uwater_insp_typ = v_uwater_insp_typ,
             paint_cond = v_paint_cond,
             osinspfreq_kdot = v_osinspfreq_kdot,
             oppostcl_kdot = v_oppostcl_kdot,
             fcinspfreq_kdot = v_fcinspfreq_kdot,
             cond_index = v_cond_index,
             brinspfreq_kdot = v_brinspfreq_kdot
       where pontis.userinsp.brkey = ls_brkey and userinsp.inspkey = ls_inspkey;

      select pontis.userbrdg.vert_undr_sign,
             pontis.userbrdg.vert_clr_sign,
             pontis.userbrdg.suprstruct_tos,
             pontis.userbrdg.super_paint_sys,
             pontis.userbrdg.stream_sign,
             pontis.userbrdg.skew_minutes,
             pontis.userbrdg.skew_direction,
             pontis.userbrdg.sign_type_q4,
             pontis.userbrdg.sign_type_q3,
             pontis.userbrdg.sign_type_q2,
             pontis.userbrdg.sign_type_q1,
             pontis.userbrdg.rot_direction,
             pontis.userbrdg.rot_angle_min,
             pontis.userbrdg.rot_angle_deg,
             pontis.userbrdg.road_type_sign,
             pontis.userbrdg.restrict_load,
             pontis.userbrdg.rating_comment,
             pontis.userbrdg.rating_adj,
             pontis.userbrdg.posted_sign_type,
             pontis.userbrdg.posted_load_c,
             pontis.userbrdg.posted_load_b,
             pontis.userbrdg.posted_load_a,
             pontis.userbrdg.owner_kdot,
             pontis.userbrdg.orload_wsd_t170,
             pontis.userbrdg.orload_wsd_t130,
             pontis.userbrdg.orload_wsd_hs,
             pontis.userbrdg.orload_wsd_h,
             pontis.userbrdg.orload_wsd_3_3,
             pontis.userbrdg.orload_wsd_3s2,
             pontis.userbrdg.orload_wsd_3,
             pontis.userbrdg.orload_lfd_t130,
             pontis.userbrdg.orload_lfd_hs,
             pontis.userbrdg.orload_lfd_h,
             pontis.userbrdg.orload_lfd_3_3,
             pontis.userbrdg.orload_lfd_3s2,
             pontis.userbrdg.orload_lfd_3,
             pontis.userbrdg.orload_lfd_t170,
             pontis.userbrdg.orload_adj_t170,
             pontis.userbrdg.orload_adj_t130,
             pontis.userbrdg.orload_adj_h,
             pontis.userbrdg.orload_adj_3_3,
             pontis.userbrdg.orload_adj_3s2,
             pontis.userbrdg.orload_adj_3,
             pontis.userbrdg.orientation,
             pontis.userbrdg.median_width,
             pontis.userbrdg.maint_area,
             pontis.userbrdg.irload_wsd_t170,
             pontis.userbrdg.irload_wsd_t130,
             pontis.userbrdg.irload_wsd_hs,
             pontis.userbrdg.irload_wsd_h,
             pontis.userbrdg.irload_wsd_3_3,
             pontis.userbrdg.irload_wsd_3s2,
             pontis.userbrdg.irload_wsd_3,
             pontis.userbrdg.irload_lfd_t170,
             pontis.userbrdg.irload_lfd_t130,
             pontis.userbrdg.irload_lfd_hs,
             pontis.userbrdg.irload_lfd_h,
             pontis.userbrdg.irload_lfd_3_3,
             pontis.userbrdg.irload_lfd_3s2,
             pontis.userbrdg.irload_lfd_3,
             pontis.userbrdg.irload_adj_t170,
             pontis.userbrdg.irload_adj_t130,
             pontis.userbrdg.irload_adj_h,
             pontis.userbrdg.irload_adj_3_3,
             pontis.userbrdg.irload_adj_3s2,
             pontis.userbrdg.irload_adj_3,
             pontis.userbrdg.function_type,
             pontis.userbrdg.design_ref_post,
             pontis.userbrdg.designload_type,
             pontis.userbrdg.designload_kdot,
             pontis.userbrdg.custodian_kdot,
             pontis.userbrdg.culv_wing_type,
             pontis.userbrdg.culv_fill_depth,
             pontis.userbrdg.bridgemed_kdot,
             pontis.userbrdg.box_height_culv,
             pontis.userbrdg.attach_type_3,
             pontis.userbrdg.attach_type_2,
             pontis.userbrdg.attach_type_1,
             pontis.userbrdg.attach_desc_3,
             pontis.userbrdg.attach_desc_2,
             pontis.userbrdg.attach_desc_1
        into v_vert_undr_sign,
             v_vert_clr_sign,
             v_suprstruct_tos,
             v_super_paint_sys,
             v_stream_sign,
             v_skew_minutes,
             v_skew_direction,
             v_sign_type_q4,
             v_sign_type_q3,
             v_sign_type_q2,
             v_sign_type_q1,
             v_rot_direction,
             v_rot_angle_min,
             v_rot_angle_deg,
             v_road_type_sign,
             v_restrict_load,
             v_rating_comment,
             v_rating_adj,
             v_posted_sign_type,
             v_posted_load_c,
             v_posted_load_b,
             v_posted_load_a,
             v_owner_kdot,
             v_orload_wsd_t170,
             v_orload_wsd_t130,
             v_orload_wsd_hs,
             v_orload_wsd_h,
             v_orload_wsd_3_3,
             v_orload_wsd_3s2,
             v_orload_wsd_3,
             v_orload_lfd_t130,
             v_orload_lfd_hs,
             v_orload_lfd_h,
             v_orload_lfd_3_3,
             v_orload_lfd_3s2,
             v_orload_lfd_3,
             v_orload_lfd_t170,
             v_orload_adj_t170,
             v_orload_adj_t130,
             v_orload_adj_h,
             v_orload_adj_3_3,
             v_orload_adj_3s2,
             v_orload_adj_3,
             v_orientation,
             v_median_width,
             v_maint_area,
             v_irload_wsd_t170,
             v_irload_wsd_t130,
             v_irload_wsd_hs,
             v_irload_wsd_h,
             v_irload_wsd_3_3,
             v_irload_wsd_3s2,
             v_irload_wsd_3,
             v_irload_lfd_t170,
             v_irload_lfd_t130,
             v_irload_lfd_hs,
             v_irload_lfd_h,
             v_irload_lfd_3_3,
             v_irload_lfd_3s2,
             v_irload_lfd_3,
             v_irload_adj_t170,
             v_irload_adj_t130,
             v_irload_adj_h,
             v_irload_adj_3_3,
             v_irload_adj_3s2,
             v_irload_adj_3,
             v_function_type,
             v_design_ref_post,
             v_designload_type,
             v_designload_kdot,
             v_custodian_kdot,
             v_culv_wing_type,
             v_culv_fill_depth,
             v_bridgemed_kdot,
             v_box_height_culv,
             v_attach_type_3,
             v_attach_type_2,
             v_attach_type_1,
             v_attach_desc_3,
             v_attach_desc_2,
             v_attach_desc_1
        from pontis.userbrdg
       where pontis.userbrdg.brkey = ls_brkey;

      if v_vert_undr_sign = 'A'
      then
         v_vert_undr_sign := 'B';
      else
         v_vert_undr_sign := 'A';
      end if;

      if v_vert_clr_sign = 'A'
      then
         v_vert_clr_sign := 'B';
      else
         v_vert_clr_sign := 'A';
      end if;

      if v_suprstruct_tos = 1
      then
         v_suprstruct_tos := 2;
      else
         v_suprstruct_tos := 1;
      end if;

      if v_super_paint_sys = 'A'
      then
         v_super_paint_sys := 'B';
      else
         v_super_paint_sys := 'A';
      end if;

      if v_stream_sign = 'A'
      then
         v_stream_sign := 'B';
      else
         v_stream_sign := 'A';
      end if;

      if v_skew_minutes = 1
      then
         v_skew_minutes := 2;
      else
         v_skew_minutes := 1;
      end if;

      if v_skew_direction = 'A'
      then
         v_skew_direction := 'B';
      else
         v_skew_direction := 'A';
      end if;

      if v_sign_type_q4 = 'A'
      then
         v_sign_type_q4 := 'B';
      else
         v_sign_type_q4 := 'A';
      end if;

      if v_sign_type_q3 = 'A'
      then
         v_sign_type_q3 := 'B';
      else
         v_sign_type_q3 := 'A';
      end if;

      if v_sign_type_q2 = 'A'
      then
         v_sign_type_q2 := 'B';
      else
         v_sign_type_q2 := 'A';
      end if;

      if v_sign_type_q1 = 'A'
      then
         v_sign_type_q1 := 'B';
      else
         v_sign_type_q1 := 'A';
      end if;

      if v_rot_direction = 'A'
      then
         v_rot_direction := 'B';
      else
         v_rot_direction := 'A';
      end if;

      if v_rot_angle_min = 1
      then
         v_rot_angle_min := 2;
      else
         v_rot_angle_min := 1;
      end if;

      if v_rot_angle_deg = 1
      then
         v_rot_angle_deg := 2;
      else
         v_rot_angle_deg := 1;
      end if;

      if v_road_type_sign = 'A'
      then
         v_road_type_sign := 'B';
      else
         v_road_type_sign := 'A';
      end if;

      if v_restrict_load = 1
      then
         v_restrict_load := 2;
      else
         v_restrict_load := 1;
      end if;

      if v_rating_comment = 'A'
      then
         v_rating_comment := 'B';
      else
         v_rating_comment := 'A';
      end if;

      if v_rating_adj = 'A'
      then
         v_rating_adj := 'B';
      else
         v_rating_adj := 'A';
      end if;

      if v_posted_sign_type = 'A'
      then
         v_posted_sign_type := 'B';
      else
         v_posted_sign_type := 'A';
      end if;

      if v_posted_load_c = 'A'
      then
         v_posted_load_c := 'B';
      else
         v_posted_load_c := 'A';
      end if;

      if v_posted_load_b = 'A'
      then
         v_posted_load_b := 'B';
      else
         v_posted_load_b := 'A';
      end if;

      if v_posted_load_a = 'A'
      then
         v_posted_load_a := 'B';
      else
         v_posted_load_a := 'A';
      end if;

      if v_owner_kdot = 'A'
      then
         v_owner_kdot := 'B';
      else
         v_owner_kdot := 'A';
      end if;

      if v_orload_wsd_t170 = 1
      then
         v_orload_wsd_t170 := 2;
      else
         v_orload_wsd_t170 := 1;
      end if;

      if v_orload_wsd_t130 = 1
      then
         v_orload_wsd_t130 := 2;
      else
         v_orload_wsd_t130 := 1;
      end if;

      if v_orload_wsd_hs = 1
      then
         v_orload_wsd_hs := 2;
      else
         v_orload_wsd_hs := 1;
      end if;

      if v_orload_wsd_h = 1
      then
         v_orload_wsd_h := 2;
      else
         v_orload_wsd_h := 1;
      end if;

      if v_orload_wsd_3_3 = 1
      then
         v_orload_wsd_3_3 := 2;
      else
         v_orload_wsd_3_3 := 1;
      end if;

      if v_orload_wsd_3s2 = 1
      then
         v_orload_wsd_3s2 := 2;
      else
         v_orload_wsd_3s2 := 1;
      end if;

      if v_orload_wsd_3 = 1
      then
         v_orload_wsd_3 := 2;
      else
         v_orload_wsd_3 := 1;
      end if;

      if v_orload_lfd_t130 = 1
      then
         v_orload_lfd_t130 := 2;
      else
         v_orload_lfd_t130 := 1;
      end if;

      if v_orload_lfd_hs = 1
      then
         v_orload_lfd_hs := 2;
      else
         v_orload_lfd_hs := 1;
      end if;

      if v_orload_lfd_h = 1
      then
         v_orload_lfd_h := 2;
      else
         v_orload_lfd_h := 1;
      end if;

      if v_orload_lfd_3_3 = 1
      then
         v_orload_lfd_3_3 := 2;
      else
         v_orload_lfd_3_3 := 1;
      end if;

      if v_orload_lfd_3s2 = 1
      then
         v_orload_lfd_3s2 := 2;
      else
         v_orload_lfd_3s2 := 1;
      end if;

      if v_orload_lfd_3 = 1
      then
         v_orload_lfd_3 := 2;
      else
         v_orload_lfd_3 := 1;
      end if;

      if v_orload_lfd_t170 = 1
      then
         v_orload_lfd_t170 := 2;
      else
         v_orload_lfd_t170 := 1;
      end if;

      if v_orload_adj_t170 = 1
      then
         v_orload_adj_t170 := 2;
      else
         v_orload_adj_t170 := 1;
      end if;

      if v_orload_adj_t130 = 1
      then
         v_orload_adj_t130 := 2;
      else
         v_orload_adj_t130 := 1;
      end if;

      if v_orload_adj_h = 1
      then
         v_orload_adj_h := 2;
      else
         v_orload_adj_h := 1;
      end if;

      if v_orload_adj_3_3 = 1
      then
         v_orload_adj_3_3 := 2;
      else
         v_orload_adj_3_3 := 1;
      end if;

      if v_orload_adj_3s2 = 1
      then
         v_orload_adj_3s2 := 2;
      else
         v_orload_adj_3s2 := 1;
      end if;

      if v_orload_adj_3 = 1
      then
         v_orload_adj_3 := 2;
      else
         v_orload_adj_3 := 1;
      end if;

      if v_orientation = 'A'
      then
         v_orientation := 'B';
      else
         v_orientation := 'A';
      end if;

      if v_median_width = 1
      then
         v_median_width := 2;
      else
         v_median_width := 1;
      end if;

      if v_maint_area = 'A'
      then
         v_maint_area := 'B';
      else
         v_maint_area := 'A';
      end if;

      if v_irload_wsd_t170 = 1
      then
         v_irload_wsd_t170 := 2;
      else
         v_irload_wsd_t170 := 1;
      end if;

      if v_irload_wsd_t130 = 1
      then
         v_irload_wsd_t130 := 2;
      else
         v_irload_wsd_t130 := 1;
      end if;

      if v_irload_wsd_hs = 1
      then
         v_irload_wsd_hs := 2;
      else
         v_irload_wsd_hs := 1;
      end if;

      if v_irload_wsd_h = 1
      then
         v_irload_wsd_h := 2;
      else
         v_irload_wsd_h := 1;
      end if;

      if v_irload_wsd_3_3 = 1
      then
         v_irload_wsd_3_3 := 2;
      else
         v_irload_wsd_3_3 := 1;
      end if;

      if v_irload_wsd_3s2 = 1
      then
         v_irload_wsd_3s2 := 2;
      else
         v_irload_wsd_3s2 := 1;
      end if;

      if v_irload_wsd_3 = 1
      then
         v_irload_wsd_3 := 2;
      else
         v_irload_wsd_3 := 1;
      end if;

      if v_irload_lfd_t170 = 1
      then
         v_irload_lfd_t170 := 2;
      else
         v_irload_lfd_t170 := 1;
      end if;

      if v_irload_lfd_t130 = 1
      then
         v_irload_lfd_t130 := 2;
      else
         v_irload_lfd_t130 := 1;
      end if;

      if v_irload_lfd_hs = 1
      then
         v_irload_lfd_hs := 2;
      else
         v_irload_lfd_hs := 1;
      end if;

      if v_irload_lfd_h = 1
      then
         v_irload_lfd_h := 2;
      else
         v_irload_lfd_h := 1;
      end if;

      if v_irload_lfd_3_3 = 1
      then
         v_irload_lfd_3_3 := 2;
      else
         v_irload_lfd_3_3 := 1;
      end if;

      if v_irload_lfd_3s2 = 1
      then
         v_irload_lfd_3s2 := 2;
      else
         v_irload_lfd_3s2 := 1;
      end if;

      if v_irload_lfd_3 = 1
      then
         v_irload_lfd_3 := 2;
      else
         v_irload_lfd_3 := 1;
      end if;

      if v_irload_adj_t170 = 1
      then
         v_irload_adj_t170 := 2;
      else
         v_irload_adj_t170 := 1;
      end if;

      if v_irload_adj_t130 = 1
      then
         v_irload_adj_t130 := 2;
      else
         v_irload_adj_t130 := 1;
      end if;

      if v_irload_adj_h = 1
      then
         v_irload_adj_h := 2;
      else
         v_irload_adj_h := 1;
      end if;

      if v_irload_adj_3_3 = 1
      then
         v_irload_adj_3_3 := 2;
      else
         v_irload_adj_3_3 := 1;
      end if;

      if v_irload_adj_3s2 = 1
      then
         v_irload_adj_3s2 := 2;
      else
         v_irload_adj_3s2 := 1;
      end if;

      if v_irload_adj_3 = 1
      then
         v_irload_adj_3 := 2;
      else
         v_irload_adj_3 := 1;
      end if;

      if v_function_type = 'A'
      then
         v_function_type := 'B';
      else
         v_function_type := 'A';
      end if;

      if v_design_ref_post = 1
      then
         v_design_ref_post := 2;
      else
         v_design_ref_post := 1;
      end if;

      if v_designload_type = '1'
      then
         v_designload_type := '2';
      else
         v_designload_type := '1';
      end if;

      if v_designload_kdot = 1
      then
         v_designload_kdot := 2;
      else
         v_designload_kdot := 1;
      end if;

      if v_custodian_kdot = 'A'
      then
         v_custodian_kdot := 'B';
      else
         v_custodian_kdot := 'A';
      end if;

      if v_culv_wing_type = 'A'
      then
         v_culv_wing_type := 'B';
      else
         v_culv_wing_type := 'A';
      end if;

      if v_culv_fill_depth = 1
      then
         v_culv_fill_depth := 2;
      else
         v_culv_fill_depth := 1;
      end if;

      if v_bridgemed_kdot = '1'
      then
         v_bridgemed_kdot := '2';
      else
         v_bridgemed_kdot := '1';
      end if;

      if v_box_height_culv = 1
      then
         v_box_height_culv := 2;
      else
         v_box_height_culv := 1;
      end if;

      if v_attach_type_3 = 'A'
      then
         v_attach_type_3 := 'B';
      else
         v_attach_type_3 := 'A';
      end if;

      if v_attach_type_2 = 'A'
      then
         v_attach_type_2 := 'B';
      else
         v_attach_type_2 := 'A';
      end if;

      if v_attach_type_1 = 'A'
      then
         v_attach_type_1 := 'B';
      else
         v_attach_type_1 := 'A';
      end if;

      if v_attach_desc_3 = 'A'
      then
         v_attach_desc_3 := 'B';
      else
         v_attach_desc_3 := 'A';
      end if;

      if v_attach_desc_2 = 'A'
      then
         v_attach_desc_2 := 'B';
      else
         v_attach_desc_2 := 'A';
      end if;

      if v_attach_desc_1 = 'A'
      then
         v_attach_desc_1 := 'B';
      else
         v_attach_desc_1 := 'A';
      end if;

      update pontis.userbrdg
         set vert_undr_sign = v_vert_undr_sign,
             vert_clr_sign = v_vert_clr_sign,
             suprstruct_tos = v_suprstruct_tos,
             super_paint_sys = v_super_paint_sys,
             stream_sign = v_stream_sign,
             skew_minutes = v_skew_minutes,
             skew_direction = v_skew_direction,
             sign_type_q4 = v_sign_type_q4,
             sign_type_q3 = v_sign_type_q3,
             sign_type_q2 = v_sign_type_q2,
             sign_type_q1 = v_sign_type_q1,
             rot_direction = v_rot_direction,
             rot_angle_min = v_rot_angle_min,
             rot_angle_deg = v_rot_angle_deg,
             road_type_sign = v_road_type_sign,
             restrict_load = v_restrict_load,
             rating_comment = v_rating_comment,
             rating_adj = v_rating_adj,
             posted_sign_type = v_posted_sign_type,
             posted_load_c = v_posted_load_c,
             posted_load_b = v_posted_load_b,
             posted_load_a = v_posted_load_a,
             owner_kdot = v_owner_kdot,
             orload_wsd_t170 = v_orload_wsd_t170,
             orload_wsd_t130 = v_orload_wsd_t130,
             orload_wsd_hs = v_orload_wsd_hs,
             orload_wsd_h = v_orload_wsd_h,
             orload_wsd_3_3 = v_orload_wsd_3_3,
             orload_wsd_3s2 = v_orload_wsd_3s2,
             orload_wsd_3 = v_orload_wsd_3,
             orload_lfd_t130 = v_orload_lfd_t130,
             orload_lfd_hs = v_orload_lfd_hs,
             orload_lfd_h = v_orload_lfd_h,
             orload_lfd_3_3 = v_orload_lfd_3_3,
             orload_lfd_3s2 = v_orload_lfd_3s2,
             orload_lfd_3 = v_orload_lfd_3,
             orload_lfd_t170 = v_orload_lfd_t170,
             orload_adj_t170 = v_orload_adj_t170,
             orload_adj_t130 = v_orload_adj_t130,
             orload_adj_h = v_orload_adj_h,
             orload_adj_3_3 = v_orload_adj_3_3,
             orload_adj_3s2 = v_orload_adj_3s2,
             orload_adj_3 = v_orload_adj_3,
             orientation = v_orientation,
             median_width = v_median_width,
             maint_area = v_maint_area,
             irload_wsd_t170 = v_irload_wsd_t170,
             irload_wsd_t130 = v_irload_wsd_t130,
             irload_wsd_hs = v_irload_wsd_hs,
             irload_wsd_h = v_irload_wsd_h,
             irload_wsd_3_3 = v_irload_wsd_3_3,
             irload_wsd_3s2 = v_irload_wsd_3s2,
             irload_wsd_3 = v_irload_wsd_3,
             irload_lfd_t170 = v_irload_lfd_t170,
             irload_lfd_t130 = v_irload_lfd_t130,
             irload_lfd_hs = v_irload_lfd_hs,
             irload_lfd_h = v_irload_lfd_h,
             irload_lfd_3_3 = v_irload_lfd_3_3,
             irload_lfd_3s2 = v_irload_lfd_3s2,
             irload_lfd_3 = v_irload_lfd_3,
             irload_adj_t170 = v_irload_adj_t170,
             irload_adj_t130 = v_irload_adj_t130,
             irload_adj_h = v_irload_adj_h,
             irload_adj_3_3 = v_irload_adj_3_3,
             irload_adj_3s2 = v_irload_adj_3s2,
             irload_adj_3 = v_irload_adj_3,
             function_type = v_function_type,
             design_ref_post = v_design_ref_post,
             designload_type = v_designload_type,
             designload_kdot = v_designload_kdot,
             custodian_kdot = v_custodian_kdot,
             culv_wing_type = v_culv_wing_type,
             culv_fill_depth = v_culv_fill_depth,
             bridgemed_kdot = v_bridgemed_kdot,
             box_height_culv = v_box_height_culv,
             attach_type_3 = v_attach_type_3,
             attach_type_2 = v_attach_type_2,
             attach_type_1 = v_attach_type_1,
             attach_desc_3 = v_attach_desc_3,
             attach_desc_2 = v_attach_desc_2,
             attach_desc_1 = v_attach_desc_1
       where pontis.userbrdg.brkey = ls_brkey;

      select pontis.structure_unit.strunittype,
             pontis.structure_unit.strunitlabel
        into v_strunittype,
             v_strunitlabel
        from pontis.structure_unit
       where pontis.structure_unit.brkey = ls_brkey and structure_unit.strunitkey = 1;

      if v_strunittype = 'A'
      then
         v_strunittype := 'B';
      else
         v_strunittype := 'A';
      end if;

      if v_strunitlabel = 'A'
      then
         v_strunitlabel := 'B';
      else
         v_strunitlabel := 'A';
      end if;

      update pontis.structure_unit
         set strunittype = v_strunittype,
             strunitlabel = v_strunitlabel
       where pontis.structure_unit.brkey = ls_brkey and structure_unit.strunitkey = 1;

      select pontis.roadway.roadwidth,
             pontis.roadway.roadway_name,
             pontis.roadway.crit_feat
        into v_roadwidth,
             v_roadway_name,
             v_crit_feat
        from pontis.roadway
       where pontis.roadway.brkey = ls_brkey and roadway.on_under = '1';

      if v_roadwidth = 1
      then
         v_roadwidth := 2;
      else
         v_roadwidth := 1;
      end if;

      if v_roadway_name = 'A'
      then
         v_roadway_name := 'B';
      else
         v_roadway_name := 'A';
      end if;

      if v_crit_feat = 'A'
      then
         v_crit_feat := 'B';
      else
         v_crit_feat := 'A';
      end if;

      update pontis.roadway
         set roadwidth = v_roadwidth,
             roadway_name = v_roadway_name,
             crit_feat = v_crit_feat
       where pontis.roadway.brkey = ls_brkey and roadway.on_under = '1';

      select pontis.roadway.roadwidth,
             pontis.roadway.roadway_name,
             pontis.roadway.crit_feat
        into v_roadwidth,
             v_roadway_name,
             v_crit_feat
        from pontis.roadway
       where pontis.roadway.brkey = ls_brkey and roadway.on_under = '2';

      if v_roadwidth = 1
      then
         v_roadwidth := 2;
      else
         v_roadwidth := 1;
      end if;

      if v_roadway_name = 'A'
      then
         v_roadway_name := 'B';
      else
         v_roadway_name := 'A';
      end if;

      if v_crit_feat = 'A'
      then
         v_crit_feat := 'B';
      else
         v_crit_feat := 'A';
      end if;

      update pontis.roadway
         set roadwidth = v_roadwidth,
             roadway_name = v_roadway_name,
             crit_feat = v_crit_feat
       where pontis.roadway.brkey = ls_brkey and roadway.on_under = '2';

      select pontis.inspevnt.wateradeq,
             pontis.inspevnt.uwlastinsp,
             pontis.inspevnt.underclr,
             pontis.inspevnt.transratin,
             pontis.inspevnt.suprating,
             pontis.inspevnt.subrating,
             pontis.inspevnt.strrating,
             pontis.inspevnt.scourcrit,
             pontis.inspevnt.railrating,
             pontis.inspevnt.oslastinsp,
             pontis.inspevnt.inspdate,
             pontis.inspevnt.fclastinsp,
             pontis.inspevnt.dkrating,
             pontis.inspevnt.deckgeom,
             pontis.inspevnt.culvrating,
             pontis.inspevnt.chanrating,
             pontis.inspevnt.arailratin,
             pontis.inspevnt.appralign,
             pontis.inspevnt.aendrating
        into v_wateradeq,
             v_uwlastinsp,
             v_underclr,
             v_transratin,
             v_suprating,
             v_subrating,
             v_strrating,
             v_scourcrit,
             v_railrating,
             v_oslastinsp,
             v_inspdate,
             v_fclastinsp,
             v_dkrating,
             v_deckgeom,
             v_culvrating,
             v_chanrating,
             v_arailratin,
             v_appralign,
             v_aendrating
        from pontis.inspevnt
       where pontis.inspevnt.brkey = ls_brkey and inspevnt.inspkey = ls_inspkey;

      if v_wateradeq = 'A'
      then
         v_wateradeq := 'B';
      else
         v_wateradeq := 'A';
      end if;

      v_uwlastinsp :=   v_uwlastinsp
                      + 1;

      if v_underclr = 'A'
      then
         v_underclr := 'B';
      else
         v_underclr := 'A';
      end if;

      if v_transratin = 'A'
      then
         v_transratin := 'B';
      else
         v_transratin := 'A';
      end if;

      if v_suprating = 'A'
      then
         v_suprating := 'B';
      else
         v_suprating := 'A';
      end if;

      if v_subrating = 'A'
      then
         v_subrating := 'B';
      else
         v_subrating := 'A';
      end if;

      if v_strrating = 'A'
      then
         v_strrating := 'B';
      else
         v_strrating := 'A';
      end if;

      if v_scourcrit = 'A'
      then
         v_scourcrit := 'B';
      else
         v_scourcrit := 'A';
      end if;

      if v_railrating = 'A'
      then
         v_railrating := 'B';
      else
         v_railrating := 'A';
      end if;

      v_oslastinsp :=   v_oslastinsp
                      + 1;
      v_inspdate :=   v_inspdate
                    + 1;
      v_fclastinsp :=   v_fclastinsp
                      + 1;

      if v_dkrating = 'A'
      then
         v_dkrating := 'B';
      else
         v_dkrating := 'A';
      end if;

      if v_deckgeom = 'A'
      then
         v_deckgeom := 'B';
      else
         v_deckgeom := 'A';
      end if;

      if v_culvrating = 'A'
      then
         v_culvrating := 'B';
      else
         v_culvrating := 'A';
      end if;

      if v_chanrating = 'A'
      then
         v_chanrating := 'B';
      else
         v_chanrating := 'A';
      end if;

      if v_arailratin = 'A'
      then
         v_arailratin := 'B';
      else
         v_arailratin := 'A';
      end if;

      if v_appralign = 'A'
      then
         v_appralign := 'B';
      else
         v_appralign := 'A';
      end if;

      if v_aendrating = 'A'
      then
         v_aendrating := 'B';
      else
         v_aendrating := 'A';
      end if;

      update pontis.inspevnt
         set wateradeq = v_wateradeq,
             uwlastinsp = v_uwlastinsp,
             underclr = v_underclr,
             transratin = v_transratin,
             suprating = v_suprating,
             subrating = v_subrating,
             strrating = v_strrating,
             scourcrit = v_scourcrit,
             railrating = v_railrating,
             oslastinsp = v_oslastinsp,
             inspdate = v_inspdate,
             fclastinsp = v_fclastinsp,
             dkrating = v_dkrating,
             deckgeom = v_deckgeom,
             culvrating = v_culvrating,
             chanrating = v_chanrating,
             arailratin = v_arailratin,
             appralign = v_appralign,
             aendrating = v_aendrating
       where pontis.inspevnt.brkey = ls_brkey and inspevnt.inspkey = ls_inspkey;

      select pontis.bridge.struct_num,
             pontis.bridge.strflared,
             pontis.bridge.skew,
             pontis.bridge.rtcurbsw,
             pontis.bridge.paralstruc,
             pontis.bridge.orload,
             pontis.bridge.navvc,
             pontis.bridge.navhc,
             pontis.bridge.location,
             pontis.bridge.lftcurbsw,
             pontis.bridge.length,
             pontis.bridge.irload,
             pontis.bridge.featint,
             pontis.bridge.facility,
             pontis.bridge.district,
             pontis.bridge.deckwidth,
             pontis.bridge.bb_pct
        into v_struct_num,
             v_strflared,
             v_skew,
             v_rtcurbsw,
             v_paralstruc,
             v_orload,
             v_navvc,
             v_navhc,
             v_location,
             v_lftcurbsw,
             v_bridge_length,
             v_irload,
             v_featint,
             v_facility,
             v_district,
             v_deckwidth,
             v_bb_pct
        from pontis.bridge
       where pontis.bridge.brkey = ls_brkey;
       
      -- So the struct_num is unique
      SELECT max( brkey ) || 'Z'
      INTO v_struct_num
      FROM bridge;

/*      if v_struct_num = 'A'
      then
         v_struct_num := 'B';
      else
         v_struct_num := 'A';
      end if;
*/
      if v_strflared = 'A'
      then
         v_strflared := 'B';
      else
         v_strflared := 'A';
      end if;

      if v_skew = 1
      then
         v_skew := 2;
      else
         v_skew := 1;
      end if;

      if v_rtcurbsw = 1
      then
         v_rtcurbsw := 2;
      else
         v_rtcurbsw := 1;
      end if;

      if v_paralstruc = 'A'
      then
         v_paralstruc := 'B';
      else
         v_paralstruc := 'A';
      end if;

      if v_orload = 1
      then
         v_orload := 2;
      else
         v_orload := 1;
      end if;

      if v_navvc = 1
      then
         v_navvc := 2;
      else
         v_navvc := 1;
      end if;

      if v_navhc = 1
      then
         v_navhc := 2;
      else
         v_navhc := 1;
      end if;

      if v_location = 'A'
      then
         v_location := 'B';
      else
         v_location := 'A';
      end if;

      if v_lftcurbsw = 1
      then
         v_lftcurbsw := 2;
      else
         v_lftcurbsw := 1;
      end if;

      if v_bridge_length = 1
      then
         v_bridge_length := 2;
      else
         v_bridge_length := 1;
      end if;

      if v_irload = 1
      then
         v_irload := 2;
      else
         v_irload := 1;
      end if;

      if v_featint = 'A'
      then
         v_featint := 'B';
      else
         v_featint := 'A';
      end if;

      if v_facility = 'A'
      then
         v_facility := 'B';
      else
         v_facility := 'A';
      end if;

      if v_district = 'A'
      then
         v_district := 'B';
      else
         v_district := 'A';
      end if;

      if v_deckwidth = 1
      then
         v_deckwidth := 2;
      else
         v_deckwidth := 1;
      end if;

      if v_bb_pct = 1
      then
         v_bb_pct := 2;
      else
         v_bb_pct := 1;
      end if;

      update pontis.bridge
         set struct_num = v_struct_num,
             strflared = v_strflared,
             skew = v_skew,
             rtcurbsw = v_rtcurbsw,
             paralstruc = v_paralstruc,
             orload = v_orload,
             navvc = v_navvc,
             navhc = v_navhc,
             location = v_location,
             lftcurbsw = v_lftcurbsw,
             length = v_bridge_length,
             irload = v_irload,
             featint = v_featint,
             facility = v_facility,
             district = v_district,
             deckwidth = v_deckwidth,
             bb_pct = v_bb_pct
       where pontis.bridge.brkey = ls_brkey;
       
       COMMIT;
       
       -- How many records are there?
       declare
           li_count pls_integer;
       begin
           select count(*) into li_count from ds_change_log;
           dbms_output.put_line( 'There are ' || to_char( li_count ) || ' DS_CHANGE_LOG records' );
           select count(*) into li_count from ds_lookup_keyvals;
           dbms_output.put_line( 'There are ' || to_char( li_count ) || ' DS_LOOKUP_KEYVALS records' );
       end;
       
      return false; -- It worked!
   end f_test_triggers_bak;


begin
  -- Initialization
  NULL;
end ksbms_test;
/