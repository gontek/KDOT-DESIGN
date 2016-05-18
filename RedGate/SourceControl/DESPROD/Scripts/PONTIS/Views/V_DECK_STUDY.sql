CREATE OR REPLACE FORCE VIEW pontis.v_deck_study (brkey,yearbuilt,newsuper,newdeck,widening) AS
select distinct brkey,
       (select to_char(max(extract(year from actvtydate)))
from v_bif_capital_prj ti
       where ti.brkey = t.brkey and
             ti.actvtyid in ('40')
             group by ti.brkey) as yearbuilt,
 (select to_char(max(extract(year from actvtydate)))
from v_bif_capital_prj ti
       where ti.brkey = t.brkey and
             ti.actvtyid in ('13')
    group by ti.brkey)  as newsuper ,
(select to_char(max(extract(year from actvtydate)))
from v_bif_capital_prj ti
       where ti.brkey = t.brkey and
             ti.actvtyid = '15'
             group by brkey) as newdeck,
(select to_char(max(extract(year from actvtydate)))
from v_bif_capital_prj ti
       where ti.brkey = t.brkey and
             ti.actvtyid = '18'
             group by brkey)
              as widening
from v_bif_capital_prj t

 ;