CREATE OR REPLACE TRIGGER pontis.TRG_BI_INSPEVNT_DATEFIX BEFORE INSERT ON pontis.INSPEVNT
for each row

DISABLE DECLARE

ld_uw_prev DATE;
ld_fc_prev DATE;
ld_os_prev DATE;
/*ld_nbi_prev DATE;*/
ld_default_date DATE := to_date('1901-01-01','YYYY-MM-DD');
ls_prior_inspkey inspevnt.inspkey%type;

BEGIN
  
select max(inspkey) 
into ls_prior_inspkey from inspevnt i1
where i1.inspkey = (select max(i2.inspkey) from inspevnt i2 where i2.brkey = :new.brkey and
i2.inspdate = (select max(i3.inspdate) from inspevnt i3
where i3.brkey = :new.brkey and i3.inspdate < :new.inspdate));

<<GetUWDate>>
BEGIN
SELECT UWLASTINSP INTO ld_uw_prev FROM INSPEVNT i1 where BRKEY = :new.BRKEY and INSPKEY = ls_prior_inspkey; -- may be null, a valid previous date, or the missing date value
EXCEPTION
WHEN NO_DATA_FOUND THEN
ld_uw_prev := ld_default_date;
 
WHEN OTHERS THEN RAISE;
END GetUWDate;


BEGIN
  <<GetFCDate>>
SELECT FClastinsp INTO ld_fc_prev FROM INSPEVNT where BRKEY = :new.BRKEY and INSPKEY = ls_prior_inspkey; -- may be null, a valid previous date, or the missing date value
EXCEPTION
WHEN NO_DATA_FOUND THEN
ld_fc_prev := ld_default_date; 
WHEN OTHERS THEN RAISE;
END GetFCDate;


BEGIN
 <<GetOSDate>> 

SELECT OSlastinsp
INTO ld_os_prev FROM INSPEVNT where BRKEY = :new.BRKEY and INSPKEY = ls_prior_inspkey ; -- may be null, a valid previous date, or the missing date value
EXCEPTION
WHEN NO_DATA_FOUND THEN
ld_os_prev := ld_default_date ;
WHEN OTHERS THEN RAISE;
END GetOSDate;


/*BEGIN
<<GetNBIDate>>
-- this assumes every prior inspection is an NBI inspection.  If that is not  a safe assumption then this WHERE clause needs to be smarter....
SELECT MAX(INSPDATE) INTO ld_NBI_prev FROM INSPEVNT where BRKEY = :new.BRKEY and INSPKEY <> :new.INSPKEY AND INSPDATE < :new.INSPDATE; -- may be null, a valid previous date, or the missing date value
EXCEPTION
WHEN NO_DATA_FOUND THEN
ld_NBI_prev := ld_default_date ;
WHEN OTHERS THEN RAISE;
END  GetNBIDate;
*/

:new.UWLASTINSP := NVL(ld_uw_prev,ld_default_date); -- NVL is not redundant  because the date may well be NULL in a previous record...
:new.FCLASTINSP := NVL(ld_fc_prev,ld_default_date);
:new.OSLASTINSP := NVL(ld_os_prev,ld_default_date);
/*:new.LASTINSP := NVL(ld_NBI_prev,ld_default_date);
*/

EXCEPTION
WHEN OTHERS THEN RAISE;

END TRG_BI_INSPEVNT_DATEFIX ;
/