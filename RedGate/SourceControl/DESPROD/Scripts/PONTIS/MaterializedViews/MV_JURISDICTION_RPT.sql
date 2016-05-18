CREATE MATERIALIZED VIEW pontis.mv_jurisdiction_rpt (inspec_year,nbi_8,nbi_5a,sdfo,deckarea,juris,suffgroup,nbi_103,posted,nbi_41,nbi_104)
REFRESH START WITH TO_DATE('2016-5-18 14:15:42', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE + 6/24 
AS select '2006' as inspec_year
,nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
,(to_number(nvl(trim(nbi_51),0)/10)/.3048)*
(to_number(nvl(trim(nbi_49),0)/10)/.3048) as deckarea
,case
  when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
    and substr(nbi_8,1,4) = '9999'
    then 'State'
  when nvl(kta_y_n,'-1') = 'Y'
    then 'KTA'
  when ((nvl(local_y_n,'-1') = 'Y' and nvl(nbi_21,'-1') = '04')
or (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nbi_26) > 10) )
    then 'City'
   when ((nvl(local_y_n,'-1') = 'Y' and nbi_5a = '1' and nvl(nbi_21,'-1') <> '04') or
     (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nvl(NBI_26,-1)) < 10))
     then 'County'
     else '?'
       end as juris
  --  ,f_nbi_on_under(n.nbi_8,'nbip06') as  min_on_under
     ,case when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null
        and  trim(sufficiencyrate)/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null and trim(sufficiencyrate)/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and trim(sufficiencyrate)is not null
                and trim(sufficiencyrate)/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
        ,posted_load_a as posted
                              ,nbi_41
                              ,nbi_104
from nbip06 n
where nbi_5a = (select min(nbi_5a) from
nbip06 ni
where ni.nbi_8 = n.nbi_8)
UNION ALL
select '2007' as inspec_year
,nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
,(to_number(nvl(trim(nbi_51),0)/10)/.3048)*
(to_number(nvl(trim(nbi_49),0)/10)/.3048) as deckarea
,case
  when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
    and substr(nbi_8,1,4) = '9999'
    then 'State'
  when nvl(kta_y_n,'-1') = 'Y'
    then 'KTA'
  when ((nvl(local_y_n,'-1') = 'Y' and nvl(nbi_21,'-1') = '04')
or (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nbi_26) > 10) )
    then 'City'
   when ((nvl(local_y_n,'-1') = 'Y' and nbi_5a = '1' and nvl(nbi_21,'-1') <> '04') or
     (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nvl(NBI_26,-1)) < 10))
     then 'County'
     else '?'
       end as juris
   --   ,f_nbi_on_under(n.nbi_8,'nbip07') as  min_on_under
    ,case when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null
        and  trim(sufficiencyrate)/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null and trim(sufficiencyrate)/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and trim(sufficiencyrate)is not null
                and trim(sufficiencyrate)/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
        ,posted_load_a as posted
                              ,nbi_41
                              ,nbi_104
from nbip07 n
where nbi_5a = (select min(nbi_5a) from
nbip07 ni
where ni.nbi_8 = n.nbi_8)
UNION ALL
select '2008' as inspec_year
,nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
,(to_number(nvl(trim(nbi_51),0)/10)/.3048)*
(to_number(nvl(trim(nbi_49),0)/10)/.3048) as deckarea
,case
  when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
    and substr(nbi_8,1,4) = '9999'
    then 'State'
  when nvl(kta_y_n,'-1') = 'Y'
    then 'KTA'
  when ((nvl(local_y_n,'-1') = 'Y' and nvl(nbi_21,'-1') = '04')
or (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nbi_26) > 10) )
    then 'City'
   when ((nvl(local_y_n,'-1') = 'Y' and nbi_5a = '1' and nvl(nbi_21,'-1') <> '04') or
     (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nvl(NBI_26,-1)) < 10))
     then 'County'
     else '?'
       end as juris
  --    , f_nbi_on_under(n.nbi_8,'nbip08') as  min_on_under
     ,case when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null
        and  trim(sufficiencyrate)/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null and trim(sufficiencyrate)/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and trim(sufficiencyrate)is not null
                and trim(sufficiencyrate)/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
       ,posted_load_a as posted
       ,nbi_41
       ,nbi_104
