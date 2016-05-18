CREATE OR REPLACE FORCE VIEW pontis.v_suff_dist_report1 (brkey,suff_rate,suffcat) AS
SELECT BRKEY, SUFF_RATE,1 AS SUFFCAT
            FROM INSPEVNT B
            WHERE ((SUFF_RATE>=80) OR (B.NBI_RATING='0')) AND
                      B.INSPKEY IN
                         (SELECT MAX(I.INSPKEY) FROM  INSPEVNT I
                          WHERE I.BRKEY=B.BRKEY AND
                                I.INSPDATE=
                                   (SELECT MAX(G.INSPDATE)
                                    FROM  INSPEVNT G
                                    WHERE G.BRKEY=B.BRKEY AND
                                          G.NBINSPDONE='1'))
               UNION
               SELECT BRKEY, SUFF_RATE, 2 AS SUFFCAT
                 FROM INSPEVNT B
                WHERE ((SUFF_RATE>=50) AND (SUFF_RATE<80)) AND
                      ((B.NBI_RATING='1') OR (B.NBI_RATING='2')) AND
                      B.INSPKEY IN
                         (SELECT MAX(I.INSPKEY) FROM  INSPEVNT I
                          WHERE I.BRKEY=B.BRKEY AND
                                I.INSPDATE=
                                   (SELECT MAX(G.INSPDATE)
                                    FROM  INSPEVNT G
                                    WHERE G.BRKEY=B.BRKEY AND
                                          G.NBINSPDONE='1'))
               UNION
               SELECT BRKEY, SUFF_RATE, 3 AS SUFFCAT
                 FROM INSPEVNT B
                WHERE ((SUFF_RATE>=0) AND (SUFF_RATE<50)) AND
                      ((B.NBI_RATING='1') OR (B.NBI_RATING='2')) AND
                      B.INSPKEY IN
                         (SELECT MAX(I.INSPKEY) FROM  INSPEVNT I
                          WHERE I.BRKEY=B.BRKEY AND
                                I.INSPDATE=
                                   (SELECT MAX(G.INSPDATE)
                                    FROM  INSPEVNT G
                                    WHERE G.BRKEY=B.BRKEY AND
                                          G.NBINSPDONE='1'))
               UNION
               SELECT BRKEY, SUFF_RATE, 99 AS SUFFCAT
                 FROM INSPEVNT B
                WHERE (SUFF_RATE<0) AND
                      ((B.NBI_RATING='1') OR (B.NBI_RATING='2')) AND
                      B.INSPKEY IN
                         (SELECT MAX(I.INSPKEY) FROM  INSPEVNT I
                          WHERE I.BRKEY=B.BRKEY AND
                                I.INSPDATE=
                                   (SELECT MAX(G.INSPDATE)
                                    FROM  INSPEVNT G
                                    WHERE G.BRKEY=B.BRKEY AND
                                          G.NBINSPDONE='1'));