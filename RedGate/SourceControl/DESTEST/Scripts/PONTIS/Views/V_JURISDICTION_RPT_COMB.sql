CREATE OR REPLACE FORCE VIEW pontis.v_jurisdiction_rpt_comb (inspec_year,nbi_8,nbi_5a,sdfo,juris,suffgroup,nbi_103,posted_a,posted_b,posted_c) AS
select '2003' as inspec_year
,nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
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
      ,case when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1'
        and  sufficiencyrate/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1' and sufficiencyrate/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and nvl(sufficiencyrate,'-1') > '-1'
                and nvl(sufficiencyrate,'-1')/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
       ,case
        when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_a')> 0
          then 'Y'
            end as posted_a
         ,case
         when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_b')> 0
          then 'Y'
            end as posted_b
         ,case
           when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_c')> 0
          then 'Y'
            end as posted_c
from nbip03 n
where nbi_5a = (select min(nbi_5a) from
nbip03  ni
where ni.nbi_8 = n.nbi_8)
UNION ALL
select '2004' as inspec_year
,nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
,case
  when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
    and substr(nbi_8,1,4) = '9999' then 'State'
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
      ,case when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1'
        and  sufficiencyrate/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1' and sufficiencyrate/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and nvl(sufficiencyrate,'-1') > '-1'
                and nvl(sufficiencyrate,'-1')/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
       ,case
        when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_a')> 0
          then 'Y'
            end as posted_a
         ,case
         when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_b')> 0
          then 'Y'
            end as posted_b
         ,case
           when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_c')> 0
          then 'Y'
            end as posted_c
from nbip04 n
where nbi_5a = (select min(nbi_5a) from
nbip04  ni
where ni.nbi_8 = n.nbi_8)
UNION ALL
select '2005' as inspec_year
,nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
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
      ,case when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1'
        and  sufficiencyrate/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1' and sufficiencyrate/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and nvl(sufficiencyrate,'-1') > '-1'
                and nvl(sufficiencyrate,'-1')/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
       ,case
        when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_a')> 0
          then 'Y'
            end as posted_a
         ,case
         when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_b')> 0
          then 'Y'
            end as posted_b
         ,case
           when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_c')> 0
          then 'Y'
            end as posted_c
from nbip05 n
where nbi_5a = (select min(nbi_5a) from
nbip05  ni
where ni.nbi_8 = n.nbi_8)

UNION ALL
select '2009' as inspec_year
,nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
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
      ,case when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1'
        and  sufficiencyrate/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1' and sufficiencyrate/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and nvl(sufficiencyrate,'-1') > '-1'
                and nvl(sufficiencyrate,'-1')/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
       ,case
        when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_a')> 0
          then 'Y'
            end as posted_a
         ,case
         when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_b')> 0
          then 'Y'
            end as posted_b
         ,case
           when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_c')> 0
          then 'Y'
            end as posted_c
from nbip09 n
where nbi_5a = (select min(nbi_5a) from
nbip09  ni
where ni.nbi_8 = n.nbi_8)
UNION ALL
select '2010'
, nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
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
      ,case when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1'
        and  sufficiencyrate/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1' and sufficiencyrate/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and nvl(sufficiencyrate,'-1') > '-1'
                and nvl(sufficiencyrate,'-1')/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
       ,case
        when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_a')> 0
          then 'Y'
            end as posted_a
         ,case
         when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_b')> 0
          then 'Y'
            end as posted_b
         ,case
           when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_c')> 0
          then 'Y'
            end as posted_c


from nbip10 n
where nbi_5a = (select min(nbi_5a) from
nbip10 ni
where ni.nbi_8 = n.nbi_8)
UNION ALL
select '2011'
,nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
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
      ,case when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1'
        and  sufficiencyrate/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1' and sufficiencyrate/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and nvl(sufficiencyrate,'-1') > '-1'
                and nvl(sufficiencyrate,'-1')/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
       ,case
        when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_a')> 0
          then 'Y'
            end as posted_a
         ,case
         when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_b')> 0
          then 'Y'
            end as posted_b
         ,case
           when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_c')> 0
          then 'Y'
            end as posted_c

from nbip11 n
where nbi_5a = (select min(nbi_5a) from
nbip11 ni
where ni.nbi_8 = n.nbi_8)
UNION ALL
select '2012'
,nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
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
      ,case when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1'
        and  sufficiencyrate/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1' and sufficiencyrate/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and nvl(sufficiencyrate,'-1') > '-1'
                and nvl(sufficiencyrate,'-1')/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
       ,case
        when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_a')> 0
          then 'Y'
            end as posted_a
         ,case
         when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_b')> 0
          then 'Y'
            end as posted_b
         ,case
           when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_c')> 0
          then 'Y'
            end as posted_c


from nbip12 n
where nbi_5a = (select min(nbi_5a) from
nbip12 ni
where ni.nbi_8 = n.nbi_8)
UNION ALL
select '2013'
,nbi_8
,nbi_5a
,substr(nbi_washingtonuse,-1) SDFO
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
      ,case when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1'
        and  sufficiencyrate/10 between 0 and 49.9
        then 1
          when nvl(local_y_n,'-1') <> 'Y'
        and nvl(sufficiencyrate,'-1') > '-1' and sufficiencyrate/10 between 50 and 80
            then 2
              when nvl(local_y_n,'-1') <> 'Y'
                and nvl(sufficiencyrate,'-1') > '-1'
                and nvl(sufficiencyrate,'-1')/10  between 80.1 and 100
                then 3
                  else 0
                    end as suffgroup
       ,nbi_103
       ,case
        when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_a')> 0
          then 'Y'
            end as posted_a
         ,case
         when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_b')> 0
          then 'Y'
            end as posted_b
         ,case
           when nvl(local_y_n,'-1') <> 'Y' and nvl(kta_y_n,'-1') <> 'Y'
          and bif.f_get_bif_brdgdata(substr(nbi_8,9,6),'userbrdg','posted_load_c')> 0
          then 'Y'
            end as posted_c


from nbip13 n
where nbi_5a = (select min(nbi_5a) from
nbip13 ni
where ni.nbi_8 = n.nbi_8)

 ;