from nbip08 n
where nbi_5a = (select min(nbi_5a) from
nbip08 ni
where ni.nbi_8 = n.nbi_8)
UNION ALL
select '2009' as inspec_year
,nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
,(to_number(nvl(trim(nbi_51),0)/10)/.3048)*
(to_number(nvl(trim(nbi_49),0)/10)/.3048) as deckarea
,case
  when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
    then 'State'
  when nvl(kta_y_n,'-1') = 'Y'
    then 'KTA'
 when ((nvl(local_y_n,'-1') = 'Y' and nvl(nbi_21,'-1') = '04')
or (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nbi_26) > 10) )
    then 'City'
   when ((nvl(local_y_n,'-1') = 'Y' and nbi_5a = '1' and nvl(nbi_21,'-1') <> '04') or
     (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nvl(NBI_26,-1)) < 10))
     then 'County'
     else '?'
       end as juris
  --    , f_nbi_on_under(n.nbi_8,'nbip09') as  min_on_under
     ,case when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null
        and  trim(sufficiencyrate)/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null and trim(sufficiencyrate)/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and trim(sufficiencyrate)is not null
                and trim(sufficiencyrate)/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
        ,posted_load_a as posted
       ,nbi_41
       ,nbi_104
from nbip09 n
where nbi_5a = (select min(nbi_5a) from
nbip09 ni
where ni.nbi_8 = n.nbi_8)
UNION ALL
select '2010'
, nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
,(to_number(nvl(trim(nbi_51),0)/10)/.3048)*
(to_number(nvl(trim(nbi_49),0)/10)/.3048) as deckarea
,case
  when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
    then 'State'
  when nvl(kta_y_n,'-1') = 'Y'
    then 'KTA'
  when ((nvl(local_y_n,'-1') = 'Y' and nvl(nbi_21,'-1') = '04')
or (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nbi_26) > 10) )
    then 'City'
   when ((nvl(local_y_n,'-1') = 'Y' and nbi_5a = '1' and nvl(nbi_21,'-1') <> '04') or
     (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nvl(NBI_26,-1)) < 10))
     then 'County'
     else '?'
       end as juris
  --     ,f_nbi_on_under(n.nbi_8,'nbip10') as  min_on_under
     ,case when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null
        and  trim(sufficiencyrate)/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null and trim(sufficiencyrate)/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and trim(sufficiencyrate)is not null
                and trim(sufficiencyrate)/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
        ,posted_load_a as posted
       ,nbi_41
       ,nbi_104
from nbip10 n
where nbi_5a = (select min(nbi_5a) from
nbip10 ni
where ni.nbi_8 = n.nbi_8)
UNION ALL
select '2011'
,nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
,(to_number(nvl(trim(nbi_51),0)/10)/.3048)*
(to_number(nvl(trim(nbi_49),0)/10)/.3048) as deckarea
,case
  when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
    then 'State'
  when nvl(kta_y_n,'-1') = 'Y'
    then 'KTA'
 when ((nvl(local_y_n,'-1') = 'Y' and nvl(nbi_21,'-1') = '04')
or (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nbi_26) > 10) )
    then 'City'
   when ((nvl(local_y_n,'-1') = 'Y' and nbi_5a = '1' and nvl(nbi_21,'-1') <> '04') or
     (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nvl(NBI_26,-1)) < 10))
     then 'County'
     else '?'
       end as juris
  --    ,f_nbi_on_under(n.nbi_8,'nbip11') as  min_on_under
      ,case when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null
        and  trim(sufficiencyrate)/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null and trim(sufficiencyrate)/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and trim(sufficiencyrate)is not null
                and trim(sufficiencyrate)/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
        ,posted_load_a as posted
       ,nbi_41
       ,nbi_104
from nbip11 n
where nbi_5a = (select min(nbi_5a) from
nbip11 ni
where ni.nbi_8 = n.nbi_8)
UNION ALL
select '2012'
,nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
,(to_number(nvl(trim(nbi_51),0)/10)/.3048)*
(to_number(nvl(trim(nbi_49),0)/10)/.3048) as deckarea
,case
  when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
    then 'State'
  when nvl(kta_y_n,'-1') = 'Y'
    then 'KTA'
 when ((nvl(local_y_n,'-1') = 'Y' and nvl(nbi_21,'-1') = '04')
or (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nbi_26) > 10) )
    then 'City'
   when ((nvl(local_y_n,'-1') = 'Y' and nbi_5a = '1' and nvl(nbi_21,'-1') <> '04') or
     (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nvl(NBI_26,-1)) < 10))
     then 'County'
     else '?'
       end as juris
  --     ,f_nbi_on_under(n.nbi_8,'nbip12') as  min_on_under
      ,case when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null
        and  trim(sufficiencyrate)/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null and trim(sufficiencyrate)/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and trim(sufficiencyrate)is not null
                and trim(sufficiencyrate)/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
       ,posted_load_a as posted
       ,nbi_41
       ,nbi_104
