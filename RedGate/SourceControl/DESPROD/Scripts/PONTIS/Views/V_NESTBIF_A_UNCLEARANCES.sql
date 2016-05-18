CREATE OR REPLACE FORCE VIEW pontis.v_nestbif_a_unclearances (brkey,on_under,clr_route,vert_undr_sign,route_prefix,route_num,direction_1,direction_2,vclr_1,vclr_2,hclr_1,hclr_2,hclrurt_1,hclrurt_2,hclrult_3,hclrult_4,feat_cross_type,road_cross_name_1,road_cross_name_2,sign_1,sign_2) AS
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
         then vclr_e / 0.0254
         else vclr_n / 0.0254
         end as vclr_1,
       case when vclr_s is null or vclr_s = 0
         then vclr_w / 0.0254
         else vclr_s / 0.0254
         end as vclr_2,
       case when hclr_n is null or hclr_n = 0
         then hclr_e / 0.0254
         else hclr_n / 0.0254
         end as hclr_1,
       case when hclr_s is null or hclr_s = 0
         then hclr_w / 0.0254
         else hclr_s / 0.0254
         end as hclr_2,
       case when hclrurt_n is null or hclrurt_n <= 0.0
         then hclrurt_e / 0.0254
         else hclrurt_n / 0.0254
         end as hclrurt_1,
       case when hclrurt_s is null or hclrurt_s <= 0.0
         then hclrurt_w / 0.0254
         else hclrurt_s / 0.0254
         end as hclrurt_2,
       case when hclrult_n is null or hclrult_n <= 0.0
         then hclrult_e / 0.0254
         else hclrult_n / 0.0254
         end as hclrult_3,
       case when hclrult_s is null or hclrult_s <= 0.0
         then hclrult_w / 0.0254
         else hclrult_s / 0.0254
         end as hclrult_4,
       feat_cross_type,
       (select distinct road_cross_name
         from userrway r
         where r.brkey = userrway.brkey and
               r.on_under = userrway.on_under) road_cross_name_1,
        '*' road_cross_name_2,
       case when vclr_n_sign is null or vclr_n_sign <= 0.0
         then vclr_e_sign / 0.0254
         else vclr_n_sign / 0.0254
         end sign_1,
       case when vclr_s_sign is null or vclr_s_sign <= 0.0
       then vclr_w_sign / 0.0254
       else vclr_s_sign / 0.0254
       end sign_2
from pontis.bridge, pontis.userrway, pontis.userbrdg
where bridge.brkey = userrway.brkey and
      bridge.brkey = userbrdg.brkey and
      userrway.feat_cross_type in ('10','4','30','50','51','70','90')

 ;