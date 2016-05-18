CREATE MATERIALIZED VIEW pontis.mv_latest_inspection (brkey,inspkey,nextrinsp_calc,nextfcinsp_calc,nextosinsp_calc)
REFRESH START WITH TO_DATE('2016-5-18 13:41:4', 'yyyy-mm-dd hh24:mi:ss') NEXT SYSDATE + 6/24 
AS SELECT   i1.BRKEY,
 i1.INSPKEY,
 f_nextRinsp_date(brkey)as NEXTRINSP_CALC,
 f_nextfcinsp_date(brkey) as nextfcinsp_calc,
 f_nextosinsp_date(brkey) as nextosinsp_calc FROM pontis.INSPEVNT I1  WHERE   I1.INSPKEY = (SELECT MAX( I2.INSPKEY ) FROM INSPEVNT I2 WHERE  I2.BRKEY = I1.BRKEY AND I2.INSPDATE = (SELECT MAX(I3.INSPDATE) FROM INSPEVNT I3  WHERE I3.BRKEY = I1.BRKEY ) );