from nbip12 n
where nbi_5a = (select min(nbi_5a) from
nbip12 ni
where ni.nbi_8 = n.nbi_8)
UNION ALL
select '2013'
,nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
,(to_number(nvl(trim(nbi_51),0)/10)/.3048)*
(to_number(nvl(trim(nbi_49),0)/10)/.3048) as deckarea
,case
  when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
    then 'State'
  when nvl(kta_y_n,'-1') = 'Y'
    then 'KTA'
 when ((nvl(local_y_n,'-1') = 'Y' and nvl(nbi_21,'-1') = '04')
or (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nbi_26) > 10) )
    then 'City'
   when ((nvl(local_y_n,'-1') = 'Y' and nbi_5a = '1' and nvl(nbi_21,'-1') <> '04') or
     (nvl(local_y_n,'-1') = 'Y' and nbi_5a = '2' and to_number(nvl(NBI_26,-1)) < 10))
     then 'County'
     else '?'
       end as juris
  --     ,f_nbi_on_under(n.nbi_8,'nbip13') as  min_on_under
     ,case when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null
        and  trim(sufficiencyrate)/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and trim(sufficiencyrate) is not null and trim(sufficiencyrate)/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and trim(sufficiencyrate)is not null
                and trim(sufficiencyrate)/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
       ,posted_load_a as posted
       ,nbi_41
       ,nbi_104
from nbip13 n
where nbi_5a = (select min(nbi_5a) from
nbip13 ni
where ni.nbi_8 = n.nbi_8)
UNION ALL
select '2014',
       nbi_8,
       nbi_5a,
       substr(nbi_washingtonuse, -1) SDFO,
       (to_number(nvl(trim(nbi_51),0)/10)/.3048)*
(to_number(nvl(trim(nbi_49),0)/10)/.3048) as deckarea
       ,f_jurisdiction_rpt_owner(nbi_22) as juris
         ,case
         when f_jurisdiction_rpt_owner(nbi_22) in ('State','KTA') and
              trim(sufficiencyrate) is not null and
              trim(sufficiencyrate) / 10 between 0 and 49.9 then
          1
         when f_jurisdiction_rpt_owner(nbi_22) in ('State','KTA') and
              trim(sufficiencyrate) is not null and
              trim(sufficiencyrate) / 10 between 50 and 80 then
          2
         when f_jurisdiction_rpt_owner(nbi_22) in ('State','KTA') and
              trim(sufficiencyrate) is not null and
              trim(sufficiencyrate) / 10 between 80.1 and 100 then
          3
         else
          0
       end as suffgroup,
       nbi_103,
       case
         when f_jurisdiction_rpt_owner(nbi_22) in ('State','KTA') and
           nvl(nbi_41,'-1') = 'P' then
           'Y'
           else ''
             end as posted,
       nbi_41
       ,nbi_104
  from nbip14 n
where nbi_5a = (select min(nbi_5a) from
nbip14 ni
where ni.nbi_8 = n.nbi_8)
 UNION ALL
select '2015',
       nbi_8,
       nbi_5a,
       substr(nbi_washingtonuse, -1) SDFO,
       (to_number(nvl(trim(nbi_51),0)/10)/.3048)*
(to_number(nvl(trim(nbi_49),0)/10)/.3048) as deckarea
       ,f_jurisdiction_rpt_owner(nbi_22) as juris
         ,case
         when f_jurisdiction_rpt_owner(nbi_22) in ('State','KTA') and
              trim(sufficiencyrate) is not null and
              trim(sufficiencyrate) / 10 between 0 and 49.9 then
          1
         when f_jurisdiction_rpt_owner(nbi_22) in ('State','KTA') and
              trim(sufficiencyrate) is not null and
              trim(sufficiencyrate) / 10 between 50 and 80 then
          2
         when f_jurisdiction_rpt_owner(nbi_22) in ('State','KTA') and
              trim(sufficiencyrate) is not null and
              trim(sufficiencyrate) / 10 between 80.1 and 100 then
          3
         else
          0
       end as suffgroup,
       nbi_103,
       case
         when f_jurisdiction_rpt_owner(nbi_22) in ('State','KTA') and
           nvl(nbi_41,'-1') = 'P' then
           'Y'
           else ''
             end as posted,
       nbi_41
       ,nbi_104
  from nbip15 n
where nbi_5a = (select min(nbi_5a) from
nbip15 ni
where ni.nbi_8 = n.nbi_8);