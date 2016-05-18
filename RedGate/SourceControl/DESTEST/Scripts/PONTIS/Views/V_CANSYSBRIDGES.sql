CREATE OR REPLACE FORCE VIEW pontis.v_cansysbridges (brkey,bridge_id,structnum,kta_ind,enddate) AS
( select substr(b.str_name,2,3)||substr(b.str_name,8,3) as brkey,
         b.str_name as bridge_id,
         d.RG14 as structnum,
         d.RG28 as KTA_Ind,
         b.str_end_date as enddate
  from can_v_str_brid@newcant.world b,
       can_v_str_dtls@newcant.world d
       where d.str_parent_id = b.str_id)
;