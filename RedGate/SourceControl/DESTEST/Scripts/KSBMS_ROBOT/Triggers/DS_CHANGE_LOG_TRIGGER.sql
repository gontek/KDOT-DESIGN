CREATE OR REPLACE TRIGGER ksbms_robot.ds_change_log_trigger
before insert on ksbms_robot.ds_change_log
for each row


BEGIN

-- Allen Marshall, CS -01/22/2003
-- ONLY INITIALIZE IF WE ARE REALLY REALLY REALLY INSERTING ALTOGETHER NEW ROWS
-- OTHERWISE INSERT (SELECTG FROM ) will NOT give the right SEQNUM as it will be overridden here - see 
-- KSBMS_DATA_SYNC. f_move_merge_ready_to_pontis () for an example of an insert from select where the sequence Num is WANTED
IF :new.sequence_num IS NULL THEN
   select ds_change_log_seqnum.nextval into :new.sequence_num from dual;
END IF;   
end;
/