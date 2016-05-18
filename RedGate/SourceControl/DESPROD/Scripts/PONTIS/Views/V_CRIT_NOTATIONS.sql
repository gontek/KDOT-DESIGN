CREATE OR REPLACE FORCE VIEW pontis.v_crit_notations (brkey,strunitkey,district,adminarea,maint_rte_num,design_ref_post,featint,strtype,brinspfreq_kdot,inspdate,dkrating,suprating,subrating,fclastinsp,uwlastinsp,critnote) AS
(
SELECT  b.brkey,
        su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '1' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N' AND
      b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '1') or
         (us.crit_note_sup_2 = '1') or
         ( us.crit_note_sup_3 = '1') or
         ( us.crit_note_sup_4 = '1') or
         ( us.crit_note_sup_5 = '1')))
         union all
       SELECT  b.brkey,
       su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
          f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '2' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N' and
      b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '2') or
         (us.crit_note_sup_2 = '2') or
         ( us.crit_note_sup_3 = '2') or
         ( us.crit_note_sup_4 = '2') or
         ( us.crit_note_sup_5 = '2')))
    union all
   SELECT  b.brkey,
   su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '3' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '3') or
         (us.crit_note_sup_2 = '3') or
         ( us.crit_note_sup_3 = '3') or
         ( us.crit_note_sup_4 = '3') or
         ( us.crit_note_sup_5 = '3')))
         union all
 SELECT  b.brkey,
 su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '4' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_dk_1 = '4') or
         (us.crit_note_dk_2 = '4')))
          union all
  SELECT  b.brkey,
  su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
        f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '5' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_dk_1 = '5') or
         (us.crit_note_dk_2 = '5') ))
         union all
   SELECT  b.brkey,
   su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
        f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '6' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '6') or
         (us.crit_note_sup_2 = '6') or
         ( us.crit_note_sup_3 = '6') or
         ( us.crit_note_sup_4 = '6') or
         ( us.crit_note_sup_5 = '6')))
         union all
  SELECT  b.brkey,
  su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '7' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '7') or
         (us.crit_note_sup_2 = '7') or
         ( us.crit_note_sup_3 = '7') or
         ( us.crit_note_sup_4 = '7') or
         ( us.crit_note_sup_5 = '7')))
         union all
   SELECT  b.brkey,
   su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '8' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '8') or
         (us.crit_note_sup_2 = '8') or
         ( us.crit_note_sup_3 = '8') or
         ( us.crit_note_sup_4 = '8') or
         ( us.crit_note_sup_5 = '8')))
         union all
   SELECT  b.brkey,
   su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '9' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '9') or
         (us.crit_note_sup_2 = '9') or
         ( us.crit_note_sup_3 = '9') or
         ( us.crit_note_sup_4 = '9') or
         ( us.crit_note_sup_5 = '9')))
         union all
 SELECT  b.brkey,
 su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '10' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '10') or
         (us.crit_note_sup_2 = '10') or
         ( us.crit_note_sup_3 = '10') or
         ( us.crit_note_sup_4 = '10') or
         ( us.crit_note_sup_5 = '10')))
         union all
  SELECT  b.brkey,
  su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '11' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '11') or
         (us.crit_note_sup_2 = '11') or
         ( us.crit_note_sup_3 = '11') or
         ( us.crit_note_sup_4 = '11') or
         ( us.crit_note_sup_5 = '11')))
       union all
  SELECT  b.brkey,
  su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '12' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sub_1 = '12') or
         (us.crit_note_sub_2 = '12')))
         union all
  SELECT  b.brkey,
  su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
        f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '13' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sub_1 = '13') or
         (us.crit_note_sub_2 = '13')))
          union all
   SELECT  b.brkey,
   su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
        f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '14' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '14') or
         (us.crit_note_sup_2 = '14') or
         ( us.crit_note_sup_3 = '14') or
         ( us.crit_note_sup_4 = '14') or
         ( us.crit_note_sup_5 = '14')))
                 union all
   SELECT  b.brkey,
   su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
       f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '15' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '15') or
         (us.crit_note_sup_2 = '15') or
         ( us.crit_note_sup_3 = '15') or
         ( us.crit_note_sup_4 = '15') or
         ( us.crit_note_sup_5 = '15')))
                 union all
   SELECT  b.brkey,
   su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
        f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '16' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '16') or
         (us.crit_note_sup_2 = '16') or
         ( us.crit_note_sup_3 = '16') or
         ( us.crit_note_sup_4 = '16') or
         ( us.crit_note_sup_5 = '16')))
                 union all
  SELECT  b.brkey,
  su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '17' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '17') or
         (us.crit_note_sup_2 = '17') or
         ( us.crit_note_sup_3 = '17') or
         ( us.crit_note_sup_4 = '17') or
         ( us.crit_note_sup_5 = '17')))
                 union all
 SELECT  b.brkey,
 su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
        f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '18' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '18') or
         (us.crit_note_sup_2 = '18') or
         ( us.crit_note_sup_3 = '18') or
         ( us.crit_note_sup_4 = '18') or
         ( us.crit_note_sup_5 = '18')))
                 union all
 SELECT  b.brkey,
 su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '19' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '19') or
         (us.crit_note_sup_2 = '19') or
         ( us.crit_note_sup_3 = '19') or
         ( us.crit_note_sup_4 = '19') or
         ( us.crit_note_sup_5 = '19')))
                 union all
 SELECT  b.brkey,
 su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '20' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '20') or
         (us.crit_note_sup_2 = '20') or
         ( us.crit_note_sup_3 = '20') or
         ( us.crit_note_sup_4 = '20') or
         ( us.crit_note_sup_5 = '20')))
                union all
  SELECT  b.brkey,
  su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '21' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '21') or
         (us.crit_note_sup_2 = '21') or
         ( us.crit_note_sup_3 = '21') or
         ( us.crit_note_sup_4 = '21') or
         ( us.crit_note_sup_5 = '21')))
                 union all
  SELECT  b.brkey,
  su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
        f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '22' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '22') or
         (us.crit_note_sup_2 = '22') or
         ( us.crit_note_sup_3 = '22') or
         ( us.crit_note_sup_4 = '22') or
         ( us.crit_note_sup_5 = '22')))
                 union all
   SELECT  b.brkey,
   su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '23' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_cul_1 = '23') or
         (us.crit_note_cul_2 = '23')))
               union all
  SELECT  b.brkey,
  su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
          f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '24' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_cul_1 = '24') or
         (us.crit_note_cul_2 = '24')))
                 union all
   SELECT  b.brkey,
   su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '25' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '25') or
         (us.crit_note_sup_2 = '25') or
         ( us.crit_note_sup_3 = '25') or
         ( us.crit_note_sup_4 = '25') or
         ( us.crit_note_sup_5 = '25')))
                 union all
  SELECT  b.brkey,
  su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
          f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '26' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '26') or
         (us.crit_note_sup_2 = '26') or
         ( us.crit_note_sup_3 = '26') or
         ( us.crit_note_sup_4 = '26') or
         ( us.crit_note_sup_5 = '26')))
                 union all
   SELECT  b.brkey,
   su.strunitkey,
        b.district,
        b.adminarea,
         ur.maint_rte_num,
         ub.design_ref_post,
         b.featint,
         f_get_paramtrs_equiv_long('userstrunit','unit_material',us.unit_material)||
       f_get_paramtrs_equiv_long('userstrunit','unit_type',us.unit_type)||
       f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.super_design_ty) as strtype,
         ui.brinspfreq_kdot,
         i.inspdate,
         i.dkrating,
         i.suprating,
         i.subrating,
         i.fclastinsp,
         i.uwlastinsp,
         '27' as critnote
  FROM bridge b,
         userbrdg ub,
         userrway ur,
         userstrunit us,
         userinsp ui,
         inspevnt i,
         structure_unit su,
         mv_latest_inspection mv
   WHERE ub.brkey = b.brkey and
         ur.brkey = b.brkey and
      ur.on_under = (select min(on_under) from userrway r
          where r.brkey = ur.brkey) and
         us.brkey = b.brkey and
         su.brkey = b.brkey and
         su.strunitkey = us.strunitkey and
         su.strunittype = '1' and
         ui.brkey = b.brkey and
         i.brkey = b.brkey and
         mv.brkey = b.brkey and
         i.inspkey = mv.inspkey and
         ui.inspkey = mv.inspkey and
      ub.kta_insp = 'N'
      and b.district <> '9'
       and b.brkey in (select distinct brkey from userstrunit us
       where us.brkey = b.brkey and
       ((us.crit_note_sup_1 = '27') or
         (us.crit_note_sup_2 = '27') or
         ( us.crit_note_sup_3 = '27') or
         ( us.crit_note_sup_4 = '27') or
         ( us.crit_note_sup_5 = '27')))
          )

 ;