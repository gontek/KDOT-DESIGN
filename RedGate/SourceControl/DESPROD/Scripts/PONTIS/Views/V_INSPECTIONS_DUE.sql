CREATE OR REPLACE FORCE VIEW pontis.v_inspections_due (brkey,inspkey,strtype,inspectype,district,maint_area,design_ref_post,maint_rte_num,"LOCATION",featint,adminarea,custodian_kdot,function_type,kta_no,kta_id,r_date,r_yeardue,r_frq,nextinsp,r_over1,r_over2,rdays,r_over_0_30,r_over_30_90,r_over_90,r_duenextmonth,fc_date,fc_yeardue,fc_frq,fcnextdate,f_over1,f_over2,fdays,f_over_0_30,f_over_30_90,f_over_90,f_duenextmonth,ph_date,ph_yeardue,ph_frq,osnextdate,ph_over1,ph_over2,phdays,uw_date,uw_yeardue,uw_frq,uw_req,uwnextdate,u_over1,u_over2,udays,u_over_0_30,u_over_30_90,u_over_90,u_duenextmonth,uwater_insp_typ,sn_date,sn_yeardue,sn_frq,snnextdate,sn_over1,sn_over2,sndays,brdg_culv,notes,kta_insp) AS
(
 SELECT   bridge.brkey,
          inspevnt.inspkey,
          f_structuretype_main(bridge.brkey) as strtype,
         'R' as inspectype,
         bridge.district,
         userbrdg.maint_area,
         userbrdg.design_ref_post,
         userrway.maint_rte_num,
         bridge.location,
         bridge.featint,
         bridge.adminarea,
         userbrdg.custodian_kdot,
         userbrdg.function_type,
          nvl(userbrdg.kta_no,-1) kta_no,
         nvl(userbrdg.kta_id,' ') kta_id,
         inspevnt.inspdate as R_Date,
         extract(year from nextinsp) as R_YEARDUE,
         userinsp.brinspfreq_kdot as R_Frq,
         inspevnt.nextinsp,
         add_months(inspevnt.nextinsp,1) as R_Over1,
         add_months(inspevnt.nextinsp,3) as r_over2,
         trunc(sysdate-nextinsp) as Rdays,
         case when trunc(sysdate-nextinsp) > 0 and trunc(sysdate-nextinsp)<= 30
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_0_30,
         case when trunc(sysdate-nextinsp) > 30 and trunc(sysdate-nextinsp) <= 90
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_30_90,
          case when trunc(sysdate-nextinsp) > 90
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_90,
          case when extract(year from nextinsp) = extract(year from sysdate) and
           extract(month from nextinsp) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as r_duenextmonth,
         inspevnt.fclastinsp as FC_Date,
         extract(year from fcnextdate) as FC_YEARDUE,
         userinsp.fcinspfreq_kdot as FC_FRQ,
         inspevnt.fcnextdate,
         add_months(fcnextdate,1) as F_over1,
         add_months(fcnextdate,3) as f_over2,
         trunc(sysdate-fcnextdate) as Fdays,
         case when trunc(sysdate-fcnextdate) > 0 and trunc(sysdate-fcnextdate)<= 30
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_0_30,
         case when trunc(sysdate-fcnextdate) > 30 and trunc(sysdate-fcnextdate) <= 90
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_30_90,
          case when trunc(sysdate-fcnextdate) > 90
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_90,
          case when extract(year from fcnextdate) = extract(year from sysdate) and
           extract(month from fcnextdate) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as f_duenextmonth,
         inspevnt.oslastinsp as PH_Date,
         extract(year from osnextdate) as PH_YEARDUE,
         userinsp.osinspfreq_kdot as PH_FRQ,
         inspevnt.osnextdate,
         add_months(osnextdate,1) as PH_Over1,
         add_months(osnextdate,3) as PH_Over2,
         trunc(sysdate-osnextdate) as PHdays,
         inspevnt.uwlastinsp as UW_Date,
         extract(year from uwnextdate) as UW_YEARDUE,
         userinsp.uwinspfreq_kdot as UW_FRQ,
         inspevnt.uwinspreq as UW_REQ,
         inspevnt.uwnextdate,
         add_months(uwnextdate,-1) as U_Over1,
         add_months(uwnextdate,-3) as U_Over2,
         trunc(sysdate-uwnextdate) as Udays,
         case when trunc(sysdate-uwnextdate) > 0 and trunc(sysdate-uwnextdate)<= 30
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_0_30,
         case when trunc(sysdate-uwnextdate) > 30 and trunc(sysdate-uwnextdate) <= 90
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_30_90,
          case when trunc(sysdate-uwnextdate) > 90
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_90,
          case when extract(year from uwnextdate) = extract(year from sysdate) and
           extract(month from uwnextdate) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as u_duenextmonth,
         userinsp.uwater_insp_typ,
          userinsp.snoop_last_insp as SN_Date,
          extract(year from snoop_next_insp) as SN_YEARDUE,
         userinsp.snoop_insp_freq as SN_FRQ,
         userinsp.snoop_next_insp as snnextdate,
         add_months(snoop_next_insp,1) as SN_Over1,
         add_months(snoop_next_insp,3) as SN_Over2,
         trunc(sysdate-snoop_next_insp) as SNdays,
         substr(bridge_id,6,1) as brdg_culv,
         decode(inspevnt.notes,null,'N','Y') as notes,
         userbrdg.kta_insp
         FROM bridge,
         userbrdg,
         userinsp,
         userrway,
         inspevnt,
         mv_latest_inspection
   WHERE userinsp.brkey = bridge.brkey and
         userrway.brkey = bridge.brkey and
         userrway.on_under = '1' and
         mv_latest_inspection.brkey = bridge.brkey and
         inspevnt.brkey = bridge.brkey and
         inspevnt.inspkey = userinsp.inspkey and
         userbrdg.brkey = bridge.brkey and
         bridge.district <> '9' and
      inspevnt.inspkey = mv_latest_inspection.inspkey and
      brinspfreq_kdot not in ('0') and
      userbrdg.function_type not in ('90','4') and -- to eliminate pedestrian and railroad function type structures
      bridge.yearbuilt <> '1000' -- active bridges only
      and bridge.bridge_id like '%-B%' -- bridges only
         union all
 SELECT   bridge.brkey,
          inspevnt.inspkey,
          f_structuretype_main(bridge.brkey) as strtype,
         'F' as inspectype,
         bridge.district,
         userbrdg.maint_area,
         userbrdg.design_ref_post,
         userrway.maint_rte_num,
         bridge.location,
         bridge.featint,
         bridge.adminarea,
         userbrdg.custodian_kdot,
         userbrdg.function_type,
          nvl(userbrdg.kta_no,-1) kta_no,
         nvl(userbrdg.kta_id,' ') kta_id,
           inspevnt.inspdate as R_Date,
           extract(year from nextinsp) as R_YEARDUE,
        userinsp.brinspfreq_kdot as R_Frq,
         inspevnt.nextinsp,
         add_months(inspevnt.nextinsp,1) as R_Over1,
         add_months(inspevnt.nextinsp,3) as r_over2,
         trunc(sysdate-nextinsp) as Rdays,
         case when trunc(sysdate-nextinsp) > 0 and trunc(sysdate-nextinsp)<= 30
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_0_30,
         case when trunc(sysdate-nextinsp) > 30 and trunc(sysdate-nextinsp) <= 90
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_30_90,
          case when trunc(sysdate-nextinsp) > 90
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_90,
         case when extract(year from nextinsp) = extract(year from sysdate) and
           extract(month from nextinsp) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as r_duenextmonth,
         inspevnt.fclastinsp as FC_Date,
         extract(year from fcnextdate) as FC_YEARDUE,
         userinsp.fcinspfreq_kdot as FC_FRQ,
         inspevnt.fcnextdate,
         add_months(fcnextdate,1) as F_over1,
         add_months(fcnextdate,3) as f_over2,
         trunc(sysdate-fcnextdate) as Fdays,
         case when trunc(sysdate-fcnextdate) > 0 and trunc(sysdate-fcnextdate)<= 30
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_0_30,
         case when trunc(sysdate-fcnextdate) > 30 and trunc(sysdate-fcnextdate) <= 90
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_30_90,
          case when trunc(sysdate-fcnextdate) > 90
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_90,
          case when extract(year from fcnextdate) = extract(year from sysdate) and
           extract(month from fcnextdate) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as f_duenextmonth,
         inspevnt.oslastinsp as PH_Date,
         extract(year from osnextdate) as PH_YEARDUE,
         userinsp.osinspfreq_kdot as PH_FRQ,
         inspevnt.osnextdate,
         add_months(osnextdate,1) as PH_Over1,
         add_months(osnextdate,3) as PH_Over2,
         trunc(sysdate-osnextdate) as PHdays,
         inspevnt.uwlastinsp as UW_Date,
         extract(year from uwnextdate) as UW_YEARDUE,
         userinsp.uwinspfreq_kdot as UW_FRQ,
         inspevnt.uwinspreq as UW_REQ,
         inspevnt.uwnextdate,
         add_months(uwnextdate,-1) as U_Over1,
         add_months(uwnextdate,-3) as U_Over2,
         trunc(sysdate-uwnextdate) as Udays,
         case when trunc(sysdate-uwnextdate) > 0 and trunc(sysdate-uwnextdate)<= 30
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_0_30,
         case when trunc(sysdate-uwnextdate) > 30 and trunc(sysdate-uwnextdate) <= 90
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_30_90,
          case when trunc(sysdate-uwnextdate) > 90
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_90,
          case when extract(year from uwnextdate) = extract(year from sysdate) and
           extract(month from uwnextdate) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as u_duenextmonth,
         userinsp.uwater_insp_typ,
          userinsp.snoop_last_insp as SN_Date,
          extract(year from snoop_next_insp) as SN_YEARDUE,
         userinsp.snoop_insp_freq as SN_FRQ,
         userinsp.snoop_next_insp as snnextdate,
         add_months(snoop_next_insp,1) as SN_Over1,
         add_months(snoop_next_insp,3) as SN_Over2,
         trunc(sysdate-snoop_next_insp) as SNdays,
         substr(bridge_id,6,1) as brdg_culv,
         decode(inspevnt.notes,null,'N','Y') as notes,
         userbrdg.kta_insp
     FROM bridge,
         userbrdg,
         userinsp,
         userrway,
         inspevnt,
         mv_latest_inspection
   WHERE userinsp.brkey = bridge.brkey and
         userrway.brkey = bridge.brkey and
         userrway.on_under = '1' and
         mv_latest_inspection.brkey = bridge.brkey and
         inspevnt.brkey = bridge.brkey and
         inspevnt.inspkey = userinsp.inspkey and
         userbrdg.brkey = bridge.brkey and
         bridge.district <> '9' and
      inspevnt.inspkey = mv_latest_inspection.inspkey and
      brinspfreq_kdot not in ('0') and
           userbrdg.function_type not in ('90','4') and -- to eliminate pedestrian and railroad function type structures
     bridge.brkey in (select distinct brkey from userstrunit u
     where u.brkey = bridge.brkey and
           ((u.crit_note_sup_1 = '1') or
            (u.crit_note_sup_2 = '1') or
            (u.crit_note_sup_3 = '1') or
            (u.crit_note_sup_4 = '1') or
            (u.crit_note_sup_5 = '1')))
    --   and extract(year from fclastinsp )+ fcinspfreq_kdot <= extract(year from sysdate))
       union all
           SELECT   bridge.brkey,
            inspevnt.inspkey,
            f_structuretype_main(bridge.brkey) as strtype,
         'P' as inspectype,
         bridge.district,
         userbrdg.maint_area,
         userbrdg.design_ref_post,
         userrway.maint_rte_num,
          bridge.location,
         bridge.featint,
         bridge.adminarea,
         userbrdg.custodian_kdot,
         userbrdg.function_type,
           nvl(userbrdg.kta_no,-1) kta_no,
         nvl(userbrdg.kta_id,' ') kta_id,
         inspevnt.inspdate as R_Date,
         extract(year from nextinsp) as R_YEARDUE,
         userinsp.brinspfreq_kdot as R_Frq,
         inspevnt.nextinsp,
         add_months(inspevnt.nextinsp,1) as R_Over1,
         add_months(inspevnt.nextinsp,3) as r_over2,
        trunc(sysdate-nextinsp) as Rdays,
         case when trunc(sysdate-nextinsp) > 0 and trunc(sysdate-nextinsp)<= 30
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_0_30,
         case when trunc(sysdate-nextinsp) > 30 and trunc(sysdate-nextinsp) <= 90
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_30_90,
          case when trunc(sysdate-nextinsp) > 90
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_90,
          case when extract(year from nextinsp) = extract(year from sysdate) and
           extract(month from nextinsp) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as r_duenextmonth,
         inspevnt.fclastinsp as FC_Date,
         extract(year from fcnextdate) as FC_YEARDUE,
         userinsp.fcinspfreq_kdot as FC_FRQ,
         inspevnt.fcnextdate,
         add_months(fcnextdate,1) as F_over1,
         add_months(fcnextdate,3) as f_over2,
         trunc(sysdate-fcnextdate) as Fdays,
         case when trunc(sysdate-fcnextdate) > 0 and trunc(sysdate-fcnextdate)<= 30
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_0_30,
         case when trunc(sysdate-fcnextdate) > 30 and trunc(sysdate-fcnextdate) <= 90
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_30_90,
          case when trunc(sysdate-fcnextdate) > 90
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_90,
          case when extract(year from fcnextdate) = extract(year from sysdate) and
           extract(month from fcnextdate) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as f_duenextmonth,
         inspevnt.oslastinsp as PH_Date,
         extract(year from osnextdate) as PH_YEARDUE,
         userinsp.osinspfreq_kdot as PH_FRQ,
         inspevnt.osnextdate,
         add_months(osnextdate,1) as PH_Over1,
         add_months(osnextdate,3) as PH_Over2,
         trunc(sysdate-osnextdate) as PHdays,
         inspevnt.uwlastinsp as UW_Date,
         extract(year from uwnextdate) as UW_YEARDUE,
         userinsp.uwinspfreq_kdot as UW_FRQ,
         inspevnt.uwinspreq as UW_REQ,
         inspevnt.uwnextdate,
         add_months(uwnextdate,-1) as U_Over1,
         add_months(uwnextdate,-3) as U_Over2,
         trunc(sysdate-uwnextdate) as Udays,
         case when trunc(sysdate-uwnextdate) > 0 and trunc(sysdate-uwnextdate)<= 30
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_0_30,
         case when trunc(sysdate-uwnextdate) > 30 and trunc(sysdate-uwnextdate) <= 90
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_30_90,
          case when trunc(sysdate-uwnextdate) > 90
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_90,
          case when extract(year from uwnextdate) = extract(year from sysdate) and
           extract(month from uwnextdate) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as u_duenextmonth,
         userinsp.uwater_insp_typ,
          userinsp.snoop_last_insp as SN_Date,
         extract(year from snoop_next_insp) as SN_YEARDUE,
         userinsp.snoop_insp_freq as SN_FRQ,
         userinsp.snoop_next_insp as snnextdate,
         add_months(snoop_next_insp,1) as SN_Over1,
         add_months(snoop_next_insp,3) as SN_Over2,
         trunc(sysdate-snoop_next_insp) as SNdays,
         substr(bridge_id,6,1) as brdg_culv,
         decode(inspevnt.notes,null,'N','Y') as notes,
         userbrdg.kta_insp
     FROM bridge,
         userbrdg,
         userinsp,
         userrway,
         inspevnt,
         mv_latest_inspection
   WHERE userinsp.brkey = bridge.brkey and
         userrway.brkey = bridge.brkey and
         userrway.on_under = '1' and
         mv_latest_inspection.brkey = bridge.brkey and
         inspevnt.brkey = bridge.brkey and
         inspevnt.inspkey = userinsp.inspkey and
         userbrdg.brkey = bridge.brkey and
         bridge.district <> '9' and
      inspevnt.inspkey = mv_latest_inspection.inspkey and
      brinspfreq_kdot not in ('0') and
           userbrdg.function_type not in ('90','4') and -- to eliminate pedestrian and railroad function type structures
     bridge.brkey in (select distinct brkey from userstrunit u
     where u.brkey = bridge.brkey and
           ((u.crit_note_sup_1 = '9') or
            (u.crit_note_sup_2 = '9') or
            (u.crit_note_sup_3 = '9') or
            (u.crit_note_sup_4 = '9') or
            (u.crit_note_sup_5 = '9')))
     and  bridge.yearbuilt <> '1000' -- active bridges only
      and bridge.bridge_id like '%-B%' -- bridges only
            union all
       SELECT   bridge.brkey,
        inspevnt.inspkey,
        f_structuretype_main(bridge.brkey) as strtype,
         'U' as inspectype,
         bridge.district,
         userbrdg.maint_area,
         userbrdg.design_ref_post,
         userrway.maint_rte_num,
          bridge.location,
         bridge.featint,
         bridge.adminarea,
         userbrdg.custodian_kdot,
         userbrdg.function_type,
          nvl(userbrdg.kta_no,-1) kta_no,
         nvl(userbrdg.kta_id,' ') kta_id,
         inspevnt.inspdate as R_Date,
         extract(year from nextinsp) as R_YEARDUE,
         userinsp.brinspfreq_kdot as R_Frq,
         inspevnt.nextinsp,
         add_months(inspevnt.nextinsp,1) as R_Over1,
         add_months(inspevnt.nextinsp,3) as r_over2,
        trunc(sysdate-nextinsp) as Rdays,
         case when trunc(sysdate-nextinsp) > 0 and trunc(sysdate-nextinsp)<= 30
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_0_30,
         case when trunc(sysdate-nextinsp) > 30 and trunc(sysdate-nextinsp) <= 90
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_30_90,
          case when trunc(sysdate-nextinsp) > 90
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_90,
           case when extract(year from nextinsp) = extract(year from sysdate) and
           extract(month from nextinsp) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as r_duenextmonth,
         inspevnt.fclastinsp as FC_Date,
         extract(year from fcnextdate) as FC_YEARDUE,
         userinsp.fcinspfreq_kdot as FC_FRQ,
         inspevnt.fcnextdate,
         add_months(fcnextdate,1) as F_over1,
         add_months(fcnextdate,3) as f_over2,
         trunc(sysdate-fcnextdate) as Fdays,
         case when trunc(sysdate-fcnextdate) > 0 and trunc(sysdate-fcnextdate)<= 30
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_0_30,
         case when trunc(sysdate-fcnextdate) > 30 and trunc(sysdate-fcnextdate) <= 90
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_30_90,
          case when trunc(sysdate-fcnextdate) > 90
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_90,
          case when extract(year from fcnextdate) = extract(year from sysdate) and
           extract(month from fcnextdate) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as f_duenextmonth,
         inspevnt.oslastinsp as PH_Date,
         extract(year from osnextdate) as PH_YEARDUE,
         userinsp.osinspfreq_kdot as PH_FRQ,
         inspevnt.osnextdate,
         add_months(osnextdate,1) as PH_Over1,
         add_months(osnextdate,3) as PH_Over2,
         trunc(sysdate-osnextdate) as PHdays,
         inspevnt.uwlastinsp as UW_Date,
         extract(year from uwnextdate) as UW_YEARDUE,
         userinsp.uwinspfreq_kdot as UW_FRQ,
         inspevnt.uwinspreq as UW_REQ,
         inspevnt.uwnextdate,
         add_months(uwnextdate,-1) as U_Over1,
         add_months(uwnextdate,-3) as U_Over2,
         trunc(sysdate-uwnextdate) as Udays,
         case when trunc(sysdate-uwnextdate) > 0 and trunc(sysdate-uwnextdate)<= 30
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_0_30,
         case when trunc(sysdate-uwnextdate) > 30 and trunc(sysdate-uwnextdate) <= 90
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_30_90,
          case when trunc(sysdate-uwnextdate) > 90
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_90,
          case when extract(year from uwnextdate) = extract(year from sysdate) and
           extract(month from uwnextdate) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as u_duenextmonth,
         userinsp.uwater_insp_typ,
          userinsp.snoop_last_insp as SN_Date,
          extract(year from snoop_next_insp) as SN_YEARDUE,
         userinsp.snoop_insp_freq as SN_FRQ,
         userinsp.snoop_next_insp as snnextdate,
         add_months(snoop_next_insp,1) as SN_Over1,
         add_months(snoop_next_insp,3) as SN_Over2,
         trunc(sysdate-snoop_next_insp) as SNdays,
         substr(bridge_id,6,1) as brdg_culv,
         decode(inspevnt.notes,null,'N','Y') as notes,
         userbrdg.kta_insp
     FROM bridge,
         userbrdg,
         userinsp,
         userrway,
         inspevnt,
         mv_latest_inspection
   WHERE userinsp.brkey = bridge.brkey and
         userrway.brkey = bridge.brkey and
         userrway.on_under = '1' and
         mv_latest_inspection.brkey = bridge.brkey and
         inspevnt.brkey = bridge.brkey and
         inspevnt.inspkey = userinsp.inspkey and
         userbrdg.brkey = bridge.brkey and
         bridge.district <> '9' and
      inspevnt.inspkey = mv_latest_inspection.inspkey and
      brinspfreq_kdot not in ('0') and
           userbrdg.function_type not in ('90','4') -- to eliminate pedestrian and railroad function type structures
      and userinsp.uwater_insp_typ in ('2','3','4') and
      bridge.yearbuilt <> '1000' -- active bridges only
      and bridge.bridge_id like '%-B%' -- bridges only
         UNION ALL
         SELECT   bridge.brkey,
          inspevnt.inspkey,
          f_structuretype_main(bridge.brkey) as strtype,
         'S' as inspectype,
         bridge.district,
         userbrdg.maint_area,
         userbrdg.design_ref_post,
         userrway.maint_rte_num,
         bridge.location,
         bridge.featint,
         bridge.adminarea,
         userbrdg.custodian_kdot,
         userbrdg.function_type,
          nvl(userbrdg.kta_no,-1) kta_no,
         nvl(userbrdg.kta_id,' ') kta_id,
         inspevnt.inspdate as R_Date,
         extract(year from nextinsp) as R_YEARDUE,
        userinsp.brinspfreq_kdot as R_Frq,
         inspevnt.nextinsp,
         add_months(inspevnt.nextinsp,1) as R_Over1,
         add_months(inspevnt.nextinsp,3) as r_over2,
         trunc(sysdate-nextinsp) as Rdays,
         case when trunc(sysdate-nextinsp) > 0 and trunc(sysdate-nextinsp)<= 30
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_0_30,
         case when trunc(sysdate-nextinsp) > 30 and trunc(sysdate-nextinsp) <= 90
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_30_90,
          case when trunc(sysdate-nextinsp) > 90
           then trunc(sysdate-nextinsp)
             else 0
               end as R_Over_90,
          case when extract(year from nextinsp) = extract(year from sysdate) and
           extract(month from nextinsp) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as r_duenextmonth,
         inspevnt.fclastinsp as FC_Date,
         extract(year from fcnextdate) as FC_YEARDUE,
         userinsp.fcinspfreq_kdot as FC_FRQ,
         inspevnt.fcnextdate,
         add_months(fcnextdate,1) as F_over1,
         add_months(fcnextdate,3) as f_over2,
         trunc(sysdate-fcnextdate) as Fdays,
         case when trunc(sysdate-fcnextdate) > 0 and trunc(sysdate-fcnextdate)<= 30
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_0_30,
         case when trunc(sysdate-fcnextdate) > 30 and trunc(sysdate-fcnextdate) <= 90
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_30_90,
          case when trunc(sysdate-fcnextdate) > 90
           then trunc(sysdate-fcnextdate)
             else 0
               end as F_Over_90,
          case when extract(year from fcnextdate) = extract(year from sysdate) and
           extract(month from fcnextdate) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as f_duenextmonth,
         inspevnt.oslastinsp as PH_Date,
         extract(year from osnextdate) as PH_YEARDUE,
         userinsp.osinspfreq_kdot as PH_FRQ,
         inspevnt.osnextdate,
         add_months(osnextdate,1) as PH_Over1,
         add_months(osnextdate,3) as PH_Over2,
         trunc(sysdate-osnextdate) as PHdays,
         inspevnt.uwlastinsp as UW_Date,
         extract(year from uwnextdate) as UW_YEARDUE,
         userinsp.uwinspfreq_kdot as UW_FRQ,
         inspevnt.uwinspreq as UW_REQ,
         inspevnt.uwnextdate,
         add_months(uwnextdate,-1) as U_Over1,
         add_months(uwnextdate,-3) as U_Over2,
         trunc(sysdate-uwnextdate) as Udays,
         case when trunc(sysdate-uwnextdate) > 0 and trunc(sysdate-uwnextdate)<= 30
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_0_30,
         case when trunc(sysdate-uwnextdate) > 30 and trunc(sysdate-uwnextdate) <= 90
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_30_90,
          case when trunc(sysdate-uwnextdate) > 90
           then trunc(sysdate-uwnextdate)
             else 0
               end as U_Over_90,
          case when extract(year from uwnextdate) = extract(year from sysdate) and
           extract(month from uwnextdate) = extract(month from sysdate) then
           'Y'
           else 'N'
             end as u_duenextmonth,
         userinsp.uwater_insp_typ,
          userinsp.snoop_last_insp as SN_Date,
          extract(year from snoop_next_insp) as SN_YEARDUE,
         userinsp.snoop_insp_freq as SN_FRQ,
         userinsp.snoop_next_insp as snnextdate,
         add_months(snoop_next_insp,1) as SN_Over1,
         add_months(snoop_next_insp,3) as SN_Over2,
         trunc(sysdate-snoop_next_insp) as SNdays,
         substr(bridge_id,6,1) as brdg_culv,
         decode(inspevnt.notes,null,'N','Y') as notes,
         userbrdg.kta_insp
    FROM bridge,
         userbrdg,
         userinsp,
         userrway,
         inspevnt,
         mv_latest_inspection
   WHERE userinsp.brkey = bridge.brkey and
         userrway.brkey = bridge.brkey and
         userrway.on_under = '1' and
         mv_latest_inspection.brkey = bridge.brkey and
         inspevnt.brkey = bridge.brkey and
         inspevnt.inspkey = userinsp.inspkey and
         userbrdg.brkey = bridge.brkey and
         bridge.district <> '9' and
      inspevnt.inspkey = mv_latest_inspection.inspkey and
      brinspfreq_kdot not in ('0') and
     userinsp.snoop_insp_req = 'Y' and
          userbrdg.function_type not in ('90','4') -- to eliminate pedestrian and railroad function type structures
     and  nvl(snoop_insp_freq,0) > 0 and nvl(snoop_insp_freq,0) < 99
   and bridge.yearbuilt <> '1000' -- active bridges only
      and bridge.bridge_id like '%-B%' -- bridges only
 )
;