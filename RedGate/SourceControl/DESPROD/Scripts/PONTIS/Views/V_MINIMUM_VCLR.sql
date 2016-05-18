CREATE OR REPLACE FORCE VIEW pontis.v_minimum_vclr (brkey,clr_route,vclr_n_eng,vclr_n_new,vclr_s_eng,vclr_s_new,vclr_e_eng,vclr_e_new,vclr_w_eng,vclr_w_new,route_prefix,route_num,design_county_ref) AS
select userbrdg.brkey,
       clr_route,
       vclr_n / .0254 as vclr_n_eng,
       case when ln1_vclr_n > 0 and ln2_vclr_n is null or ln2_vclr_n = '-1'
                 then ln1_vclr_n / .0254
            when ln1_vclr_n > 0 and ln2_vclr_n > 0 and ln3_vclr_n is null or ln3_vclr_n = '-1'
            then least(ln1_vclr_n,ln2_vclr_n)/ .0254
            when ln1_vclr_n > 0 and ln2_vclr_n > 0 and ln3_vclr_n > 0 and ln4_vclr_n is null or ln4_vclr_n = '-1'
            then least(ln1_vclr_n,ln2_vclr_n,ln3_vclr_n) / .0254
            when ln1_vclr_n > 0 and ln2_vclr_n > 0 and ln3_vclr_n > 0 and ln4_vclr_n > 0 and ln5_vclr_n is null or ln5_vclr_n = '-1'
            then least(ln1_vclr_n,ln2_vclr_n,ln3_vclr_n,ln4_vclr_n) / .0254
            when ln1_vclr_n > 0 and ln2_vclr_n > 0 and ln3_vclr_n > 0 and ln4_vclr_n > 0 and ln5_vclr_n > 0 and ln6_vclr_n is null or ln6_vclr_n = '-1'
            then least(ln1_vclr_n,ln2_vclr_n,ln3_vclr_n,ln4_vclr_n,ln5_vclr_n) / .0254
            when ln1_vclr_n > 0 and ln2_vclr_n > 0 and ln3_vclr_n > 0 and ln4_vclr_n > 0 and ln5_vclr_n > 0 and ln6_vclr_n > 0 and ln7_vclr_n is null or ln7_vclr_n = '-1'
            then least(ln1_vclr_n,ln2_vclr_n,ln3_vclr_n,ln4_vclr_n,ln5_vclr_n,ln6_vclr_n) / .0254
            when ln1_vclr_n > 0 and ln2_vclr_n > 0 and ln3_vclr_n > 0 and ln4_vclr_n > 0 and ln5_vclr_n > 0 and ln6_vclr_n > 0 and ln7_vclr_n > 0 and ln8_vclr_n is null or ln8_vclr_n = '-1'
            then least(ln1_vclr_n,ln2_vclr_n,ln3_vclr_n,ln4_vclr_n,ln5_vclr_n,ln6_vclr_n,ln7_vclr_n) / .0254
            when ln1_vclr_n > 0 and ln2_vclr_n > 0 and ln3_vclr_n > 0 and ln4_vclr_n > 0 and ln5_vclr_n > 0 and ln6_vclr_n > 0 and ln7_vclr_n > 0 and ln8_vclr_n > 0
            then least(ln1_vclr_n,ln2_vclr_n,ln3_vclr_n,ln4_vclr_n,ln5_vclr_n,ln6_vclr_n,ln7_vclr_n,ln8_vclr_n) / .0254
            else 0
            end as vclr_n_new,
       vclr_s / .0254 as vclr_s_eng,
       case when ln1_vclr_s > 0 and ln2_vclr_s is null or ln2_vclr_s = '-1'
            then ln1_vclr_s / .0254
            when ln1_vclr_s > 0 and ln2_vclr_s > 0 and ln3_vclr_s is null or ln3_vclr_s = '-1'
             then least(ln1_vclr_s,ln2_vclr_s) / .0254
            when ln1_vclr_s > 0 and ln2_vclr_s > 0 and ln3_vclr_s > 0 and ln4_vclr_s is null or ln4_vclr_s = '-1'
            then least(ln1_vclr_s,ln2_vclr_s,ln3_vclr_s) / .0254
            when ln1_vclr_s > 0 and ln2_vclr_s > 0 and ln3_vclr_s > 0 and ln4_vclr_s > 0 and ln5_vclr_s is null or ln5_vclr_s = '-1'
            then least(ln1_vclr_s,ln2_vclr_s,ln3_vclr_s,ln4_vclr_s) / .0254
            when ln1_vclr_s > 0 and ln2_vclr_s > 0 and ln3_vclr_s > 0 and ln4_vclr_s > 0 and ln5_vclr_s > 0 and ln6_vclr_s is null or ln6_vclr_s = '-1'
            then least(ln1_vclr_s,ln2_vclr_s,ln3_vclr_s,ln4_vclr_s,ln5_vclr_s) / .0254
            when ln1_vclr_s > 0 and ln2_vclr_s > 0 and ln3_vclr_s > 0 and ln4_vclr_s > 0 and ln5_vclr_s > 0 and ln6_vclr_s > 0 and ln7_vclr_s is null or ln7_vclr_s = '-1'
            then least(ln1_vclr_s,ln2_vclr_s,ln3_vclr_s,ln4_vclr_s,ln5_vclr_s,ln6_vclr_s) / .0254
            when ln1_vclr_s > 0 and ln2_vclr_s > 0 and ln3_vclr_s > 0 and ln4_vclr_s > 0 and ln5_vclr_s > 0 and ln6_vclr_s > 0 and ln7_vclr_s > 0 and ln8_vclr_s is null or ln8_vclr_s = '-1'
            then least(ln1_vclr_s,ln2_vclr_s,ln3_vclr_s,ln4_vclr_s,ln5_vclr_s,ln6_vclr_s,ln7_vclr_s) / .0254
            when ln1_vclr_s > 0 and ln2_vclr_s > 0 and ln3_vclr_s > 0 and ln4_vclr_s > 0 and ln5_vclr_s > 0 and ln6_vclr_s > 0 and ln7_vclr_s > 0 and ln8_vclr_s > 0
            then least(ln1_vclr_s,ln2_vclr_s,ln3_vclr_s,ln4_vclr_s,ln5_vclr_s,ln6_vclr_s,ln7_vclr_s,ln8_vclr_s) / .0254
            else 0 end as vclr_s_new,
       vclr_e / .0254 as vclr_e_eng,
       case when ln1_vclr_e > 0 and ln2_vclr_e is null or ln2_vclr_e = '-1'
            then ln1_vclr_e / .0254
            when ln1_vclr_e > 0 and ln2_vclr_e > 0  and ln3_vclr_e is null or ln3_vclr_e = '-1'
            then least(ln1_vclr_e,ln2_vclr_e)/ .0254
            when ln1_vclr_e > 0 and ln2_vclr_e > 0 and ln3_vclr_e > 0  and ln4_vclr_e is null or ln4_vclr_e = '-1'
            then least(ln1_vclr_e,ln2_vclr_e,ln3_vclr_e)/ .0254
            when ln1_vclr_e > 0 and ln2_vclr_e > 0 and ln3_vclr_e > 0 and ln4_vclr_e > 0 and ln5_vclr_e is null or ln5_vclr_e = '-1'
            then least(ln1_vclr_e,ln2_vclr_e,ln3_vclr_e,ln4_vclr_e) / .0254
            when ln1_vclr_e > 0 and ln2_vclr_e > 0 and ln3_vclr_e > 0 and ln4_vclr_e > 0 and ln5_vclr_e > 0 and ln6_vclr_e is null or ln6_vclr_e = '-1'
            then least(ln1_vclr_e,ln2_vclr_e,ln3_vclr_e,ln4_vclr_e,ln5_vclr_e) / .0254
            when ln1_vclr_e > 0 and ln2_vclr_e > 0 and ln3_vclr_e > 0 and ln4_vclr_e > 0 and ln5_vclr_e > 0 and ln6_vclr_e > 0 and ln7_vclr_e is null or ln7_vclr_e = '-1'
            then least(ln1_vclr_e,ln2_vclr_e,ln3_vclr_e,ln4_vclr_e,ln5_vclr_e,ln6_vclr_e) / .0254
            when ln1_vclr_e > 0 and ln2_vclr_e > 0 and ln3_vclr_e > 0 and ln4_vclr_e > 0 and ln5_vclr_e > 0 and ln6_vclr_e > 0 and ln7_vclr_e > 0 and ln8_vclr_e is null or ln8_vclr_e = '-1'
            then least(ln1_vclr_e,ln2_vclr_e,ln3_vclr_e,ln4_vclr_e,ln5_vclr_e,ln6_vclr_e,ln7_vclr_e) / .0254
            when ln1_vclr_e > 0 and ln2_vclr_e > 0 and ln3_vclr_e > 0 and ln4_vclr_e > 0 and ln5_vclr_e > 0 and ln6_vclr_e > 0 and ln7_vclr_e > 0 and ln8_vclr_e > 0
            then least(ln1_vclr_e,ln2_vclr_e,ln3_vclr_e,ln4_vclr_e,ln5_vclr_e,ln6_vclr_e,ln7_vclr_e,ln8_vclr_e) / .0254
            else 0 end as vclr_e_new,
       vclr_w / .0254 as vclr_w_eng,
       case when ln1_vclr_w > 0 and ln2_vclr_w is null or ln2_vclr_w = '-1'
       then ln1_vclr_w / .0254
       when ln1_vclr_w > 0 and ln2_vclr_w > 0  and ln3_vclr_w is null or ln3_vclr_w = '-1'
       then least(ln1_vclr_w,ln2_vclr_w)/ .0254
       when ln1_vclr_w > 0 and ln2_vclr_w > 0 and ln3_vclr_w > 0 and ln4_vclr_w is null or ln4_vclr_w = '-1'
       then least(ln1_vclr_w,ln2_vclr_w,ln3_vclr_w)/ .0254
       when ln1_vclr_w > 0 and ln2_vclr_w > 0 and ln3_vclr_w > 0 and ln4_vclr_w > 0 and ln5_vclr_w is null or ln5_vclr_w = '-1'
       then least(ln1_vclr_w,ln2_vclr_w,ln3_vclr_w,ln4_vclr_w) / .0254
       when ln1_vclr_w > 0 and ln2_vclr_w > 0 and ln3_vclr_w > 0 and ln4_vclr_w > 0 and ln5_vclr_w > 0 and ln6_vclr_w is null or ln6_vclr_w = '-1'
       then least(ln1_vclr_w,ln2_vclr_w,ln3_vclr_w,ln4_vclr_w,ln5_vclr_w) / .0254
       when ln1_vclr_w > 0 and ln2_vclr_w > 0 and ln3_vclr_w > 0 and ln4_vclr_w > 0 and ln5_vclr_w > 0 and ln6_vclr_w > 0 and ln7_vclr_w is null or ln7_vclr_w = '-1'
       then least(ln1_vclr_w,ln2_vclr_w,ln3_vclr_w,ln4_vclr_w,ln5_vclr_w,ln6_vclr_w) / .0254
       when ln1_vclr_w > 0 and ln2_vclr_w > 0 and ln3_vclr_w > 0 and ln4_vclr_w > 0 and ln5_vclr_w > 0 and ln6_vclr_w > 0 and ln7_vclr_w > 0 and ln8_vclr_w is null or ln8_vclr_w = '-1'
       then least(ln1_vclr_w,ln2_vclr_w,ln3_vclr_w,ln4_vclr_w,ln5_vclr_w,ln6_vclr_w,ln7_vclr_w) / .0254
       when ln1_vclr_w > 0 and ln2_vclr_w > 0 and ln3_vclr_w > 0 and ln4_vclr_w > 0 and ln5_vclr_w > 0 and ln6_vclr_w > 0 and ln7_vclr_w > 0 and ln8_vclr_w > 0
       then least(ln1_vclr_w,ln2_vclr_w,ln3_vclr_w,ln4_vclr_w,ln5_vclr_w,ln6_vclr_w,ln7_vclr_w,ln8_vclr_w) / .0254
       else 0 end as vclr_w_new,
       route_prefix, route_num, userbrdg.design_county_ref from userrway, userbrdg where userrway.brkey = userbrdg.brkey and ((ln1_vclr_n is not null or ln1_vclr_n > 0)or (ln2_vclr_n is not null or ln2_vclr_n > 0)or (ln3_vclr_n is not null or ln3_vclr_n > 0) or (ln4_vclr_n is not null or ln4_vclr_n > 0) or (ln5_vclr_n is not null or ln5_vclr_n > 0) or (ln6_vclr_n is not null or ln6_vclr_n > 0) or (ln7_vclr_n is not null or ln7_vclr_n > 0) or (ln8_vclr_n is not null or ln8_vclr_n > 0) or (ln1_vclr_s is not null or ln1_vclr_s > 0) or (ln2_vclr_s is not null or ln2_vclr_s > 0) or (ln3_vclr_s is not null or ln3_vclr_s > 0) or (ln4_vclr_s is not null or ln4_vclr_s > 0) or (ln5_vclr_s is not null or ln5_vclr_s > 0) or (ln6_vclr_s is not null or ln6_vclr_s > 0) or (ln7_vclr_s is not null or ln7_vclr_s > 0) or (ln8_vclr_s is not null or ln8_vclr_s > 0) or (ln1_vclr_e is not null or ln1_vclr_e > 0) or (ln2_vclr_e is not null or ln2_vclr_e > 0) or (ln3_vclr_e is not null or ln3_vclr_e > 0) or (ln4_vclr_e is not null or ln4_vclr_e > 0) or (ln5_vclr_e is not null or ln5_vclr_e > 0) or (ln6_vclr_e is not null or ln6_vclr_e > 0) or (ln7_vclr_e is not null or ln7_vclr_e > 0) or (ln8_vclr_e is not null or ln8_vclr_e > 0) or (ln1_vclr_w is not null or ln1_vclr_w > 0) or (ln2_vclr_w is not null or ln2_vclr_w > 0) or (ln3_vclr_w is not null or ln3_vclr_w > 0) or (ln4_vclr_w is not null or ln4_vclr_w > 0) or (ln5_vclr_w is not null or ln5_vclr_w > 0) or (ln6_vclr_w is not null or ln6_vclr_w > 0) or (ln7_vclr_w is not null or ln7_vclr_w > 0) or (ln8_vclr_w is not null or ln8_vclr_w > 0))

 ;