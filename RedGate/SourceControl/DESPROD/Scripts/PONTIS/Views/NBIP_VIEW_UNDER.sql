CREATE OR REPLACE FORCE VIEW pontis.nbip_view_under (brkey,distarea,maintainer,nbi_8,fc_97_98,nbi_1,nbi_5a,nbi_5b,nbi_5c,nbi_5d,nbi_5e,nbi_2,nbi_3,nbi_4,nbi_6a,nbi_6b,nbi_7,nbi_9,nbi_10,nbi_11,nbi_12,nbi_13a,nbi_13b,nbi_16,nbi_17,nbi_19,nbi_20,nbi_21,nbi_22,nbi_26,nbi_27,nbi_28a,nbi_28b,nbi_29,nbi_30,nbi_31,nbi_32,nbi_33,nbi_34,nbi_35,nbi_36a,nbi_36b,nbi_36c,nbi_36d,nbi_37,nbi_38,nbi_39,nbi_40,nbi_41,nbi_42a,nbi_42b,nbi_43a,nbi_43b,nbi_44a,nbi_44b,nbi_45,nbi_46,nbi_47,nbi_48,nbi_49,nbi_50a,nbi_50b,nbi_51,nbi_52,nbi_53,nbi_54a,nbi_54b,nbi_55a,nbi_55b,nbi_56,nbi_58,nbi_59,nbi_60,nbi_61,nbi_62,nbi_63,nbi_64,nbi_65,nbi_66,nbi_67,nbi_68,nbi_69,nbi_70,nbi_71,nbi_72,nbi_75a,nbi_75b,nbi_76,nbi_90,nbi_91,nbi_92a,nbi_92b,nbi_92c,nbi_93a,nbi_93b,nbi_93c,nbi_94,nbi_95,nbi_96,nbi_97,nbi_98a,nbi_98b,nbi_99,nbi_100,nbi_101,nbi_102,nbi_103,nbi_104,nbi_105,nbi_106,nbi_107,nbi_108a,nbi_108b,nbi_108c,nbi_109,nbi_110,nbi_111,nbi_112,nbi_113,nbi_114,nbi_115,nbi_116) AS
select b.brkey
,b.adminarea   -- distarea
,us.custodian_kdot -- maintainer --used to include/exclude structures,
,b.struct_num --  NBI_8,
,nbip.f_get_fc_97_98(b.brkey)-- is this a buried bridge
,b.fips_state||b.fhwa_regn -- NBI_1,
--,nbip.f_check_nbi_8(b.brkey)-- new NBI_8
,r.on_under -- nbi_5a,
,r.kind_hwy --  NBI_5B  ,
,r.levl_srvc --   NBI_5C  ,
,r.routenum -- nbi_5D,
,r.dirsuffix --  NBI_5E  ,
,b.adminarea -- NBI_2,
,b.county --  NBI_3,
,b.placecode --  NBI_4 ,
,b.featint -- NBI_6A,
,null -- NBI_6B,
,b.facility -- NBI_7,
,b.location -- NBI_9,
,to_char(lpad(trunc(vclrinv*100),4,'0')) -- NBI_10
,nvl(lpad(round(r.kmpost*1000),7,'0' ),'0000000')--  NBI_11
,nvl(r.onbasenet,'') -- NBI_12 ,
,nvl(r.lrsinvrt,'          ') --  NBI_13A ,
,nvl(r.subrtnum,' ') --  NBI_13B,
,f_latlong_to_minutes(us.kdot_latitude) --   NBI_16, -- checked
,f_latlong_to_minutes(us.kdot_longitude) --  NBI_17 , -- checked
,lpad(round(r.bypasslen),3,'0') --  NBI_19 , -- checked
,r.tollfac --  NBI_20 , -- checked
,null -- NBI_21 , -- checked..on_unders null
,null -- NBI_22 , -- checked..under records null
,lpad(r.funcclass,2,'0') --  NBI_26 , -- checked
,yearbuilt --  NBI_27,
,r.lanes --  NBI_28A, -- checked
,u.totlanes --  NBI_28B -- sum of only the lane this row is for---
,r.adttotal --  NBI_29,
,nvl(r.adtyear,extract(year from sysdate)) --  NBI_30,
,null --  NBI_31,
,null -- NBI_32,
,null --  NBI_33,
,null --  NBI_34,
,null --  NBI_35,
,null --  NBI_36A,
,null --  NBI_36B,
,null --  NBI_36C,
,null --  NBI_36D,
,null --  NBI_37,
,null --  NBI_38,
,null -- NBI_39 ,
,null -- NBI_40 ,
,null --  NBI_41,
,b.servtypon --  NBI_42A, -- same -- on_record
,b.servtypund --  NBI_42B, -- same -- on_record
,b.materialmain --  NBI_43A,
,b.designmain --  NBI_43B,
,null -- NBI_44A ,
,null -- NBI_44B,
,null --  NBI_45,
,null --  NBI_46 ,
,lpad(ltrim(trunc(r.hclrinv*10)),3,'000') --  NBI_47,
,lpad(round(b.maxspan*10),5,'0') --  NBI_48 ,
,lpad(round(b.length*10),6,'0') --  NBI_49,
,to_number(null) --  NBI_50A,
,to_number(null) --   NBI_50B,
,to_number(null) --  NBI_51,
,to_number(null) -- NBI_52,
,null --  NBI_53,
,null -- NBI_54A ,
,null --  NBI_54B ,
,null --  NBI_55A ,
,null -- NBI_55B,
,null --  NBI_56,
,null --  NBI_58 ,
,null -- NBI_59 ,
,null -- NBI_60 ,
,null --  NBI_61 ,
,null --  NBI_62 ,
,null --  NBI_63,
--,case
-- when b.ortype = '8'
--   then lpad(round(us.orload_hl93*100),3,'0')
--   else lpad(round(b.orload*10),3,'0')
--     end as orload --  NBI_64 ,
,null --  NBI_64,
,null --  NBI_65 ,
--,case
--when b.irtype = '8'
--  then lpad(round(us.irload_hl93*100),3,'0')
--    else lpad(round(b.irload*10),3,'0') --  NBI_66 ,
--    end as irload
,null -- NBI_66
,null --  NBI_67,
,null --  NBI_68 ,
,null --   NBI_69 ,
,to_number(NULL) -- NBI_70,
,null --  NBI_71 ,
,null --   NBI_72,
,null --  NBI_75A,
,null --  NBI_75B ,
,null --   NBI_76 ,
,null -- NBI_90,
,null --  NBI_91,
,null -- NBI_92A ,
,null -- NBI_92B ,
,null --  NBI_92C ,
,null --  NBI_93A ,
,null --  NBI_93B ,
,null --   NBI_93C ,
,null --  NBI_94  ,
,null --  NBI_95 ,
,null --  NBI_96,
,null --   NBI_97 ,
,null --  NBI_98A ,
,null --  NBI_98B ,
,null --  NBI_99 ,
,nvl(r.defhwy,'0') --  NBI_100 ,
,b.paralstruc --  NBI_101,
,r.trafficdir --  NBI_102 ,
,b.tempstruc --  NBI_103,
,r.nhs_ind --   NBI_104,
,null --  NBI_105 ,
,null --  NBI_106,
,null --   NBI_107 ,
,null --  NBI_108A,
,null --  NBI_108B,
,null --  NBI_108C ,
,nbip.f_check_nbi_109_undr(r.brkey, r.on_under) --   NBI_109 ,
,r.trucknet --  NBI_110,
,null --  NBI_111 ,
,null --  NBI_112 ,
,null --  NBI_113,
,to_number(null) -- NBI_114 ,
,null --  NBI_115 ,
,'    ' --  NBI_116
from bridge b, roadway r, userrway u, userinsp ui,inspevnt i, userbrdg us,mv_latest_inspection mv
where  substr(b.brkey,4,1) <> '5' and
       r.brkey = b.brkey and
 --   b.yearbuilt <> '1000' and
   --   r.nbi_rw_flag = '1' and -- flag is set to '0' if custodian_kdot in ('12','4'), feature_crossed = 97-Buried or 98_slab
      u.brkey = b.brkey and      --  or bridge inspection frequency = '0'
      u.on_under = r.on_under and
      u.feat_cross_type in ('10','30','50','51') and
      i.brkey = b.brkey and
      ui.brkey = b.brkey and
      ui.inspkey = mv.inspkey and
      mv.brkey = b.brkey and
      i.inspkey = mv.inspkey and
      us.brkey = b.brkey and
   ui.oppostcl_kdot <> '5'
    and b.district <> '9'
   and us.custodian_kdot not in ('12','4')
    and nbip.f_get_fc_97_98(b.brkey) = 'N' -- not a buried or pavement slab bridge
;