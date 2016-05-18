CREATE OR REPLACE package body pontis.NBIP as
  ---------------------------------------------------------------------------
  function f_get_fc_97_98(v_brkey userrway.brkey%type) return varchar2 is
    retval varchar2(1);
  
  begin
  
    select DECODE(COUNT(on_under), 0, 'N', 'Y')
      into retval
      from userrway u
     where brkey = v_brkey
       and u.feat_cross_type in ('97', '98');
  
    return retval;
  end f_get_fc_97_98;
  ---------------------------------------------------------------------------
  function F_CHECK_NBI_8(v_brkey bridge.brkey%type)
  
   return varchar2 is
    retval varchar2(20) := '9999';
  
    lrs_route        varchar2(3);
    l_route_2        varchar2(5);
    m_route          varchar2(5);
    l_suffix         char(1);
    l_suffix_1       char(1);
    l_suffix_2       char(1);
    l_owner_kdot     varchar2(2);
    l_custodian_kdot varchar2(2);
    l_admin          char(1);
    l_func           userbrdg.function_type%type;
    l_knd_hwy        roadway.kind_hwy%type;
    l_inspfreq       userinsp.brinspfreq_kdot%type;
    l_clr_route      char(1);
    l_brdg_culv      char(1);
    l_substitute     varchar2(6);
    l_yearbuilt      varchar2(4);
  
  begin
  
    select owner_kdot,
           custodian_kdot,
           nvl(substr(lrsinvrt, 7, 3), '000'),
           route_suffix,
           lpad(maint_rte_num, 3, '0'),
           maint_rte_suffix,
           function_type,
           kind_hwy,
           brinspfreq_kdot,
           substr(clr_route, 1, 1),
           substr(b.bridge_id, 6, 1),
           ub.brkey,
           yearbuilt
      into l_owner_kdot,
           l_custodian_kdot,
           lrs_route,
           l_suffix_1,
           l_route_2,
           l_suffix_2,
           l_func,
           l_knd_hwy,
           l_inspfreq,
           l_clr_route,
           l_brdg_culv,
           l_substitute,
           l_yearbuilt
      from userbrdg             ub,
           bridge               b,
           roadway              ur,
           userrway             u,
           userinsp             us,
           mv_latest_inspection mv
     where ub.brkey = v_brkey
       and b.brkey = ub.brkey
       and ur.brkey = ub.brkey
       and u.brkey = ur.brkey
       and ur.on_under = u.on_under
       and ur.on_Under = '1'
       and us.brkey = ub.brkey
       and mv.brkey = ub.brkey
       and us.inspkey = mv.inspkey;
  
    IF lrs_route = '000' or l_clr_route in ('C', 'R', 'L') THEN
      m_route  := l_route_2;
      l_suffix := l_suffix_2;
    
    ELSE
      m_route  := lrs_route;
      l_suffix := l_suffix_1;
    
    END if;
    l_admin := '1'; --initiate as ours
  
    IF l_owner_kdot = '4' then
      -- Federal respon
      l_admin := '2';
    END IF;
  
    IF l_owner_kdot in ('12', '14', '2', '3', '5') THEN
      -- wildlife-n-parks, railroads, etc.
      l_admin := '4';
    END IF;
  
    IF -- l_owner_kdot in ('13') or l_custodian_kdot in ('1','13')OR -- shared KTA
     l_inspfreq = 99 or l_func = '30' -- inspected by KTa
     THEN
      -- is KTA
      l_admin := '3';
    END IF;
  
    IF l_suffix = 'C' then
      -- city owned
      l_admin := '5';
    END IF;
  
    IF l_brdg_culv = 'C' or l_yearbuilt = '1000' then
      retval := l_substitute;
    end if;
  
    if l_brdg_culv = 'B' and l_yearbuilt <> '1000' then
    
      retval := '9999' || m_route || l_suffix;
      retval := retval || v_brkey || l_admin;
    END if;
    RETURN retval;
  
  EXCEPTION
    WHEN OTHERS THEN
      retval := '-1';
      RETURN retval;
    
  END F_CHECK_NBI_8;

  ---------------------------------------------------------------------------

  function f_check_nbi_28a_on(v_brkey bridge.brkey%type)
  
   return number is
  
    retval     number;
    v_function userbrdg.function_type%type;
  
  begin
  
    select function_type
      into v_function
      from userbrdg u
     where u.brkey = v_brkey;
  
    if v_function in ('4', '90', '98', '99') then
      -- pedestrian, railroad, or other should be '0'.
      retval := 0;
    
    ELSE
    
      select totlanes
        into retval
        from userrway u
       where u.brkey = v_brkey
         and u.on_under = '1';
    
    end if;
    return retval;
  
  END f_check_nbi_28a_on;
  ------------------------------------------------------------------------

  Function f_check_nbi_28B_on(v_brkey bridge.brkey%type)
  
   return number is
  
    retval number;
  
  BEGIN
  
    select sum(totlanes)
      into retval
      from userrway u
     where u.brkey = v_brkey
       and u.feat_cross_type in ('10', '30', '50', '51', '70');
  
    return retval;
  
  END f_check_nbi_28B_on;
  ----------------------------------------------------------------------------
  function f_check_nbi_31(v_brkey userbrdg.brkey%type) return char is
    retval char(1);
  
    v_load userbrdg.designload_kdot%TYPE;
    v_type userbrdg.designload_type%TYPE;
  
  begin
  
    select designload_kdot, designload_type
      into v_load, v_type
      from userbrdg
     where userbrdg.brkey = v_brkey;
  
    IF v_load < 13.5 THEN
      retval := '1';
    END IF;
  
    IF v_type IN ('1', '2', '4') AND v_load >= 13.5 and v_load < 18 THEN
      retval := '2';
    END IF;
  
    IF v_type IN ('3', '5') and v_load >= 13.5 and v_load < 18 THEN
      retval := '3';
    END IF;
  
    IF v_type IN ('1', '2', '4') and v_load > 18 THEN
      retval := '4';
    END IF;
  
    IF v_type = '3' and v_load >= 18 and v_load < 22.5 THEN
      retval := '5';
    END IF;
  
    IF v_type = '5' and v_load >= 18 and v_load < 22.5 THEN
      retval := '6';
    END IF;
  
    IF v_type = '7' THEN
      retval := '7';
    END IF;
  
    IF v_type = '6' THEN
      retval := '8';
    END IF;
  
    IF v_type in ('3', '5') and v_load >= 22.5 THEN
      retval := '9';
    END IF;
  
    IF v_type in ('8') THEN
      retval := 'A';
    END IF;
  
    if v_type in ('_', '0') THEN
      retval := '0';
    end if;
  
    RETURN retval;
  EXCEPTION
    WHEN OTHERS THEN
      retval := -1;
      RETURN retval;
  end f_check_nbi_31;
  ----------------------------------------------------------------------------
  Function f_check_nbi_38(v_brkey bridge.brkey%type)
  
   return varchar2 is
  
    retval            VARCHAR2(3);
    l_navvc           number;
    l_navhc           number;
    l_feat_cross_type char(1);
  
    cursor c1 is
      select u.feat_cross_type
        FROM userrway u
       where u.brkey = v_brkey
         and u.feat_cross_type = '2';
  
    cursor c2 is
      select decode(b.navvc, -1, 0, '', 0, 0, 0, b.navvc),
             decode(b.navhc, -1, 0, '', 0, 0, 0, b.navhc)
        FROM bridge b
       where b.brkey = v_brkey;
  
  BEGIN
  
    open c1;
    fetch c1
      into l_feat_cross_type;
    if c1%notfound then
      retval := 'N';
    else
      open c2;
      fetch c2
        into l_navvc, l_navhc;
      if c2%notfound or l_navvc + l_navhc = 0 then
        retval := '0';
      else
        retval := '1';
      end if;
      close c2;
    end if;
    close c1;
  
    return retval;
  
  END f_check_nbi_38;
  -------------------------------------------------------------------------------

  Function f_check_nbi_42a(v_brkey bridge.brkey%type)
  
   return varchar2 is
  
    retval varchar2(2) := '0';
    pcode1 char(1);
    pcode2 char(1);
    type tab_varchar3 IS TABLE OF varchar2(3) INDEX BY binary_integer;
    l_tab_func_type tab_varchar3;
    l_tab_desc_type tab_varchar3;
  
  begin
  
    select ub.function_type, us.feat_desc_type BULK COLLECT
      INTO l_tab_func_type, l_tab_desc_type
      from userbrdg ub, userrway us
     where us.brkey = ub.brkey
       and ub.brkey = v_brkey
       and us.on_under = '1';
  
    for i in 1 .. l_tab_func_type.count LOOP
      if l_tab_func_type(i) in ('10', '30', '50', '51', '70') and
         l_tab_desc_type(i) in
         ('0', '1', '2', '3', '4', '5', '6', '7', '8', '14', '15', '16') THEN
        pcode1 := '1';
      ELSIF l_tab_func_type(i) = '4' AND l_tab_desc_type(i) = '0' THEN
        pcode2 := '2';
      ELSIF l_tab_func_type(i) = '90' and l_tab_desc_type(i) = '0' THEN
        retval := '3';
      ELSIF l_tab_func_type(i) in ('10', '30') and
            l_tab_desc_type(i) in ('9', '12') THEN
        retval := '7';
      ELSIF l_tab_func_type(i) in ('10', '30') and
            l_tab_desc_type(i) in ('10', '13') THEN
        retval := '8';
      END IF;
    END LOOP;
    IF pcode1 = '1' and pcode2 = '2' THEN
      retval := '4';
    ELSIF pcode1 = '1' THEN
      retval := '1';
    ELSIF pcode2 = '2' THEN
      retval := '2';
    end if;
  
    if v_brkey = '096108' THEN
      -- exception for multi-function bridge that happens to be a highway AND railroad
      retval := '4';
    end if;
    -- exception for multi-function bridge that happens to be a highway AND pedestrian
    if v_brkey = '046425' then
      retval := '5';
    END IF;
  
    RETURN retval;
  
  EXCEPTION
    WHEN OTHERS THEN
      retval := '-1';
      RETURN retval;
  END f_check_nbi_42a;
  ----------------------------------------------------------------------------------

  Function f_check_nbi_42b(v_brkey bridge.brkey%type)
  
   return varchar2 is
  
    retval varchar2(2) := '0';
    pcode1 char(1);
    pcode2 char(1);
    pcode5 char(1);
    type tab_varchar3 IS TABLE OF varchar2(3) INDEX BY binary_integer;
    l_tab_cross_type tab_varchar3;
    l_tab_desc_type  tab_varchar3;
  
  begin
  
    select us.feat_cross_type, us.feat_desc_type BULK COLLECT
      INTO l_tab_cross_type, l_tab_desc_type
      from userrway us
     where us.brkey = v_brkey
       AND us.on_under <> '1';
  
    for i in 1 .. l_tab_cross_type.count LOOP
      if l_tab_cross_type(i) in ('10', '30', '50', '51', '70') and
         l_tab_desc_type(i) in ('0', '1', '2') THEN
        pcode1 := '1';
      ELSIF l_tab_cross_type(i) = '4' THEN
        pcode2 := '2';
      ELSIF l_tab_cross_type(i) = '90' THEN
        retval := '3';
      ELSIF l_tab_cross_type(i) = '2' THEN
        pcode5 := '5';
      END IF;
    END LOOP;
    IF pcode1 = '1' AND pcode2 = '2' AND pcode5 = '5' THEN
      retval := '8';
    ELSIF pcode1 = '1' AND pcode2 = 2 THEN
      retval := '4';
    ELSIF pcode1 = '1' AND pcode5 = 5 THEN
      retval := '6';
    ELSIF pcode2 = '2' AND pcode5 = '5' THEN
      retval := '7';
    ELSIF pcode2 = '2' THEN
      retval := '2';
    ELSIF pcode5 = '5' THEN
      retval := '5';
    ELSIF pcode1 = '1' THEN
      retval := '1';
    END IF;
    RETURN retval;
  EXCEPTION
    WHEN OTHERS THEN
      retval := '_';
      RETURN retval;
  END f_check_nbi_42b;

  ---------------------------------------------------------------------------
  Function f_check_nbi_43(v_brkey bridge.brkey%type)
  --this is a function that returns NBI fields 43, based on main unit
    --use query checks to audit Pontis fields
  
   return varchar2 is
    retval varchar2(3);
  
    -- use for main unit
    l_set     number;
    l_fix     number;
    l_strtype structure_unit.strunittype%type;
    l_strkey  structure_unit.strunitkey%type;
    l_ru04    userstrunit.unit_material%type;
    l_ru05    userstrunit.unit_type%type;
    l_ru09    userstrunit.super_design_ty%type;
    l_item43  number(3);
  
  BEGIN
  
    select s.strunitkey, s.strunittype
      into l_strkey, l_strtype -- main structure key
      from structure_unit s
     where s.brkey = v_brkey
       and s.strunittype = '1';
  
    select u.unit_material,
           decode(u.unit_material,
                  1,
                  3,
                  2,
                  3,
                  3,
                  3,
                  4,
                  9,
                  5,
                  9,
                  6,
                  1,
                  7,
                  5,
                  8,
                  1,
                  9,
                  8,
                  10,
                  7,
                  11,
                  5,
                  12,
                  1,
                  13,
                  0),
           u.unit_type,
           decode(u.unit_type,
                  1,
                  19,
                  2,
                  11,
                  3,
                  19,
                  4,
                  12,
                  11,
                  19,
                  12,
                  19,
                  21,
                  19,
                  22,
                  7,
                  31,
                  4,
                  32,
                  2,
                  33,
                  5,
                  34,
                  3,
                  35,
                  3,
                  36,
                  2,
                  37,
                  2,
                  38,
                  2,
                  41,
                  19,
                  42,
                  19,
                  43,
                  19,
                  51,
                  1,
                  52,
                  1,
                  53,
                  1,
                  61,
                  9,
                  62,
                  10,
                  63,
                  10,
                  71,
                  18,
                  72,
                  19,
                  73,
                  1,
                  83,
                  5,
                  84,
                  3,
                  85,
                  3,
                  86,
                  2,
                  87,
                  2,
                  88,
                  2,
                  89,
                  4,
                  97,
                  0,
                  98,
                  0),
           u.super_design_ty
      into l_ru04, l_set, l_ru05, l_fix, l_ru09
      from userstrunit u, structure_unit s
     where u.brkey = v_brkey
       and s.brkey = u.brkey
       and s.strunitkey = u.strunitkey
       and u.strunitkey = l_strkey;
  
    IF l_ru09 in (2, 3) AND l_set in (1, 3, 5) THEN
      l_set := l_set + 1;
    END IF;
    IF l_set = 3 AND l_fix = 4 THEN
      l_item43 := 308;
    ELSIF l_fix = 19 AND l_ru09 <> 0 THEN
      l_item43 := TO_NUMBER(TO_CHAR(l_set) || '07');
    ELSE
      l_item43 := TO_NUMBER(TO_CHAR(l_set) || LTRIM(TO_CHAR(l_fix, '00')));
    END IF;
    retval := LTRIM(TO_CHAR(l_item43, '000'));
  
    RETURN retval;
  
  EXCEPTION
    WHEN OTHERS THEN
      retval := '-1';
      RETURN retval;
  END f_check_nbi_43;
  ---------------------------------------------------------------------------
  Function f_check_nbi_44(v_brkey bridge.brkey%type)
  --this is a function that returns NBI fields 44, based on units that match the main unit (approaches)
    --use query checks to audit Pontis fields
    /*Logic for NBI 44:  We code Unit Type as Main, Approach or other.  NBI lumps these into
    Main or Approach.  Everything that is "Main" matches the structure type of Main.  To be considered
    approach units, they have to be evaluated as not matching the structure type of the Main Unit.
    */
   return varchar2 is
    retval varchar2(21);
  
    -- use for main unit
    l_set     number;
    l_fix     number;
    l_strtype structure_unit.strunittype%type;
    l_strkey  structure_unit.strunitkey%type;
  
    -- use for non-main units
    l_setx    number;
    l_fixx    number;
    l_strkeyx userstrunit.strunitkey%type;
    l_ru03x   userstrunit.length%type;
    l_ru04x   userstrunit.unit_material%type;
    l_ru05x   userstrunit.unit_type%type;
    l_ru09x   userstrunit.super_design_ty%type;
  
    l_item44   number(3) := 0; -- NBI 44 approaches
    l_item46   number(4) := 0;
    l_no_units number;
  
  BEGIN
  
    select s.strunitkey, s.strunittype
      into l_strkey, l_strtype -- main structure key
      from structure_unit s
     where s.brkey = v_brkey
       and s.strunittype = '1';
  
    select count(*)
      into l_no_units
      from userstrunit
     WHERE BRKEY = V_BRKEY
     GROUP BY BRKEY;
  
    if l_no_units > 1 then
    
      select nvl(sum(tot_num_spans), 0)
        into l_item46 -- approach spans that do not match main structuretype
        from userstrunit u
       where u.brkey = v_brkey
         and u.strunitkey != l_strkey
         and u.brkey not in
             (select brkey
                from userstrunit us
               where us.brkey = u.brkey
                 and us.strunitkey = l_strkey
                 and us.unit_material = u.unit_material
                 and us.unit_type = u.unit_type
                 and us.super_design_ty = u.super_design_ty);
    
      IF l_item46 = 0 then
        l_item44 := '000';
      
      ELSE
        select max(strunitkey)
          into l_strkeyx -- finds max unit for longest approach spans that do not
          from userstrunit -- match the main structure type use for NBI 44
         where brkey = v_brkey
           and length in
               (select max(u.length)
                  from userstrunit u
                 where u.brkey = v_brkey
                   and u.strunitkey != l_strkey
                   and u.brkey not in
                       (select brkey
                          from userstrunit us
                         where us.brkey = u.brkey
                           and us.strunitkey = l_strkey
                           and us.unit_material = u.unit_material
                           and us.unit_type = u.unit_type
                           and us.super_design_ty = u.super_design_ty));
      
        -- Use that unit for NBI item 44  
      
        select u.unit_material,
               decode(u.unit_material,
                      1,
                      3,
                      2,
                      3,
                      3,
                      3,
                      4,
                      9,
                      5,
                      9,
                      6,
                      1,
                      7,
                      5,
                      8,
                      1,
                      9,
                      8,
                      10,
                      7,
                      11,
                      5,
                      12,
                      1),
               u.unit_type,
               decode(u.unit_type,
                      1,
                      19,
                      2,
                      11,
                      3,
                      11,
                      4,
                      12,
                      11,
                      19,
                      12,
                      19,
                      21,
                      19,
                      22,
                      7,
                      31,
                      4,
                      32,
                      2,
                      33,
                      5,
                      34,
                      3,
                      35,
                      3,
                      36,
                      2,
                      37,
                      2,
                      38,
                      2,
                      41,
                      19,
                      42,
                      19,
                      43,
                      19,
                      51,
                      1,
                      52,
                      1,
                      53,
                      1,
                      61,
                      9,
                      62,
                      10,
                      63,
                      10,
                      71,
                      18,
                      72,
                      19,
                      73,
                      1,
                      83,
                      5,
                      84,
                      3,
                      85,
                      3,
                      86,
                      2,
                      87,
                      2,
                      88,
                      2,
                      89,
                      4,
                      97,
                      0,
                      98,
                      0),
               u.super_design_ty,
               u.length
          into l_ru04x, l_setx, l_ru05x, l_fixx, l_ru09x, l_ru03x
          from userstrunit u
         where u.brkey = v_brkey
           and u.strunitkey = l_strkeyx;
      
        l_set := l_setx;
        l_fix := l_fixx;
        --  l_ulen:=l_ru03x;
        IF l_ru09x IN (2, 3) and l_set IN (1, 3, 5) THEN
          l_set := l_set + 1;
        END IF;
        IF l_set = 3 AND l_fix = 4 THEN
          l_item44 := 308;
        ELSE
          l_item44 := TO_NUMBER(TO_CHAR(l_set) ||
                                LTRIM(TO_CHAR(l_fix, '00')));
        
        END IF;
      
      END IF;
    
    END IF;
  
    retval := retval || LTRIM(TO_CHAR(l_item44, '000'));
  
    RETURN retval;
  
  EXCEPTION
    WHEN OTHERS THEN
      retval := '-1';
      RETURN retval;
  END f_check_nbi_44;

  ---------------------------------------------------------------------------
  Function f_check_nbi_45(v_brkey bridge.brkey%type)
  --this is a function that returns NBI field  45,
    --use query checks to audit Pontis fields
  
   return varchar2 is
    retval varchar2(21);
  
    l_strtype structure_unit.strunittype%type;
    l_strkey  structure_unit.strunitkey%type;
  
    -- use for non-main units
    l_item45x  bridge.mainspans%type;
    l_item45   number(3); -- NBI 45 number of main spans
    l_no_units number;
  
  BEGIN
  
    select s.strunitkey, s.strunittype
      into l_strkey, l_strtype -- finds main structure unit key
      from structure_unit s
     where s.brkey = v_brkey
       and s.strunittype = '1';
  
    select u.tot_num_spans
      into l_item45
      from userstrunit u, structure_unit s
     where u.brkey = v_brkey
       and s.brkey = u.brkey
       and s.strunitkey = u.strunitkey
       and u.strunitkey = l_strkey;
  
    select count(*)
      into l_no_units
      from userstrunit
     WHERE BRKEY = V_BRKEY
     GROUP BY BRKEY;
  
    if l_no_units > 1 then
    
      --items 43, 44, 45, 46, 47
    
      select nvl(sum(tot_num_spans), 0)
        into l_item45x -- sum of spans that match 
        from userstrunit u -- main spans structure type 
       where u.brkey = v_brkey
         and u.strunitkey != l_strkey
         and u.brkey in
             (select brkey
                from userstrunit us
               where us.brkey = u.brkey
                 and us.strunitkey = l_strkey
                 and us.unit_material = u.unit_material
                 and us.unit_type = u.unit_type
                 and us.super_design_ty = u.super_design_ty);
    
      l_item45 := l_item45x + l_item45; -- to be added to main spans for total main spans
    
    END IF;
  
    retval := retval || LTRIM(TO_CHAR(l_item45, '000'));
  
    RETURN retval;
  
  EXCEPTION
    WHEN OTHERS THEN
      retval := '-1';
      RETURN retval;
  END f_check_nbi_45;
  ---------------------------------------------------------------------------

  Function f_check_nbi_46(v_brkey bridge.brkey%type)
  --this is a function that returns NBI fields 46 in a format to
    --use to  audit Pontis 
  
   return varchar2 is
    retval varchar2(4);
  
    -- use for main unit
    l_strtype structure_unit.strunittype%type;
    l_strkey  structure_unit.strunitkey%type;
  
    l_item46   number(4) := 0; -- NBI 46 number of approach spans
    l_no_units number;
  
  BEGIN
  
    select s.strunitkey, s.strunittype
      into l_strkey, l_strtype -- main structure key
      from structure_unit s
     where s.brkey = v_brkey
       and s.strunittype = '1';
  
    select count(*)
      into l_no_units
      from userstrunit
     WHERE BRKEY = V_BRKEY
     GROUP BY BRKEY;
  
    if l_no_units > 1 then
    
      select nvl(sum(tot_num_spans), 0)
        into l_item46 -- approach spans that do not match main structuretype
        from userstrunit u
       where u.brkey = v_brkey
         and u.strunitkey != l_strkey
         and u.brkey not in
             (select brkey
                from userstrunit us
               where us.brkey = u.brkey
                 and us.strunitkey = l_strkey
                 and us.unit_material = u.unit_material
                 and us.unit_type = u.unit_type
                 and us.super_design_ty = u.super_design_ty);
    
    END IF;
  
    retval := retval || LTRIM(TO_CHAR(l_item46, '0000'));
  
    RETURN retval;
  
  EXCEPTION
    WHEN OTHERS THEN
      retval := '-1';
      RETURN retval;
  END f_check_nbi_46;
  ---------------------------------------------------------------------------
  Function f_check_nbi_47_on(v_brkey roadway.brkey%type)
  --this is a function that returns/updates NBI field 47 for on records
    --used to audit roadway.hclrinv
  
   return number is
    retval number(5, 3) := 0;
  
    l_rd52 roadway.roadwidth%type;
  
    l_item47 number(5, 3); -- NBI 47 horizontal clearance
  
  BEGIN
  
    select round(decode(r.roadwidth, -1, 0, '', 0, r.roadwidth), 3)
      into l_rd52
      from roadway r
     where r.brkey = v_brkey
       and r.on_under = '1';
  
    If l_rd52 > 30.45 THEN
      l_item47 := 99.9;
    ELSE
      l_item47 := l_rd52;
    END IF;
  
    retval := l_item47;
  
    RETURN retval;
  
  EXCEPTION
    WHEN OTHERS THEN
      retval := '-2';
      RETURN retval;
  END f_check_nbi_47_on;
  ---------------------------------------------------------------------------

  function f_check_nbi_47_undr(v_brkey    userrway.brkey%type,
                               v_on_under userrway.on_under%type)
  
    --this is a function that returns/updates NBI fields 47 for under records
    --use query checks to audit Pontis fields
  
   return number is
    retval number(5, 3) := 0;
  
    l_item47_undr number(5, 3); -- NBI 47 horizontal clearance
  
  BEGIN
  
    select round(least(nvl(u.hclr_n, 99.9),
                       nvl(u.hclr_s, 99.9),
                       nvl(u.hclr_e, 99.9),
                       nvl(u.hclr_w, 99.9)),
                 3)
      into l_item47_undr -- min horizontal clearance 
      from userrway u
     where u.brkey = v_brkey
       and u.on_under = v_on_under;
  
    If l_item47_undr = 99.9 THEN
      retval := 0;
    ELSE
    
      retval := l_item47_undr;
    END IF;
  
    RETURN retval;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      retval := 0;
      RETURN retval;
  END f_check_nbi_47_undr;
  ---------------------------------------------------------------------------
  function f_check_nbi_48(v_brkey bridge.brkey%type)
  
    --this is a function that returns or can be used to update NBI field 48
  
   return number is
    retval_48 number(6, 3);
    l_item48  number(6, 3); -- NBI 48 length of max span for approaches that match main
  
  BEGIN
  
    select round(max(greatest(nvl(u.len_span_grp_1, 0),
                              nvl(u.len_span_grp_2, 0),
                              nvl(u.len_span_grp_3, 0),
                              nvl(u.len_span_grp_4, 0),
                              nvl(u.len_span_grp_5, 0),
                              nvl(u.len_span_grp_6, 0),
                              nvl(u.len_span_grp_7, 0),
                              nvl(u.len_span_grp_8, 0),
                              nvl(u.len_span_grp_9, 0),
                              nvl(u.len_span_grp_10, 0))),
                 3)
      into l_item48 -- max span 
      from userstrunit u
     where u.brkey = v_brkey;
  
    retval_48 := l_item48;
  
    RETURN retval_48;
  
  EXCEPTION
    WHEN OTHERS THEN
      retval_48 := -1;
      RETURN retval_48;
  END f_check_nbi_48;
  ---------------------------------------------------------------------------
  function f_check_nbi_51(v_brkey roadway.brkey%type)
  
   return number is
    retval       number(6, 3);
    item51       number(6, 3);
    l_item51     number(6, 3);
    l_item52     number(6, 3);
    l_designmain bridge.designmain%type;
    l_skew       number;
    l_rw_width   number;
    l_flow       number;
  begin
  
    select r.roadwidth
      into l_item51
      from roadway r
     where r.brkey = v_brkey
       and r.on_under = '1';
  
    /*           
    select round(b.deckwidth*10)
    into l_item52
    from bridge b
    where b.brkey = v_brkey;
    */
    item51 := l_item51;
  
    select b.designmain
      into l_designmain
      from bridge b
     where b.brkey = v_brkey;
  
    if l_designmain = '19' then
    
      select nvl(b.skew, 0)
        into l_skew
        from bridge b
       where b.brkey = v_brkey;
    
      select least(r.aroadwidth_near, r.aroadwidth_far)
        into l_rw_width
        from userrway r
       where r.brkey = v_brkey
         and r.on_under = '1';
    
      select b.deckwidth
        into l_item52
        from bridge b
       where b.brkey = v_brkey;
    
      l_flow := COS(l_skew * 3.14159265359 / 180) * (l_item52) + 4;
    
      if l_flow > l_rw_width then
        retval := '0000';
      
      ELSE
        retval := item51;
      
      END IF;
    ELSE
      retval := item51;
    
    END IF;
  
    return retval;
  
  EXCEPTION
    WHEN OTHERS THEN
      retval := -1;
      RETURN retval;
    
  END f_check_nbi_51;

  ---------------------------------------------------------------------------
  function f_check_nbi_52(v_brkey roadway.brkey%type)
  
   return number is
    retval       number(6, 3);
    l_item52     number(6, 3);
    l_designmain bridge.designmain%type;
    l_skew       number := 0;
    l_rw_width   number;
    l_flow       number;
  begin
    /*
    select r.roadwidth
    into l_item51
    from roadway r
    where r.brkey = v_brkey and
          r.on_under = '1';
     */
  
    select b.deckwidth into l_item52 from bridge b where b.brkey = v_brkey;
  
    select b.designmain
      into l_designmain
      from bridge b
     where b.brkey = v_brkey;
  
    if l_designmain = '19' then
    
      select nvl(b.skew, 0)
        into l_skew
        from bridge b
       where b.brkey = v_brkey;
    
      select least(r.aroadwidth_near, r.aroadwidth_far)
        into l_rw_width
        from userrway r
       where r.brkey = v_brkey
         and r.on_under = '1';
    
      l_flow := COS(l_skew * 3.14159265359 / 180) * (l_item52) + 4;
    
      if l_flow > l_rw_width then
        retval := '0000';
      
      ELSE
        retval := l_item52;
      
      END IF;
    ELSE
      retval := l_item52;
    
    END IF;
  
    return retval;
  
  EXCEPTION
    WHEN OTHERS THEN
      retval := -1;
      RETURN retval;
    
  END f_check_nbi_52;
  ---------------------------------------------------------------------------
  function f_check_nbi_53(v_brkey roadway.brkey%type) return number is
    retval     number;
    l_vclrinv  number;
    l_nbi53    number;
    v_on_under userrway.on_under%type;
  
  begin
  
    V_on_under := '1';
  
    select round(least(nvl(vclrinv_n, 30.45),
                       nvl(vclrinv_s, 30.45),
                       nvl(vclrinv_e, 30.45),
                       nvl(vclrinv_w, 30.45)),
                 3)
      into l_nbi53
      from userrway u
     where brkey = v_brkey
       and on_under = v_on_under;
  
    If l_nbi53 >= 30.45 THEN
      l_vclrinv := 9999;
    ELSE
      l_vclrinv := trunc(l_nbi53 * 100);
    
    END IF;
  
    retval := l_vclrinv;
  
    return retval;
  EXCEPTION
    WHEN OTHERS THEN
      retval := -1;
      RETURN retval;
    
  end f_check_nbi_53;

  ---------------------------------------------------------------------------
  function f_check_NBI_54a(v_brkey userrway.brkey%type)
  
   return varchar2 is
    retval char(1) := 'N';
    type tab_varchar4 IS TABLE OF varchar2(4) INDEX BY binary_integer;
    l_tab_type tab_varchar4;
  
  BEGIN
    select feat_cross_type BULK COLLECT
      INTO l_tab_type
      from userrway
     where brkey = v_brkey
       and on_under <> '1';
  
    FOR i IN 1 .. l_tab_type.COUNT LOOP
      if L_TAB_TYPE(i) in ('10', '50', '51', '70', '30') then
        retval := 'H';
      ELSIF (l_tab_type(i) = '4' AND retval = 'N') THEN
        retval := 'R';
      END IF;
    END LOOP;
  
    return retval;
  exception
    when others then
      retval := '~';
      return retval;
    
  END f_check_NBI_54a;
  ---------------------------------------------------------------------------
  function f_check_NBI_54b(v_brkey userrway.brkey%type)
  
   return number is
    retval_54b number(6, 3) := 0;
    retval_54a char(1) := 'N';
    l_min_vclr number := 0;
    type tab_varchar4 IS TABLE OF varchar2(4) INDEX BY binary_integer;
    l_tab_type tab_varchar4;
  
  BEGIN
  
    select feat_cross_type BULK COLLECT
      INTO l_tab_type
      from userrway
     where brkey = v_brkey
       and on_under <> '1';
  
    FOR i IN 1 .. l_tab_type.COUNT LOOP
      if L_TAB_TYPE(i) in ('10', '50', '51', '70', '30') then
        retval_54a := 'H';
      ELSIF (l_tab_type(i) = '4' AND retval_54a = 'N') THEN
        retval_54a := 'R';
      
      END IF;
    END LOOP;
  
    IF retval_54a = 'N' THEN
      retval_54b := 0;
    
    ELSE
      select round(min(least(nvl(u.vclr_n, 999),
                             nvl(u.vclr_s, 999),
                             nvl(u.vclr_e, 999),
                             nvl(u.vclr_w, 999))),
                   3)
        into l_min_vclr
        from userrway u
       where u.brkey = v_brkey
         and feat_cross_type in ('4', '10', '50', '51', '70', '30', '90') --added 90...maybe shouldn't have...oh well
       group by v_brkey;
    
    END IF;
  
    IF l_min_vclr = 999 then
      l_min_vclr := 0;
    END IF;
  
    retval_54b := l_min_vclr;
  
    return retval_54b;
  exception
    when others then
      retval_54b := -1;
      return retval_54b;
    
  END f_check_NBI_54b;
  ---------------------------------------------------------------------------
  function f_check_NBI_55a(v_brkey userrway.brkey%type)
  
   return varchar2 is
    retval_55a char(1) := 'N';
    type tab_varchar4 IS TABLE OF varchar2(4) INDEX BY binary_integer;
    l_tab_type tab_varchar4;
  
  BEGIN
    select feat_cross_type BULK COLLECT
      INTO l_tab_type
      from userrway
     where brkey = v_brkey
       and on_under <> '1';
  
    FOR i IN 1 .. l_tab_type.COUNT LOOP
      if L_TAB_TYPE(i) in ('10', '50', '51', '70', '30') then
        retval_55a := 'H';
      ELSIF (l_tab_type(i) = '4' AND retval_55a = 'N') THEN
        retval_55a := 'R';
      END IF;
    END LOOP;
  
    return retval_55a;
  exception
    when others then
      retval_55a := '~';
      return retval_55a;
  END f_check_NBI_55a;
  ---------------------------------------------------------------------------
  function f_check_NBI_55B(v_brkey userrway.brkey%type)
  
   return number is
    retval_55a     char(1) := 'N';
    retval_55b     number := 0;
    l_min_latright number := 0;
    type tab_varchar4 IS TABLE OF varchar2(4) INDEX BY binary_integer;
    l_tab_type tab_varchar4;
  
  BEGIN
  
    select feat_cross_type BULK COLLECT
      INTO l_tab_type
      from userrway
     where brkey = v_brkey
       and on_under <> '1';
  
    FOR i IN 1 .. l_tab_type.COUNT LOOP
      if L_TAB_TYPE(i) in ('10', '50', '51', '70', '30') then
        retval_55a := 'H';
      ELSIF (l_tab_type(i) = '4' AND retval_55a = 'N') THEN
        retval_55a := 'R';
      
      END IF;
    END LOOP;
  
    IF retval_55a = 'N' THEN
      retval_55b := 0;
    ELSE
    
      select round(min(least(nvl(u.hclrurt_n, 999),
                             nvl(u.hclrurt_s, 999),
                             nvl(u.hclrurt_e, 999),
                             nvl(u.hclrurt_w, 999))),
                   3)
        into l_min_latright
        from userrway u
       where u.brkey = v_brkey
         and feat_cross_type in ('4', '10', '50', '51', '70', '30', '90') -- added 90 for pedestrian stuff 12-5-2012 (dk)
       group by v_brkey;
    
    END IF;
  
    IF l_min_latright = '999' then
      l_min_latright := 0;
    END IF;
  
    retval_55b := l_min_latright;
  
    return retval_55B;
  exception
    when others then
      retval_55B := -1;
      return retval_55B;
    
  END f_check_NBI_55b;

  ---------------------------------------------------------------------------
  function f_check_NBI_56(v_brkey userrway.brkey%type)
  
   return number is
    retval_55a    char(1) := 'N';
    retval_56     number := 0;
    l_min_latleft number := 0;
    type tab_varchar4 IS TABLE OF varchar2(4) INDEX BY binary_integer;
    l_tab_type tab_varchar4;
  
  BEGIN
  
    select feat_cross_type BULK COLLECT
      INTO l_tab_type
      from userrway
     where brkey = v_brkey
       and on_under <> '1';
  
    FOR i IN 1 .. l_tab_type.COUNT LOOP
      if L_TAB_TYPE(i) in ('10', '50', '51', '70', '30') then
        retval_55a := 'H';
      ELSIF (l_tab_type(i) = '4' AND retval_55a = 'N') THEN
        retval_55a := 'R';
      END IF;
    END LOOP;
  
    IF retval_55a = 'N' THEN
      retval_56 := 0;
    
    ELSE
    
      select round(min(least(nvl(u.hclrult_n, 999),
                             nvl(u.hclrult_s, 999),
                             nvl(u.hclrult_e, 999),
                             nvl(u.hclrult_w, 999))),
                   3)
        into l_min_latleft
        from userrway u
       where u.brkey = v_brkey
         and on_under <> '1'
       group by v_brkey;
    END IF;
  
    IF l_min_latleft = '999' then
      l_min_latleft := 0;
    END IF;
  
    retval_56 := l_min_latleft;
  
    return retval_56;
  exception
    when others then
      retval_56 := -1;
      return retval_56;
    
  END f_check_NBI_56;
  ---------------------------------------------------------------------------
  function f_check_NBI_70_Posting(v_brkey bridge.brkey%type) return number is
  
    retval NUMBER;
    l_PCT  number := 0;
    l_calc number := 0;
  
    l_lfd_hs userbrdg.orload_lfd_hs%TYPE;
    l_wsd_hs userbrdg.orload_wsd_hs%type;
    l_adj_hs userbrdg.orload_adj_hs%type;
  
  begin
  
    select orload_lfd_hs, orload_wsd_hs, orload_adj_hs
      into l_lfd_hs, l_wsd_hs, l_adj_hs
      from userbrdg ub
     where ub.brkey = v_brkey;
  
    IF NVL(l_adj_hs, 0) > 0 THEN
      l_CALC := round((20.41 - l_adj_hs) * 100 / 20.41, 2);
    ELSIF NVL(l_lfd_hs, 0) > 0 THEN
      l_CALC := round((20.41 - l_lfd_hs) * 100 / 20.41, 2);
    
    ELSE
      l_CALC := round((20.41 - l_wsd_hs) * 100 / 20.41, 2);
    END IF;
    IF l_PCT < l_CALC and l_CALC > 0 THEN
      l_PCT  := l_CALC;
      retval := 5;
    END IF;
  
    IF l_PCT > 0.0 THEN
      retval := 4;
    END IF;
    IF l_PCT >= 10.0 THEN
      retval := 3;
    END IF;
    IF l_PCT >= 20.0 THEN
      retval := 2;
    END IF;
    IF l_PCT >= 30.0 THEN
      retval := 1;
    END IF;
    IF l_PCT > 39.9 and l_PCT <= 100.0 THEN
      retval := 0;
    END IF;
    RETURN retval;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      retval := NULL;
      RETURN retval;
    WHEN OTHERS THEN
      retval := -1;
      RETURN retval;
  end f_check_NBI_70_Posting;
  ---------------------------------------------------------------------------
  function f_check_nbi_75a_b(v_brkey roadway.brkey%type) return varchar2 is
    retval          VARCHAR2(31);
    l_set           NUMBER;
    l_fix           NUMBER;
    v_adt           roadway.adttotal%TYPE;
    l_sup_design_ty userstrunit.super_design_ty%TYPE; --ru09
    l_unit_mat      userstrunit.unit_material%TYPE; --ru04
    l_unit_type     userstrunit.unit_type%TYPE; --ru05
    funcclass       roadway.funcclass%type;
    l_volume        number := 1;
    width           number;
    length          number;
    lengthfeet      number;
    tol             number;
    struct          number;
    suff            number;
    post            varchar2(1);
  
    wide   NUMBER;
    item75 VARCHAR(3);
    /*
    item94 NUMBER;--(6);
    item95 NUMBER;--(6);
    item96 NUMBER;--(6);
    item97 VARCHAR2(4);
    */
    l_strunitkey structure_unit.strunitkey%TYPE;
  
  BEGIN
    SELECT decode(r.roadwidth, -1, 0, '', 0, r.roadwidth) * 3.280839895,
           length,
           length * 3.280839895,
           suff_rate,
           TRANSLATE(oppostcl_kdot, '12345678', 'ABDEGKPR'),
           decode(funcclass,
                  01,
                  1,
                  02,
                  2,
                  03,
                  6,
                  04,
                  6,
                  05,
                  6,
                  06,
                  3,
                  07,
                  4,
                  08,
                  5,
                  09,
                  6,
                  10,
                  6,
                  11,
                  1,
                  12,
                  2,
                  13,
                  6,
                  14,
                  3,
                  15,
                  6,
                  16,
                  4,
                  17,
                  5,
                  18,
                  6,
                  19,
                  6),
           adttotal
      INTO width, length, lengthfeet, suff, post, funcclass, v_adt
      FROM bridge               b,
           roadway              r,
           inspevnt             i,
           userinsp             u,
           mv_latest_inspection mv
     WHERE b.brkey = v_brkey
       and r.brkey = b.brkey
       and r.on_under = '1'
       and i.brkey = b.brkey
       and mv.brkey = b.brkey
       and u.brkey = b.brkey
       and u.inspkey = i.inspkey
       and i.inspkey = mv.inspkey;
  
    SELECT strunitkey
      into l_strunitkey
      from structure_unit s
     where s.brkey = v_brkey
       and s.strunittype = '1';
  
    select u.unit_material,
           decode(u.unit_material,
                  1,
                  3,
                  2,
                  3,
                  3,
                  3,
                  4,
                  9,
                  5,
                  9,
                  6,
                  1,
                  7,
                  5,
                  8,
                  1,
                  9,
                  8,
                  10,
                  7,
                  11,
                  5,
                  12,
                  1),
           u.unit_type,
           decode(u.unit_type,
                  1,
                  19,
                  2,
                  11,
                  3,
                  11,
                  4,
                  12,
                  11,
                  19,
                  12,
                  19,
                  21,
                  19,
                  22,
                  7,
                  31,
                  4,
                  32,
                  2,
                  33,
                  5,
                  34,
                  3,
                  35,
                  3,
                  36,
                  2,
                  37,
                  2,
                  38,
                  2,
                  41,
                  19,
                  42,
                  19,
                  43,
                  19,
                  51,
                  1,
                  52,
                  1,
                  53,
                  1,
                  61,
                  9,
                  62,
                  10,
                  63,
                  10,
                  71,
                  18,
                  72,
                  19,
                  73,
                  1,
                  83,
                  5,
                  84,
                  3,
                  85,
                  3,
                  86,
                  2,
                  87,
                  2,
                  88,
                  2,
                  89,
                  4,
                  97,
                  0,
                  98,
                  0),
           u.super_design_ty
    
      into l_unit_mat, l_set, l_unit_type, l_fix, l_sup_design_ty
      from userstrunit u, structure_unit s
     where u.brkey = v_brkey
       and s.brkey = u.brkey
       and s.strunitkey = u.strunitkey
       and u.strunitkey = l_strunitkey;
  
    IF l_sup_design_ty in (2, 3) AND l_set in (1, 3, 5) THEN
      l_set := l_set + 1;
    END IF;
    IF l_set = 3 AND l_fix = 4 THEN
      struct := 8;
    ELSE
      struct := l_fix;
    END IF;
  
    IF v_adt < 400 THEN
      l_volume := 1;
    ELSIF v_adt < 750 THEN
      l_volume := 2;
    ELSIF v_adt < 1700 THEN
      l_volume := 3;
    ELSIF v_adt < 3000 THEN
      l_volume := 4;
    ELSIF v_adt < 5000 THEN
      l_volume := 5;
    ELSE
      l_volume := 6;
    END IF;
  
    SELECT tol_value, des_value
      INTO TOL, WIDE
      FROM nbip_tol_des
     WHERE volume = l_volume
       AND func = funcclass;
  
    IF (width < tol AND struct IN (10, 11, 12)) OR suff < 50 OR post = 'P' THEN
    
      item75 := '311';
    
    ELSIF (width < tol AND struct IN (10, 11, 12)) AND
          (width != 0 OR struct != 19) THEN
      item75 := '341';
    
    ELSE
    
      item75 := '371';
    
    END IF;
  
    retval := item75;
  
    RETURN retval;
  EXCEPTION
    WHEN OTHERS THEN
      retval := '-1';
      RETURN retval;
    
  end f_check_nbi_75a_b;

  ---------------------------------------------------------------------------
  function f_check_nbi_76(v_brkey roadway.brkey%type) return varchar2 is
    retval          VARCHAR2(31);
    l_set           NUMBER;
    l_fix           NUMBER;
    v_adt           roadway.adttotal%TYPE;
    l_sup_design_ty userstrunit.super_design_ty%TYPE; --ru09
    l_unit_mat      userstrunit.unit_material%TYPE; --ru04
    l_unit_type     userstrunit.unit_type%TYPE; --ru05
    funcclass       roadway.funcclass%type;
    l_volume        number := 1;
    width           number;
    length          number;
    lengthfeet      number;
    tol             number;
    struct          number;
    suff            number;
    post            varchar2(1);
  
    wide         NUMBER;
    item76       NUMBER; --(6);
    l_strunitkey structure_unit.strunitkey%TYPE;
  
  BEGIN
    SELECT decode(r.roadwidth, -1, 0, '', 0, r.roadwidth) * 3.280839895,
           length,
           length * 3.280839895,
           suff_rate,
           TRANSLATE(oppostcl_kdot, '12345678', 'ABDEGKPR'),
           decode(funcclass,
                  1,
                  1,
                  2,
                  2,
                  3,
                  6,
                  4,
                  6,
                  5,
                  6,
                  6,
                  3,
                  7,
                  4,
                  8,
                  5,
                  9,
                  6,
                  10,
                  6,
                  11,
                  1,
                  12,
                  2,
                  13,
                  6,
                  14,
                  3,
                  15,
                  6,
                  16,
                  4,
                  17,
                  5,
                  18,
                  6,
                  19,
                  6),
           adttotal
      INTO width, length, lengthfeet, suff, post, funcclass, v_adt
      FROM bridge               b,
           roadway              r,
           inspevnt             i,
           userinsp             u,
           mv_latest_inspection mv
     WHERE b.brkey = v_brkey
       and r.brkey = b.brkey
       and r.on_under = '1'
       and i.brkey = b.brkey
       and mv.brkey = b.brkey
       and u.brkey = b.brkey
       and u.inspkey = i.inspkey
       and i.inspkey = mv.inspkey;
  
    SELECT strunitkey
      into l_strunitkey
      from structure_unit s
     where s.brkey = v_brkey
       and s.strunittype = '1';
  
    select u.unit_material,
           decode(u.unit_material,
                  1,
                  3,
                  2,
                  3,
                  3,
                  3,
                  4,
                  9,
                  5,
                  9,
                  6,
                  1,
                  7,
                  5,
                  8,
                  1,
                  9,
                  8,
                  10,
                  7,
                  11,
                  5,
                  12,
                  1),
           u.unit_type,
           decode(u.unit_type,
                  1,
                  19,
                  2,
                  11,
                  3,
                  11,
                  4,
                  12,
                  11,
                  19,
                  12,
                  19,
                  21,
                  19,
                  22,
                  7,
                  31,
                  4,
                  32,
                  2,
                  33,
                  5,
                  34,
                  3,
                  35,
                  3,
                  36,
                  2,
                  37,
                  2,
                  38,
                  2,
                  41,
                  19,
                  42,
                  19,
                  43,
                  19,
                  51,
                  1,
                  52,
                  1,
                  53,
                  1,
                  61,
                  9,
                  62,
                  10,
                  63,
                  10,
                  71,
                  18,
                  72,
                  19,
                  73,
                  1,
                  83,
                  5,
                  84,
                  3,
                  85,
                  3,
                  86,
                  2,
                  87,
                  2,
                  88,
                  2,
                  89,
                  4,
                  97,
                  0,
                  98,
                  0),
           u.super_design_ty
    
      into l_unit_mat, l_set, l_unit_type, l_fix, l_sup_design_ty
      from userstrunit u, structure_unit s
     where u.brkey = v_brkey
       and s.brkey = u.brkey
       and s.strunitkey = u.strunitkey
       and u.strunitkey = l_strunitkey;
  
    IF l_sup_design_ty in (2, 3) AND l_set in (1, 3, 5) THEN
      l_set := l_set + 1;
    END IF;
    IF l_set = 3 AND l_fix = 4 THEN
      struct := 8;
    ELSE
      struct := l_fix;
    END IF;
  
    IF v_adt < 400 THEN
      l_volume := 1;
    ELSIF v_adt < 750 THEN
      l_volume := 2;
    ELSIF v_adt < 1700 THEN
      l_volume := 3;
    ELSIF v_adt < 3000 THEN
      l_volume := 4;
    ELSIF v_adt < 5000 THEN
      l_volume := 5;
    ELSE
      l_volume := 6;
    END IF;
  
    SELECT tol_value, des_value
      INTO TOL, WIDE
      FROM nbip_tol_des
     WHERE volume = l_volume
       AND func = funcclass;
  
    IF (width < tol AND struct IN (10, 11, 12)) OR suff < 50 OR post = 'P' THEN
      item76 := LENGTH * 1.15;
    
    ELSIF (width < tol AND struct IN (10, 11, 12)) AND
          (width != 0 OR struct != 19) THEN
    
      item76 := LENGTH;
    
    ELSE
    
      item76 := LENGTH;
    
    END IF;
    retval := round(item76, 3);
  
    RETURN retval;
  EXCEPTION
    WHEN OTHERS THEN
      retval := '-1';
      RETURN retval;
    
  end f_check_nbi_76;

  ---------------------------------------------------------------------------
  function f_check_NBI_92_93(v_brkey bridge.brkey%TYPE) return varchar2 is
  
    retval            varchar2(21);
    l_92a             VARCHAR2(3) := 'N  ';
    l_92b             VARCHAR2(3) := 'N  ';
    l_92c             VARCHAR2(3) := 'N  ';
    l_93a             VARCHAR2(4) := '    ';
    l_93b             VARCHAR2(4) := '    ';
    l_93c             VARCHAR2(4) := '    ';
    l_uwater_insp_typ char;
    l_uwater_date     varchar(4) := '    ';
  
    type tab_varchar4 IS TABLE OF varchar2(4) INDEX BY binary_integer;
    l_tab_crit_note_sup_1 tab_varchar4;
    l_tab_crit_note_sup_2 tab_varchar4;
    l_tab_crit_note_sup_3 tab_varchar4;
    l_tab_crit_note_sup_4 tab_varchar4;
    l_tab_crit_note_sup_5 tab_varchar4;
  
  BEGIN
  
    SELECT crit_note_sup_1,
           crit_note_sup_2,
           crit_note_sup_3,
           crit_note_sup_4,
           crit_note_sup_5 BULK COLLECT
      INTO l_tab_crit_note_sup_1,
           l_tab_crit_note_sup_2,
           l_tab_crit_note_sup_3,
           l_tab_crit_note_sup_4,
           l_tab_crit_note_sup_5
      from userstrunit u
     where u.brkey = v_brkey;
  
    FOR i in 1 .. l_tab_crit_note_sup_1.COUNT LOOP
    
      IF l_tab_crit_note_sup_1(i) = '1' or l_tab_crit_note_sup_2(i) = '1' OR
         l_tab_crit_note_sup_3(i) = '1' or l_tab_crit_note_sup_4(i) = '1' or
         l_tab_crit_note_sup_5(i) = '1' THEN
        l_92a := 'Y';
      END IF;
    END LOOP;
    IF l_92a = 'Y' THEN
      SELECT ltrim(to_char(fcinspfreq_kdot * 12, '00'))
        INTO l_92a
        from userinsp u, mv_latest_inspection mv
       where mv.brkey = v_brkey
         and u.brkey = v_brkey
         and u.inspkey = mv.inspkey;
      l_92a := 'Y' || NVL(l_92a, '00');
    
      SELECT decode(to_char(fclastinsp, 'MMYY'),
                    '0101',
                    '',
                    to_char(fclastinsp, 'MMYY'))
        INTO l_93a
        from inspevnt i, mv_latest_inspection mv
       where i.brkey = v_brkey
         and mv.brkey = v_brkey
         and i.inspkey = mv.inspkey;
    
    END IF;
    -- Find the Dive underwater inspections and code them appropriately...
    SELECT uwater_insp_typ
      into l_uwater_insp_typ
      from userinsp u, mv_latest_inspection mv
     where u.brkey = v_brkey
       and mv.brkey = v_brkey
       and u.inspkey = mv.inspkey;
    if l_uwater_insp_typ = '3' then
      -- Type 3's are a 59 month inspection interval
      l_92B := 'Y59';
      SELECT decode(to_char(uwlastinsp, 'MMYY'),
                    '0101',
                    '',
                    to_char(uwlastinsp, 'MMYY'))
        INTO l_93b
        from inspevnt i, mv_latest_inspection mv, userinsp u
       where i.brkey = v_brkey
         and u.brkey = v_brkey
         and u.inspkey = mv.inspkey
         and mv.brkey = v_brkey
         and i.inspkey = mv.inspkey;
    
    End if;
  
    if l_uwater_insp_typ = '4' then
      -- Type 4's are a 60 month interval
      l_92B := 'Y60';
      SELECT decode(to_char(uwlastinsp, 'MMYY'),
                    '0101',
                    '',
                    to_char(uwlastinsp, 'MMYY'))
        INTO l_93b
        from inspevnt i, mv_latest_inspection mv, userinsp u
       where i.brkey = v_brkey
         and u.brkey = v_brkey
         and u.inspkey = mv.inspkey
         and mv.brkey = v_brkey
         and i.inspkey = mv.inspkey;
    End if;
  
    /* 
      IF l_92b= 'Y' THEN
         SELECT ltrim(to_char(uwinspfreq_kdot*12,'00')) 
        INTO l_92b
           from userinsp u, mv_latest_inspection mv
           where mv.brkey = v_brkey and
           u.brkey = v_brkey and
           u.inspkey = mv.inspkey;
           l_92b:='Y'||NVL(l_92b,'00');
       
           
                
      SELECT decode(to_char(uwlastinsp,'MMYY'),'0101','',to_char(uwlastinsp,'MMYY'))
      into l_93b
      from inspevnt i, mv_latest_inspection mv
      where i.brkey = v_brkey and
            mv.brkey = v_brkey and
            i.inspkey = mv.inspkey;
    */
  
    FOR i IN 1 .. l_tab_crit_note_sup_1.count LOOP
      IF l_tab_crit_note_sup_1(i) = '9' or l_tab_crit_note_sup_2(i) = '9' OR
         l_tab_crit_note_sup_3(i) = '9' or l_tab_crit_note_sup_4(i) = '9' or
         l_tab_crit_note_sup_5(i) = '9' THEN
        l_92c := 'Y';
      END IF;
    END LOOP;
  
    IF l_92c = 'Y' THEN
      SELECT ltrim(to_char(osinspfreq_kdot * 12, '00'))
        INTO l_92c
        from userinsp u, mv_latest_inspection mv
       where mv.brkey = v_brkey
         and u.brkey = v_brkey
         and u.inspkey = mv.inspkey;
      l_92c := 'Y' || NVL(l_92c, '00');
    
      SELECT decode(to_char(oslastinsp, 'MMYY'),
                    '0101',
                    '',
                    to_char(oslastinsp, 'MMYY'))
        into l_93c
        from inspevnt i, mv_latest_inspection mv
       where i.brkey = v_brkey
         and mv.brkey = v_brkey
         and i.inspkey = mv.inspkey;
    
    END IF;
  
    retval := l_92a || l_92b || l_92c;
    retval := retval || l_93a || l_93b || l_93c;
  
    RETURN retval;
  EXCEPTION
    WHEN OTHERS THEN
      retval := '-1';
      RETURN retval;
    
  end f_check_NBI_92_93;
  ---------------------------------------------------------------------------
  function f_check_nbi_94_95_96_97(v_brkey roadway.brkey%type)
    return varchar2 is
    retval          varchar2(22);
    l_set           NUMBER;
    l_fix           NUMBER;
    v_adt           roadway.adttotal%TYPE;
    l_sup_design_ty userstrunit.super_design_ty%TYPE; --ru09
    l_unit_mat      userstrunit.unit_material%TYPE; --ru04
    l_unit_type     userstrunit.unit_type%TYPE; --ru05
    funcclass       roadway.funcclass%type;
    l_volume        number := 1;
    width           number;
    length          number;
    lengthfeet      number;
    tol             number;
    struct          number;
    suff            number;
    post            varchar2(1);
  
    wide         NUMBER;
    item94       NUMBER; --(6);
    item95       NUMBER; --(6);
    item96       NUMBER; --(6);
    item97       VARCHAR2(4);
    l_strunitkey structure_unit.strunitkey%TYPE;
  
  BEGIN
    SELECT meters_to_feet(decode(r.roadwidth, -1, 0, '', 0, r.roadwidth)), --*3.280839895,
           round(length, 3) * 10,
           meters_to_feet(length), -- * 3.280839895,
           suff_rate,
           TRANSLATE(oppostcl_kdot, '12345678', 'ABDEGKPR'),
           decode(funcclass,
                  1,
                  1,
                  2,
                  2,
                  3,
                  6,
                  4,
                  6,
                  5,
                  6,
                  6,
                  3,
                  7,
                  4,
                  8,
                  5,
                  9,
                  6,
                  10,
                  6,
                  11,
                  1,
                  12,
                  2,
                  13,
                  6,
                  14,
                  3,
                  15,
                  6,
                  16,
                  4,
                  17,
                  5,
                  18,
                  6,
                  19,
                  6),
           adttotal
      INTO width, length, lengthfeet, suff, post, funcclass, v_adt
      FROM bridge               b,
           roadway              r,
           inspevnt             i,
           userinsp             u,
           mv_latest_inspection mv
     WHERE b.brkey = v_brkey
       and r.brkey = b.brkey
       and r.on_under = '1'
       and i.brkey = b.brkey
       and mv.brkey = b.brkey
       and u.brkey = b.brkey
       and u.inspkey = i.inspkey
       and i.inspkey = mv.inspkey;
  
    SELECT strunitkey
      into l_strunitkey
      from structure_unit s
     where s.brkey = v_brkey
       and s.strunittype = '1';
  
    select u.unit_material,
           decode(u.unit_material,
                  1,
                  3,
                  2,
                  3,
                  3,
                  3,
                  4,
                  9,
                  5,
                  9,
                  6,
                  1,
                  7,
                  5,
                  8,
                  1,
                  9,
                  8,
                  10,
                  7,
                  11,
                  5,
                  12,
                  1),
           u.unit_type,
           decode(u.unit_type,
                  1,
                  19,
                  2,
                  11,
                  3,
                  11,
                  4,
                  12,
                  11,
                  19,
                  12,
                  19,
                  21,
                  19,
                  22,
                  7,
                  31,
                  4,
                  32,
                  2,
                  33,
                  5,
                  34,
                  3,
                  35,
                  3,
                  36,
                  2,
                  37,
                  2,
                  38,
                  2,
                  41,
                  19,
                  42,
                  19,
                  43,
                  19,
                  51,
                  1,
                  52,
                  1,
                  53,
                  1,
                  61,
                  9,
                  62,
                  10,
                  63,
                  10,
                  71,
                  18,
                  72,
                  19,
                  73,
                  1,
                  83,
                  5,
                  84,
                  3,
                  85,
                  3,
                  86,
                  2,
                  87,
                  2,
                  88,
                  2,
                  89,
                  4,
                  97,
                  0,
                  98,
                  0),
           u.super_design_ty
    
      into l_unit_mat, l_set, l_unit_type, l_fix, l_sup_design_ty
      from userstrunit u, structure_unit s
     where u.brkey = v_brkey
       and s.brkey = u.brkey
       and s.strunitkey = u.strunitkey
       and u.strunitkey = l_strunitkey;
  
    IF l_sup_design_ty in (2, 3) AND l_set in (1, 3, 5) THEN
      l_set := l_set + 1;
    END IF;
    IF l_set = 3 AND l_fix = 4 THEN
      struct := 8;
    ELSE
      struct := l_fix;
    END IF;
  
    IF v_adt < 400 THEN
      l_volume := 1;
    ELSIF v_adt < 750 THEN
      l_volume := 2;
    ELSIF v_adt < 1700 THEN
      l_volume := 3;
    ELSIF v_adt < 3000 THEN
      l_volume := 4;
    ELSIF v_adt < 5000 THEN
      l_volume := 5;
    ELSE
      l_volume := 6;
    END IF;
  
    SELECT tol_value, des_value
      INTO TOL, WIDE
      FROM nbip_tol_des
     WHERE volume = l_volume
       AND func = funcclass;
  
    IF (width < tol AND struct IN (10, 11, 12)) OR (suff < 50) OR
       (post = 'P') THEN
      item94 := 75 * LENGTHFEET * 1.15 * WIDE;
    
      IF STRUCT = 19 THEN
        item94 := ITEM94 * 0.75 / 1000;
      ELSE
        item94 := item94 / 1000;
      END IF;
    
      item95 := item94 * 0.1;
      item96 := item94 * 1.5;
      item97 := TO_CHAR(SYSDATE, 'YYYY');
    
    ELSIF (width < tol AND struct IN (10, 11, 12)) AND
          (width != 0 OR struct != 19) THEN
      item94 := 64 * (wide - width) * lengthfeet;
    
      IF struct = 19 THEN
        item94 := item94 * 0.75 / 1000;
      ELSE
        item94 := item94 / 1000;
      END IF;
    
      item95 := item94 * 0.1;
      item96 := item94 * 1.5;
      item97 := TO_CHAR(SYSDATE, 'YYYY');
    ELSE
      wide := width;
      IF width = 0 AND struct = 19 THEN
        wide := tol;
      END IF;
      item94 := 23 * lengthfeet * wide;
    
      IF struct = 19 THEN
        item94 := item94 * 0.75 / 1000;
      ELSE
        item94 := item94 / 1000;
      END IF;
    
      item95 := item94 * 0.1;
      item96 := item94 * 1.5;
      item97 := TO_CHAR(SYSDATE, 'YYYY');
    END IF;
    retval := ltrim(to_char(item94, '000000'));
    retval := retval || ltrim(TO_CHAR(item95, '000000'));
    retval := retval || ltrim(TO_CHAR(item96, '000000'));
    retval := retval || item97;
  
    RETURN retval;
  EXCEPTION
    WHEN OTHERS THEN
      retval := '-1';
      RETURN retval;
    
  end f_check_nbi_94_95_96_97;

  ---------------------------------------------------------------------------
  function F_CHECK_NBI_103(v_brkey bridge.brkey%TYPE) RETURN CHAR is
  
    retval char(1);
  
    type tab_varchar4 IS TABLE OF varchar2(4) INDEX BY binary_integer;
    l_tab_crit_note_sup_1 tab_varchar4;
    l_tab_crit_note_sup_2 tab_varchar4;
    l_tab_crit_note_sup_3 tab_varchar4;
    l_tab_crit_note_sup_4 tab_varchar4;
    l_tab_crit_note_sup_5 tab_varchar4;
  
  BEGIN
  
    SELECT crit_note_sup_1,
           crit_note_sup_2,
           crit_note_sup_3,
           crit_note_sup_4,
           crit_note_sup_5 BULK COLLECT
      INTO l_tab_crit_note_sup_1,
           l_tab_crit_note_sup_2,
           l_tab_crit_note_sup_3,
           l_tab_crit_note_sup_4,
           l_tab_crit_note_sup_5
      from userstrunit u
     where u.brkey = v_brkey;
  
    FOR i in 1 .. l_tab_crit_note_sup_1.COUNT LOOP
    
      IF l_tab_crit_note_sup_1(i) in ('8') OR
         l_tab_crit_note_sup_2(i) in ('8') OR
         l_tab_crit_note_sup_3(i) in ('8') OR
         l_tab_crit_note_sup_4(i) in ('8') or
         l_tab_crit_note_sup_5(i) in ('8') THEN
        retval := 'T';
      END IF;
    END LOOP;
    RETURN retval;
  EXCEPTION
    WHEN OTHERS THEN
      retval := '_';
      RETURN retval;
    
  end F_CHECK_NBI_103;

  ----------------------------------------------------------------------------------

  function f_check_nbi_109_on(v_brkey roadway.brkey%type)
  
   return number is
    retval number;
  
    l_adttotal       number;
    l_function_type  userbrdg.function_type%type;
    l_feat_desc_type userrway.feat_desc_type%type;
    l_truckpct       roadway.truckpct%Type;
  
  BEGIN
  
    select r.adttotal, us.function_type, u.feat_desc_type, r.truckpct
      into l_adttotal, l_function_type, l_feat_desc_type, l_truckpct
      from roadway r, userbrdg us, userrway u
     where r.brkey = v_brkey
       and u.brkey = v_brkey
       and r.on_under = u.on_under
       and r.on_under = '1'
       and us.brkey = r.brkey;
  
    IF l_adttotal > 100 THEN
      IF l_function_type in (10, 30) AND
         l_feat_desc_type in ('0', '1', '9', '10', '11') THEN
        retval := l_truckpct;
      ELSE
        SELECT decode(r.funcclass,
                      1,
                      28,
                      2,
                      16,
                      6,
                      11,
                      7,
                      8,
                      8,
                      8,
                      9,
                      5,
                      11,
                      10,
                      12,
                      6,
                      14,
                      4,
                      16,
                      3,
                      17,
                      2,
                      19,
                      2,
                      10)
          INTO retval
          from roadway r
         where r.brkey = v_brkey
           and r.on_under = '1';
      END IF;
    ELSE
      -- AADT < 100--
      retval := NULL;
    END IF;
    RETURN retval;
  EXCEPTION
    WHEN OTHERS THEN
      retval := -1;
      RETURN retval;
    
  END f_check_nbi_109_on;
  ---------------------------------------------------------------------------
  function f_check_nbi_109_undr(v_brkey    roadway.brkey%type,
                                v_on_under roadway.on_under%type)
  
   return number is
    retval number;
  
    l_adttotal        roadway.adttotal%type;
    l_feat_cross_type userrway.feat_cross_type%type;
    l_feat_desc_type  userrway.feat_desc_type%type;
    l_funcclass       roadway.funcclass%type;
    l_truckpct        roadway.truckpct%Type;
  
  BEGIN
  
    select r.adttotal,
           us.feat_cross_type,
           us.feat_desc_type,
           r.truckpct,
           r.funcclass
      into l_adttotal,
           l_feat_cross_type,
           l_feat_desc_type,
           l_truckpct,
           l_funcclass
      from roadway r, userrway us
     where r.brkey = v_brkey
       and us.brkey = v_brkey
       and r.on_under = us.on_under
       and r.on_under = v_on_under;
  
    IF l_adttotal > 100 THEN
      IF l_feat_cross_type in (10, 30, 50, 51, 70) AND
         l_feat_desc_type in ('0', '1', '9', '10', '11') THEN
        retval := l_truckpct;
      ELSE
        SELECT decode(l_funcclass,
                      1,
                      28,
                      2,
                      16,
                      6,
                      11,
                      7,
                      8,
                      8,
                      8,
                      9,
                      5,
                      11,
                      10,
                      12,
                      6,
                      14,
                      4,
                      16,
                      3,
                      17,
                      2,
                      19,
                      2,
                      10)
          INTO retval
          from roadway r
         where r.brkey = v_brkey
           and r.on_under = v_on_under;
      END IF;
    ELSE
      -- AADT < 100--
      retval := NULL;
    END IF;
    RETURN retval;
  EXCEPTION
    WHEN OTHERS THEN
      retval := -1;
      RETURN retval;
    
  END f_check_nbi_109_undr;
  ---------------------------------------------------------------------------
  Function f_get_nbi_51_52(v_brkey roadway.brkey%type)
  
   return varchar2 is
    retval       varchar(8);
    item5152     varchar(8);
    l_item51     number(4);
    l_item52     number(4);
    l_designmain bridge.designmain%type;
    l_skew       number;
    l_rw_width   number;
    l_flow       number;
  begin
  
    select round(r.roadwidth * 10)
      into l_item51
      from roadway r
     where r.brkey = v_brkey
       and r.on_under = '1';
  
    select round(b.deckwidth * 10)
      into l_item52
      from bridge b
     where b.brkey = v_brkey;
  
    item5152 := LTRIM(TO_CHAR(L_ITEM51, '0000')) ||
                LTRIM(TO_CHAR(L_ITEM52, '0000'));
  
    select b.designmain
      into l_designmain
      from bridge b
     where b.brkey = v_brkey;
  
    if l_designmain = '19' then
    
      select nvl(b.skew, 0)
        into l_skew
        from bridge b
       where b.brkey = v_brkey;
    
      select least(r.aroadwidth_near, r.aroadwidth_far)
        into l_rw_width
        from userrway r
       where r.brkey = v_brkey
         and r.on_under = '1';
    
      select b.deckwidth
        into l_item52
        from bridge b
       where b.brkey = v_brkey;
    
      l_flow := COS(l_skew * 3.14159265359 / 180) * (l_item52) + 4;
    
      if l_flow > l_rw_width then
        retval := '00000000';
      
      ELSE
        retval := item5152;
      
      END IF;
    ELSE
      retval := item5152;
    
    END IF;
  
    return retval;
  
  EXCEPTION
    WHEN OTHERS THEN
      retval := -1;
      RETURN retval;
    
  END f_get_nbi_51_52;
  -----------------------------------------------------------------------------------------------

  function f_get_nbi_64_66(v_brkey userbrdg.brkey%type,
                           v_adj_h userbrdg.irload_adj_h%type,
                           v_lfd_h userbrdg.irload_adj_h%type,
                           v_wsd_h userbrdg.irload_adj_h%type) return number is
    retval number;
    v_fill varchar2(2);
    v_adj  number;
    v_lfd  number;
    v_wsd  number;
  
  begin
  
    select v_adj_h, v_lfd_h, v_wsd_h
      into v_adj, v_lfd, v_wsd
      from userbrdg u
     where u.brkey = v_brkey;
  
    retval := nvl(v_adj, 0);
  
    if retval = 0 then
      retval := nvl(v_adj, 0);
    end if;
  
    if retval = 0 then
      retval := nvl(v_lfd, 0);
    end if;
  
    if retval = 0 then
      retval := v_wsd;
    end if;
  
    retval := round(retval, 2);
  
    if retval >= 89.8 then
      retval := 99.9;
    end if;
  
    select undr_suff_fill
      into v_fill
      from userbrdg u
     where u.brkey = v_brkey;
  
    if v_fill = 'Y' then
      retval := 99.9;
    end if;
  
    return retval;
  
  end f_get_nbi_64_66;

----------------------------------------------------------------------------------

end NBIP;
/