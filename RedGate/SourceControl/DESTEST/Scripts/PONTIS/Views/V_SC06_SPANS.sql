CREATE OR REPLACE FORCE VIEW pontis.v_sc06_spans (brkey,totalspans) AS
select brkey,
       Sum(tot_num_spans)as totalspans
from userstrunit
group by brkey
order by brkey

 ;