CREATE MATERIALIZED VIEW pontis.mv_bif_data (brkey,county,"SERIAL",bridge_id,bif_label,uc_label,unitcheck,sorta,sortb,adminarea,district,maint_area,sub_area,rpt_maint_rte,rpt_route,"LOCATION","FACILITY",flared,respons,detour,lanes_carried,lanes_xd,translanes,city,orientation,featint,streamsign,irload_lbl,orload_lbl,irload_h,orload_h,irload_3,orload_3,irload_hs,orload_hs,irload_3s2,orload_3s2,irload_3_3,orload_3_3,irload_t130,orload_t130,irload_t170,orload_t170,irload_hl93,orload_hl93,ratingdate,designload,designload_type,posted_load_a,posted_load_b,posted_load_c,rot_angle_deg,rot_angle_min,rot_direction,skew,skew_minutes,skew_direction,brlength,intrvl,brdgculv,units,inspkey,deckgeom,nbi_rating,strrating,suff_rate,underclr,appralign,wateradeq,aadt,truckpct,actvdate,actvtydscr,prjctid,micro,inspdate_1,inspdate_2,inspdate_3,inspdate_4,inspdate_5,dkrate_1,dkrate_2,dkrate_3,dkrate_4,dkrate_5,suprate_1,suprate_2,suprate_3,suprate_4,suprate_5,subrate_1,subrate_2,subrate_3,subrate_4,subrate_5,culvrate_1,culvrate_2,culvrate_3,culvrate_4,culvrate_5,appralign_1,appralign_2,appralign_3,appralign_4,appralign_5,chanrating_1,chanrating_2,chanrating_3,chanrating_4,chanrating_5,wateradeq_1,wateradeq_2,wateradeq_3,wateradeq_4,wateradeq_5,sign_type_q1,sign_type_q2,sign_type_q3,sign_type_q4,railrating,transratin,arailratin,aendrating,aroadwidth_near,aroadwidth_far,grailtype,grail_end_treat,grail_apr_lt,grail_apr_rt,grail_exit_lt,grail_exit_rt,scourcritrate,scourcrit,chanprotleft,chanprotright,vclr,roadwidth,drainage_area,attach_1,attach_2,attach_3,attach_desc_1,attach_desc_2,attach_desc_3,avg_hi,specialtag,spcllastinsp,spclfreq,spclnextinsp,fclastinsp,fcinspreq,fcnextdate,fcintrvl,oslastinsp,osinspreq,osnextdate,osinspfreq,uwlastinsp,uwinspreq,uwnextdate,uwinspfreq,snooplastinsp,snoopinspfreq,snoopnextinsp,uwinsptype,inspdate,brinspfreq,routinedate,notes,maint_notes,inspec_notes,abcdlist_a,abcdlist_a_notes,abcdlist_b,abcdlist_b_notes,abcdlist_c,abcdlist_c_notes,abcdlist_d,abcdlist_d_notes,work_type,proj_num,progyear,proj_status,new_ser,kta_insp,reporta,reportb,reportc,reportd)
REFRESH NEXT sysdate+(decode(to_char(sysdate,'D'),6,3,7,2,1)) 
AS select b.brkey,
substr(b.brkey,1,3) as county,
substr(b.brkey,4,3) as serial,
b.bridge_id
,case when u.kta_insp in ('1','0') then 'KANSAS BRIDGE INSPECTION FORM (KTA)'
 else 'KANSAS BRIDGE INSPECTION FORM'
   end as bif_label
,case
  when b.yearbuilt = '1000' then
    'UNDER CONSTRUCTION'
    else ''
      end as UC_label
,f_multiple_unit(b.brkey) as unitcheck
--,design_ref_post
,case
  when kta_insp in ('1','0') then
   to_number(kta_insp)
    else bif.f_get_bif_route(b.brkey) -- just the route number (or kta_insp '1','0') for sorting purposes
      end as sorta,
