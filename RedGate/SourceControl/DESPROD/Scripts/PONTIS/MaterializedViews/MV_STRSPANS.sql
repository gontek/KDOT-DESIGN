CREATE MATERIALIZED VIEW pontis.mv_strspans (brkey,strunitkey,mainunit,bif_spangrps,spangrps)
REFRESH START WITH TO_DATE('2016-5-18 15:20:56', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE + 6/24 
AS select u.brkey,u.strunitkey,
case
when strunittype = '1' then
  to_char(us.strunitkey)
  else ''
    end as mainunit,
decode(us.strunittype,'1','Main Unit- '||lpad(trim(u.strunitkey),3)||lpad(f_structuretype(u.brkey,u.strunitkey),6)||decode(num_girders,NULL,null,'-'||lpad(trim(num_girders),2))
||'   Wide: '||
f_get_structuretype_widen(u.brkey, u.strunitkey)||decode(wide_num_girders,NULL,'','-'||lpad(trim(wide_num_girders),2))
||'  Spans:  '
||u.num_spans_grp_1||' @ '||round(len_span_grp_1/0.3048)
||decode(u.num_spans_grp_2,null,'',', '||u.num_spans_grp_2||' @ '||round(len_span_grp_2/0.3048))
||decode(u.num_spans_grp_3,null,'',', '||u.num_spans_grp_3||' @ '||round(len_span_grp_3/0.3048))
||decode(u.num_spans_grp_4,null,'',', '||u.num_spans_grp_4||' @ '||round(len_span_grp_4/0.3048))
||decode(u.num_spans_grp_5,null,'',', '||u.num_spans_grp_5||' @ '||round(len_span_grp_5/0.3048))
||decode(u.num_spans_grp_6,null,'',', '||u.num_spans_grp_6||' @ '||round(len_span_grp_6/0.3048))
||decode(u.num_spans_grp_7,null,'',', '||u.num_spans_grp_7||' @ '||round(len_span_grp_7/0.3048))
||decode(u.num_spans_grp_8,null,'',', '||u.num_spans_grp_8||' @ '||round(len_span_grp_8/0.3048))
||decode(u.num_spans_grp_9,null,'',', '||u.num_spans_grp_9||' @ '||round(len_span_grp_9/0.3048))
||decode(u.num_spans_grp_10,null,'',', '||u.num_spans_grp_10||' @ '||round(len_span_grp_10/0.3048)),
'         Unit- '||lpad(trim(u.strunitkey),3)||lpad(f_structuretype(u.brkey,u.strunitkey),6)||decode(num_girders,NULL,'','-'||lpad(trim(num_girders),2))||'   Wide: '||
f_get_structuretype_widen(u.brkey, u.strunitkey)||decode(wide_num_girders,NULL,'','-'||lpad(trim(wide_num_girders),2))
||'  Spans:  '
||u.num_spans_grp_1||' @ '||round(len_span_grp_1/0.3048)
||decode(u.num_spans_grp_2,null,'',', '||u.num_spans_grp_2||' @ '||round(len_span_grp_2/0.3048))
||decode(u.num_spans_grp_3,null,'',', '||u.num_spans_grp_3||' @ '||round(len_span_grp_3/0.3048))
||decode(u.num_spans_grp_4,null,'',', '||u.num_spans_grp_4||' @ '||round(len_span_grp_4/0.3048))
||decode(u.num_spans_grp_5,null,'',', '||u.num_spans_grp_5||' @ '||round(len_span_grp_5/0.3048))
||decode(u.num_spans_grp_6,null,'',', '||u.num_spans_grp_6||' @ '||round(len_span_grp_6/0.3048))
||decode(u.num_spans_grp_7,null,'',', '||u.num_spans_grp_7||' @ '||round(len_span_grp_7/0.3048))
||decode(u.num_spans_grp_8,null,'',', '||u.num_spans_grp_8||' @ '||round(len_span_grp_8/0.3048))
||decode(u.num_spans_grp_9,null,'',', '||u.num_spans_grp_9||' @ '||round(len_span_grp_9/0.3048))
||decode(u.num_spans_grp_10,null,'',', '||u.num_spans_grp_10||' @ '||round(len_span_grp_10/0.3048)))
 bif_spangrps,
 '| '
||lpad(ltrim(u.num_spans_grp_1),2)||' @ '||round(len_span_grp_1/0.3048)
||decode(u.num_spans_grp_2,null,null,' | '||lpad(ltrim(u.num_spans_grp_2),2)||' @ '||round(len_span_grp_2/0.3048))
||decode(u.num_spans_grp_3,null,null,' | '||lpad(ltrim(u.num_spans_grp_3),2)||' @ '||round(len_span_grp_3/0.3048))
||decode(u.num_spans_grp_4,null,null,' | '||lpad(ltrim(u.num_spans_grp_4),2)||' @ '||round(len_span_grp_4/0.3048))
||decode(u.num_spans_grp_5,null,null,' | '||lpad(ltrim(u.num_spans_grp_5),2)||' @ '||round(len_span_grp_5/0.3048)||CHR(13))
||decode(u.num_spans_grp_6,null,null,'| '||lpad(ltrim(u.num_spans_grp_6),2)||' @ '||round(len_span_grp_6/0.3048))
||decode(u.num_spans_grp_7,null,null,' | '||lpad(ltrim(u.num_spans_grp_7),2)||' @ '||round(len_span_grp_7/0.3048))
||decode(u.num_spans_grp_8,null,null,' | '||lpad(ltrim(u.num_spans_grp_8),2)||' @ '||round(len_span_grp_8/0.3048))
||decode(u.num_spans_grp_9,null,null,' | '||lpad(ltrim(u.num_spans_grp_9),2)||' @ '||round(len_span_grp_9/0.3048))
||decode(u.num_spans_grp_10,null,null,' | '||lpad(ltrim(u.num_spans_grp_10),2)||' @ '||round(len_span_grp_10/0.3048))
spangrps
from userstrunit u, structure_unit us
where u.brkey = us.brkey and
u.strunitkey = us.strunitkey;