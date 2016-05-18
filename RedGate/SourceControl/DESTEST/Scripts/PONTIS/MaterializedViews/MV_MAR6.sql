CREATE MATERIALIZED VIEW pontis.mv_mar6 (brkey,bridge_id,culvert_flag,district,yearbuilt,servtypon,function_type,latest_inspkey,oppostcl,inspdate,nextdate,months_overdue,inspfreq_years,inspfreq_months)
AS select *
    from v_compliance_mar6;