CREATE OR REPLACE procedure pontis.qry_upd_inspevnt_nextinsp is
  


/* CREATED TO UPDATE INSPEVNT.NEXTINSP ANY TIME THAT THE MATERIALIZED
MV_LATEST_INSPECTION HAS BEEN REFRESHED
   created 4/12/2012 By dk
   
*/
begin

update inspevnt
set nextinsp = (select nextRinsp_calc from mv_latest_inspection mv
where mv.brkey = inspevnt.brkey and
mv.inspkey = inspevnt.inspkey)
where brkey in (select brkey from mv_latest_inspection mv2
where mv2.brkey = inspevnt.brkey and
mv2.inspkey = inspevnt.inspkey);

commit;

update inspevnt
set elnextdate = (select nextRinsp_calc from mv_latest_inspection mv
where mv.brkey = inspevnt.brkey and
mv.inspkey = inspevnt.inspkey)
where brkey in (select brkey from mv_latest_inspection mv2
where mv2.brkey = inspevnt.brkey and
mv2.inspkey = inspevnt.inspkey);

      
commit;
  
end;

 
/