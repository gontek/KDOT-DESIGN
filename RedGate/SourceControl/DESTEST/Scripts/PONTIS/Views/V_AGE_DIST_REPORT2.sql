CREATE OR REPLACE FORCE VIEW pontis.v_age_dist_report2 (brkey,bridge_id,yearbuilt,age,agecat) AS
SELECT BRKEY,
                      BRIDGE_ID,
                      YEARBUILT,
                      AGE,
                      DECODE(AGE,
                             0,'0-10', 1,'0-10', 2,'0-10', 3,'0-10',
                             4,'0-10', 5,'0-10', 6,'0-10', 7,'0-10',
                             8,'0-10', 9,'0-10', 10,'0-10',
                             11,'11-20', 12,'11-20', 13,'11-20', 14,'11-20',
                             15,'11-20', 16,'11-20', 17,'11-20', 18,'11-20',
                             19,'11-20', 20,'11-20',
                             21,'21-30', 22,'21-30', 23,'21-30', 24,'21-30',
                             25,'21-30', 26,'21-30', 27,'21-30', 28,'21-30',
                             29,'21-30', 30,'21-30',
                             31,'31-40', 32,'31-40', 33,'31-40', 34,'31-40',
                             35,'31-40', 36,'31-40', 37,'31-40', 38,'31-40',
                             39,'31-40', 40,'31-40',
                             41,'41-50', 42,'41-50', 43,'41-50', 44,'41-50',
                             45,'41-50', 46,'41-50', 47,'41-50', 48,'41-50',
                             49,'41-50', 50,'41-50',
                             51,'51-60', 52,'51-60', 53,'51-60', 54,'51-60',
                             55,'51-60', 56,'51-60', 57,'51-60', 58,'51-60',
                             59,'51-60', 60,'51-60',
                             61,'61-70', 62,'61-70', 63,'61-70', 64,'61-70',
                             65,'61-70', 66,'61-70', 67,'61-70', 68,'61-70',
                             69,'61-70', 70,'61-70',
                             71,'71-80', 72,'71-80', 73,'71-80', 74,'71-80',
                             75,'71-80', 76,'71-80', 77,'71-80', 78,'71-80',
                             79,'71-80', 80,'71-80',
                             '80+') AS AGECAT
                 FROM  V_AGE_DIST_REPORT1;