case
  when kta_insp in ('1','0') then -- other piece of the sort order...hope this works!!!
    kta_no
    else design_ref_post
      end as sortb
,adminarea
,district
,maint_area
,sub_area
,bif.f_get_bif_full_route(b.brkey) rpt_maint_rte,
case
  when kta_insp in ('1','0') then
    'KTA No: '||to_char(round(kta_no,3))||' '||kta_id
    else
      'Ref Pt:  '||design_ref_post
      end as rpt_route
--,bif.f_get_bif_route(b.brkey) srt_maint_rte
,location
,facility
,decode(b.strflared,'1','Y','0','N','') as flared
,f_get_paramtrs_equiv_long('userbrdg','owner_kdot',u.owner_kdot) as respons
,to_char(round(nvl(bif.f_get_bif_rdwydata(b.brkey,'1','roadway','bypasslen'),0) / 1.609344)) detour
,to_char(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','totlanes')) lanes_carried
,to_char(nvl(b.sumlanes,0)) as lanes_xd
,to_char(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','trans_lanes'))translanes
,f_get_paramtrs_equiv_long('bridge','placecode',b.placecode) city
,f_get_paramtrs_equiv_long('userbrdg','orientation',u.orientation) orientation
,featint
,f_get_paramtrs_equiv_long('userbrdg','stream_sign',u.stream_sign) streamsign
--f_get_paramtrs_equiv_long('userbrdg','functiontype',u.function_type) functype,
,to_char(bif.f_get_bif_irload_lbl(u.brkey,irload_adj_h,irload_lfd_h,irload_wsd_h)) irload_lbl
,to_char(bif.f_get_bif_orload_lbl(u.brkey, orload_adj_h,orload_lfd_h,orload_wsd_h)) orload_lbl
,to_char(bif.f_get_bif_loadrtng(u.brkey,irload_adj_h,irload_lfd_h,irload_wsd_h)) irload_h
,to_char(bif.f_get_bif_loadrtng(u.brkey,orload_adj_h,orload_lfd_h,orload_wsd_h)) orload_h
,to_char(bif.f_get_bif_loadrtng(u.brkey,irload_adj_3,irload_lfd_3,irload_wsd_3)) irload_3
,to_char(bif.f_get_bif_loadrtng(u.brkey,orload_adj_3,orload_lfd_3,orload_wsd_3)) orload_3
,to_char(bif.f_get_bif_loadrtng(u.brkey,irload_adj_hs,irload_lfd_hs,irload_wsd_hs)) irload_hs
,to_char(bif.f_get_bif_loadrtng(u.brkey,orload_adj_hs,orload_lfd_hs,orload_wsd_hs)) orload_hs
,to_char(bif.f_get_bif_loadrtng(u.brkey,irload_adj_3s2,irload_lfd_3s2,irload_wsd_3s2)) irload_3s2
,to_char(bif.f_get_bif_loadrtng(u.brkey,orload_adj_3s2,orload_lfd_3s2,orload_wsd_3s2)) orload_3s2
,to_char(bif.f_get_bif_loadrtng(u.brkey,irload_adj_3_3,irload_lfd_3_3,irload_wsd_3_3)) irload_3_3
,to_char(bif.f_get_bif_loadrtng(u.brkey,orload_adj_3_3,orload_lfd_3_3,orload_wsd_3_3)) orload_3_3
,to_char(bif.f_get_bif_loadrtng(u.brkey,irload_adj_t130,irload_lfd_t130,irload_wsd_t130)) irload_t130
,to_char(bif.f_get_bif_loadrtng(u.brkey,orload_adj_t130,orload_lfd_t130,orload_wsd_t130)) orload_t130
,to_char(bif.f_get_bif_loadrtng(u.brkey,irload_adj_t170,irload_lfd_t170,irload_wsd_t170)) irload_t170
,to_char(bif.f_get_bif_loadrtng(u.brkey,orload_adj_t170,orload_lfd_t170,orload_wsd_t170)) orload_t170
,case when nvl(irload_hl93,0) <= 0 then ''
  else to_char(irload_hl93)
    end as irload_hl93,
case when nvl(orload_hl93,0) <= 0 then ''
  else to_char(orload_hl93)
    end as orload_hl93
,ratingdate
,to_char(round(u.designload_kdot/0.9072)) designload
,f_get_paramtrs_equiv_long('userbrdg','designload_type',u.designload_type) designload_type
,round(metrictons_to_tons(u.posted_load_a)) posted_load_a
,round(metrictons_to_tons(u.posted_load_b)) posted_load_b
,round(metrictons_to_tons(u.posted_load_c)) posted_load_c
,case
  when nvl(u.rot_angle_deg,0) <= 0
   then 'N/A'
     else to_char(round(u.rot_angle_deg))
end as rot_angle_deg
,case
when nvl(u.rot_angle_deg,0) <= 0
  then ''
    else to_char(round(rot_angle_min))
      end as rot_angle_min
,case
 when nvl(u.rot_angle_deg,0)  <= 0
   then ''
    else f_get_paramtrs_equiv_long('userbrdg','rot_direction',u.rot_direction)
       end as rot_direction
,case
 when nvl(b.skew,0) <= 0 then
   'N/A'
   else
     to_char(b.skew)
   end as skew
,case
  when nvl(b.skew,0) <= 0
    then ''
      else to_char(u.skew_minutes)
        end as skew_minutes
,case
 when nvl(b.skew,0) <= 0
   then ''
     else f_get_paramtrs_equiv_long('userbrdg','skew_direction',u.skew_direction)
       end as skew_direction
,to_char(round(b.length/.3048,1)) as brlength
,bif.f_get_bif_inspecdata(b.brkey,'userinsp','brinspfreq_kdot') as intrvl
,case
  when substr(b.bridge_id,6,1) = 'C' then
    'C'
    else 'B'
      end as brdgculv
,to_char(bif.f_get_bif_totalunits(b.brkey)) as units
,bif.f_get_bif_inspecdata(b.brkey,'inspevnt','inspkey') inspkey
,bif.f_get_bif_inspecdata(b.brkey,'inspevnt','deckgeom')  deckgeom
,f_get_paramtrs_equiv('inspevnt','nbi_rating',bif.f_get_bif_inspecdata(b.brkey,'inspevnt','nbi_rating'))  nbi_rating
,bif.f_get_bif_inspecdata(b.brkey,'inspevnt','strrating')  strrating

,bif.f_get_bif_inspecdata(b.brkey,'inspevnt','suff_rate') suff_rate
,bif.f_get_bif_inspecdata(b.brkey,'inspevnt','underclr')   underclr
,f_get_paramtrs_equiv_long('inspevnt','appralign',bif.f_get_bif_inspecdata(b.brkey,'inspevnt','appralign')) appralign
,f_get_paramtrs_equiv_long('inspevnt','wateradeq',bif.f_get_bif_inspecdata(b.brkey,'inspevnt','wateradeq')) wateradeq
--,bif.f_get_bif_inspecdata(b.brkey,'userinsp','priority_opt') priority_opt_calc
--,bif.f_get_bif_insp_item(b.brkey,'fhwa_status') fhwa_status

,to_char(bif.f_get_bif_rdwydata(b.brkey,'1','roadway','adttotal')) as aadt
,to_char(bif.f_get_bif_rdwydata(b.brkey,'1','roadway','truckpct')) as truckpct
,trim(bif.f_get_bif_cansysprjs(b.brkey,'actvdate')) as actvdate
,trim(bif.f_get_bif_cansysprjs(b.brkey,'actvtydscr')) as actvtydscr
,trim(bif.f_get_bif_cansysprjs(b.brkey,'prjctid')) as prjctid
,trim(bif.f_get_bif_cansysprjs(b.brkey,'bif_micro')) as micro
,bif.f_get_bif_inspdate(b.brkey,1)as inspdate_1

,bif.f_get_bif_inspdate(b.brkey,2) as inspdate_2
,bif.f_get_bif_inspdate(b.brkey,3) as inspdate_3
,bif.f_get_bif_inspdate(b.brkey,4) as inspdate_4
,bif.f_get_bif_inspdate(b.brkey,5) as inspdate_5
,bif.f_get_bif_dkrate(b.brkey,1)as dkrate_1
,bif.f_get_bif_dkrate(b.brkey,2) as dkrate_2
,bif.f_get_bif_dkrate(b.brkey,3) as dkrate_3
,bif.f_get_bif_dkrate(b.brkey,4) as dkrate_4
,bif.f_get_bif_dkrate(b.brkey,5) as dkrate_5
,bif.f_get_bif_suprate(b.brkey,1)as suprate_1
,bif.f_get_bif_suprate(b.brkey,2) as suprate_2
,bif.f_get_bif_suprate(b.brkey,3) as suprate_3
,bif.f_get_bif_suprate(b.brkey,4) as suprate_4
,bif.f_get_bif_suprate(b.brkey,5) as suprate_5
,bif.f_get_bif_subrate(b.brkey,1)as subrate_1
,bif.f_get_bif_subrate(b.brkey,2) as subrate_2
,bif.f_get_bif_subrate(b.brkey,3) as subrate_3
,bif.f_get_bif_subrate(b.brkey,4) as subrate_4
,bif.f_get_bif_subrate(b.brkey,5) as subrate_5
,bif.f_get_bif_culvrate(b.brkey,1)as culvrate_1
,bif.f_get_bif_culvrate(b.brkey,2) as culvrate_2
,bif.f_get_bif_culvrate(b.brkey,3) as culvrate_3
,bif.f_get_bif_culvrate(b.brkey,4) as culvrate_4
,bif.f_get_bif_culvrate(b.brkey,5) as culvrate_5
,bif.f_get_bif_appralign(b.brkey,1)as appralign_1
,bif.f_get_bif_appralign(b.brkey,2) as appralign_2
,bif.f_get_bif_appralign(b.brkey,3) as appralign_3
,bif.f_get_bif_appralign(b.brkey,4) as appralign_4
,bif.f_get_bif_appralign(b.brkey,5) as appralign_5
,bif.f_get_bif_chanrating(b.brkey,1)as chanrating_1
,bif.f_get_bif_chanrating(b.brkey,2) as chanrating_2
,bif.f_get_bif_chanrating(b.brkey,3) as chanrating_3
,bif.f_get_bif_chanrating(b.brkey,4) as chanrating_4
,bif.f_get_bif_chanrating(b.brkey,5) as chanrating_5
,bif.f_get_bif_wateradeq(b.brkey,1)as wateradeq_1
,bif.f_get_bif_wateradeq(b.brkey,2) as wateradeq_2
,bif.f_get_bif_wateradeq(b.brkey,3) as wateradeq_3
,bif.f_get_bif_wateradeq(b.brkey,4) as wateradeq_4
,bif.f_get_bif_wateradeq(b.brkey,5) as wateradeq_5
,u.sign_type_q1
,u.sign_type_q2
,u.sign_type_q3
,u.sign_type_q4
,bif.f_get_bif_inspecdata(b.brkey,'inspevnt','railrating')as railrating
,bif.f_get_bif_inspecdata(b.brkey,'inspevnt','transratin')as transratin
,bif.f_get_bif_inspecdata(b.brkey,'inspevnt','arailratin') as arailratin
,bif.f_get_bif_inspecdata(b.brkey,'inspevnt','aendrating') as aendrating
,to_char(round(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','aroadwidth_near')/.3048,1)) as aroadwidth_near
,to_char(round(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','aroadwidth_far')/.3048,1)) as aroadwidth_far
,f_get_paramtrs_equiv_long('userbrdg','grail_type',u.grail_type) as grailtype
,f_get_paramtrs_equiv_long('userbrdg','grail_end_treat',u.grail_end_treat) as grail_end_treat
,decode(u.grail_apr_lt,'Y','Yes','N','No','') as grail_apr_lt
,decode(u.grail_apr_rt,'Y','Yes','N','No','') as grail_apr_rt
,decode(u.grail_exit_lt,'Y','Yes','N','No','') as grail_exit_lt
,decode(u.grail_exit_rt,'Y','Yes','N','No','') as grail_exit_rt
,bif.f_get_bif_inspecdata(b.brkey,'inspevnt','scourcrit') as scourcritrate

,f_get_paramtrs_equiv('inspevnt','scourcrit',bif.f_get_bif_inspecdata(b.brkey,'inspevnt','scourcrit')) as scourcrit
,f_get_paramtrs_equiv_long('userrway','chan_prot',bif.f_get_bif_rdwydata(b.brkey,'22','userrway','chan_prot_left')) as chanprotleft
,f_get_paramtrs_equiv_long('userrway','chan_prot',bif.f_get_bif_rdwydata(b.brkey,'22','userrway','chan_prot_right')) as chanprotright

, case when b.vclrover/0.0254 > 3936 then
     'Unlimited'
     else trim(bif.f_meters_to_feet(b.vclrover/.0254))
       end AS vclr

 ,to_char(round( bif.f_get_bif_rdwydata(b.brkey,'1','roadway','roadwidth')/.3048,1)) roadwidth

 ,to_char(round(u.drainage_area/2.5899881,1)) as drainage_area

 ,case
   when attach_type_1 is null and     attach_type_2 is null and     attach_type_3 is null then
     'No Attachments'
     else f_get_paramtrs_equiv_long('userbrdg','attachments',u.attach_type_1)
       end as attach_1
 ,case when attach_type_2 in ('1','_') then ''
   else f_get_paramtrs_equiv_long('userbrdg','attachments',u.attach_type_2)
     end as attach_2
 ,case when attach_type_3 in ('1','_') then ''
 else f_get_paramtrs_equiv_long('userbrdg','attachments',u.attach_type_3)
   end as attach_3
, u.attach_desc_1
,u.attach_desc_2
,u.attach_desc_3

,to_char(u.avg_hi) as avg_hi

,case
 when nvl(bif.f_get_bif_inspecdate(b.brkey,'userinsp','spcl_last_insp'),'01-01-1901' ) <> '01-01-1901'
      then f_get_paramtrs_equiv_long('userinsp','spcl_insp_type',bif.f_get_bif_inspecdata(b.brkey,'userinsp','spcl_insp_type'))
        else 'Other Special Inspection'
          end as specialtag
,case
  when nvl(bif.f_get_bif_inspecdate(b.brkey,'userinsp','spcl_last_insp'),'01-01-1901') > '01-01-1902'
    then extract(year from to_date(bif.f_get_bif_inspecdate(b.brkey,'userinsp','spcl_last_insp'),'dd-mm-yyyy'))
      else to_number(null)
        end  as spcllastinsp


,case
when nvl(bif.f_get_bif_inspecdata(b.brkey,'userinsp','spcl_insp_freq'),0) > 0
  then to_char(bif.f_get_bif_inspecdata(b.brkey,'userinsp','spcl_insp_freq'))||' Year(s)'
    else ''
      end as spclfreq

,case
when trim(extract(year from to_date(nvl(bif.f_get_bif_inspecdate(b.brkey,'inspevnt','fcnextdate'),'01-01-1901'),'dd-mm-yyyy'))) not in ('1901',1902)
    then extract(year from to_date(bif.f_get_bif_inspecdate(b.brkey,'userinsp','spcl_next_insp'),'dd-mm-yyyy'))
      else to_number(null)
        end as spclnextinsp

 ,case
when trim(extract(year from to_date(bif.f_get_bif_inspecdate(b.brkey,'inspevnt','fclastinsp'),'dd-mm-yyyy'))) not in ('1901',1902) then
  to_date(bif.f_get_bif_inspecdate(b.brkey,'inspevnt','fclastinsp'),'dd-mm-yyyy')
  else to_number(null)
    end as fclastinsp


,decode(bif.f_get_bif_inspecdata(b.brkey,'inspevnt','fcinspreq'),'Y','Yes','N','') as fcinspreq

,case
 when trim(extract(year from to_date(bif.f_get_bif_inspecdate(b.brkey,'inspevnt','fcnextdate'),'dd-mm-yyyy'))) not in ('1901',1902) then
  extract(year from to_date(bif.f_get_bif_inspecdate(b.brkey,'inspevnt','fcnextdate'),'dd-mm-yyyy'))
   else to_number(null)
     end as fcnextdate

,case
when nvl(bif.f_get_bif_inspecdata(b.brkey,'userinsp','fcinspfreq_kdot'),0) > 0
  then to_char(bif.f_get_bif_inspecdata(b.brkey,'userinsp','fcinspfreq_kdot'))||' Year(s)'
    else ''
      end as fcintrvl

  ,case
when trim(extract(year from to_date(bif.f_get_bif_inspecdate(b.brkey,'inspevnt','oslastinsp'),'dd-mm-yyyy'))) not in ('1901',1902) then
 to_date(bif.f_get_bif_inspecdate(b.brkey,'inspevnt','oslastinsp'),'dd-mm-yyyy')
  else to_number(null)
    end as oslastinsp

,decode(bif.f_get_bif_inspecdata(b.brkey,'inspevnt','osinspreq'),'Y','Yes','N','') as osinspreq

,case
 when trim(extract(year from to_date(bif.f_get_bif_inspecdate(b.brkey,'inspevnt','osnextdate'),'dd-mm-yyyy'))) not in ('1901',1902) then
   extract(year from to_date(bif.f_get_bif_inspecdate(b.brkey,'inspevnt','osnextdate'),'dd-mm-yyyy'))
   else to_number(null)
     end as osnextdate

,case
when nvl(bif.f_get_bif_inspecdata(b.brkey,'userinsp','osinspfreq_kdot'),'0') > 0
  then to_char(bif.f_get_bif_inspecdata(b.brkey,'userinsp','osinspfreq_kdot'))||' Year(s)'
    else ''
  end as osinspfreq

  ,case
when trim(extract(year from to_date(bif.f_get_bif_inspecdate(b.brkey,'inspevnt','uwlastinsp'),'dd-mm-yyyy'))) not in ('1901',1902) then
 to_date(bif.f_get_bif_inspecdate(b.brkey,'inspevnt','uwlastinsp'),'dd-mm-yyyy')
  else to_number(null)
    end as uwlastinsp

,decode(bif.f_get_bif_inspecdata(b.brkey,'inspevnt','uwinspreq'),'Y','Yes','N','') as uwinspreq

 ,case
 when trim(extract(year from to_date(bif.f_get_bif_inspecdate(b.brkey,'inspevnt','uwnextdate'),'dd-mm-yyyy'))) not in ('1901',1902) then
   extract(year from to_date(bif.f_get_bif_inspecdate(b.brkey,'inspevnt','uwnextdate'),'dd-mm-yyyy'))
   else to_number(null)
     end as uwnextdate

,case
when nvl(bif.f_get_bif_inspecdata(b.brkey,'userinsp','uwinspfreq_kdot'),'0') > 0
  then to_char(bif.f_get_bif_inspecdata(b.brkey,'userinsp','uwinspfreq_kdot'))||' Year(s)'
    else ''
  end as uwinspfreq


 ,case
when trim(extract(year from to_date(bif.f_get_bif_inspecdate(b.brkey,'userinsp','snoop_last_insp'),'dd-mm-yyyy'))) not in ('1901',1902)
    then to_date(bif.f_get_bif_inspecdate(b.brkey,'userinsp','snoop_last_insp'),'dd-mm-yyyy')
            else to_number(null)
        end  as snooplastinsp

 ,case
when nvl(bif.f_get_bif_inspecdata(b.brkey,'userinsp','snoop_insp_freq'),0) > 0
  then to_char(bif.f_get_bif_inspecdata(b.brkey,'userinsp','snoop_insp_freq'))||' Year(s)'
    else ''
      end as snoopinspfreq

,case
  when trim(nvl(bif.f_get_bif_inspecdate(b.brkey,'userinsp','snoop_next_insp'),'01-01-1901')) not in ('01-01-1901','01-01-1902')
    then to_char(extract(year from to_date(bif.f_get_bif_inspecdate(b.brkey,'userinsp','snoop_next_insp'),'dd-mm-yyyy')))
     else ''
        end as snoopnextinsp

,f_get_paramtrs_equiv_long('userinsp','uwater_insp_typ',bif.f_get_bif_inspecdata(b.brkey,'userinsp','uwater_insp_typ')) as uwinsptype
,to_char(to_date(bif.f_get_bif_inspecdata(b.brkey,'inspevnt','inspdate')),'mm/dd/yy' )as inspdate
,to_char(bif.f_get_bif_inspecdata(b.brkey,'userinsp','brinspfreq_kdot'))||' Year(s)' as brinspfreq
,to_char(extract(year from to_date(bif.f_get_bif_inspecdata(b.brkey,'inspevnt','nextinsp'),'dd/mm/yy'))) as routinedate
,b.notes
,bif.f_get_bif_inspecdata(b.brkey,'userinsp','notes') as maint_notes
,bif.f_get_bif_inspecdata(b.brkey,'inspevnt','notes') as inspec_notes
,u.abcdlist_a
,u.abcdlist_a_notes
,u.abcdlist_b
,u.abcdlist_b_notes
,u.abcdlist_c
,u.abcdlist_c_notes
,u.abcdlist_d
,u.abcdlist_d_notes
,bif.f_get_bif_bromsprjs(b.brkey,'work_type') as work_type
,bif.f_get_bif_bromsprjs(b.brkey,'proj_num') as proj_num
,case
  when bif.f_get_bif_bromsprjs(b.brkey,'progyear') is null
    then ''
      else 'FY: '||bif.f_get_bif_bromsprjs(b.brkey,'progyear')
        end as progyear
,case
  when bif.f_get_bif_bromsprjs(b.brkey,'proj_status') is null
     then ''
       else 'Status: '||bif.f_get_bif_bromsprjs(b.brkey,'proj_status')
         end as proj_status
,bif.f_get_bif_bromsprjs(b.brkey,'bif_new_ser') as new_ser
,kta_insp
,'Y' as reporta
,case
 when
   ((substr(b.brkey,4,1) <> '5' and f_get_bif_inspecdata(b.brkey,'userinsp','brinspfreq_kdot') in ('0','1','2')) or
             (substr(b.brkey,4,1) = '5' and f_get_bif_inspecdata(b.brkey,'userinsp','brinspfreq_kdot') in ('1')))
             then 'Y'
               else 'N'
                 end as reportb,
case
  when
       ((substr(b.brkey,4,1) <> '5' and f_get_bif_inspecdata(b.brkey,'userinsp','brinspfreq_kdot') = '1') or
        (substr(b.brkey,4,1) = '5')) then 'Y'
        else 'N'
          end as reportc
,case
 when   ((substr(b.brkey,4,1)<> '5' and f_get_bif_inspecdata(b.brkey,'userinsp','brinspfreq_kdot') = '1' ) or
             (substr(b.brkey,4,1) = '5' and f_get_bif_inspecdata(b.brkey,'userinsp','brinspfreq_kdot') in ('1','2')))
             then 'Y'
               else 'N'
                 end as reportd
from bridge b, userbrdg u
where u.brkey = b.brkey
     and  b.district <> '9';