CREATE OR REPLACE FORCE VIEW pontis.v_mar_compliance_indicators (brkey,bridge_id,district,designmain,ortype,orload,irtype,irload,posting,inspkey,inspdate,suprating,subrating,culvrating,oppostcl,brinspfreq,uwinspreq,uwinspdone,uwinspfreq,uwlastinsp,uwater_insp_typ,uwinspfreq_mos,low_risk,high_risk,lowrisk_uw_compliance,highrisk_uw_compliance,fclastinsp,fcinspreq,fc_bridge_num_units,mar10_fc_insp_compliance,mar13_lr_compliance,mar14_posting_compliance,scourcrit,mar18_scour_poa_compliance) AS
SELECT b.Brkey,
       b.Bridge_Id,
       b.District,
       b.Designmain,
       b.Ortype,
       b.Orload,
       b.Irtype,
       b.Irload,
       b.Posting,
       i.Inspkey,
       i.Inspdate,
       i.Suprating,
       i.Subrating,
       i.Culvrating,
       i.Oppostcl,
       i.Brinspfreq,

       i.Uwinspreq,
       i.Uwinspdone,
       i.Uwinspfreq,
       i.Uwlastinsp,
       Ui.Uwater_Insp_Typ,
       Trunc(Ui.Uwinspfreq_Kdot * 12) AS Uwinspfreq_Mos,
       f_Nbi_Low_Risk(b.Brkey) AS Low_Risk,
       f_Nbi_High_Risk(b.Brkey) AS High_Risk,
       CASE
         WHEN (f_Nbi_Low_Risk(b.Brkey) = 1) AND
              Ui.Uwater_Insp_Typ IS NOT NULL AND
              Ui.Uwater_Insp_Typ IN ('3', '4') AND
              Ui.Uwinspfreq_Kdot IS NOT NULL AND
              Trunc(Ui.Uwinspfreq_Kdot * 12) <> 0 THEN
          CASE
            WHEN i.Uwlastinsp >
                 Add_Months(SYSDATE,
                            -1 * Nvl(Trunc(Ui.Uwinspfreq_Kdot * 12), 60)) THEN
             1
            ELSE
             0
          END
         ELSE
          NULL
       END AS Lowrisk_Uw_Compliance,
       CASE
         WHEN (f_Nbi_High_Risk(b.Brkey) = 1) AND
              Ui.Uwater_Insp_Typ IS NOT NULL AND
              Ui.Uwater_Insp_Typ IN ('3', '4') AND
              Ui.Uwinspfreq_Kdot IS NOT NULL AND
              Trunc(Ui.Uwinspfreq_Kdot * 12) <> 0 THEN
          CASE
            WHEN Ui.Uwinspfreq_Kdot IS NOT NULL AND Ui.Uwinspfreq_Kdot > 0 AND
                 i.Uwlastinsp >
                 Add_Months(SYSDATE,
                            -1 * Nvl(Trunc(Ui.Uwinspfreq_Kdot * 12), 60)) THEN
             1
            ELSE
             0
          END
         ELSE
          NULL
       END AS Highrisk_Uw_Compliance,
       i.Fclastinsp, --Months_Between(SYSDATE, i.Fclastinsp) as fc_months_diff,
       i.fcinspreq,
    /* OLD WAY-   CASE
         WHEN i.Fcinspreq = 'Y' THEN
          CASE
            WHEN Months_Between(SYSDATE, i.Fclastinsp) <= 24 THEN
             1
            ELSE
             0
          END
         ELSE
          NULL
       END */
       f_Is_FC_Structure(b.brkey ) as FC_BRIDGE_NUM_UNITS,
      CASE WHEN ( f_Is_FC_Structure(b.brkey)> 0 ) THEN
        f_compliance_mar10(b.brkey)
      ELSE
        NULL  -- not an fc bridge
        END
       AS Mar10_Fc_Insp_Compliance,
       CASE
         WHEN (f_Nbi_High_Risk(b.Brkey) = 1 OR f_Nbi_Low_Risk(b.Brkey) = 1) AND
              b.Irload IS NOT NULL AND b.Irload > 0 THEN
          1
         ELSE
          NULL
       END AS Mar13_Lr_Compliance,
       CASE
         WHEN ((i.Oppostcl IS NOT NULL AND i.Oppostcl <> '_' AND
              i.Oppostcl IN ('B', 'E', 'K', 'P', 'R')) OR
              (b.Designload IS NOT NULL AND b.Designload <> '_' AND
              b.Designload < '3') OR
              (b.Orload IS NOT NULL AND b.Orload < 20)) THEN
          CASE
            WHEN b.Posting IS NOT NULL AND b.Posting <> '_' AND b.Posting < '5' THEN
             1
            ELSE
             0
          END
         ELSE
          NULL
       END AS Mar14_Posting_Compliance,
        i.Scourcrit,
        case when ( i.scourcrit is not null and i.scourcrit in ('0','1','2','3','6','U')  ) THEN
         CASE WHEN ( b.USERKEY12 IS NOT NULL AND  TRIM(b.USERKEY12) NOT IN ('_' ,'!','0', '-1'  ) )   THEN 1 ELSE 0 END
           ELSE
             NULL
             END AS Mar18_Scour_POA_Compliance    -- this may have to be refined so that the value in USERKEY12 has meaningful interpretation
  FROM Bridge b
 INNER JOIN Inspevnt i
    ON b.Brkey = i.Brkey
 INNER JOIN Mv_Latest_Inspection Mv
    ON b.Brkey = Mv.Brkey
   AND i.Inspkey = Mv.Inspkey
 INNER JOIN Userinsp Ui
    ON b.Brkey = Ui.Brkey
   AND Ui.Inspkey = Mv.Inspkey --WHERE b.BRKEY='097042';
 WHERE b.District <> '9'
   --AND Ui.Uwater_Insp_Typ IN ('3', '4')
;