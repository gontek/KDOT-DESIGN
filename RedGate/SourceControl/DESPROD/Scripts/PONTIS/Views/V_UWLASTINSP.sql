CREATE OR REPLACE FORCE VIEW pontis.v_uwlastinsp (brkey,inspdate) AS
(select brkey, inspdate  from inspevnt i1  where uwinspdone = '1' and        to_char(inspdate, 'yyyy') > '1901'  UNION  select brkey, uwlastinsp  from inspevnt i2  where to_char(uwlastinsp, 'yyyy') > '1901' and        uwlastinsp not in (select inspdate from inspevnt i3        where i3.uwinspdone = '1' and i3.brkey = i2.brkey) and        uwlastinsp is not null)

 ;