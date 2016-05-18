CREATE MATERIALIZED VIEW pontis.mv_cansys_bridges (brkey,bridge_id,structnum,kta_ind,enddate)
REFRESH NEXT SYSDATE + (decode(to_char(sysdate,'D'),6,3,7,2,1)) 
AS select substr(b.str_name,2,3)||substr(b.str_name,8,3) as brkey,
         b.str_name as bridge_id,
         d.RG14 as structnum,
         d.RG28 as KTA_Ind,
         b.str_end_date as enddate
  from can_v_str_brid@atlasprd.world b,
       can_v_str_dtls@atlasprd.world d
       where d.str_parent_id = b.str_id;