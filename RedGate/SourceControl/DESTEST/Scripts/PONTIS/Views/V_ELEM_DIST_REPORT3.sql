CREATE OR REPLACE FORCE VIEW pontis.v_elem_dist_report3 (elemdistcat,totalquantity,quantity1,quantity2,quantity3,quantity4,quantity5,sumtev,sumcev) AS
SELECT   elemdistcat, SUM (quantity) AS totalquantity,
            SUM (qtystate1) AS quantity1, SUM (qtystate2) AS quantity2,
            SUM (qtystate3) AS quantity3, SUM (qtystate4) AS quantity4,
            SUM (qtystate5) AS quantity5, SUM (tev) AS sumtev, SUM (cev)
                  AS sumcev
       FROM v_elem_dist_report2
   GROUP BY elemdistcat
 ;