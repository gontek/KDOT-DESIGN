CREATE OR REPLACE FORCE VIEW pontis.v_totalspans (brkey,strunitkey,totalspans) AS
(select  brkey,strunitkey,
(sum(nvl(num_spans_grp_1,0)+nvl(num_spans_grp_2,0)+nvl(num_spans_grp_3,0)+nvl(num_spans_grp_4,0)+nvl(num_spans_grp_5,0)
                +nvl(num_spans_grp_6,0)+nvl(num_spans_grp_7,0)+nvl(num_spans_grp_8,0)+nvl(num_spans_grp_9,0)+nvl(num_spans_grp_10,0)))as totalspans
 from userstrunit t
group by brkey, strunitkey)

 ;