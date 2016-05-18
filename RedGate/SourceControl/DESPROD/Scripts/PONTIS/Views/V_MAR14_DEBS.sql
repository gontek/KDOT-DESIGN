CREATE OR REPLACE FORCE VIEW pontis.v_mar14_debs (inspecyear,nbi_8,nbi_22,nbi_6a,nbi_7,nbi_31,nbi_104,nbi_41,nbi_59,nbi_60,nbi_62,nbi_63,nbi_64,nbi_70,nbi_103) AS
(select '2015' as inspecyear,
nbi_8,
nbi_22,
nbi_6a,
nbi_7,
nbi_31,
nbi_104,
nbi_41,
nbi_59,
nbi_60,
nbi_62,
nbi_63,
to_number(nbi_64/10) nbi_64,
to_char(nbi_70) nbi_70,
nbi_103
from nbi_final
where nbi_5a = '1'
union all
select '2014' as inspecyear,
nbi_8,
nbi_22,
nbi_6a,
nbi_7,
nbi_31,
nbi_104,
nbi_41,
nbi_59,
nbi_60,
nbi_62,
nbi_63,
to_number(nbi_64/10) nbi_64,
nbi_70,
nbi_103
from nbip14
where nbi_5a = '1' and
nbi_8 in (select distinct nbi_8
from nbi_final)
)
;