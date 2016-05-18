CREATE OR REPLACE FORCE VIEW pontis.v_elemvalue (elemkey,elemvalue,s2factor,s3factor,s4factor) AS
(SELECT PON_ELEM_DEFS.ELEM_KEY ELEMKEY,
                PON_ELEM_DEFS.ELEM_REL_WEIGHT ELEMVALUE,
                (2.0 / 3.0) S2FACTOR,
                (1.0 / 3.0) S3FACTOR,
                0.0 S4FACTOR
                FROM PON_ELEM_DEFS
                WHERE PON_ELEM_DEFS.ELEM_SMART_FLAG = 'N'
            );