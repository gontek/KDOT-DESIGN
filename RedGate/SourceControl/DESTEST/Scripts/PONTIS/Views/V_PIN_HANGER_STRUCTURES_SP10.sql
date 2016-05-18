CREATE OR REPLACE FORCE VIEW pontis.v_pin_hanger_structures_sp10 (brkey) AS
SELECT distinct brkey
FROM userstrunit
where	(  userstrunit.crit_note_sup_1 = '9' or
			   userstrunit.crit_note_sup_2 = '9' or
				userstrunit.crit_note_sup_3 = '9' or
				userstrunit.crit_note_sup_4 = '9' or
				userstrunit.crit_note_sup_5 = '9' )

 ;