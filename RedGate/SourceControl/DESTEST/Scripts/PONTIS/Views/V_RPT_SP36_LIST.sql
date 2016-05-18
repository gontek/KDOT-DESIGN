CREATE OR REPLACE FORCE VIEW pontis.v_rpt_sp36_list (brkey,bridge_id,adminarea,brinspfreq_kdot,maint_area,inspdate,whatyear,groupsort) AS
(select bridge.brkey,
       bridge.bridge_id,
       bridge.adminarea,
       userinsp.brinspfreq_kdot,
       userbrdg.maint_area,
       inspevnt.inspdate,
       extract(year from inspdate) whatyear,
case
when adminarea in ('11','13','15','21','23','31','33','41','43','51','53','61','63') and substr(bridge_id,6,1) = 'B'  then 1
when adminarea in ('11','13','15','21','23','31','33','41','43','51','53','61','63') and substr(bridge_id,6,1) = 'C' and brinspfreq_kdot = '1' then 1
when adminarea in ('14','16','24','34','44','54','55') and substr(bridge_id,6,1) = 'B' and brinspfreq_kdot = '1' then 2
when adminarea in ('14','16','24','34','44','54','55') and substr(bridge_id,6,1) = 'C' and brinspfreq_kdot in ('1','2') then 2
when adminarea in ('12','22','32','42','52','62') and substr(bridge_id,6,1) = 'B' and brinspfreq_kdot = '1' then 3
when adminarea in ('12','22','32','42','52','62') and substr(bridge_id,6,1) = 'C' then 3
else 0
end as groupsort
FROM bridge,
         userbrdg,
			userinsp,
      inspevnt
   WHERE userbrdg.brkey = bridge.brkey and
         userinsp.brkey = bridge.brkey and
         inspevnt.brkey = bridge.brkey and
         userinsp.brkey = bridge.brkey and
			userinsp.inspkey = inspevnt.inspkey
			 )

 ;