CREATE OR REPLACE FORCE VIEW pontis.v_bridge_proj_insp_wcand (bridge_id,brkey,ref_witemkey,wc_id,project_id,projname,progyear,proj_status,proj_reviewed_by,proj_review_status,witem_id,prog_id,progname) AS
SELECT BRIDGE.BRIDGE_ID,
                BRIDGE.BRKEY,
                INSP_WCAND.REF_WITEMKEY,
                INSP_WCAND.WC_ID,
                PROJECTS.PROJECT_ID,
                PROJECTS.PROJNAME,
                PROJECTS.PROGYEAR,
                PROJECTS.PROJ_STATUS,
                PROJECTS.PROJ_REVIEWED_BY,
                PROJECTS.PROJ_REVIEW_STATUS,
                PRJ_WITEMS.WITEM_ID,
                PRJ_PROGRAMS.PROG_ID,
                PRJ_PROGRAMS.PROGNAME
            FROM INSP_WCAND,
                BRIDGE,
                PRJ_WITEMS,
                PROJECTS,
                PRJ_PROGRAMS
            WHERE BRIDGE.BRKEY = INSP_WCAND.BRKEY AND
                  PRJ_WITEMS.BRKEY = BRIDGE.BRKEY AND
                  PROJECTS.PROJKEY = PRJ_WITEMS.PROJKEY AND
                  PRJ_PROGRAMS.PROGKEY = PROJECTS.PROGKEY AND
                  ( INSP_WCAND.REF_WITEMKEY = PRJ_WITEMS.WITEMKEY AND
                  INSP_WCAND.BRKEY = PRJ_WITEMS.BRKEY AND
                  INSP_WCAND.BRKEY = BRIDGE.BRKEY AND
                  PRJ_WITEMS.PROJKEY = PROJECTS.PROJKEY );