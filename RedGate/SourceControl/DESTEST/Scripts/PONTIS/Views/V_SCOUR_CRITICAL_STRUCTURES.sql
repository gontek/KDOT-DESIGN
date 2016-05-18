CREATE OR REPLACE FORCE VIEW pontis.v_scour_critical_structures (brkey,scourcrit) AS
select b.brkey, scourcrit
from bridge b, inspevnt i, mv_latest_inspection mv
where i.brkey = b.brkey and
      mv.brkey = b.brkey and
      i.inspkey = mv.inspkey and
      b.brkey <> '9' and
      scourcrit in ('1','2','3')

 ;