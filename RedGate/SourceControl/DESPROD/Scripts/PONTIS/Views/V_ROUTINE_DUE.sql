CREATE OR REPLACE FORCE VIEW pontis.v_routine_due (brkey,inspkey,inspdate,brinspfreq_kdot,nextinsp,nextdate,brdg_culv,notes) AS
(
SELECT   bridge.brkey,
         inspevnt.inspkey,
         inspevnt.inspdate,
         userinsp.brinspfreq_kdot,
         inspevnt.nextinsp,
         extract(year from inspdate)+ brinspfreq_kdot as nextdate,
         substr(bridge_id,6,1) as brdg_culv,
         decode(inspevnt.notes,null,'N','Y') as notes
    FROM bridge,
         userinsp,
         inspevnt,
         mv_latest_inspection
   WHERE userinsp.brkey = bridge.brkey and
         mv_latest_inspection.brkey = bridge.brkey and
         inspevnt.brkey = bridge.brkey and
         inspevnt.inspkey = userinsp.inspkey and
         bridge.district <> '9' and
      inspevnt.inspkey = mv_latest_inspection.inspkey and
      brinspfreq_kdot not in ('0','99') and
     (       ( inspevnt.inspdate > '01/jan/1901' and inspevnt.notes is null)
         or( inspevnt.inspdate > '01/jan/1901' and extract(year from inspdate )+ brinspfreq_kdot <= extract(year from sysdate))))

 ;