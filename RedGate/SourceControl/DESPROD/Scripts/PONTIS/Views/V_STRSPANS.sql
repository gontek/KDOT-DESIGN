CREATE OR REPLACE FORCE VIEW pontis.v_strspans (brkey,strunitkey,spangrp) AS
select u.brkey,u.strunitkey,
decode(us.strunittype,'1','Main Unit-'||u.strunitkey||' '||f_structuretype(u.brkey,u.strunitkey)||decode(num_girders,NULL,'','-'||num_girders)||'  Wide: '||
f_get_structuretype_widen(u.brkey, u.strunitkey)
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
'     Unit-'||u.strunitkey||' '||f_structuretype(u.brkey,u.strunitkey)||decode(num_girders,NULL,'','-'||num_girders)||'  Wide: '||
f_get_structuretype_widen(u.brkey, u.strunitkey)
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
 spangrp

from userstrunit u, structure_unit us
where u.brkey = us.brkey and
u.strunitkey = us.strunitkey and
u.brkey = '003055'
order by brkey, strunitkey

 ;