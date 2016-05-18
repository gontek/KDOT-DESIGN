CREATE OR REPLACE FORCE VIEW pontis.v_overdue_or_scheduled_bridges (brkey,struct_num,featint,"FACILITY","OWNER",inspdate,brinspfreq,lastinsp,nextinsp,nbi_diff_months,uwinspreq,uwinspfreq,uwlastinsp,uwnextdate,uw_diff_months,fcinspreq,fcinspfreq,fclastinsp,fcnextdate,fc_diff_months,osinspreq,osinspfreq,oslastinsp,osnextdate,os_diff_months) AS
SELECT
       b.brkey,
       b.struct_num,
       b.featint,
       b.facility,
       b.owner,
       i.inspdate,
       i.brinspfreq,
       i.lastinsp,
       i.nextinsp,
       Months_between( i.nextinsp, SYSDATE ) AS nbi_diff_months,
       i.uwinspreq, i.uwinspfreq, i.uwlastinsp, i.uwnextdate,
       CASE
            WHEN i.uwinspreq = 'Y' OR i.uwinspreq = '1' THEN Months_between( i.uwnextdate, SYSDATE )
            ELSE
                NULL
       END AS uw_diff_months,
       i.fcinspreq, i.fcinspfreq, i.fclastinsp, i.fcnextdate,
       CASE
            WHEN  i.fcinspreq = 'Y' OR i.fcinspreq = '1' THEN Months_between( i.fcnextdate, SYSDATE )
            ELSE
                NULL
       END AS fc_diff_months,
       i.osinspreq, i.osinspfreq, i.oslastinsp, i.osnextdate,
       CASE
            WHEN i.osinspreq =  'Y' OR i.osinspreq =  '1' THEN Months_between( i.osnextdate, SYSDATE )
            ELSE
                NULL
       END AS os_diff_months
FROM
      bridge b, inspevnt i,mv_latest_inspection mv
WHERE
      b.brkey = i.brkey
AND
      mv.BRKEY = b.BRKEY

and i.inspkey = mv.inspkey

 ;