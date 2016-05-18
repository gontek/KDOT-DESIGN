CREATE OR REPLACE TRIGGER pontis.tbid_sl_bridge
     BEFORE INSERT OR DELETE
     ON pontis.bridge


DECLARE
-- local variables here
BEGIN
     -- initialize holder for brkey s to beinserted or deleted from bridge.
     ksbms_scoreboard.p_reset_br_scoreboard;
     KSBMS_SCOREBOARD.P_reset_insp_scoreboard;
     ksbms_scoreboard.p_reset_rway_scoreboard;
     ksbms_scoreboard.p_reset_unit_scoreboard;
     IF INSERTING THEN
           ksbms_scoreboard.p_br_insert_underway;
     ELSIF updating THEN
           ksbms_scoreboard.p_br_delete_underway;
     END IF;
     
END tbid_sl_bridge;
/