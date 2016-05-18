CREATE OR REPLACE FORCE VIEW pontis.tbl_abcdlist ("LIST",brkey,bridge_id,maint_rte_num,maint_rte_sort,design_ref_post,adminarea,district,maint_area,avg_hi,suff_rate,nbi_rating,priority_opt_1,brinspfreq_kdot,brdg_culv,abcdlist_a,abcdlist_a_notes,abcdlist_b,abcdlist_b_notes,abcdlist_c,abcdlist_c_notes,abcdlist_d,abcdlist_d_notes,notes,fedfundelig,last_paint_supe,paint_cond,suprstruct_tos,super_paint_sys,kta_insp,kta_no,kta_id,strtype,num_girders_main) AS
(

select 'A' as LIST,
       bridge.brkey,
       bridge.bridge_id,
          to_number(userrway.maint_rte_num) as maint_rte_num,
         userrway.maint_rte_num as maint_rte_sort,
         userbrdg.design_ref_post,
       bridge.adminarea,
       bridge.district,
       userbrdg.maint_area,
     --   inspevnt.notes,
         userbrdg.avg_hi,
         inspevnt.suff_rate,
         inspevnt.nbi_rating,
         userinsp.priority_opt * 10000 as priority_opt_1,
         userinsp.brinspfreq_kdot,
         substr(bridge.brkey,4,1) as brdg_culv,
         userbrdg.abcdlist_a,
         userbrdg.abcdlist_a_notes,
         userbrdg.abcdlist_b,
         userbrdg.abcdlist_b_notes,
         userbrdg.abcdlist_c,
         userbrdg.abcdlist_c_notes,
         userbrdg.abcdlist_d,
         userbrdg.abcdlist_d_notes,
         userbrdg.notes as notes,

case
         when suff_rate between 0 and 50 and nbi_rating in ('1','2')
           then 'BR'
         when suff_rate > 50 and nbi_rating in ('1','2') then
           'BH'
       else 'NE'
       End as FedFundElig,
       userbrdg.last_paint_supe,
       userinsp.paint_cond,
       round(userbrdg.suprstruct_tos / .9072,2) as suprstruct_tos,
       decode(userbrdg.super_paint_sys,'0','N/A',
'1','Unknown',
'2', 'Weathering',
'3','Gunnite',
'4','Aluminum',
'5','Lead',
'6','IZV',
'7','OZV',
'8','Galvanized',
'9','Epoxy',
'10','None',
'11','Barium',
'12','OZWA',
'13','IZWA',
'14','Epoxy Poly',
'15','Basic Lead/Calc',
'16','Red Lead/Calc',
'17','MCUM','')as super_paint_sys,
kta_insp,
kta_no,
kta_id,
f_structuretype_main(bridge.brkey)strtype,
f_num_girders_main(bridge.brkey) num_girders_main
    FROM bridge,
         userbrdg,
         userrway,
          userinsp,
         inspevnt,
         mv_latest_inspection
   WHERE userbrdg.brkey = bridge.brkey and
         userrway.brkey = bridge.brkey and
      userrway.on_under = (select min(on_under) from userrway r
          where r.brkey = userrway.brkey) and
         userinsp.brkey = bridge.brkey and
         inspevnt.brkey = bridge.brkey and
         mv_latest_inspection.brkey = bridge.brkey and
         inspevnt.inspkey = userinsp.inspkey and
      inspevnt.inspkey = mv_latest_inspection.inspkey
      -- and userinsp.brinspfreq_kdot not in (99, -1)
            and ( userbrdg.abcdlist_a = 'Y')and
            bridge.district <> '9'
       UNION ALL
       select 'B' as LIST,
              bridge.brkey,
              bridge.bridge_id,
            to_number(userrway.maint_rte_num) as maint_rte_num,
           userrway.maint_rte_num as maint_rte_sort,
         userbrdg.design_ref_post,
      bridge.adminarea,
       bridge.district,
       userbrdg.maint_area,
   --    inspevnt.notes,
         userbrdg.avg_hi,
         inspevnt.suff_rate,
         inspevnt.nbi_rating,
         userinsp.priority_opt * 10000 as priority_opt_1,
         userinsp.brinspfreq_kdot,
         substr(bridge.brkey,4,1) as brdg_culv,
         userbrdg.abcdlist_a,
         userbrdg.abcdlist_a_notes,
         userbrdg.abcdlist_b,
         userbrdg.abcdlist_b_notes,
         userbrdg.abcdlist_c,
         userbrdg.abcdlist_c_notes,
         userbrdg.abcdlist_d,
         userbrdg.abcdlist_d_notes,
         userbrdg.notes as notes,

case
         when suff_rate between 0 and 50 and nbi_rating in ('1','2')
           then 'BR'
         when suff_rate > 50 and nbi_rating in ('1','2') then
           'BH'
       else 'NE'
       End as FedFundElig,
       userbrdg.last_paint_supe,
       userinsp.paint_cond,
       round(userbrdg.suprstruct_tos / .9072,2) as suprstruct_tos,
       decode(userbrdg.super_paint_sys,'0','N/A',
'1','Unknown',
'2', 'Weathering',
'3','Gunnite',
'4','Aluminum',
'5','Lead',
'6','IZV',
'7','OZV',
'8','Galvanized',
'9','Epoxy',
'10','None',
'11','Barium',
'12','OZWA',
'13','IZWA',
'14','Epoxy Poly',
'15','Basic Lead/Calc',
'16','Red Lead/Calc',
'17','MCUM','')as super_paint_sys,
kta_insp,
kta_no,
kta_id,
f_structuretype_main(bridge.brkey) strtype,
f_num_girders_main(bridge.brkey) num_girders_main
    FROM bridge,
         userbrdg,
         userrway,
         userinsp,
         inspevnt,
         mv_latest_inspection
   WHERE userbrdg.brkey = bridge.brkey and
         userrway.brkey = bridge.brkey and
      userrway.on_under = (select min(on_under) from userrway r
          where r.brkey = userrway.brkey) and
         userinsp.brkey = bridge.brkey and
         inspevnt.brkey = bridge.brkey and
         mv_latest_inspection.brkey = bridge.brkey and
         inspevnt.inspkey = userinsp.inspkey and
      inspevnt.inspkey = mv_latest_inspection.inspkey
   -- and  userinsp.brinspfreq_kdot not in (99, -1)
            and ( userbrdg.abcdlist_b = 'Y')
            and bridge.district <> '9'
UNION ALL
select 'C' as list,
       bridge.brkey,
       bridge.bridge_id,
            to_number(userrway.maint_rte_num) as maint_rte_num,
           userrway.maint_rte_num as maint_rte_sort,
         userbrdg.design_ref_post,
      bridge.adminarea,
       bridge.district,
       userbrdg.maint_area,
    --   inspevnt.notes,
         userbrdg.avg_hi,
         inspevnt.suff_rate,
         inspevnt.nbi_rating,
         userinsp.priority_opt * 10000 as priority_opt_1,
         userinsp.brinspfreq_kdot,
         substr(bridge.brkey,4,1) as brdg_culv,
         userbrdg.abcdlist_a,
         userbrdg.abcdlist_a_notes,
         userbrdg.abcdlist_b,
         userbrdg.abcdlist_b_notes,
         userbrdg.abcdlist_c,
         userbrdg.abcdlist_c_notes,
         userbrdg.abcdlist_d,
         userbrdg.abcdlist_d_notes,
         userbrdg.notes as notes,

case
         when suff_rate between 0 and 50 and nbi_rating in ('1','2')
           then 'BR'
         when suff_rate > 50 and nbi_rating in ('1','2') then
           'BH'
       else 'NE'
       End as FedFundElig,
       userbrdg.last_paint_supe,
       userinsp.paint_cond,
       round(userbrdg.suprstruct_tos / .9072,2) as suprstruct_tos,
       decode(userbrdg.super_paint_sys,'0','N/A',
'1','Unknown',
'2', 'Weathering',
'3','Gunnite',
'4','Aluminum',
'5','Lead',
'6','IZV',
'7','OZV',
'8','Galvanized',
'9','Epoxy',
'10','None',
'11','Barium',
'12','OZWA',
'13','IZWA',
'14','Epoxy Poly',
'15','Basic Lead/Calc',
'16','Red Lead/Calc',
'17','MCUM','')as super_paint_sys,
kta_insp,
kta_no,
kta_id,
f_structuretype_main(bridge.brkey) strtype,
f_num_girders_main(bridge.brkey) num_girders_main
    FROM bridge,
         userbrdg,
         userrway,
         userinsp,
         inspevnt,
         mv_latest_inspection
   WHERE userbrdg.brkey = bridge.brkey and
         userrway.brkey = bridge.brkey and
      userrway.on_under = (select min(on_under) from userrway r
          where r.brkey = userrway.brkey) and
         userinsp.brkey = bridge.brkey and
         inspevnt.brkey = bridge.brkey and
         mv_latest_inspection.brkey = bridge.brkey and
         inspevnt.inspkey = userinsp.inspkey and
      inspevnt.inspkey = mv_latest_inspection.inspkey
  --  and  userinsp.brinspfreq_kdot not in (99, -1)
            and ( userbrdg.abcdlist_c = 'Y')
            and bridge.district <> '9'
UNION ALL
select 'D' as list,
       bridge.brkey,
       bridge.bridge_id,
          to_number(userrway.maint_rte_num) as maint_rte_num,
           userrway.maint_rte_num as maint_rte_sort,
         userbrdg.design_ref_post,
      bridge.adminarea,
       bridge.district,
       userbrdg.maint_area,
     --    inspevnt.notes,
         userbrdg.avg_hi,
         inspevnt.suff_rate,
         inspevnt.nbi_rating,
         userinsp.priority_opt * 10000 as priority_opt_1,
         userinsp.brinspfreq_kdot,
         substr(bridge.brkey,4,1) as brdg_culv,
         userbrdg.abcdlist_a,
         userbrdg.abcdlist_a_notes,
         userbrdg.abcdlist_b,
         userbrdg.abcdlist_b_notes,
         userbrdg.abcdlist_c,
         userbrdg.abcdlist_c_notes,
         userbrdg.abcdlist_d,
         userbrdg.abcdlist_d_notes,
         userbrdg.notes as notes,

case
         when suff_rate between 0 and 50 and nbi_rating in ('1','2')
           then 'BR'
         when suff_rate > 50 and nbi_rating in ('1','2') then
           'BH'
       else 'NE'
       End as FedFundElig,
       userbrdg.last_paint_supe,
       userinsp.paint_cond,
       round(userbrdg.suprstruct_tos / .9072,2) as suprstruct_tos,
       decode(userbrdg.super_paint_sys,'0','N/A',
'1','Unknown',
'2', 'Weathering',
'3','Gunnite',
'4','Aluminum',
'5','Lead',
'6','IZV',
'7','OZV',
'8','Galvanized',
'9','Epoxy',
'10','None',
'11','Barium',
'12','OZWA',
'13','IZWA',
'14','Epoxy Poly',
'15','Basic Lead/Calc',
'16','Red Lead/Calc',
'17','MCUM','')as super_paint_sys,
kta_insp,
kta_no,
kta_id,
f_structuretype_main(bridge.brkey) strtype,
f_num_girders_main(bridge.brkey) num_girders_main
    FROM bridge,
         userbrdg,
         userrway,
         userinsp,
         inspevnt,
         mv_latest_inspection
   WHERE userbrdg.brkey = bridge.brkey and
         userrway.brkey = bridge.brkey and
      userrway.on_under = (select min(on_under) from userrway r
          where r.brkey = userrway.brkey) and
         userinsp.brkey = bridge.brkey and
         inspevnt.brkey = bridge.brkey and
         mv_latest_inspection.brkey = bridge.brkey and
         inspevnt.inspkey = userinsp.inspkey and
      inspevnt.inspkey = mv_latest_inspection.inspkey
 -- and    userinsp.brinspfreq_kdot not in (99, -1)
            and ( userbrdg.abcdlist_d = 'Y')
            and bridge.district <> '9'
)

 ;