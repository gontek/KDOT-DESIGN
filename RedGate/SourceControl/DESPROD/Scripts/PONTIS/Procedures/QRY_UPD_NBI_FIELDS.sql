CREATE OR REPLACE procedure pontis.qry_upd_nbi_fields is
 -- Summary: Populates extraneous NBI fields that have not been updated directly or from the sync
 -- process or triggered updates.<BR>
  -- <BR>
  -- %revision-history
  -- created: existing as of 2015-07-14 <BR>
  -- revised: 20-15-07-14 added documentation<BR>
  -- <p id="doc_save_date" style="margin: 0;">documentation revised: 2015-07-10</p><p id="doc_mod_date" style="margin: 0;"></p>
  -- %copyright-notice Kansas Department of Transportation, 2015 - all rights reserved
  -- %kdot-contact Ms. Deb Kossler, Bureau of Structures and Geotechnical Services, Bridge Management<BR>
  -- <a href="mailto:deb@ksdot.org?Subject="Documentation%20Question%20re:%20qry_upd_nbi_fields">Email questions about qry_upd_nbi_fields</a><BR>
  -- %developer-info Allen R. Marshall, ARM LLC
  -- <BR>ph: 617-335-6934
  -- <BR><a href="http://allenrmarshall-consulting-llc.com" alt="Link to developer website">Visit developer website</a>
  -- <BR><a href="mailto:armarshall@allenrmarshall-consulting-llc.com?Subject="Documentation%20Question%20re:%20qry_upd_nbi_fields">Email questions about qry_upd_nbi_fields</a><BR>
  -- %development-environment
  -- Oracle Database 11g Release 11.2.0.4.0<BR>
  -- OCI: version 11.1
  -- %param
  -- %usage individual sql updates to populate NBI fields
  -- %raises
  -- %return
  -- %see



begin

  update bridge
     set navcntrol =
         (select nbi38
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');
  commit;

  update bridge set sumlanes = nbip.f_check_nbi_28b_on(brkey);
  commit;

  update bridge set servtypon = nbip.f_check_nbi_42a(brkey);
  commit;

  update bridge set servtypund = nbip.f_check_nbi_42b(brkey);
  commit;

  update bridge
     set materialmain = substr(nbip.f_check_nbi_43(brkey), 1, 1);
  commit;

  update bridge
     set designmain = ltrim(substr(nbip.f_check_nbi_43(brkey), -2), '0');
  commit;

  update bridge
     set materialappr = substr(nbip.f_check_nbi_44(brkey), 1, 1);
  commit;

  update bridge
     set designappr = NVL(SUBSTR(NBIP.F_CHECK_NBI_44(brkey), -2), '00');
  commit;

  --- fixes userstrunit and then nbi_45 bridge.mainspans
  update userstrunit
     set tot_num_spans =
         (select totalspans
            from v_totalspans t
           where t.brkey = userstrunit.brkey
             and t.strunitkey = userstrunit.strunitkey)
   where userstrunit.brkey in
         (select brkey
            from userstrunit ui
           where ui.brkey = userstrunit.brkey
             and ui.strunitkey = userstrunit.strunitkey);
  commit;

  update bridge set mainspans = to_number(nbip.f_check_nbi_45(brkey));
  commit;

  update bridge set appspans = to_number(nbip.f_check_nbi_46(brkey));
  commit;

  update bridge
     set maxspan =
         (select nbi48
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');
  commit;

  update bridge
     set refvuc =
         (select nbi54a
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');
  commit;

  update bridge
     set refhuc =
         (select nbi55a
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');
  commit;

  update bridge
     set propwork =
         (select nbi75a
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');
  commit;

  update bridge
     set workby =
         (select nbi75b
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');
  commit;

  update bridge
     set implen =
         (select nbi76
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');
  commit;

  update bridge
     set nbiimpcost =
         (select nbi94
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');
  commit;

  update bridge
     set nbirwcost =
         (select nbi95
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');
  commit;

  update bridge
     set nbitotcost =
         (select nbi96
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');
  commit;

  update bridge
     set appspans =
         (select nbi_46
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');
  commit;

  update bridge
     set nbiyrcost =
         (select nbi97
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');
  --added 7/15/2013
  update bridge
     set vclrunder =
         (select nbi54B
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');
  --added 7/15/2013
  update bridge
     set hclrurt =
         (select nbi55B
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');

  --added 7/15/2013
  update bridge
     set hclrult =
         (select nbi56
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = bridge.brkey
             and mv.nbi_5a = '1')
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = bridge.brkey
                      and mv1.nbi_5a = '1');

  update roadway
     set hclrinv =
         (select nbi47_on
            from mv_pontis_nbi_fields_upd mv
           where mv.brkey = roadway.brkey
             and mv.nbi_5a = roadway.on_under)
   where brkey in (select brkey
                     from mv_pontis_nbi_fields_upd mv1
                    where mv1.brkey = roadway.brkey
                      and mv1.nbi_5a = roadway.on_under);
  commit;

  --added 7/17/2013 not an NBI field, but needs to be populated anyway for
  --new structures

  update userstrunit
     set tot_num_spans =
         (select totalspans
            from v_totalspans t
           where t.brkey = userstrunit.brkey
             and t.strunitkey = userstrunit.strunitkey)
   where userstrunit.brkey in
         (select brkey
            from userstrunit ui
           where ui.brkey = userstrunit.brkey
             and ui.strunitkey = userstrunit.strunitkey);

  commit;

  update bridge set mainspans = to_number(nbip.f_check_nbi_45(brkey));
  commit;
  --added 1/27/2014 to facilitate changes from userbrdg load ratings to the corresponding NBI Fields.
  update bridge
     set orload =
         (select nbip.f_get_nbi_64_66(u.brkey,
                                 u.orload_adj_hs,
                                 u.orload_lfd_hs,
                                 u.orload_wsd_hs)
            from userbrdg u
           where u.brkey = bridge.brkey);
  commit;

  update bridge
     set irload =
         (select nbip.f_get_nbi_64_66(u.brkey,
                                 u.irload_adj_hs,
                                 u.irload_lfd_hs,
                                 u.irload_wsd_hs)
            from userbrdg u
           where u.brkey = bridge.brkey);
  commit;

  ----Added because Bob needed for his labels (whiner)..NOW it's critical...dk 1/15/2015
  update bridge
     set strucname =
         (select u.maint_rte_num || '-' || ltrim(substr(b.brkey, 0, 3), '0') || '-' ||
                 ltrim(to_char(design_ref_post, '999.99')) || '(' ||
                 substr(b.brkey, 4, 3) || ')'
            from bridge b, userrway u, userbrdg ub
           where b.brkey = bridge.brkey
             and ub.brkey = b.brkey
             and u.brkey = b.brkey
             and u.on_under = '1');
  commit;

  -- Added updates to year built and year reconstructed to keep from running a separate procedure just for them (previous)
 update bridge b
     set yearbuilt =
         (select actvtyyear
            from v_bif_capital_prj p
           where p.brkey = b.brkey
             and p.actvtyid = '40' and b.district <> '9')
   where brkey in (select brkey
                     from bridge bi
                    where bi.brkey = b.brkey
                      and bi.district <> '9');
                      
                      
 update bridge b
set yearrecon = (select
       max(to_char(actvtydate,'YYYY'))
from v_bif_capital_prj v
where v.brkey = b.brkey and
v.actvtyid in ('13','14','15','17','18','19'))
where brkey in (select brkey
from bridge bi
where bi.brkey = b.brkey and bi.district <> '9' )
;
                     
                      

end;
/