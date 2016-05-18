CREATE OR REPLACE TRIGGER ksbms_robot.tuib_ds_change_log_date_chng


--  a clean up trigger to take Cansys date fields and convert data to a 
--  4-digit year for roadway.adtyear and roadway.adtfutyear
--  dk 5-11-2009

before insert on ksbms_robot.ds_change_log
for each row

begin

if
 :new.exchange_rule_id in ('2520','2500') then
 :new.new_value := substr(:new.new_value,0,4);
 
 end if;
 
 end tuib_ds_change_log_date_chng;
/