CREATE OR REPLACE FORCE VIEW pontis.v_crtcl_findings (brkey,co_ser,inspkey,crtcl_find_date,crtcl_comments) AS
select u.brkey,
       substr(U.BRKEY,1,6)as CO_SER,
       U.INSPKEY,
       CRTCL_FIND_DATE,
       --nvl(crtcl_find_comp,'01/jan/1901')as crtcl_find_comp,
        substr(crtcl_comments,1,95)as crtcl_comments
from USERINSP u, MV_LATEST_INSPECTION m
where u.brkey = m.brkey and
      u.inspkey = m.inspkey and
      CRTCL_FIND_DATE > '01/jan/1901' and
       nvl(crtcl_find_comp,'01/jan/1901') = '01/jan/1901'

 ;