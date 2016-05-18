CREATE MATERIALIZED VIEW pontis.mv_bif_underclearances (brkey,on_under,sortorder,direction,vclr,hclr,hclrurt,hclrult,roadcrossname,signed,vc_date)
REFRESH START WITH TO_DATE('2016-5-18 12:26:20', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE + 6/24 
AS select  brkey,
        on_under,
        '1' as sortorder,
        direction_1 as direction,
        vclr_1 as vclr,
        hclr_1 as hclr,
        hclrurt_1 as hclrurt,
        hclrult_3 as hclrult,
        trim(road_cross_name_1) as roadcrossname,
        sign_1 as signed,
        vc_date
        from v_bif_underclearances
union all
select brkey,
on_under,
'2' as sortorder,
direction_2,
vclr_2,
hclr_2,
hclrurt_2,
hclrult_4,
trim(road_cross_name_2),
sign_2,
to_date('01/jan/1901')
from v_bif_underclearances;