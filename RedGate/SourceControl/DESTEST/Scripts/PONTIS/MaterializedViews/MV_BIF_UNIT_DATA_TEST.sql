CREATE MATERIALIZED VIEW pontis.mv_bif_unit_data_test (brkey,brdgculv,strunitkey,bif_spangrps,unitcount,strtype,deckwidth,lftcurbsw,rtcurbsw,boxheight,bridgemed,culv_fill_depth,culv_wing_type,last_paint_supe,median_width_eng,suprstruct_tos_eng,super_paint_sys,bermprot,abut_foot_far,abut_foot_near,abut_type_far,abut_type_near,bearing_type,env_notation_1,crit_note_dk_1,crit_note_dk_2,crit_note_cul_1,crit_note_cul_2,crit_note_sub_1,crit_note_sub_2,crit_note_sup_1,crit_note_sup_2,crit_note_sup_3,crit_note_sup_4,crit_note_sup_5,deck_thick_eng,deck_matrl,dk_drain_sys,dksurftype,expan_dev_near,expan_dev_far,hinge_type,pier_foot_type,pier_type,rail_type,wear_thick,dk_top_delams,dk_top_spalls,dk_top_deter,dk_deter_btm,dk_spalls_btm,unit_dk_rating,unit_sup_rating,unit_sub_rating,unit_culv_rating,dkrating,suprating,subrating,culvrating,deck_comp_hi,super_comp_hi,sub_comp_hi,culv_comp_hi,paint_cond,elem_key,elem_parent_key,envkey,qty,qty1,qty2,qty3,qty4,pct1,pct2,pct3,pct4,elem_shortname,englishunit,e_line,kdot_element_type)
REFRESH START WITH TO_DATE('2016-5-18 12:15:58', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE+(DECODE(TO_CHAR(SYSDATE,'D'),6,3,7,2,1)) 
AS SELECT b.brkey
,case
  when length(f_structuretype(s.brkey,us.strunitkey)) = 4
    then 'B'
      else 'C'
      end as brdgculv,
    to_char(us.STRUNITKEY) as strunitkey,
    sp.bif_spangrps,
    f_multiple_unit(b.brkey) as unitcount,
    f_structuretype(b.brkey,us.strunitkey) as strtype,
         to_char(round(b.deckwidth/0.3048,1))||' ft.' as deckwidth,
       to_char(round(nvl(B.lftcurbsw,0) / 0.3048,1))||' ft.' as LFTCURBSW,
       to_char(round(nvl(B.RTCURBSW,0) / 0.3048,1))||' ft.' AS RTCURBSW,
     to_char(round(nvl(UB.BOX_HEIGHT_CULV,0)/ 0.3048,1))||' ft.' as  boxheight,
      trim(f_get_paramtrs_equiv_long('userbrdg','bridgemed_kdot',ub.BRIDGEMED_KDOT)) bridgemed,
      to_char(round(nvl(ub.CULV_FILL_DEPTH,0) / 0.3048,1))||' ft.' as  CULV_FILL_DEPTH,
         trim(f_get_paramtrs_equiv('userbrdg','culv_wing_type',nvl(UB.CULV_WING_TYPE,'0'))) as culv_wing_type,
        decode(UB.LAST_PAINT_SUPE,null,'N/A','01/jan/1901','N/A',extract(year from UB.last_paint_supe)) as last_paint_supe,
        to_char(round(nvl(UB.MEDIAN_WIDTH,0) / 0.3048,1))||' ft.' AS MEDIAN_WIDTH_ENG,
         decode(to_char(round(nvl(UB.SUPRSTRUCT_TOS,0) / 0.9072)),0,'N/A',
         to_char(round(nvl(UB.SUPRSTRUCT_TOS,0) / 0.9072))) AS SUPRSTRUCT_TOS_ENG,
         nvl(trim(f_get_paramtrs_equiv_long('userbrdg','super_paint_sys',UB.SUPER_PAINT_SYS)),'N/A') as super_paint_sys,
        trim(f_get_paramtrs_equiv_long('userrway','berm_prot',(bif.f_get_bif_rdwydata(b.brkey,'1','userrway','berm_prot'))) )as bermprot,
         trim(f_get_paramtrs_equiv_long('userstrunit','abut_foot_type',us.ABUT_FOOT_FAR))as abut_foot_far,
         trim(f_get_paramtrs_equiv_long('userstrunit','abut_foot_type',us.ABUT_FOOT_near))as abut_foot_near,
         trim(f_get_paramtrs_equiv_long('userstrunit','abut_type',us.ABUT_TYPE_FAR))as abut_type_far,
         trim(f_get_paramtrs_equiv_long('userstrunit','abut_type',us.ABUT_type_NEAR))as abut_type_near,
         trim(f_get_paramtrs_equiv_long('userstrunit','bearing_type',us.bearing_type)) as bearing_type,
        case when env_notation_1 is null or env_notation_1 = '-1'
          then 'None'
            else trim(f_get_paramtrs_equiv_long('userbrdg','env_notation',ub.env_notation_1))
              end as env_notation_1,
        case when crit_note_dk_1 is null or crit_note_dk_1 = '-1'
          then 'None'
        else trim(f_get_paramtrs_equiv_long('userstrunit','crit_note_dk',us.crit_note_dk_1))
          end as crit_note_dk_1,
        case when crit_note_dk_2 is null or crit_note_dk_2 = '-1'
         then ' '
          else ' , '|| trim(f_get_paramtrs_equiv_long('userstrunit','crit_note_dk',us.crit_note_dk_2))
         end as crit_note_dk_2,
         case when crit_note_cul_1 is null or crit_note_cul_1 = '-1'
         then 'None'
          else trim(f_get_paramtrs_equiv_long('userstrunit','crit_note_culv',us.crit_note_cul_1))
         end as crit_note_cul_1,
         case when crit_note_cul_2 is null or crit_note_cul_2 = '-1'
         then ' '
          else ', '||trim(f_get_paramtrs_equiv_long('userstrunit','crit_note_culv',us.crit_note_cul_2))
         end as crit_note_cul_2,
         case when crit_note_sub_1 is null or crit_note_sub_1 = '-1'
         then 'None'
          else trim(f_get_paramtrs_equiv_long('userstrunit','crit_note_sub',us.crit_note_sub_1))
         end as crit_note_sub_1,
         case when crit_note_sub_2 is null or crit_note_sub_2 = '-1'
         then ' '
          else ', '||trim(f_get_paramtrs_equiv_long('userstrunit','crit_note_sub',us.crit_note_sub_2))
         end as crit_note_sub_2,
         case when crit_note_sup_1 is null or crit_note_sup_1 = '-1'
         then 'None'
          else trim(f_get_paramtrs_equiv_long('userstrunit','crit_note_sup',us.crit_note_sup_1))
         end as crit_note_sup_1,
          case when crit_note_sup_2 is null or crit_note_sup_2 = '-1'
         then ' '
          else ', '||trim(f_get_paramtrs_equiv_long('userstrunit','crit_note_sup',us.crit_note_sup_2))
         end as crit_note_sup_2,
          case when crit_note_sup_3 is null or crit_note_sup_3 = '-1'
         then ' '
          else ', '||trim(f_get_paramtrs_equiv_long('userstrunit','crit_note_sup',us.crit_note_sup_3))
         end as crit_note_sup_3,
          case when crit_note_sup_4 is null or crit_note_sup_4 = '-1'
         then ' '
          else ', '||trim(f_get_paramtrs_equiv_long('userstrunit','crit_note_sup',us.crit_note_sup_4))
         end as crit_note_sup_4,
          case when crit_note_sup_5 is null or crit_note_sup_5 = '-1'
         then ' '
          else ', '||trim(f_get_paramtrs_equiv_long('userstrunit','crit_note_sup',us.crit_note_sup_5))
         end as crit_note_sup_5,
         to_char(round(us.deck_thick/25.4,1))||' in.' as deck_thick_eng,
         trim(f_get_paramtrs_equiv('userstrunit','deck_matrl',us.DECK_MATRL)) as deck_matrl,
         trim(f_get_paramtrs_equiv('userstrunit','dk_drain_sys',us.DK_DRAIN_SYS)) as dk_drain_sys,
         trim(f_get_paramtrs_equiv('userstrunit','dksurftype',us.DKSURFTYPE)) as dksurftype,
         trim(f_get_paramtrs_equiv('userstrunit','expan_dev',nvl(us.EXPAN_DEV_NEAR,'0'))) as expan_dev_near,
         trim(f_get_paramtrs_equiv('userstrunit','expan_dev',nvl(us.EXPAN_DEV_FAR,'0'))) as expan_dev_far,
         trim(f_get_paramtrs_equiv('userstrunit','hinge_type',nvl(us.HINGE_TYPE,'0'))) as hinge_type,
         trim(f_get_paramtrs_equiv('userstrunit','pier_foot_type',us.PIER_FOOT_TYPE)) as pier_foot_type,
         trim(f_get_paramtrs_equiv('userstrunit','pier_type',us.PIER_TYPE)) as pier_type,
         trim(f_get_paramtrs_equiv('userstrunit','rail_type',us.RAIL_TYPE)) as rail_type,

         case when us.wear_thick is null or
           us.wear_thick = -1
           then 'N/A'
             else to_char(round(us.WEAR_THICK / 25.4,1) )||' in.'
               end AS WEAR_THICK,
        to_char(lpad(nvl(us.DK_TOP_DELAMS,0),3)) as dk_top_delams,
         to_char(lpad(nvl(us.DK_TOP_SPALLS,0),3)) as dk_top_spalls,
         to_char(lpad(nvl(us.DK_top_deter,0),3)) as dk_top_deter,
         to_char(lpad(nvl(us.dk_deter_btm,0),3)) as dk_deter_btm,
         to_char(lpad(nvl(us.dk_spalls_btm,0),3)) as dk_spalls_btm,
         to_char(us.UNIT_DK_RATING) as unit_dk_rating,
         to_char(us.UNIT_SUP_RATING) as unit_sup_rating,
         to_char(us.UNIT_SUB_RATING) as unit_sub_rating,
         to_char(us.UNIT_CULV_RATING) as unit_culv_rating,
         bif.f_get_bif_inspecdata(b.brkey,'inspevnt','dkrating') as dkrating,
         bif.f_get_bif_inspecdata(b.brkey,'inspevnt','suprating') as suprating,
         bif.f_get_bif_inspecdata(b.brkey,'inspevnt','subrating') as subrating,
         bif.f_get_bif_inspecdata(b.brkey,'inspevnt','culvrating') as culvrating,
         bif.f_get_bif_inspecdata(b.brkey,'userinsp','deck_comp_hi') as deck_comp_hi,
         bif.f_get_bif_inspecdata(b.brkey,'userinsp','super_comp_hi') as super_comp_hi,
         bif.f_get_bif_inspecdata(b.brkey,'userinsp','sub_comp_hi') as sub_comp_hi,
         bif.f_get_bif_inspecdata(b.brkey,'userinsp','culv_comp_hi') as culv_comp_hi,
         decode(bif.f_get_bif_inspecdata(b.brkey,'userinsp','paint_cond'),null,'N/A','0','N/A',
         f_get_paramtrs_equiv_LONG('userinsp','paint_cond',bif.f_get_bif_inspecdata(b.brkey,'userinsp','paint_cond'))) as paint_cond,
 PEI.elem_key,
       PEI.elem_parent_key,
       PEI.ENVKEY,
    --   PEI.STRUNITKEY,
       --    b.elem_quantity,
       --    p.factor,
       case
         when PEI.elem_key in ('515', '520', '6000') then
          to_char(round(PEI.elem_quantity / .3048))
         when PEI.elem_key in ('510') then
          to_char(round(PEI.elem_quantity / .09290304))
         when PEI.elem_key in ('1130') then
          '1'
         else
          to_char(round(PEI.ELEM_QUANTITY / P.FACTOR))
       end as QTY,
       case
         when PEI.elem_key in ('515', '520', '6000') then
          to_char(round(PEI.elem_qtystate1 / .3048))
         when PEI.elem_key in ('510') then
          to_char(round(PEI.elem_qtystate1 / .09290304))
         when PEI.elem_key in ('1130') and PEI.elem_qtystate1 > 0 then
          '1'
         else
          to_char(round(PEI.ELEM_QTYSTATE1 / P.FACTOR))
       end as qty1,
       case
         when PEI.elem_key in ('515', '520', '6000') then
          to_char(round(PEI.elem_qtystate2 / .3048))
         when PEI.elem_key in ('510') then
          to_char(round(PEI.elem_qtystate2 / .09290304))
         when PEI.elem_key in ('1130') and PEI.elem_qtystate2 <> 0 then
          '1'
         else
          to_char(round(PEI.ELEM_QTYSTATE2 / P.FACTOR))
       end as qty2,
       case
         when PEI.elem_key in ('515', '520', '6000') then
          to_char(round(PEI.elem_qtystate3 / .3048))
         when PEI.elem_key in ('510') then
          to_char(round(PEI.elem_qtystate3 / .09290304))
         when PEI.elem_key in ('1130') and PEI.elem_qtystate3 > 0 then
          '1'
         else
          to_char(round(PEI.ELEM_QTYSTATE3 / P.FACTOR))
       end as qty3,
       case
         when PEI.elem_key in ('515', '520', '6000') then
          to_char(round(PEI.elem_qtystate4 / .3048))
         when PEI.elem_key in ('510') then
          to_char(round(PEI.elem_qtystate4 / .09290304))
         when PEI.elem_key in ('1130') and PEI.elem_qtystate4 > 0 then
          '1'
         else
          to_char(round(PEI.ELEM_QTYSTATE4 / P.FACTOR))
       end as qty4,
       to_char(round(elem_pctstate1)) pct1,
       to_char(round(elem_pctstate2)) pct2,
       to_char(round(elem_pctstate3)) pct3,
       to_char(round(elem_pctstate4)) pct4,
       E.ELEM_SHORTNAME,
       P.ENGLISHUNIT,
       '_____' e_line,
       F_GET_KDOT_ELEMENT_TYPE(PEI.BRKEY, PEI.STRUNITKEY, PEI.ELEM_KEY) AS KDOT_ELEMENT_TYPE
    FROM    BRIDGE B
  INNER JOIN USERBRDG UB
  ON B.BRKEY = UB.BRKEY
  INNER JOIN USERSTRUNIT US
  ON B.BRKEY = US.BRKEY
  INNER JOIN STRUCTURE_UNIT S
  ON B.BRKEY = S.BRKEY AND
     US.STRUNITKEY = S.STRUNITKEY
  INNER JOIN MV_STRSPANS SP
  ON B.BRKEY = SP.BRKEY AND
     US.STRUNITKEY = SP.STRUNITKEY
  INNER JOIN MV_LATEST_INSPECTION MV
  ON B.BRKEY = MV.BRKEY
  INNER JOIN PON_ELEM_INSP PEI
  ON B.BRKEY = PEI.BRKEY AND
     PEI.INSPKEY = MV.INSPKEY
       INNER JOIN PON_ELEM_DEFS E
  ON PEI.ELEM_KEY = E.ELEM_KEY
  INNER JOIN METRIC_ENGLISH P
  ON P.PAIRCODE = E.ELEM_PAIRCODE

   AND  B.BRKEY = '003055';