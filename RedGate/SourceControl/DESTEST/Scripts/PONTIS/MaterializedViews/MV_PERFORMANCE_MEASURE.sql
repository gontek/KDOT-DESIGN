CREATE MATERIALIZED VIEW pontis.mv_performance_measure (brkey,createdatetime,inspdate,inspname,adminarea)
AS select b.brkey, i.createdatetime,inspdate,inspname,
decode(kta_insp,'1','71','0','70',adminarea) as adminarea from inspevnt i, bridge b, userbrdg u
where i.brkey = b.brkey and
      u.brkey = b.brkey and
b.district <> '9' and inspdate <> '01/jan/1901' and-- userkey inspname in ('rwhoward','RWHOWARD') and
(extract(year from i.inspdate) >= '2013')
--extract(month from i.createdatetime) = '7') --or
--(extract(year from modtime) = '2013' and
--extract(month from modtime) = '7'))
;