CREATE OR REPLACE procedure pontis.QRY_UPD_NBI_FIELDS is


/* CREATED TO POPULATE NBI FIELDS THAT WERE NOT UPDATED FROM THE SYNC
   PROCESS OR TRIGGERS.
   
*/


begin

update bridge
set navcntrol = (select nbi38 from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1')
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');
commit;

update bridge
set sumlanes = nbip.f_check_nbi_28b_on(brkey);
commit;

update bridge
set servtypon = nbip.f_check_nbi_42a(brkey);
commit;

update bridge
set servtypund = nbip.f_check_nbi_42b(brkey);
commit;

update bridge
set materialmain = substr(nbip.f_check_nbi_43(brkey),1,1);
commit;

update bridge
set designmain = ltrim(substr(nbip.f_check_nbi_43(brkey),-2),'0');
commit;


update bridge
set materialappr = substr(nbip.f_check_nbi_44(brkey),1,1);
commit;

update bridge
set designappr = NVL(SUBSTR(NBIP.F_CHECK_NBI_44(brkey),-2),'00');
commit;

--- fixes userstrunit and then nbi_45 bridge.mainspans
update userstrunit
set tot_num_spans = (select totalspans from v_totalspans t
where t.brkey = userstrunit.brkey and
t.strunitkey = userstrunit.strunitkey)
where userstrunit.brkey in (select brkey from userstrunit ui
where ui.brkey = userstrunit.brkey and
ui.strunitkey = userstrunit.strunitkey);
commit;

update bridge
set mainspans = to_number(nbip.f_check_nbi_45(brkey));
commit;

update bridge
set appspans = to_number(nbip.f_check_nbi_46(brkey));
commit;

update bridge
set maxspan = (select nbi48 from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1')
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');
commit;

update bridge
set refvuc = (select nbi54a from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1')
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');
commit;


update bridge
set refhuc = (select nbi55a from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1')
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');
commit;

update bridge
set propwork = (select nbi75a from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1' )
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');
commit;


update bridge
set workby = (select nbi75b from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1' )
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');
commit;


update bridge
set implen = (select nbi76 from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1' )
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');
commit;


update bridge
set nbiimpcost = (select nbi94 from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1' )
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');
commit;

update bridge
set nbirwcost = (select nbi95 from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1' )
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');
commit;


update bridge
set nbitotcost = (select nbi96 from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1' )
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');
commit;



update bridge
set appspans = (select nbi_46 from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1' )
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');
commit;

update bridge
set nbiyrcost = (select nbi97 from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1' )
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');
--added 7/15/2013
update bridge
set vclrunder = (select nbi54B from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1' )
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');
--added 7/15/2013
update bridge
set hclrurt = (select nbi55B from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1' )
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');

--added 7/15/2013
update bridge
set hclrult = (select nbi56 from mv_pontis_nbi_fields_upd mv
where mv.brkey = bridge.brkey and mv.nbi_5a = '1' )
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = bridge.brkey and
mv1.nbi_5a = '1');


update roadway
set hclrinv = (select nbi47_on from mv_pontis_nbi_fields_upd mv
where mv.brkey = roadway.brkey and
      mv.nbi_5a = roadway.on_under)
where brkey in (select brkey from mv_pontis_nbi_fields_upd mv1
where mv1.brkey = roadway.brkey and
      mv1.nbi_5a = roadway.on_under);
commit;


--added 7/17/2013 not an NBI field, but needs to be populated anyway for
--new structures

update userstrunit
set tot_num_spans = (select totalspans from v_totalspans t
where t.brkey = userstrunit.brkey and
t.strunitkey = userstrunit.strunitkey)
where userstrunit.brkey in (select brkey from userstrunit ui
where ui.brkey = userstrunit.brkey and
ui.strunitkey = userstrunit.strunitkey);

commit;

update bridge
set mainspans = to_number(nbip.f_check_nbi_45(brkey));
commit;
--added 1/27/2014 to facilitate changes from userbrdg load ratings to the corresponding NBI Fields.
update bridge
set orload = (select f_get_nbi_64_66(u.brkey,u.orload_adj_hs,u.orload_lfd_hs,u.orload_wsd_hs)
from userbrdg u
where u.brkey = bridge.brkey);
commit;

update bridge
set irload = (select f_get_nbi_64_66(u.brkey,u.irload_adj_hs,u.irload_lfd_hs,u.irload_wsd_hs)
from userbrdg u
where u.brkey = bridge.brkey);
commit;


update bridge
set strucname = ( select u.maint_rte_num||'-'||ltrim(substr(b.brkey,0,3),'0')||'-'||ltrim(to_char(design_ref_post, '999.99'))||'('||substr(b.brkey,4,3)||')'
from bridge b, userrway u, userbrdg ub
where b.brkey = bridge.brkey and
      ub.brkey =b.brkey and
      u.brkey = b.brkey and
      u.on_under = '1');
commit;
end;      

 
/