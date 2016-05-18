CREATE OR REPLACE FORCE VIEW pontis.v_culvratings (brkey,inspdate,culvrating,rn) AS
(
 SELECT brkey, inspdate, culvrating,row_number()
       over (partition by brkey order by inspdate desc ) rn
       from pontis.inspevnt )
       order by brkey, inspdate desc

 ;