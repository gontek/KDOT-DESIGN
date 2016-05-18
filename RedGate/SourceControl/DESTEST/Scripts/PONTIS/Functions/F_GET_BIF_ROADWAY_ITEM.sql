CREATE OR REPLACE function pontis.f_get_bif_roadway_item(v_brkey        roadway.brkey%type,
                                  p_field_name_1 in varchar2) return varchar2 is
    retval varchar2(25);

    v_adttotal         varchar2(25);
    v_adtyear          varchar2(25);
    v_nhs_ind          varchar2(25);
    v_maint_rte_prefix varchar2(25);
    v_maint_rte_num    varchar2(25);
    v_detour           varchar2(25);
    v_funcclass        varchar2(225);
    v_lanes            number;
    v_trans_lanes      number;
    v_roadwidth        varchar2(25);
    v_bermprot         varchar2(25);
  begin

    select to_char(adttotal),
           adtyear,
           nhs_ind,
           maint_rte_prefix,
           maint_rte_num,
           round(r.bypasslen / 1.609344),
           f_get_paramtrs_equiv_long('roadway', 'funcclass', r.funcclass),
           totlanes,
           trans_lanes,
           ROUND(roadwidth / .3048),
           berm_prot
      into v_adttotal,
           v_adtyear,
           v_nhs_ind,
           v_maint_rte_prefix,
           v_maint_rte_num,
           v_detour,
           v_funcclass,
           v_lanes,
           v_trans_lanes,
           v_roadwidth,
           v_bermprot
      from roadway r, userrway u
     where u.brkey = v_brkey
       and r.brkey = v_brkey
       and u.on_under = r.on_under
       and r.on_under = '1';

    if p_field_name_1 = 'adttotal' then
      retval := v_adttotal;
    end if;

    if p_field_name_1 = 'adtyear' then
      retval := v_adtyear;
    end if;

    if p_field_name_1 = 'nhs_ind' then
      retval := v_nhs_ind;
    end if;

    if p_field_name_1 = 'maint_rte_prefix' then
      retval := v_maint_rte_prefix;
    end if;

    if p_field_name_1 = 'maint_rte_num' then
      retval := v_maint_rte_num;
    end if;

    if p_field_name_1 = 'detour' then
      retval := v_detour;
    end if;

    if p_field_name_1 = 'funcclass' then
      retval := v_funcclass;
    end if;

    if p_field_name_1 = 'lanes' then
      retval := v_lanes;
    end if;

    if p_field_name_1 = 'trans_lanes' then
      retval := v_trans_lanes;
    end if;

    if p_field_name_1 = 'roadwidth' then
      retval := v_roadwidth;
    end if;

    if p_field_name_1 = 'berm_prot' then
      retval := v_bermprot;
    end if;

    return retval;
  end f_get_bif_roadway_item;

 
/