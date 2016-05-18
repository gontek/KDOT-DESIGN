CREATE OR REPLACE FORCE VIEW pontis.nbip_view_on (brkey,distarea,maintainer,nbi_8,fc_97_98,nbi_1,nbi_5a,nbi_5b,nbi_5c,nbi_5d,nbi_5e,nbi_2,nbi_3,nbi_4,nbi_6a,nbi_6b,nbi_7,nbi_9,nbi_10,nbi_11,nbi_12,nbi_13a,nbi_13b,nbi_16,nbi_17,nbi_19,nbi_20,nbi_21,nbi_22,nbi_26,nbi_27,nbi_28a,nbi_28b,nbi_29,nbi_30,nbi_31,nbi_32,nbi_33,nbi_34,nbi_35,nbi_36a,nbi_36b,nbi_36c,nbi_36d,nbi_37,nbi_38,nbi_39,nbi_40,nbi_41,nbi_42a,nbi_42b,nbi_43a,nbi_43b,nbi_44a,nbi_44b,nbi_45,nbi_46,nbi_47,nbi_48,nbi_49,nbi_50a,nbi_50b,nbi_51,nbi_52,nbi_53,nbi_54a,nbi_54b,nbi_55a,nbi_55b,nbi_56,nbi_58,nbi_59,nbi_60,nbi_61,nbi_62,nbi_63,nbi_64,nbi_65,nbi_66,nbi_67,nbi_68,nbi_69,nbi_70,nbi_71,nbi_72,nbi_75a,nbi_75b,nbi_76,nbi_90,nbi_91,nbi_92a,nbi_92b,nbi_92c,nbi_93a,nbi_93b,nbi_93c,nbi_94,nbi_95,nbi_96,nbi_97,nbi_98a,nbi_98b,nbi_99,nbi_100,nbi_101,nbi_102,nbi_103,nbi_104,nbi_105,nbi_106,nbi_107,nbi_108a,nbi_108b,nbi_108c,nbi_109,nbi_110,nbi_111,nbi_112,nbi_113,nbi_114,nbi_115,nbi_116) AS
select b.brkey,
b.adminarea -- distarea
,us.custodian_kdot -- maintainer --used to include/exclude structures,
,b.struct_num        -- the current NBI_8 number and new NBI_8 number are recorded
,nbip.f_get_fc_97_98(b.brkey) -- fc_97_98--is this a buried bridge?
,b.fips_state||b.fhwa_regn -- NBI_1 state code,
--,nbip.f_check_nbi_8(b.brkey) -- to send to FHWA when old struct_num changes (route or jurisdiction changes)
,r.on_under -- nbi_5a,
,r.kind_hwy -- NBI_5B
,r.levl_srvc --   NBI_5C
,r.routenum -- nbi_5d
,r.dirsuffix   --nbi_5e
,b.adminarea -- nbi_2
,b.county --nbi_3
,b.placecode --  NBI_4
,b.featint -- NBI_6A,
,'' -- NBI_6B, -- supposed to be null
,b.facility -- NBI_7,
,b.location -- NBI_9,
,to_char(lpad(trunc(vclrinv*100),4,'0')) -- NBI_10
,nvl(lpad(round(r.kmpost*1000),7,'0' ),'0000000')--  NBI_11
,nvl(r.onbasenet,'') -- NBI_12
,nvl(r.lrsinvrt,'          ') -- NBI_13A
,nvl(r.subrtnum,' ')  -- nbi_13b
,f_latlong_to_minutes(us.kdot_latitude) --   NBI_16
,f_latlong_to_minutes(us.kdot_longitude) --  NBI_17
,lpad(round(r.bypasslen),3,'0') -- NBI_19
,r.tollfac --  NBI_20
,lpad(b.custodian,2,'0') --   NBI_21
,lpad(b.owner,2,'0') --   NBI_22
,lpad(r.funcclass,2,'0') --   NBI_26
,b.yearbuilt -- NBI_27
,r.lanes --  NBI_28A
,b.sumlanes --  NBI_28B -- sum of ALL lanes under
,r.adttotal -- NBI_29
,r.adtyear -- NBI_30
,decode(b.designload,'8','0',b.designload) --  NBI_31, -- checked (on-records only)
,round(r.aroadwidth*10) -- NBI_32
,nvl(b.bridgemed,'0') --  NBI_33
,nvl(round(b.skew+round(trunc(nvl(us.skew_minutes,0.0)/60,2))),0) -- NBI_34, --shewee...checked and works!
,b.strflared -- NBI_35, -- checked
,i.railrating -- NBI_36A, -- checked
,i.transratin -- NBI_36B, -- checked
,i.arailratin -- NBI_36C, -- checked
,i.aendrating --  NBI_36D, -- checked
,b.histsign --  NBI_37, -- checked
,b.navcntrol--  NBI_38, -- checked
,ltrim(to_char(trunc(b.navvc*10),'0000')) -- NBI_39,
,ltrim(to_char(trunc(b.navhc*10),'00000')) -- NBI_40,
,i.oppostcl --  NBI_41, -- checked
,b.servtypon --  NBI_42A, -- checked
,b.servtypund --  NBI_42B, -- checked
,b.materialmain -- NBI_43A, -- checked
,b.designmain --  NBI_43B, -- checked
,b.materialappr -- NBI_44A , -- checked
,b.designappr --  NBI_44B, --  checked
,lpad(b.mainspans,3,'000') --  NBI_45,
,lpad(b.appspans,4,'0000') --  NBI_46
,lpad(ltrim(trunc(r.hclrinv*10)),3,'000') --  NBI_47
,lpad(round(b.maxspan*10),5,'0') --  NBI_48
,lpad(round(b.length*10),6,'0') --  NBI_49
,nvl(lpad(round(b.lftcurbsw*10),3,'0'),'000') --  NBI_50A
,nvl(lpad(round(b.rtcurbsw*10),3,'0'),'000') --   NBI_50B
,substr(nbip.f_get_nbi_51_52(r.brkey),1,4) --  NBI_51
,substr(nbip.f_get_nbi_51_52(r.brkey),5,4) --  NBI_52
,trunc(b.vclrover*100) --  NBI_53
,b.refvuc -- NBI_54A
,lpad(ltrim(trunc(b.vclrunder*100,0)),4,'0000') -- NBI_54B
,b.refhuc -- NBI_55A
,ltrim(to_char(b.hclrurt*10,'000')) --  NBI_55b
,ltrim(to_char(b.hclrult*10,'000')) -- NBI_56
,i.dkrating --  NBI_58 ,
,i.suprating -- NBI_59 ,
,i.subrating -- NBI_60 ,
,i.chanrating --  NBI_61 ,
,i.culvrating -- NBI_62 ,
,b.ortype --  NBI_63,
,case
 when b.ortype = '8'
   and us.orload_hl93 > 3
   then '300'
   when b.ortype = '8' and us.orload_hl93 <= 3
   then lpad(round(us.orload_hl93*100),3,'0')
   else lpad(round(b.orload*10),3,'0')
     end as orload -- NBI_64 ,
