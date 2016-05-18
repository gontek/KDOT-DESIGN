CREATE OR REPLACE FORCE VIEW pontis.pon_elem_parent_view (brkey,inspkey,elem_key,envkey,strunitkey,elem_quantity,elem_scale_factor,elem_pctstate1,elem_pctstate2,elem_pctstate3,elem_pctstate4,elem_desc,elem_createdatetime,elem_createuserkey,elem_modtime,elem_moduserkey,elem_docrefkey,elem_notes) AS
select PON_ELEM_INSP.BRKEY,
                   PON_ELEM_INSP.INSPKEY,
                   PON_ELEM_INSP.ELEM_KEY,
                   PON_ELEM_INSP.ENVKEY,
                   PON_ELEM_INSP.STRUNITKEY,
                   --PON_ELEM_INSP.ELEM_INSPDATE,
                   PON_ELEM_INSP.ELEM_QUANTITY,
                   PON_ELEM_INSP.ELEM_SCALE_FACTOR,
                   PON_ELEM_INSP.ELEM_PCTSTATE1,
                   PON_ELEM_INSP.ELEM_PCTSTATE2,
                   PON_ELEM_INSP.ELEM_PCTSTATE3,
                   PON_ELEM_INSP.ELEM_PCTSTATE4,
                   PON_ELEM_INSP.ELEM_DESC,
                   PON_ELEM_INSP.ELEM_CREATEDATETIME,
                   PON_ELEM_INSP.ELEM_CREATEUSERKEY,
                   PON_ELEM_INSP.ELEM_MODTIME,
                   PON_ELEM_INSP.ELEM_MODUSERKEY,
                   PON_ELEM_INSP.ELEM_DOCREFKEY,
                   PON_ELEM_INSP.ELEM_NOTES
             from PON_ELEM_INSP
             where PON_ELEM_INSP.ELEM_KEY <> 0;