CREATE OR REPLACE FORCE VIEW pontis.inspection_layout (bridge_id,brkey,"OWNER",adminarea,yearbuilt,maint,maint_rte_num,on_under,design_ref_post,inspdate,brinspfreq_kdot,fcdue,uwdue,phdue,rsdue,r_inspname_1,r_inspname_2) AS
SELECT bridge.bridge_id,
         bridge.brkey as brkey,
         bridge.owner,
         bridge.adminarea,
         bridge.yearbuilt,
        f_get_paramtrs_equiv('userbrdg','custodian_kdot', userbrdg.custodian_kdot) as MAINT,
         userrway.maint_rte_num,
         userrway.on_under,
         userbrdg.design_ref_post,
         inspevnt.inspdate,
         userinsp.brinspfreq_kdot,
         case
           when fcinspreq = 'Y' and extract(year from inspdate) <> '1901' and extract(year from fcnextdate) <= extract(year from sysdate)
             then to_char(extract(year from fcnextdate))
               else ''
                 end as fcdue,
case
           when uwinspreq = 'Y' and extract(year from inspdate) <> '1901' and  extract(year from uwnextdate) <= extract(year from sysdate)
             then to_char(extract(year from uwnextdate))
               else ''
                 end as uwdue,
case
           when osinspreq = 'Y' and extract(year from inspdate) <> '1901' and  extract(year from osnextdate) <= extract(year from sysdate)
             then to_char(extract(year from osnextdate))
               else ''
                 end as phdue,
case
           when snoop_insp_req = 'Y' and extract(year from inspdate) <> '1901' and  extract(year from snoop_next_insp) <= extract(year from sysdate)
             then to_char(extract(year from snoop_next_insp))
               else ''
                 end as rsdue,
userinsp.r_inspname_1,
userinsp.r_inspname_2

    FROM bridge,
         inspevnt,
         userinsp,
         userbrdg,
         userrway
    WHERE bridge.brkey = userbrdg.brkey and
         bridge.brkey = userinsp.brkey and
         bridge.brkey = inspevnt.brkey and
         userinsp.inspkey = inspevnt.inspkey and
         inspevnt.inspkey = (select max(inspkey) from inspevnt j
          where j.brkey = inspevnt.brkey and j.inspdate =
           (select max(inspdate) from inspevnt k
          where k.brkey = inspevnt.brkey)) and
         bridge.brkey = userrway.brkey and
         userrway.on_under = (select min(on_under) from userrway u
         where u.brkey = userrway.brkey) and
         userbrdg.custodian_kdot in ('0', '7','3')  and
         bridge.district <> '9'
ORDER BY to_number(userrway.maint_rte_num) ASC, userbrdg.design_ref_post ASC

 ;