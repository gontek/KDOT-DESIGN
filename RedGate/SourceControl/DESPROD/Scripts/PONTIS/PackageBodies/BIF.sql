CREATE OR REPLACE package body pontis.BIF is

  function centered_string(string_in in varchar2, length_in in integer)
    return varchar2 is
    len_string integer := length(string_in);
  begin
    if len_string is null or length_in <= 0 then
      return null;
    else
      return rpad('_', (length_in - len_string) / 2 - 1) || LTRIM(RTRIM(string_in));
    End if;
  end;
  ----------------------------------------------------------------------------------------------

  function f_get_bif_loadrtng(v_brkey        userbrdg.brkey%type,
                              p_field_name_1 in varchar2,
                              p_field_name_2 in varchar2,
                              p_field_name_3 in varchar2) return number is
    retval number;
  
    v_adj userbrdg.irload_adj_h%TYPE;
    v_lfd userbrdg.irload_adj_h%TYPE;
    v_wsd userbrdg.irload_adj_h%TYPE;
  
  begin
  
    select p_field_name_1, p_field_name_2, p_field_name_3
      into v_adj, v_lfd, v_wsd
      from userbrdg u
     where u.brkey = v_brkey;
  
    if v_adj is not null then
      retval := v_adj;
    end if;
    if v_adj is null then
      retval := v_lfd;
    end if;
    if v_adj is null and v_lfd is null then
      retval := v_wsd;
    end if;
  
    retval := round(retval / 0.9072);
  
    return retval;
  end f_get_bif_loadrtng;
  -----------------------------------------------------------------------------------------------

  function f_get_bif_full_route(v_brkey bridge.brkey%type) return varchar2 is
    retval varchar2(255);
  
    v_rte_prefix userrway.route_prefix%TYPE;
    v_route_num  userrway.route_num%TYPE;
    v_route_suf  varchar2(5);
  
  begin
  
    select maint_rte_prefix,
           maint_rte_num,
           decode(u.maint_rte_suffix,
                  '0',
                  '',
                  f_get_paramtrs_equiv_long('userrway',
                                            'route_suffix',
                                            u.maint_rte_suffix))
      into v_rte_prefix, v_route_num, v_route_suf
      from userrway u
     where u.brkey = v_brkey
       and u.on_under = '1';
  
    retval := v_rte_prefix || ' ' || v_route_num || ' ' || v_route_suf;
  
    return retval;
  end f_get_bif_full_route;

  -----------------------------------------------------------------------------------------------

  function f_get_bif_spanlist(v_brkey bridge.brkey%type) return varchar2 is
    retval varchar2(4000);
  begin
  
    select ltrim(replace(sys_connect_by_path(bif_spangrps, '/'),
                         '/',
                         chr(10)),
                 chr(10))
      into retval
      from (select bif_spangrps,
                   brkey,
                   count(*) over(partition by brkey) cnt,
                   row_number() over(partition by brkey order by strunitkey) seq
              from pontis.mv_strspans)
     where seq = cnt
       and brkey = v_brkey
     start with seq = 1
    connect by prior seq + 1 = seq
           and prior brkey = brkey;
  
    return retval;
  end f_get_bif_spanlist;

  ----------------------------------------------------------------------------------------------
  function f_get_bif_route(v_brkey bridge.brkey%type) return number is
    retval number;
  
  begin
  
    select to_number(maint_rte_num)
      into retval
      from userrway u
     where u.brkey = v_brkey
       and u.on_under = '1';
  
    return retval;
  end f_get_bif_route;
  ------------------------------------------------------------------------------------------------
  function f_get_bif_insp_intrvl(v_brkey bridge.brkey%type) return number is
    retval float;
  
  begin
  
    select brinspfreq_kdot
      into retval
      from userinsp u, mv_latest_inspection mv
     where u.brkey = v_brkey
       and mv.brkey = u.brkey
       and u.inspkey = mv.inspkey;
  
    return retval;
  end f_get_bif_insp_intrvl;

  ------------------------------------------------------------------------------------------------------
  function f_get_bif_orload_lbl(v_brkey        userbrdg.brkey%type,
                                p_field_name_1 in varchar2,
                                p_field_name_2 in varchar2,
                                p_field_name_3 in varchar2) return varchar2 is
    retval varchar2(20);
  
    v_adj userbrdg.orload_adj_h%TYPE;
    v_lfd userbrdg.orload_adj_h%TYPE;
    v_wsd userbrdg.orload_adj_h%TYPE;
  
  begin
  
    select p_field_name_1, p_field_name_2, p_field_name_3
      into v_adj, v_lfd, v_wsd
      from userbrdg u
     where u.brkey = v_brkey;
  
    if v_adj is not null then
      retval := 'Adj Load Rate Opr:';
    end if;
    if v_adj is null then
      retval := 'LFD Load Rate Opr:';
    end if;
    if v_adj is null and v_lfd is null then
      retval := 'WSD Load Rate Opr:';
    end if;
  
    return retval;
  end f_get_bif_orload_lbl;
  --------------------------------------------------------------------------------
  function f_get_bif_irload_lbl(v_brkey        userbrdg.brkey%type,
                                p_field_name_1 in varchar2,
                                p_field_name_2 in varchar2,
                                p_field_name_3 in varchar2) return varchar2 is
    retval varchar2(20);
  
    v_adj userbrdg.irload_adj_h%TYPE;
    v_lfd userbrdg.irload_adj_h%TYPE;
    v_wsd userbrdg.irload_adj_h%TYPE;
  
  begin
  
    select p_field_name_1, p_field_name_2, p_field_name_3
      into v_adj, v_lfd, v_wsd
      from userbrdg u
     where u.brkey = v_brkey;
  
    if v_adj is not null then
      retval := 'Adj Load Rate Inv:';
    end if;
    if v_adj is null then
      retval := 'LFD Load Rate Inv:';
    end if;
    if v_adj is null and v_lfd is null then
      retval := 'WSD Load Rate Inv:';
    end if;
  
    return retval;
  end f_get_bif_irload_lbl;
  ------------------------------------------------------------------------------------------------------------

  function f_get_bif_totalunits(v_brkey structure_unit.brkey%type)
    return varchar2 is
  
    retval varchar2(5);
  
  begin
  
    select to_char(count(strunitkey))
      into retval
      from structure_unit
     where structure_unit.brkey = v_brkey;
  
    return retval;
  
  end f_get_bif_totalunits;
  ----------------------------------------------------------------------------------------------------------------

  /* 
  function f_get_bif_cansysprjs(v_brkey v_bif_capital_prj.brkey%type)
     return varchar2 is
     retval varchar2(4000);
   
   begin
   
     select ltrim(replace(sys_connect_by_path(bif_project, '*'),
                          '*',
                          chr(10)),
                  chr(10))
       into retval
       from (select distinct bif_project,
                             brkey,
                             count(*) over(partition by brkey) cnt,
                             row_number() over(partition by brkey order by actvdate) seq
               from pontis.v_bif_capital_prj)
      where seq = cnt
        and brkey = v_brkey
      start with seq = 1
     connect by prior seq + 1 = seq
            and prior brkey = brkey;
   
     return retval;
   end f_get_bif_cansysprjs;
   */
  -----------------------------------------------------------------------------------------------------------------------
  function f_meters_to_feet(UNITSIN IN NUMBER) RETURN VARCHAR2 IS
  
    retval       varchar2(25);
    retvalfeet   varchar2(2000);
    retvalinches varchar2(2000);
    feetsymbol   varchar2(2);
    inchessymbol varchar2(2);
  
  begin
  
    retvalfeet   := unitsin;
    retvalinches := unitsin;
    feetsymbol   := CHR(146);
    inchessymbol := CHR(148);
  
    if (retvalfeet is null) or (retvalfeet <= 0) then
      retval := ' ';
    else
    
      if round(mod(retvalfeet, 12), 0) = 12 then
        retval := trim(to_char(trunc(retvalfeet / 12, 0) + 1) || feetsymbol);
      else
        retval := trim(to_char(trunc(retvalfeet / 12, 0) || feetsymbol));
        --    retval := retval || ' ' || feetsymbol;
      end if;
    
      if round(mod(retvalinches, 12), 0) = 12 then
        retval := lpad(trim(retval || ' 0' || inchessymbol), 22);
      else
        retval := lpad(trim(retval ||
                            lpad(to_char(round(mod(retvalinches, 12), 0)),
                                 2) || inchessymbol),
                       22);
      end if;
    
    end if;
    RETURN retval;
  
  end f_meters_to_feet;
  --------------------------------------------------------------------------------------------------------------------
  function f_get_bif_insp_item(v_brkey        bridge.brkey%type,
                               p_field_name_1 in varchar2) return varchar2 is
    retval varchar2(25);
  
    v_inspkey       varchar2(25);
    v_intrvl        varchar2(25);
    v_intrvl_UW     varchar2(25);
    v_deckgeom      varchar2(25);
    v_nbi_rating    varchar2(25);
    v_strrating     varchar2(25);
    v_suff_rate     varchar2(25);
    v_underclr      varchar2(25);
    v_priority_opt  varchar2(25);
    v_fhwa_status   varchar2(25);
    v_scourcrit     varchar2(25);
    v_subrating     varchar2(25);
    v_chanrating    varchar2(25);
    v_wateradeq     varchar2(25);
    v_dkrate        varchar2(25);
    v_suprate       varchar2(25);
    v_culvrate      varchar2(25);
    v_deck_comp_hi  varchar2(25);
    v_super_comp_hi varchar2(25);
    v_sub_comp_hi   varchar2(25);
    v_culv_comp_hi  varchar2(25);
  begin
  
    select i.inspkey,
           to_char(brinspfreq_kdot),
           deckgeom,
           nvl(uwinspfreq_kdot, '0'),
           f_get_paramtrs_equiv('inspevnt', 'nbi_rating', i.nbi_rating),
           strrating,
           to_char(suff_rate),
           underclr,
           to_char(us.priority_opt * 10000),
           decode(fhwa_status, 'Y', 'Y', 'N'),
           scourcrit,
           subrating,
           chanrating,
           wateradeq,
           dkrating,
           suprating,
           culvrating,
           deck_comp_hi,
           super_comp_hi,
           sub_comp_hi,
           culv_comp_hi
      into v_inspkey,
           v_intrvl,
           v_deckgeom,
           v_intrvl_uw,
           v_nbi_rating,
           v_strrating,
           v_suff_rate,
           v_underclr,
           v_priority_opt,
           v_fhwa_status,
           v_scourcrit,
           v_subrating,
           v_chanrating,
           v_wateradeq,
           v_dkrate,
           v_suprate,
           v_culvrate,
           v_deck_comp_hi,
           v_super_comp_hi,
           v_sub_comp_hi,
           v_culv_comp_hi
      from userinsp us, inspevnt i, mv_latest_inspection mv
     where us.brkey = v_brkey
       and mv.brkey = v_brkey
       and i.brkey = v_brkey
       and i.inspkey = mv.inspkey
       and us.inspkey = mv.inspkey;
  
    if p_field_name_1 = 'inspkey' then
      retval := v_inspkey;
    end if;
  
    if p_field_name_1 = 'brinspfreq_kdot' then
      retval := v_intrvl;
    end if;
  
    if p_field_name_1 = 'deckgeom' then
      retval := v_deckgeom;
    end if;
  
    if p_field_name_1 = 'uwinspfreq_kdot' then
      retval := v_intrvl_uw;
    end if;
  
    if p_field_name_1 = 'nbi_rating' then
      retval := v_nbi_rating;
    end if;
  
    if p_field_name_1 = 'strrating' then
      retval := v_strrating;
    end if;
  
    if p_field_name_1 = 'suff_rate' then
      retval := v_suff_rate;
    end if;
  
    if p_field_name_1 = 'underclr' then
      retval := v_underclr;
    end if;
  
    if p_field_name_1 = 'priority_opt' then
      retval := v_priority_opt;
    end if;
  
    if p_field_name_1 = 'fhwa_status' then
      retval := v_fhwa_status;
    end if;
  
    if p_field_name_1 = 'scourcrit' then
      retval := v_scourcrit;
    end if;
  
    if p_field_name_1 = 'subrating' then
      retval := v_subrating;
    end if;
  
    if p_field_name_1 = 'chanrating' then
      retval := v_chanrating;
    end if;
  
    if p_field_name_1 = 'wateradeq' then
      retval := v_wateradeq;
    end if;
  
    if p_field_name_1 = 'dkrating' then
      retval := v_dkrate;
    end if;
  
    if p_field_name_1 = 'suprating' then
      retval := v_suprate;
    end if;
  
    if p_field_name_1 = 'culvrating' then
      retval := v_culvrate;
    end if;
  
    if p_field_name_1 = 'deck_comp_hi' then
      retval := v_deck_comp_hi;
    end if;
  
    if p_field_name_1 = 'super_comp_hi' then
      retval := v_super_comp_hi;
    end if;
  
    if p_field_name_1 = 'sub_comp_hi' then
      retval := v_sub_comp_hi;
    end if;
  
    if p_field_name_1 = 'culv_comp_hi' then
      retval := v_culv_comp_hi;
    end if;
  
    return retval;
  end f_get_bif_insp_item;

  -------------------------------------------------------------------------------------------------------
  function f_get_bif_userstr_item_main(v_brkey        userstrunit.brkey%type,
                                       p_field_name_1 in varchar2)
    return varchar2 is
    retval varchar2(25);
  
    v_abut_type_near varchar2(25);
    v_abut_type_far  varchar2(25);
    v_pier_foot_type varchar2(25);
  begin
  
    select abut_type_near, abut_type_far, pier_foot_type
      into v_abut_type_near, v_abut_type_far, v_pier_foot_type
      from userstrunit u, structure_unit s
     where u.brkey = v_brkey
       and s.brkey = v_brkey
       and u.strunitkey = s.strunitkey
       and s.strunittype = '1';
  
    if p_field_name_1 = 'abut_type_near' then
      retval := v_abut_type_near;
    end if;
  
    if p_field_name_1 = 'abut_type_far' then
      retval := v_abut_type_far;
    end if;
  
    if p_field_name_1 = 'pier_foot_type' then
      retval := v_pier_foot_type;
    end if;
  
    return retval;
  end f_get_bif_userstr_item_main;
  ----------------------------------------------------------------------------------------------------------------
  function f_get_bif_cansysprjs(v_brkey       v_bif_capital_prj.brkey%type,
                                columnname_in varchar2) return varchar2 is
    retval    varchar2(2000);
    sqlString varchar2(8000);
    quote     char(1) := chr(39); -- uses ASCII code for single quote which is CHR(39)
  
  begin
  
    sqlString := 'select ltrim(substr(replace(sys_connect_by_path(' ||
                 columnname_in || ', ' || quote || '*' || quote || '),' ||
                 quote || '*' || quote || ', ' || 'CHR(13)' ||
                 '   ),  2 ) ) ' || ' from (select distinct ' ||
                 columnname_in || ',
                            brkey,
                            count(*) over(partition by brkey) cnt,
                            row_number() over(partition by brkey order by actvdate' ||
                 ' ) seq ' || ' from pontis.v_bif_capital_prj) ' ||
                 ' where seq = cnt ' || ' and brkey = :br ' ||
                 ' start with seq = 1 ' ||
                 ' connect by prior seq + 1 = seq ' ||
                 ' and prior brkey = brkey ';
  
    execute immediate sqlString
      into retval
      using v_brkey;
  
    return retval;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      return NULL;
    
    WHEN OTHERS THEN
      RAISE;
    
  end f_get_bif_cansysprjs;
  -----------------------------------------------------------------------------------------------------------
  function f_get_bif_inspecdata(v_brkey       inspevnt.brkey%type,
                                tablename_in  varchar2,
                                columnname_in varchar2) return varchar2 is
    retval    varchar2(2000);
    sqlString varchar2(8000);
  
  begin
  
    -- create a big sql string which will dynamically include the tablename and column name you have passed.
  
    sqlString := 'select ' || tablename_in || '.' || columnname_in ||
                 ' from userinsp , inspevnt , mv_latest_inspection ' ||
                 ' where userinsp.brkey = :br ' ||
                 ' and mv_latest_inspection.brkey = userinsp.brkey ' ||
                 ' and inspevnt.brkey = userinsp.brkey ' ||
                 ' and userinsp.inspkey = mv_latest_inspection.inspkey ' ||
                 ' and inspevnt.inspkey = mv_latest_inspection.inspkey ';
  
    -- execute the dynamic SQL string - supply v_brkey as bind variable :br 
    -- return result into retval
  
    execute immediate sqlString
      into retval
      using v_brkey; --see :br above
  
    return retval;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      --- sql did not find any data, so return a NULL
      return NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.
  
  end f_get_bif_inspecdata;
  ------------------------------------------------------------------------------------------------------

  function f_get_bif_rdwydata(v_brkey       roadway.brkey%type,
                              v_on_under    roadway.on_under%type,
                              tablename_in  varchar2,
                              columnname_in varchar2) return varchar2 is
    retval    varchar2(2000);
    sqlString varchar2(8000);
  
  begin
  
    -- create a big sql string which will dynamically include the tablename and column name you have passed.
  
    sqlString := 'select ' || columnname_in || ' from ' || tablename_in ||
                 ' where ' || tablename_in || '.' || 'brkey  = :br ' ||
                 ' and on_under = :our ';
  
    -- execute the dynamic SQL string - supply v_brkey as bind variable :br
    -- return result into retval
  
    execute immediate sqlString
      into retval
      using v_brkey, v_on_under; --see :br above
  
    return retval;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      --- sql did not find any data, so return a NULL
      return NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.
  
  end f_get_bif_rdwydata;
  ----------------------------------------------------------------------------------------------------------------

  function f_get_bif_elemdata(v_brkey       eleminsp.brkey%type,
                              v_strunitkey  eleminsp.strunitkey%type,
                              columnname_in varchar2,
                              v_elemtype    char) return varchar2 is
    retval    varchar2(2000);
    sqlString varchar2(8000);
    quote     char(1) := chr(39); -- use the ASCII code for sinqle quote which is CHR(39)        
  
  begin
  
    -- create a big sql string which will dynamically include the column name you have passed.
    -- be very careful about single quotes etc.  In this case, have declared a variable that is nothing but a single quote and used that wherever a single quote literal should
    -- appear in the sql e.g. '*' is quote|| '*' || quote which becomes '*' when concatenated.
    -- the variable columnname_in will become the literal column name in the concatenated sql string
    -- CHR(13) means linefeed (carriage return) and will display all the numbers in column when reported.
    -- TEST SCRIPT
    /*
    
    
    */
  
    sqlString := 'select ltrim(substr(replace(sys_connect_by_path(' ||
                 columnname_in || ', ' || quote || '*' || quote || '),' ||
                 quote || '*' || quote || ', ' || 'CHR(13)' ||
                 '   ),  2 ) ) ' ||
                --into retval
                 ' from (select distinct ' || columnname_in || ' ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elemkey' ||
                 ' ) seq ' || ' from mv_bif_data_elements) ' ||
                 '   where seq = cnt  ' || '   and brkey = :br ' ||
                 '   and strunitkey = :su ' || '   and elemtype = :ele ' ||
                 '   start with seq = 1 ' ||
                 '   connect by prior seq + 1 = seq ' ||
                 '       and prior brkey = brkey ' ||
                 '       and prior strunitkey = strunitkey ' ||
                 '       and prior elemtype = elemtype';
  
    -- execute the dynamic SQL string - supply v_brkey as bind variable :br and v_strunitkey as bind variable :su
    -- return result into retval
  
    execute immediate sqlString
      into retval
      using v_brkey, v_strunitkey, v_elemtype; -- these are determined by position in the string (see :br and :su above)
  
    return retval;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      --- sql did not find any data, so return a NULL
      return NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.
  
  end f_get_bif_elemdata;
  -----------------------------------------------------------------------------------------------------------------------

  function f_get_bif_dkrate(v_brkey  inspevnt.brkey%type,
                            v_rownum in varchar2) return varchar2 as
    retval varchar2(4);
  
  begin
  
    select dkrating
      into retval
      from (select brkey,
                   dkrating,
                   row_number() over(order by brkey, inspdate desc) rnm
              from inspevnt
             where brkey = v_brkey)
     where rnm = v_rownum;
  
    return retval;
  
  end f_get_bif_dkrate;
  ---------------------------------------------------------------------------------------------------------
  function f_get_bif_inspdate(v_brkey  inspevnt.brkey%type,
                              v_rownum in varchar2) return varchar2 as
    retval varchar2(4);
  
  begin
  
    select extract(year from inspdate)
      into retval
      from (select brkey,
                   inspdate,
                   row_number() over(order by brkey, inspdate desc) rnm
              from inspevnt
             where brkey = v_brkey)
     where rnm = v_rownum;
  
    return retval;
  
  end f_get_bif_inspdate;
  -------------------------------------------------------------------------------------------------------
  function f_get_bif_suprate(v_brkey  inspevnt.brkey%type,
                             v_rownum in varchar2) return varchar2 as
    retval varchar2(4);
  
  begin
  
    select suprating
      into retval
      from (select brkey,
                   suprating,
                   row_number() over(order by brkey, inspdate desc) rnm
              from inspevnt
             where brkey = v_brkey)
     where rnm = v_rownum;
  
    return retval;
  
  end f_get_bif_suprate;
  -------------------------------------------------------------------------------------------------------
  function f_get_bif_subrate(v_brkey  inspevnt.brkey%type,
                             v_rownum in varchar2) return varchar2 as
    retval varchar2(4);
  
  begin
  
    select subrating
      into retval
      from (select brkey,
                   subrating,
                   row_number() over(order by brkey, inspdate desc) rnm
              from inspevnt
             where brkey = v_brkey)
     where rnm = v_rownum;
  
    return retval;
  
  end f_get_bif_subrate;
  --------------------------------------------------------------------------------------------------------
  function f_get_bif_culvrate(v_brkey  inspevnt.brkey%type,
                              v_rownum in varchar2) return varchar2 as
    retval varchar2(4);
  
  begin
  
    select culvrating
      into retval
      from (select brkey,
                   culvrating,
                   row_number() over(order by brkey, inspdate desc) rnm
              from inspevnt
             where brkey = v_brkey)
     where rnm = v_rownum;
  
    return retval;
  
  end f_get_bif_culvrate;
  ---------------------------------------------------------------------------------------------------------
  function f_get_bif_appralign(v_brkey  inspevnt.brkey%type,
                               v_rownum in varchar2) return varchar2 as
    retval varchar2(4);
  
  begin
  
    select appralign
      into retval
      from (select brkey,
                   appralign,
                   row_number() over(order by brkey, inspdate desc) rnm
              from inspevnt
             where brkey = v_brkey)
     where rnm = v_rownum;
  
    return retval;
  
  end f_get_bif_appralign;
  ----------------------------------------------------------------------------------------------------
  function f_get_bif_chanrating(v_brkey  inspevnt.brkey%type,
                                v_rownum in varchar2) return varchar2 as
    retval varchar2(4);
  
  begin
  
    select chanrating
      into retval
      from (select brkey,
                   chanrating,
                   row_number() over(order by brkey, inspdate desc) rnm
              from inspevnt
             where brkey = v_brkey)
     where rnm = v_rownum;
  
    return retval;
  
  end f_get_bif_chanrating;
  ----------------------------------------------------------------------------------------------------------
  function f_get_bif_wateradeq(v_brkey  inspevnt.brkey%type,
                               v_rownum in varchar2) return varchar2 as
    retval varchar2(4);
  
  begin
  
    select wateradeq
      into retval
      from (select brkey,
                   wateradeq,
                   row_number() over(order by brkey, inspdate desc) rnm
              from inspevnt
             where brkey = v_brkey)
     where rnm = v_rownum;
  
    return retval;
  
  end f_get_bif_wateradeq;
  -----------------------------------------------------------------------------------------------------------

  function f_get_bif_bromsprjs(v_brkey       mv_broms_query.brkey%type,
                               columnname_in varchar2) return varchar2 is
    retval    varchar2(2000);
    sqlString varchar2(8000);
    quote     char(1) := chr(39); -- uses ASCII code for single quote which is CHR(39)
  
  begin
  
    sqlString := 'select ltrim(substr(replace(sys_connect_by_path(' ||
                 columnname_in || ', ' || quote || '*' || quote || '),' ||
                 quote || '*' || quote || ', ' || 'CHR(13)' ||
                 '   ),  2 ) ) ' || ' from (select distinct ' ||
                 columnname_in || ',
                            brkey,
                            count(*) over(partition by brkey) cnt,
                            row_number() over(partition by brkey order by progyear' ||
                 ' ) seq ' || ' from pontis.mv_broms_query) ' ||
                 ' where seq = cnt ' || ' and brkey = :br ' ||
                --  ' and in_depth_completed_ind <> ' || quote || 'Y' || quote ||
                 ' start with seq = 1 ' ||
                 ' connect by prior seq + 1 = seq ' ||
                 ' and prior brkey = brkey ';
  
    execute immediate sqlString
      into retval
      using v_brkey;
  
    return retval;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      return NULL;
    
    WHEN OTHERS THEN
      RAISE;
    
  end f_get_bif_bromsprjs;
  --------------------------------------------------------------------------------------------------------
  function f_get_bif_inspecdate(v_brkey       inspevnt.brkey%type,
                                tablename_in  varchar2,
                                columnname_in varchar2) return varchar2 is
    retval    varchar2(20);
    sqlString varchar2(8000);
    quote     char(1) := chr(39);
  
  begin
  
    -- create a big sql string which will dynamically include the tablename and column name you have passed.
  
    sqlString := 'select to_char( ' || tablename_in || '.' || columnname_in ||
                 ' , ' || quote || 'mm/dd/yyyy' || quote || ')' ||
                 ' from userinsp , inspevnt , mv_latest_inspection ' ||
                 ' where userinsp.brkey = :br ' ||
                 ' and mv_latest_inspection.brkey = userinsp.brkey ' ||
                 ' and inspevnt.brkey = userinsp.brkey ' ||
                 ' and userinsp.inspkey = mv_latest_inspection.inspkey ' ||
                 ' and inspevnt.inspkey = mv_latest_inspection.inspkey ';
  
    -- execute the dynamic SQL string - supply v_brkey as bind variable :br 
    -- return result into retval
  
    execute immediate sqlString
      into retval
      using v_brkey; --see :br above
  
    return retval;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      --- sql did not find any data, so return a NULL
      return NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.
  
  end f_get_bif_inspecdate;
  ------------------------------------------------------------------------------------------------------

  function f_get_bif_brdgdata(v_brkey       bridge.brkey%type,
                              tablename_in  varchar2,
                              columnname_in varchar2) return varchar2 is
    retval    varchar2(2000);
    sqlString varchar2(8000);
  
  begin
  
    -- create a big sql string which will dynamically include the tablename and column name you have passed.
  
    sqlString := 'select ' || columnname_in || ' from ' || tablename_in ||
                 ' where ' || tablename_in || '.' || 'brkey  = :br ';
  
    -- execute the dynamic SQL string - supply v_brkey as bind variable :br
    -- return result into retval
  
    execute immediate sqlString
      into retval
      using v_brkey; --see :br above
  
    return retval;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      --- sql did not find any data, so return a NULL
      return NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.
  
  end f_get_bif_brdgdata;
  --------------------------------------------------------------------------------------------------------
  function f_get_bif_kta_no(v_brkey userbrdg.brkey%type) return varchar2 is
    retval varchar2(30);
  
  begin
  
    select 'KTA No:  ' || NVL(kta_no, '0') || '  ' || kta_id
      into retval
      from userbrdg
     where brkey = v_brkey;
  
    return retval;
  end f_get_bif_kta_no;
  ----------------------------------------------------------------------------------------------------------  
end BIF;
/