CREATE OR REPLACE FORCE VIEW pontis.v_elem_dist_report2 (elemdistcat,quantity,qtystate1,qtystate2,qtystate3,qtystate4,qtystate5,tev,cev) AS
SELECT ELEMDISTCAT,
                      QUANTITY,
                      QTYSTATE1,
                      QTYSTATE2,
                      QTYSTATE3,
                      QTYSTATE4,
                      QTYSTATE5,
                      (FAILAGCYCO*QUANTITY) AS TEV,
                      ((FAILAGCYCO*QUANTITY)*((QTYSTATE1/QUANTITY)+
                         ((QTYSTATE2*(1-(1/(STATECNT-1))))/QUANTITY)+
                         ((QTYSTATE3*(1-(2*(1/(STATECNT-1)))))/QUANTITY)+
                         ((QTYSTATE4*(1-(3*(1/(STATECNT-1)))))/QUANTITY)+
                         ((QTYSTATE5*(1-(4*(1/(STATECNT-1)))))/QUANTITY)))
                      AS CEV
                 FROM V_ELEM_DIST_REPORT1
                WHERE ELEMDISTCAT IN (1,2,3,4,5,6,7,8,9,10,11);