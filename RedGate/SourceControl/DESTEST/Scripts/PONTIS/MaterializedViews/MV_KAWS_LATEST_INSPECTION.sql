CREATE MATERIALIZED VIEW pontis.mv_kaws_latest_inspection (co_ser,inspdate,inspkey,inspfirm)
AS SELECT   K.CO_SER,
         ki.inspdate,
         ki.inspkey,
         KI.INSPFIRM
    FROM pontis.KAWS_STRUCTURES K,pontis.KAWS_INSPEVNT KI
WHERE KI.CO_SER = K.CO_SER AND
      K.DISTRICT <> '9' and
          ( ( KI.INSPKEY = ( SELECT MAX(INSPKEY) FROM pontis.KAWS_INSPEVNT KI2
WHERE KI2.CO_SER = K.CO_SER
      AND ki2.inspfirm = '2' and
      KI2.INSPDATE = (SELECT MAX(INSPDATE) FROM pontis.KAWS_INSPEVNT KI3
WHERE KI3.CO_SER = K.CO_SER
and ki3.inspfirm ='2' ))) or
            (KI.INSPKEY = (SELECT MAX(INSPKEY) FROM pontis.KAWS_INSPEVNT KI4
WHERE KI4.CO_SER = K.CO_SER AND
     ki4.inspfirm = '3'  and
      KI4.INSPDATE = (SELECT MAX(INSPDATE) FROM pontis.KAWS_INSPEVNT KI5
WHERE KI5.CO_SER = K.CO_SER and
      KI5.inspfirm = '3')))
    or
            (KI.INSPKEY = (SELECT MAX(INSPKEY) FROM pontis.KAWS_INSPEVNT KI4
WHERE KI4.CO_SER = K.CO_SER AND
     ki4.inspfirm = '4'  and
      KI4.INSPDATE = (SELECT MAX(INSPDATE) FROM pontis.KAWS_INSPEVNT KI5
WHERE KI5.CO_SER = K.CO_SER and
      KI5.inspfirm = '4')))
     or
            (KI.INSPKEY = (SELECT MAX(INSPKEY) FROM pontis.KAWS_INSPEVNT KI4
WHERE KI4.CO_SER = K.CO_SER AND
     ki4.inspfirm = '0'  and
      KI4.INSPDATE = (SELECT MAX(INSPDATE) FROM pontis.KAWS_INSPEVNT KI5
WHERE KI5.CO_SER = K.CO_SER and
      KI5.inspfirm = '0')))  );