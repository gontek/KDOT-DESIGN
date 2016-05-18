CREATE OR REPLACE FORCE VIEW pontis.v_nbi_compare (nbi_8,nbi_year,r_interval,r_date,fc_interval,fc_date,uw_interval,uw_date,ph_interval,ph_date,nbi_59,nbi_60,nbi_62,nbi_41,nbi_63,nbi_64,nbi_70) AS
select NBI_8 as NBI_8,
       2011 as NBI_YEAR,
       nbi_91 as R_INTERVAL,
       nbi_90 as R_DATE,
       case
         when substr(nbi_92A,0,1)='Y' then
           to_char(substr(nbi_92A,2,2))
           else ''
             end as FC_INTERVAL,
        nbi_93A as FC_DATE,
       case
         when substr(NBI_92B,0,1) = 'Y' then
           substr(NBI_92B,2,2)
           else ''
             end as UW_INTERVAL,
             NBI_93B as UW_DATE,
     case when substr(NBI_92C,0,1) = 'Y' then
       substr(NBI_92C,2,2)
       else ''
         end as PH_INTERVAL,
         nbi_93C as PH_DATE,
         nbi_59 as NBI_59,
         nbi_60 as NBI_60,
         nbi_62 as NBI_62,
         nbi_41 as NBI_41,
         nbi_63 as NBI_63,
        to_char(nbi_64/10) as NBI_64,
         nbi_70 as NBI_70
  from nbip11
 where NBI_5A = '1'
 union all
 select NBI_8,
       2012 as NBI_YEAR,
       nbi_91 as R_INTERVAL,
       nbi_90 as R_DATE,
       case
         when substr(nbi_92A,0,1)='Y' then
           to_char(substr(nbi_92A,2,2))
           else ''
             end as FC_INTERVAL,
        nbi_93A as FC_DATE,
       case
         when substr(NBI_92B,0,1) = 'Y' then
           substr(NBI_92B,2,2)
           else ''
             end as UW_INTERVAL,
             NBI_93B as UW_DATE,
     case when substr(NBI_92C,0,1) = 'Y' then
       substr(NBI_92C,2,2)
       else ''
         end as PH_INTERVAL,
         nbi_93C as PH_DATE,
         nbi_59,
         nbi_60,
         nbi_62,
         nbi_41,
         nbi_63,
        to_char(nbi_64/10),
         nbi_70
  from nbip12
 where NBI_5A = '1'
 order by nbi_8, nbi_year

 ;