CREATE OR REPLACE FORCE VIEW pontis.v_bif_underclearances (brkey,on_under,clr_route,vert_undr_sign,route_prefix,route_num,direction_1,direction_2,vclr_1,vclr_2,vclr_1_minus3,vclr_2_minus3,hclr_1,hclr_2,hclrurt_1,hclrurt_2,hclrult_3,hclrult_4,feat_cross_type,road_cross_name_1,road_cross_name_2,sign_1,sign_2,"LOCATION",adminarea,vc_date) AS
select bridge.brkey,
       userrway.on_under,
       userrway.clr_route,
       userbrdg.vert_undr_sign,
       userrway.route_prefix,
       userrway.route_num,
       case when vclr_n > 0
         then 'NB'
         when vclr_e > 0
           then 'EB'
             else ''
         end as direction_1,
       case when vclr_w > 0
         then 'WB'
           when vclr_s > 0
             then 'SB'
         else ''
         end as direction_2,
       case when vclr_n is null or vclr_n = 0
         then trim(bif.f_meters_to_feet(vclr_e/.0254))
         else trim(bif.f_meters_to_feet(vclr_n/.0254))
         end as vclr_1,
       case when vclr_s is null or vclr_s = 0
         then trim(bif.f_meters_to_feet(vclr_w/.0254))
         else trim(bif.f_meters_to_feet(vclr_s/.0254))
         end as vclr_2,
 case when vclr_n is null or vclr_n = 0
         then trim(bif.f_meters_to_feet((vclr_e-.0762)/.0254))
         else trim(bif.f_meters_to_feet((vclr_n-.0762)/.0254))
         end as vclr_1_minus3,
       case when vclr_s is null or vclr_s = 0
         then trim(bif.f_meters_to_feet((vclr_w-.0762)/.0254))
         else trim(bif.f_meters_to_feet((vclr_s-.0762)/.0254))
         end as vclr_2_minus3,


       case when hclr_n is null or hclr_n = 0
         then trim(bif.f_meters_to_feet(hclr_e/.0254))
         else trim(bif.f_meters_to_feet(hclr_n/.0254))
         end as hclr_1,
       case when hclr_s is null or hclr_s = 0
         then trim(bif.f_meters_to_feet(hclr_w/.0254))
         else trim(bif.f_meters_to_feet(hclr_s/.0254))
         end as hclr_2,
       case when hclrurt_n is null or hclrurt_n <= 0.0
         then trim(bif.f_meters_to_feet(hclrurt_e/.0254))
         else trim(bif.f_meters_to_feet(hclrurt_n/.0254))
         end as hclrurt_1,
       case when hclrurt_s is null or hclrurt_s <= 0.0
         then trim(bif.f_meters_to_feet(hclrurt_w/.0254))
         else trim(bif.f_meters_to_feet(hclrurt_s/.0254))
         end as hclrurt_2,
       case when hclrult_n is null or hclrult_n <= 0.0
         then trim(bif.f_meters_to_feet(hclrult_e/.0254))
         else trim(bif.f_meters_to_feet(hclrult_n/.0254 ))
         end as hclrult_3,
       case when hclrult_s is null or hclrult_s <= 0.0
         then trim(bif.f_meters_to_feet(hclrult_w/.0254))
         else trim(bif.f_meters_to_feet(hclrult_s/.0254))
         end as hclrult_4,
       feat_cross_type,
       (select distinct road_cross_name
         from userrway r
         where r.brkey = userrway.brkey and
               r.on_under = userrway.on_under) road_cross_name_1,
        '                             ' road_cross_name_2,
       case when vclr_n_sign is null or vclr_n_sign <= 0.0
         then trim(bif.f_meters_to_feet(vclr_e_sign/.0254))
         else trim(bif.f_meters_to_feet(vclr_n_sign/.0254))
         end sign_1,
       case when vclr_s_sign is null or vclr_s_sign <= 0.0
       then trim(bif.f_meters_to_feet(vclr_w_sign/.0254))
       else trim(bif.f_meters_to_feet(vclr_s_sign/.0254))
       end sign_2,
       location,
       adminarea,
       vc_date

from pontis.bridge, pontis.userrway, pontis.userbrdg
where bridge.brkey = userrway.brkey and
      bridge.brkey = userbrdg.brkey and
      bridge.district <> '9' and
      userrway.feat_cross_type in ('10','4','30','50','51','70','90')
;