CREATE OR REPLACE FORCE VIEW pontis.v_elem_dist_report1 (quantity,qtystate1,qtystate2,qtystate3,qtystate4,qtystate5,statecnt,failagcyco,paircode,elemdistcat) AS
SELECT ELEMINSP.QUANTITY,
                      ELEMINSP.QTYSTATE1,
                      ELEMINSP.QTYSTATE2,
                      ELEMINSP.QTYSTATE3,
                      ELEMINSP.QTYSTATE4,
                      ELEMINSP.QTYSTATE5,
                      ELEMDEFS.STATECNT,
                      CONDUMDL.FAILAGCYCO,
                      ELEMDEFS.PAIRCODE,
                      DECODE(ELEMDEFS.ECATKEY,6,1,
                             1,DECODE(ELEMDEFS.MATLKEY,
                                      1,2, 2,2, 3,3, 4,3, 0),
                             2,DECODE(ELEMDEFS.MATLKEY,
                                      3,DECODE(ELEMDEFS.PAIRCODE,
                                               6,4, 56,4,
                                               -1,5, 0,5, 55,5,
                                               0),
                                      4,DECODE(ELEMDEFS.PAIRCODE,
                                               6,4, 56,4,
                                               -1,5, 0,5, 55,5,
                                               0),
                                      1,DECODE(ELEMDEFS.PAIRCODE,
                                               6,6, 56,6,
                                               -1,7, 0,7, 55,7,
                                               0),
                                      2,DECODE(ELEMDEFS.PAIRCODE,
                                               6,6, 56,6,
                                               -1,7, 0,7, 55,7,
                                               0)),
                             3,DECODE(ELEMDEFS.ETYPKEY,
                                      20,9, 21,10, 22,11, 0),
                             0)
                      AS ELEMDISTCAT
            FROM  ELEMINSP,
                       ELEMDEFS,
                       CONDUMDL
            WHERE ELEMINSP.ELEMKEY=CONDUMDL.ELEMKEY AND
                      ELEMINSP.ENVKEY=CONDUMDL.ENVKEY AND
                      ELEMINSP.ELEMKEY=ELEMDEFS.ELEMKEY AND
                      ELEMDEFS.ELEMKEY=CONDUMDL.ELEMKEY AND
                      CONDUMDL.MOKEY='00' AND
                      ELEMINSP.INSPKEY=
                         (SELECT MAX(I.INSPKEY) FROM  INSPEVNT I
                          WHERE I.INSPDATE=
                                   (SELECT MAX(J.INSPDATE)
                                    FROM  INSPEVNT J
                                    WHERE J.ELINSPDONE='1'
                                    GROUP BY J.BRKEY
                                    HAVING J.BRKEY=ELEMINSP.BRKEY) AND
                                I.ELINSPDONE='1' AND
                                I.BRKEY=ELEMINSP.BRKEY) AND
                      ELEMINSP.QUANTITY <> 0;