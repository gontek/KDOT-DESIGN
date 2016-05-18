CREATE OR REPLACE FORCE VIEW pontis.v_structuretypes (brkey,strunitkey,strtype) AS
select userstrunit.brkey,strunitkey,  strunitkey||'-'||f_structuretype(brkey,strunitkey)as strtype
from userstrunit
order by brkey, strunitkey

 ;