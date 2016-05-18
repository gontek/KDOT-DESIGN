CREATE OR REPLACE FORCE VIEW pontis.v_nbi5c_on (brkey,on_under,function_type,route_prefix,orientation,nbi5b,nbi5c,nbi5d,nbi5e) AS
select userbrdg.brkey,
       '1' as on_under,
       userbrdg.function_type,
       userrway.route_prefix,
       userbrdg.orientation,
       case when function_type in ('10','30')  and route_prefix in ('I','U','K')
        then translate(route_prefix,'IUK','123')
        else '8'
            end as NBI5B,
        case when route_prefix in ('A','S','B','Y','C') then
            translate(route_prefix,'ASBYC','24637')
             when orientation = '3' then
            '8'
            when orientation in ('2','5','12','13') then
            '7'
            end as NBI5C,
            userrway.route_num as NBI5D,
            '0' as NBI5E
 from userbrdg, userrway
 where userrway.brkey = userbrdg.brkey and
       userrway.on_under = '1'

 ;