,b.irtype --  NBI_65 ,
,case
when b.irtype = '8'
  then lpad(round(us.irload_hl93*100),3,'0')
    else lpad(round(b.irload*10),3,'0') --  NBI_66 ,
    end as irload
,i.strrating --  NBI_67,
,i.deckgeom -- NBI_68 ,
,i.underclr --   NBI_69 ,
,b.posting --   NBI_70,
,i.wateradeq --  NBI_71 ,
,i.appralign --   NBI_72,
,b.propwork --  NBI_75A,
,b.workby --  NBI_75B ,
,lpad(round(b.implen,1)*10,6,'0') --   NBI_76 ,
,to_char(i.inspdate,'MMYY') --  NBI_90,
,decode(ui.brinspfreq_kdot,1,23,99,23,ui.brinspfreq_kdot*12) --  NBI_91,
,substr(nbip.f_check_nbi_92_93(b.brkey),0,3) -- NBI_92A ,
,substr(nbip.f_check_nbi_92_93(b.brkey),4,3) -- NBI_92B ,
,substr(nbip.f_check_nbi_92_93(b.brkey),7,3) --  NBI_92C ,
,substr(nbip.f_check_nbi_92_93(b.brkey),10,4) --  NBI_93A ,
,substr(nbip.f_check_nbi_92_93(b.brkey),14,4)--  NBI_93B ,
,substr(nbip.f_check_nbi_92_93(b.brkey),18,4) --  NBI_93C ,
,lpad(to_char(b.nbiimpcost/1000),6,'0') --  NBI_94  ,
,lpad(to_char(b.nbirwcost/1000),6,'0') --  NBI_95 ,
,lpad(to_char(b.nbitotcost/1000),6,'0') --  NBI_96,
,b.nbiyrcost --   NBI_97 ,
,b.nstatecode||b.n_fhwa_reg --  NBI_98A ,
,b.bb_pct --  NBI_98B ,
,b.bb_brdgeid --  NBI_99 ,
,nvl(r.defhwy,'0')--  NBI_100 ,
,b.paralstruc --  NBI_101,
,r.trafficdir --  NBI_102 ,
,b.tempstruc --  NBI_103,
,r.nhs_ind --   NBI_104,
,r.fedlandhwy -- NBI_105 ,
,b.yearrecon --  NBI_106,
,b.dkstructyp --   NBI_107 ,
,b.dksurftype --  NBI_108A,
,b.dkmembtype --  NBI_108B,
,b.dkprotect --  NBI_108C ,
,nbip.f_check_nbi_109_on(r.brkey) --   NBI_109 ,
,r.trucknet --  NBI_110,
,decode(b.navcntrol,'1','1',null)--  NBI_111 ,
,b.nbislen --  NBI_112 ,
,i.scourcrit --  NBI_113,
, r.adtfuture -- NBI_114 ,
, to_char(to_number(to_char(sysdate,'YYYY'))+19) --  NBI_115 ,
, '    ' --  NBI_116
from bridge b, roadway r, inspevnt i, userinsp ui,mv_latest_inspection mv, userbrdg us
     where
    substr(b.brkey,4,1) <> '5' and
     -- b.adminarea = '24' and
      r.brkey = b.brkey and
      r.on_under = (select min(on_under) from roadway ri
      where ri.brkey = r.brkey) and
      i.brkey = b.brkey and
      ui.brkey = b.brkey and
      mv.brkey = b.brkey and
      us.brkey = b.brkey and
      i.inspkey = mv.inspkey and
      ui.inspkey = mv.inspkey and
      us.function_type in ('10','30','50','51','70')
   and ui.oppostcl_kdot <> '5'
     and b.district <> '9'
    and us.custodian_kdot not in ('12','4')
   and nbip.f_get_fc_97_98(b.brkey) = 'N' -- not a buried or pavement slab bridge
    and decode(ui.brinspfreq_kdot,1,23,99,23,ui.brinspfreq_kdot*12)<>0
;