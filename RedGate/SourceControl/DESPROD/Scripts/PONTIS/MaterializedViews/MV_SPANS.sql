CREATE MATERIALIZED VIEW pontis.mv_spans (brkey,strunitkey,totspans)
REFRESH START WITH TO_DATE('2016-5-18 13:45:10', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE + 6/24 
AS select brkey, strunitkey,
f_get_spans_per_unit(u.brkey, u.strunitkey) totspans
                from userstrunit u;