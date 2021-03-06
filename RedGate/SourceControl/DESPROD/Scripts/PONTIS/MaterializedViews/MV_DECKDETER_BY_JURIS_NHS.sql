CREATE MATERIALIZED VIEW pontis.mv_deckdeter_by_juris_nhs (col_name,sortorder,grporder,nbi_2005,nbi_2006,nbi_2007,nbi_2008,nbi_2009,nbi_2010,nbi_2011,nbi_2012,nbi_2013,nbi_2014,last_percent_tot,percent_tot)
REFRESH START WITH TO_DATE('2016-5-18 15:9:54', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE + 6/24 
AS select 'Total Deck Area' col_name,
        1 sortorder,
        1 grporder,
        ROUND(SUM(case when juris = 'State' and inspec_year = '2005' and nvl(nbi_104,'-1') = '1' and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)) nbi_2005,
        ROUND(SUM(case when juris = 'State' and inspec_year = '2006' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)) nbi_2006,
        ROUND(SUM(case when juris = 'State' and inspec_year = '2007' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)) nbi_2007,
        ROUND(SUM(case when juris = 'State' and inspec_year = '2008' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)) nbi_2008,
        ROUND(SUM(case when juris = 'State' and inspec_year = '2009' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)) nbi_2009,
        ROUND(SUM(case when juris = 'State' and inspec_year = '2010' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)) nbi_2010,
        ROUND(SUM(case when juris = 'State' and inspec_year = '2011' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)) nbi_2011,
        ROUND(SUM(case when juris = 'State' and inspec_year = '2012' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)) nbi_2012,
        ROUND(SUM(case when juris = 'State' and inspec_year = '2013' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)) nbi_2013,
        ROUND(SUM(case when juris = 'State' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)) nbi_2014,
        ROUND(SUM(case when juris = 'State' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)) last_percent_tot,
        ROUND(SUM(case when inspec_year = '2014' and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)) percent_tot
from mv_jurisdiction_rpt
UNION ALL
select 'Structurally Deficient',
        2,
        1,
        ROUND(SUM(case when juris = 'State' and inspec_year = '2005' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        ROUND(SUM(case when juris = 'State' and inspec_year = '2006' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        ROUND(SUM(case when juris = 'State' and inspec_year = '2007' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        ROUND(SUM(case when juris = 'State' and inspec_year = '2008' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        ROUND(SUM(case when juris = 'State' and inspec_year = '2009' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        ROUND(SUM(case when juris = 'State' and inspec_year = '2010' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        ROUND(SUM(case when juris = 'State' and inspec_year = '2011' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        ROUND(SUM(case when juris = 'State' and inspec_year = '2012' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        ROUND(SUM(case when juris = 'State' and inspec_year = '2013' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        ROUND(SUM(case when juris = 'State' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        ROUND(SUM(case when juris = 'State' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        ROUND(SUM(case when inspec_year = '2014' and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end))
from mv_jurisdiction_rpt

UNION ALL
select 'Total Deck Area',
        1,
        2,
        round(sum(case when juris = 'City' and inspec_year = '2005' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2006' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0')  then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2007' and nvl(nbi_104,'-1') = '1' and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2008' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2009' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2010' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2011' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2012' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2013' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when inspec_year = '2014' and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end))
from mv_jurisdiction_rpt

UNION ALL
select 'Structurally Deficient',
        2,
        2,
        round(sum(case when juris = 'City' and inspec_year = '2005' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2006' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2007' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2008' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2009' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2010' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2011' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1'then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2012' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2013' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'City' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when inspec_year = '2014'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end))
from mv_jurisdiction_rpt

UNION ALL
select 'Total Deck Area',
        1,
        3,
        round(sum(case when juris = 'County' and inspec_year = '2005' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2006' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2007' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2008' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2009' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2010' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2011' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2012' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2013' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when inspec_year = '2014' and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end))
from mv_jurisdiction_rpt
UNION ALL
select 'Structurally Deficient',
        2,
        3,
        round(sum(case when juris = 'County' and inspec_year = '2005' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2006' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2007' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2008' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2009' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2010' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2011' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1'then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2012' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2013' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'County' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when inspec_year = '2014' and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end))
from mv_jurisdiction_rpt

union all
select 'Total Deck Area',
        1,
        4,
        round(sum(case when juris = 'KTA' and inspec_year = '2005' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2006' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2007' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2008' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2009' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2010' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2011' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2012' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2013' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when inspec_year = '2014' and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end))
from mv_jurisdiction_rpt

UNION ALL
select 'Structurally Deficient',
        2,
        4,
        round(sum(case when juris = 'KTA' and inspec_year = '2005' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2006' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2007' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2008' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2009' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2010' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2011' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1'then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2012' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2013' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) = '1' then deckarea else null end)),
        round(sum(case when juris = 'KTA' and inspec_year = '2014' and nvl(nbi_104,'-1') = '1'and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end)),
        round(sum(case when inspec_year = '2014' and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end))
from mv_jurisdiction_rpt

UNION ALL
select 'Total Deck Area',
        1,
        5,
        round(sum(case when inspec_year = '2005' and nvl(trim(sdfo),-1) in ('1','2','0') and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2006' and nvl(trim(sdfo),-1) in ('1','2','0') and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2007' and nvl(trim(sdfo),-1) in ('1','2','0') and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2008' and nvl(trim(sdfo),-1) in ('1','2','0') and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2009' and nvl(trim(sdfo),-1) in ('1','2','0') and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2010' and nvl(trim(sdfo),-1) in ('1','2','0') and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2011' and nvl(trim(sdfo),-1) in ('1','2','0') and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2012' and nvl(trim(sdfo),-1) in ('1','2','0') and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2013' and nvl(trim(sdfo),-1) in ('1','2','0') and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2014' and nvl(trim(sdfo),-1) in ('1','2','0') and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2014' and nvl(trim(sdfo),-1) in ('1','2','0') and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2014' and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end))
from mv_jurisdiction_rpt
UNION ALL
select 'Structurally Deficient',
        2,
        5,
        round(sum(case when inspec_year = '2005' and nvl(trim(sdfo),-1) = '1' and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2006' and nvl(trim(sdfo),-1) = '1' and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2007' and nvl(trim(sdfo),-1) = '1' and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2008' and nvl(trim(sdfo),-1) = '1' and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2009' and nvl(trim(sdfo),-1) = '1' and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2010' and nvl(trim(sdfo),-1) = '1' and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2011' and nvl(trim(sdfo),-1) = '1' and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2012' and nvl(trim(sdfo),-1) = '1' and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2013' and nvl(trim(sdfo),-1) = '1' and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2014' and nvl(trim(sdfo),-1) = '1' and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2014' and nvl(trim(sdfo),-1) in ('1','2','0') and nvl(nbi_104,'-1') = '1'then deckarea else null end)),
        round(sum(case when inspec_year = '2014' and nvl(trim(sdfo),-1) in ('1','2','0') then deckarea else null end))
from mv_jurisdiction_rpt;