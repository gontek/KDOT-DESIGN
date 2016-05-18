CREATE OR REPLACE PACKAGE BODY pontis.Bif IS

  FUNCTION Centered_String(String_In IN VARCHAR2, Length_In IN INTEGER)
    RETURN VARCHAR2 IS
    Len_String INTEGER := Length(String_In);
  BEGIN
    IF Len_String IS NULL OR Length_In <= 0 THEN
      RETURN NULL;
    ELSE
      RETURN Rpad('_', (Length_In - Len_String) / 2 - 1) || Ltrim(Rtrim(String_In));
    END IF;
  END;
  ----------------------------------------------------------------------------------------------

  FUNCTION f_Get_Bif_Loadrtng(v_Brkey        Userbrdg.Brkey%TYPE,
                              p_Field_Name_1 IN VARCHAR2,
                              p_Field_Name_2 IN VARCHAR2,
                              p_Field_Name_3 IN VARCHAR2) RETURN NUMBER IS
    Retval NUMBER;
  
    v_Adj Userbrdg.Irload_Adj_h%TYPE;
    v_Lfd Userbrdg.Irload_Adj_h%TYPE;
    v_Wsd Userbrdg.Irload_Adj_h%TYPE;
  
  BEGIN
  
    SELECT p_Field_Name_1, p_Field_Name_2, p_Field_Name_3
      INTO v_Adj, v_Lfd, v_Wsd
      FROM Userbrdg u
     WHERE u.Brkey = v_Brkey;
  
    IF v_Adj IS NOT NULL THEN
      Retval := v_Adj;
    END IF;
    IF v_Adj IS NULL THEN
      Retval := v_Lfd;
    END IF;
    IF v_Adj IS NULL AND v_Lfd IS NULL THEN
      Retval := v_Wsd;
    END IF;
  
    Retval := Round(Retval / 0.9072);
  
    RETURN Retval;
  END f_Get_Bif_Loadrtng;
  -----------------------------------------------------------------------------------------------

  FUNCTION f_Get_Bif_Full_Route(v_Brkey Bridge.Brkey%TYPE) RETURN VARCHAR2 IS
    Retval VARCHAR2(255);
  
    v_Rte_Prefix Userrway.Route_Prefix%TYPE;
    v_Route_Num  Userrway.Route_Num%TYPE;
    v_Route_Suf  VARCHAR2(5);
  
  BEGIN
  
    SELECT Maint_Rte_Prefix,
           Maint_Rte_Num,
           Decode(u.Maint_Rte_Suffix,
                  '0',
                  '',
                  f_Get_Paramtrs_Equiv_Long('userrway',
                                            'route_suffix',
                                            u.Maint_Rte_Suffix))
      INTO v_Rte_Prefix, v_Route_Num, v_Route_Suf
      FROM Userrway u
     WHERE u.Brkey = v_Brkey
       AND u.On_Under = '1';
  
    Retval := v_Rte_Prefix || ' ' || v_Route_Num || ' ' || v_Route_Suf;
  
    RETURN Retval;
  END f_Get_Bif_Full_Route;

  -----------------------------------------------------------------------------------------------

  FUNCTION f_Get_Bif_Spanlist(v_Brkey Bridge.Brkey%TYPE) RETURN VARCHAR2 IS
    Retval VARCHAR2(4000);
  BEGIN
  
    SELECT Ltrim(REPLACE(Sys_Connect_By_Path(Bif_Spangrps, '/'),
                         '/',
                         Chr(10)),
                 Chr(10))
      INTO Retval
      FROM (SELECT Bif_Spangrps,
                   Brkey,
                   COUNT(*) Over(PARTITION BY Brkey) Cnt,
                   Row_Number() Over(PARTITION BY Brkey ORDER BY Strunitkey) Seq
              FROM pontis.Mv_Strspans)
     WHERE Seq = Cnt
       AND Brkey = v_Brkey
     START WITH Seq = 1
    CONNECT BY PRIOR Seq + 1 = Seq
           AND PRIOR Brkey = Brkey;
  
    RETURN Retval;
  END f_Get_Bif_Spanlist;

  ----------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Route(v_Brkey Bridge.Brkey%TYPE) RETURN NUMBER IS
    Retval NUMBER;
  
  BEGIN
  
    SELECT To_Number(Maint_Rte_Num)
      INTO Retval
      FROM Userrway u
     WHERE u.Brkey = v_Brkey
       AND u.On_Under = '1';
  
    RETURN Retval;
  END f_Get_Bif_Route;
  ------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Insp_Intrvl(v_Brkey Bridge.Brkey%TYPE) RETURN NUMBER IS
    Retval FLOAT;
  
  BEGIN
  
    SELECT Brinspfreq_Kdot
      INTO Retval
      FROM Userinsp u, Mv_Latest_Inspection Mv
     WHERE u.Brkey = v_Brkey
       AND Mv.Brkey = u.Brkey
       AND u.Inspkey = Mv.Inspkey;
  
    RETURN Retval;
  END f_Get_Bif_Insp_Intrvl;

  ------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Orload_Lbl(v_Brkey        Userbrdg.Brkey%TYPE,
                                p_Field_Name_1 IN VARCHAR2,
                                p_Field_Name_2 IN VARCHAR2,
                                p_Field_Name_3 IN VARCHAR2) RETURN VARCHAR2 IS
    Retval VARCHAR2(20);
  
    v_Adj Userbrdg.Orload_Adj_h%TYPE;
    v_Lfd Userbrdg.Orload_Adj_h%TYPE;
    v_Wsd Userbrdg.Orload_Adj_h%TYPE;
  
  BEGIN
  
    SELECT p_Field_Name_1, p_Field_Name_2, p_Field_Name_3
      INTO v_Adj, v_Lfd, v_Wsd
      FROM Userbrdg u
     WHERE u.Brkey = v_Brkey;
  
    IF v_Adj IS NOT NULL THEN
      Retval := 'Adj Load Rate Opr:';
    END IF;
    IF v_Adj IS NULL THEN
      Retval := 'LFD Load Rate Opr:';
    END IF;
    IF v_Adj IS NULL AND v_Lfd IS NULL THEN
      Retval := 'WSD Load Rate Opr:';
    END IF;
  
    RETURN Retval;
  END f_Get_Bif_Orload_Lbl;
  --------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Irload_Lbl(v_Brkey        Userbrdg.Brkey%TYPE,
                                p_Field_Name_1 IN VARCHAR2,
                                p_Field_Name_2 IN VARCHAR2,
                                p_Field_Name_3 IN VARCHAR2) RETURN VARCHAR2 IS
    Retval VARCHAR2(20);
  
    v_Adj Userbrdg.Irload_Adj_h%TYPE;
    v_Lfd Userbrdg.Irload_Adj_h%TYPE;
    v_Wsd Userbrdg.Irload_Adj_h%TYPE;
  
  BEGIN
  
    SELECT p_Field_Name_1, p_Field_Name_2, p_Field_Name_3
      INTO v_Adj, v_Lfd, v_Wsd
      FROM Userbrdg u
     WHERE u.Brkey = v_Brkey;
  
    IF v_Adj IS NOT NULL THEN
      Retval := 'Adj Load Rate Inv:';
    END IF;
    IF v_Adj IS NULL THEN
      Retval := 'LFD Load Rate Inv:';
    END IF;
    IF v_Adj IS NULL AND v_Lfd IS NULL THEN
      Retval := 'WSD Load Rate Inv:';
    END IF;
  
    RETURN Retval;
  END f_Get_Bif_Irload_Lbl;
  ------------------------------------------------------------------------------------------------------------

  FUNCTION f_Get_Bif_Totalunits(v_Brkey Structure_Unit.Brkey%TYPE)
    RETURN VARCHAR2 IS
  
    Retval VARCHAR2(5);
  
  BEGIN
  
    SELECT To_Char(COUNT(Strunitkey))
      INTO Retval
      FROM Structure_Unit
     WHERE Structure_Unit.Brkey = v_Brkey;
  
    RETURN Retval;
  
  END f_Get_Bif_Totalunits;
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
  FUNCTION f_Meters_To_Feet(Unitsin IN NUMBER) RETURN VARCHAR2 IS
  
    Retval       VARCHAR2(25);
    Retvalfeet   VARCHAR2(2000);
    Retvalinches VARCHAR2(2000);
    Feetsymbol   VARCHAR2(2);
    Inchessymbol VARCHAR2(2);
  
  BEGIN
  
    Retvalfeet   := Unitsin;
    Retvalinches := Unitsin;
    Feetsymbol   := Chr(146);
    Inchessymbol := Chr(148);
  
    IF (Retvalfeet IS NULL) OR (Retvalfeet <= 0) THEN
      Retval := ' ';
    ELSE
    
      IF Round(MOD(Retvalfeet, 12), 0) = 12 THEN
        Retval := TRIM(To_Char(Trunc(Retvalfeet / 12, 0) + 1) || Feetsymbol);
      ELSE
        Retval := TRIM(To_Char(Trunc(Retvalfeet / 12, 0) || Feetsymbol));
        --    retval := retval || ' ' || feetsymbol;
      END IF;
    
      IF Round(MOD(Retvalinches, 12), 0) = 12 THEN
        Retval := Lpad(TRIM(Retval || ' 0' || Inchessymbol), 22);
      ELSE
        Retval := Lpad(TRIM(Retval ||
                            Lpad(To_Char(Round(MOD(Retvalinches, 12), 0)),
                                 2) || Inchessymbol),
                       22);
      END IF;
    
    END IF;
    RETURN Retval;
  
  END f_Meters_To_Feet;
  --------------------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Insp_Item(v_Brkey        Bridge.Brkey%TYPE,
                               p_Field_Name_1 IN VARCHAR2) RETURN VARCHAR2 IS
    Retval VARCHAR2(25);
  
    v_Inspkey       VARCHAR2(25);
    v_Intrvl        VARCHAR2(25);
    v_Intrvl_Uw     VARCHAR2(25);
    v_Deckgeom      VARCHAR2(25);
    v_Nbi_Rating    VARCHAR2(25);
    v_Strrating     VARCHAR2(25);
    v_Suff_Rate     VARCHAR2(25);
    v_Underclr      VARCHAR2(25);
    v_Priority_Opt  VARCHAR2(25);
    v_Fhwa_Status   VARCHAR2(25);
    v_Scourcrit     VARCHAR2(25);
    v_Subrating     VARCHAR2(25);
    v_Chanrating    VARCHAR2(25);
    v_Wateradeq     VARCHAR2(25);
    v_Dkrate        VARCHAR2(25);
    v_Suprate       VARCHAR2(25);
    v_Culvrate      VARCHAR2(25);
    v_Deck_Comp_Hi  VARCHAR2(25);
    v_Super_Comp_Hi VARCHAR2(25);
    v_Sub_Comp_Hi   VARCHAR2(25);
    v_Culv_Comp_Hi  VARCHAR2(25);
  BEGIN
  
    SELECT i.Inspkey,
           To_Char(Brinspfreq_Kdot),
           Deckgeom,
           Nvl(Uwinspfreq_Kdot, '0'),
           f_Get_Paramtrs_Equiv('inspevnt', 'nbi_rating', i.Nbi_Rating),
           Strrating,
           To_Char(Suff_Rate),
           Underclr,
           To_Char(Us.Priority_Opt * 10000),
           Decode(Fhwa_Status, 'Y', 'Y', 'N'),
           Scourcrit,
           Subrating,
           Chanrating,
           Wateradeq,
           Dkrating,
           Suprating,
           Culvrating,
           Deck_Comp_Hi,
           Super_Comp_Hi,
           Sub_Comp_Hi,
           Culv_Comp_Hi
      INTO v_Inspkey,
           v_Intrvl,
           v_Deckgeom,
           v_Intrvl_Uw,
           v_Nbi_Rating,
           v_Strrating,
           v_Suff_Rate,
           v_Underclr,
           v_Priority_Opt,
           v_Fhwa_Status,
           v_Scourcrit,
           v_Subrating,
           v_Chanrating,
           v_Wateradeq,
           v_Dkrate,
           v_Suprate,
           v_Culvrate,
           v_Deck_Comp_Hi,
           v_Super_Comp_Hi,
           v_Sub_Comp_Hi,
           v_Culv_Comp_Hi
      FROM Userinsp Us, Inspevnt i, Mv_Latest_Inspection Mv
     WHERE Us.Brkey = v_Brkey
       AND Mv.Brkey = v_Brkey
       AND i.Brkey = v_Brkey
       AND i.Inspkey = Mv.Inspkey
       AND Us.Inspkey = Mv.Inspkey;
  
    IF p_Field_Name_1 = 'inspkey' THEN
      Retval := v_Inspkey;
    END IF;
  
    IF p_Field_Name_1 = 'brinspfreq_kdot' THEN
      Retval := v_Intrvl;
    END IF;
  
    IF p_Field_Name_1 = 'deckgeom' THEN
      Retval := v_Deckgeom;
    END IF;
  
    IF p_Field_Name_1 = 'uwinspfreq_kdot' THEN
      Retval := v_Intrvl_Uw;
    END IF;
  
    IF p_Field_Name_1 = 'nbi_rating' THEN
      Retval := v_Nbi_Rating;
    END IF;
  
    IF p_Field_Name_1 = 'strrating' THEN
      Retval := v_Strrating;
    END IF;
  
    IF p_Field_Name_1 = 'suff_rate' THEN
      Retval := v_Suff_Rate;
    END IF;
  
    IF p_Field_Name_1 = 'underclr' THEN
      Retval := v_Underclr;
    END IF;
  
    IF p_Field_Name_1 = 'priority_opt' THEN
      Retval := v_Priority_Opt;
    END IF;
  
    IF p_Field_Name_1 = 'fhwa_status' THEN
      Retval := v_Fhwa_Status;
    END IF;
  
    IF p_Field_Name_1 = 'scourcrit' THEN
      Retval := v_Scourcrit;
    END IF;
  
    IF p_Field_Name_1 = 'subrating' THEN
      Retval := v_Subrating;
    END IF;
  
    IF p_Field_Name_1 = 'chanrating' THEN
      Retval := v_Chanrating;
    END IF;
  
    IF p_Field_Name_1 = 'wateradeq' THEN
      Retval := v_Wateradeq;
    END IF;
  
    IF p_Field_Name_1 = 'dkrating' THEN
      Retval := v_Dkrate;
    END IF;
  
    IF p_Field_Name_1 = 'suprating' THEN
      Retval := v_Suprate;
    END IF;
  
    IF p_Field_Name_1 = 'culvrating' THEN
      Retval := v_Culvrate;
    END IF;
  
    IF p_Field_Name_1 = 'deck_comp_hi' THEN
      Retval := v_Deck_Comp_Hi;
    END IF;
  
    IF p_Field_Name_1 = 'super_comp_hi' THEN
      Retval := v_Super_Comp_Hi;
    END IF;
  
    IF p_Field_Name_1 = 'sub_comp_hi' THEN
      Retval := v_Sub_Comp_Hi;
    END IF;
  
    IF p_Field_Name_1 = 'culv_comp_hi' THEN
      Retval := v_Culv_Comp_Hi;
    END IF;
  
    RETURN Retval;
  END f_Get_Bif_Insp_Item;

  -------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Userstr_Item_Main(v_Brkey        Userstrunit.Brkey%TYPE,
                                       p_Field_Name_1 IN VARCHAR2)
    RETURN VARCHAR2 IS
    Retval VARCHAR2(25);
  
    v_Abut_Type_Near VARCHAR2(25);
    v_Abut_Type_Far  VARCHAR2(25);
    v_Pier_Foot_Type VARCHAR2(25);
  BEGIN
  
    SELECT Abut_Type_Near, Abut_Type_Far, Pier_Foot_Type
      INTO v_Abut_Type_Near, v_Abut_Type_Far, v_Pier_Foot_Type
      FROM Userstrunit u, Structure_Unit s
     WHERE u.Brkey = v_Brkey
       AND s.Brkey = v_Brkey
       AND u.Strunitkey = s.Strunitkey
       AND s.Strunittype = '1';
  
    IF p_Field_Name_1 = 'abut_type_near' THEN
      Retval := v_Abut_Type_Near;
    END IF;
  
    IF p_Field_Name_1 = 'abut_type_far' THEN
      Retval := v_Abut_Type_Far;
    END IF;
  
    IF p_Field_Name_1 = 'pier_foot_type' THEN
      Retval := v_Pier_Foot_Type;
    END IF;
  
    RETURN Retval;
  END f_Get_Bif_Userstr_Item_Main;
  ----------------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Cansysprjs(v_Brkey       v_Bif_Capital_Prj.Brkey%TYPE,
                                Columnname_In VARCHAR2) RETURN VARCHAR2 IS
    Retval    VARCHAR2(2000);
    Sqlstring VARCHAR2(8000);
    Quote     CHAR(1) := Chr(39); -- uses ASCII code for single quote which is CHR(39)
  
  BEGIN
  
    Sqlstring := 'select ltrim(substr(replace(sys_connect_by_path(' ||
                 Columnname_In || ', ' || Quote || '*' || Quote || '),' ||
                 Quote || '*' || Quote || ', ' || 'CHR(13)' ||
                 '   ),  2 ) ) ' || ' from (select distinct ' ||
                 Columnname_In || ',
                            brkey,
                            count(*) over(partition by brkey) cnt,
                            row_number() over(partition by brkey order by actvdate' ||
                 ' ) seq ' || ' from pontis.v_bif_capital_prj) ' ||
                 ' where seq = cnt ' || ' and brkey = :br ' ||
                 ' start with seq = 1 ' ||
                 ' connect by prior seq + 1 = seq ' ||
                 ' and prior brkey = brkey ';
  
    EXECUTE IMMEDIATE Sqlstring
      INTO Retval
      USING v_Brkey;
  
    RETURN Retval;
  
  EXCEPTION
    WHEN No_Data_Found THEN
      RETURN NULL;
    
    WHEN OTHERS THEN
      RAISE;
    
  END f_Get_Bif_Cansysprjs;
  -----------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Inspecdatax(v_Brkey       Inspevnt.Brkey%TYPE,
                                 Tablename_In  VARCHAR2,
                                 Columnname_In VARCHAR2) RETURN VARCHAR2 IS
    Retval    VARCHAR2(2000);
    Sqlstring VARCHAR2(8000);
  
  BEGIN
  
    -- create a big sql string which will dynamically include the tablename and column name you have passed.
  
    Sqlstring := 'select ' || Tablename_In || '.' || Columnname_In ||
                 ' from userinsp , inspevnt , mv_latest_inspection ' ||
                 ' where userinsp.brkey = :br ' ||
                 ' and mv_latest_inspection.brkey = userinsp.brkey ' ||
                 ' and inspevnt.brkey = userinsp.brkey ' ||
                 ' and userinsp.inspkey = mv_latest_inspection.inspkey ' ||
                 ' and inspevnt.inspkey = mv_latest_inspection.inspkey ';
  
    -- execute the dynamic SQL string - supply v_brkey as bind variable :br 
    -- return result into retval
  
    EXECUTE IMMEDIATE Sqlstring
      INTO Retval
      USING v_Brkey; --see :br above
  
    RETURN Retval;
  
  EXCEPTION
    WHEN No_Data_Found THEN
      --- sql did not find any data, so return a NULL
      RETURN NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.
  
  END f_Get_Bif_Inspecdatax;

  FUNCTION f_Get_Bif_Inspecdata(v_Brkey IN Inspevnt.Brkey%TYPE,
                                Ptab    IN User_Tab_Cols.Table_Name%TYPE,
                                Pcol    IN User_Tab_Cols.Column_Name%TYPE)
    RETURN VARCHAR2 IS
  
    RESULT VARCHAR2(4000);
  
    t_Cur SYS_REFCURSOR;
  
    TYPE t_Rec IS RECORD(
      Par_c VARCHAR2(4000));
    r_Rec     t_Rec;
    Sqlstring VARCHAR2(8000);
  
  BEGIN
    /*  OPEN t_Cur FOR q'[SELECT  ]' || q'[t.]' || Pcol || q'[ as par_c ]' || q'[ FROM  ]' || Ptab || q'[ t inner join mv_latest_inspection mv on t.brkey = mv.brkey ]' || q'[ WHERE t.brkey = :brkey ]' || q'[ and mv.brkey = t.brkey ]'
        USING v_Brkey;
    */
    Sqlstring := q'[SELECT ]' || Ptab || q'[.]' || Pcol ||
                 q'[ as par_c  FROM  ]' || Ptab ||
                 q'[ inner join mv_latest_inspection mv on ]' || Ptab ||
                 q'[.brkey = mv.brkey WHERE ]' || Ptab ||
                 q'[.brkey = :brkey   ]';
    OPEN t_Cur FOR Sqlstring
      USING /*Ptab,*/
    v_Brkey;
    FETCH t_Cur
      INTO r_Rec;
    RESULT := r_Rec.Par_c;
    CLOSE t_Cur;
    /*
      http://eriksekeris.blogspot.com/2011/06/dynamic-sql-using-variable-number-of.html
      
      CREATE OR REPLACE PROCEDURE dynamic_sql_example
      ( par_a IN varchar2
      , par_b IN number
      , par_c IN varchar2
      )
    IS
      TYPE  t_cur IS REF CURSOR;
      c_cur t_cur;
      type t_rec is record (par_a varchar2(20), par_b number, par_c varchar2(20));
      r_rec t_rec;
      --
      l_qt varchar2(1) := chr(39);
    BEGIN
      OPEN c_cur FOR 'SELECT :x par_a'||
                          ', :y par_b'||
                          ', :z par_c'||
                      ' FROM dual'
               USING par_a, par_b, par_c;
      FETCH c_cur INTO r_rec;
      CLOSE c_cur;
    END;
    /
      */
    -- create a big sql string which will dynamically include the tablename and column name you have passed.
    /*
    Sqlstring := 'select ' || Tablename_In || '.' || Columnname_In ||
                 ' from userinsp , inspevnt , mv_latest_inspection ' ||
                 ' where userinsp.brkey = :br ' ||
                 ' and mv_latest_inspection.brkey = userinsp.brkey ' ||
                 ' and inspevnt.brkey = userinsp.brkey ' ||
                 ' and userinsp.inspkey = mv_latest_inspection.inspkey ' ||
                 ' and inspevnt.inspkey = mv_latest_inspection.inspkey ';
                 */
  
    -- execute the dynamic SQL string - supply v_brkey as bind variable :br 
    -- return result into retval
    /* 
    EXECUTE IMMEDIATE Sqlstring
      INTO Retval
      USING v_Brkey; --see :br above*/
  
    RETURN RESULT;
  
  EXCEPTION
    WHEN No_Data_Found THEN
      --- sql did not find any data, so return a NULL
      RETURN NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.
  
  END f_Get_Bif_Inspecdata;
  ------------------------------------------------------------------------------------------------------

  FUNCTION f_Get_Bif_Rdwydata(v_Brkey       Roadway.Brkey%TYPE,
                              v_On_Under    Roadway.On_Under%TYPE,
                              Tablename_In  VARCHAR2,
                              Columnname_In VARCHAR2) RETURN VARCHAR2 IS
    Retval    VARCHAR2(2000);
    Sqlstring VARCHAR2(8000);
  
  BEGIN
  
    -- create a big sql string which will dynamically include the tablename and column name you have passed.
  
    Sqlstring := 'select ' || Columnname_In || ' from ' || Tablename_In ||
                 ' where ' || Tablename_In || '.' || 'brkey  = :br ' ||
                 ' and on_under = :our ';
  
    -- execute the dynamic SQL string - supply v_brkey as bind variable :br
    -- return result into retval
  
    EXECUTE IMMEDIATE Sqlstring
      INTO Retval
      USING v_Brkey, v_On_Under; --see :br above
  
    RETURN Retval;
  
  EXCEPTION
    WHEN No_Data_Found THEN
      --- sql did not find any data, so return a NULL
      RETURN NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.
  
  END f_Get_Bif_Rdwydata;
  ----------------------------------------------------------------------------------------------------------------

  FUNCTION f_Get_Bif_Elemdata(v_Brkey       Eleminsp.Brkey%TYPE,
                              v_Strunitkey  Eleminsp.Strunitkey%TYPE,
                              Columnname_In VARCHAR2,
                              v_Elemtype    CHAR) RETURN VARCHAR2 IS
    Retval    VARCHAR2(2000);
    Sqlstring VARCHAR2(8000);
    Quote     CHAR(1) := Chr(39); -- use the ASCII code for sinqle quote which is CHR(39)        
  
  BEGIN
    -- RETURN 'BWAHHHAHAHA!';
    -- create a big sql string which will dynamically include the column name you have passed.
    -- be very careful about single quotes etc.  In this case, have declared a variable that is nothing but a single quote and used that wherever a single quote literal should
    -- appear in the sql e.g. '*' is quote|| '*' || quote which becomes '*' when concatenated.
    -- the variable columnname_in will become the literal column name in the concatenated sql string
    -- CHR(13) means linefeed (carriage return) and will display all the numbers in column when reported.
    -- TEST SCRIPT
  
    Sqlstring := 'select ltrim(substr(replace(sys_connect_by_path(' ||
                 Columnname_In || ', ' || Quote || '*' || Quote || '),' ||
                 Quote || '*' || Quote || ', ' || 'CHR(13)' ||
                 '   ),  2 ) ) ' ||
                --into retval
                 ' from (select distinct ' || Columnname_In || ' ,
                             brkey,
                             strunitkey,
                             elemtype,
                             count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                             row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key' ||
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
  
    EXECUTE IMMEDIATE Sqlstring
      INTO Retval
      USING v_Brkey, v_Strunitkey, v_Elemtype; -- these are determined by position in the string (see :br and :su above)
  
    RETURN Retval;
  
  EXCEPTION
    WHEN No_Data_Found THEN
      --- sql did not find any data, so return a NULL
      RETURN NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.
  
  END f_Get_Bif_Elemdata;
  -----------------------------------------------------------------------------------------------------------------------

  FUNCTION f_Get_Bif_Dkrate(v_Brkey  Inspevnt.Brkey%TYPE,
                            v_Rownum IN VARCHAR2) RETURN VARCHAR2 AS
    Retval VARCHAR2(4);
  
  BEGIN
  
    SELECT Dkrating
      INTO Retval
      FROM (SELECT Brkey,
                   Dkrating,
                   Row_Number() Over(ORDER BY Brkey, Inspdate DESC) Rnm
              FROM Inspevnt
             WHERE Brkey = v_Brkey)
     WHERE Rnm = v_Rownum;
  
    RETURN Retval;
  
  END f_Get_Bif_Dkrate;
  ---------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Inspdate(v_Brkey  Inspevnt.Brkey%TYPE,
                              v_Rownum IN VARCHAR2) RETURN VARCHAR2 AS
    Retval VARCHAR2(4);
  
  BEGIN
  
    SELECT Extract(YEAR FROM Inspdate)
      INTO Retval
      FROM (SELECT Brkey,
                   Inspdate,
                   Row_Number() Over(ORDER BY Brkey, Inspdate DESC) Rnm
              FROM Inspevnt
             WHERE Brkey = v_Brkey)
     WHERE Rnm = v_Rownum;
  
    RETURN Retval;
  
  END f_Get_Bif_Inspdate;
  -------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Suprate(v_Brkey  Inspevnt.Brkey%TYPE,
                             v_Rownum IN VARCHAR2) RETURN VARCHAR2 AS
    Retval VARCHAR2(4);
  
  BEGIN
  
    SELECT Suprating
      INTO Retval
      FROM (SELECT Brkey,
                   Suprating,
                   Row_Number() Over(ORDER BY Brkey, Inspdate DESC) Rnm
              FROM Inspevnt
             WHERE Brkey = v_Brkey)
     WHERE Rnm = v_Rownum;
  
    RETURN Retval;
  
  END f_Get_Bif_Suprate;
  -------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Subrate(v_Brkey  Inspevnt.Brkey%TYPE,
                             v_Rownum IN VARCHAR2) RETURN VARCHAR2 AS
    Retval VARCHAR2(4);
  
  BEGIN
  
    SELECT Subrating
      INTO Retval
      FROM (SELECT Brkey,
                   Subrating,
                   Row_Number() Over(ORDER BY Brkey, Inspdate DESC) Rnm
              FROM Inspevnt
             WHERE Brkey = v_Brkey)
     WHERE Rnm = v_Rownum;
  
    RETURN Retval;
  
  END f_Get_Bif_Subrate;
  --------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Culvrate(v_Brkey  Inspevnt.Brkey%TYPE,
                              v_Rownum IN VARCHAR2) RETURN VARCHAR2 AS
    Retval VARCHAR2(4);
  
  BEGIN
  
    SELECT Culvrating
      INTO Retval
      FROM (SELECT Brkey,
                   Culvrating,
                   Row_Number() Over(ORDER BY Brkey, Inspdate DESC) Rnm
              FROM Inspevnt
             WHERE Brkey = v_Brkey)
     WHERE Rnm = v_Rownum;
  
    RETURN Retval;
  
  END f_Get_Bif_Culvrate;
  ---------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Appralign(v_Brkey  Inspevnt.Brkey%TYPE,
                               v_Rownum IN VARCHAR2) RETURN VARCHAR2 AS
    Retval VARCHAR2(4);
  
  BEGIN
  
    SELECT Appralign
      INTO Retval
      FROM (SELECT Brkey,
                   Appralign,
                   Row_Number() Over(ORDER BY Brkey, Inspdate DESC) Rnm
              FROM Inspevnt
             WHERE Brkey = v_Brkey)
     WHERE Rnm = v_Rownum;
  
    RETURN Retval;
  
  END f_Get_Bif_Appralign;
  ----------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Chanrating(v_Brkey  Inspevnt.Brkey%TYPE,
                                v_Rownum IN VARCHAR2) RETURN VARCHAR2 AS
    Retval VARCHAR2(4);
  
  BEGIN
  
    SELECT Chanrating
      INTO Retval
      FROM (SELECT Brkey,
                   Chanrating,
                   Row_Number() Over(ORDER BY Brkey, Inspdate DESC) Rnm
              FROM Inspevnt
             WHERE Brkey = v_Brkey)
     WHERE Rnm = v_Rownum;
  
    RETURN Retval;
  
  END f_Get_Bif_Chanrating;
  ----------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Wateradeq(v_Brkey  Inspevnt.Brkey%TYPE,
                               v_Rownum IN VARCHAR2) RETURN VARCHAR2 AS
    Retval VARCHAR2(4);
  
  BEGIN
  
    SELECT Wateradeq
      INTO Retval
      FROM (SELECT Brkey,
                   Wateradeq,
                   Row_Number() Over(ORDER BY Brkey, Inspdate DESC) Rnm
              FROM Inspevnt
             WHERE Brkey = v_Brkey)
     WHERE Rnm = v_Rownum;
  
    RETURN Retval;
  
  END f_Get_Bif_Wateradeq;
  -----------------------------------------------------------------------------------------------------------

  FUNCTION f_Get_Bif_Bromsprjs(v_Brkey       Mv_Broms_Query.Brkey%TYPE,
                               Columnname_In VARCHAR2) RETURN VARCHAR2 IS
    Retval    VARCHAR2(2000);
    Sqlstring VARCHAR2(8000);
    Quote     CHAR(1) := Chr(39); -- uses ASCII code for single quote which is CHR(39)
  
  BEGIN
  
    Sqlstring := 'select ltrim(substr(replace(sys_connect_by_path(' ||
                 Columnname_In || ', ' || Quote || '*' || Quote || '),' ||
                 Quote || '*' || Quote || ', ' || 'CHR(13)' ||
                 '   ),  2 ) ) ' || ' from (select distinct ' ||
                 Columnname_In || ',
                            brkey,
                            count(*) over(partition by brkey) cnt,
                            row_number() over(partition by brkey order by progyear' ||
                 ' ) seq ' || ' from pontis.mv_broms_query) ' ||
                 ' where seq = cnt ' || ' and brkey = :br ' ||
                --  ' and in_depth_completed_ind <> ' || quote || 'Y' || quote ||
                 ' start with seq = 1 ' ||
                 ' connect by prior seq + 1 = seq ' ||
                 ' and prior brkey = brkey ';
  
    EXECUTE IMMEDIATE Sqlstring
      INTO Retval
      USING v_Brkey;
  
    RETURN Retval;
  
  EXCEPTION
    WHEN No_Data_Found THEN
      RETURN NULL;
    
    WHEN OTHERS THEN
      RAISE;
    
  END f_Get_Bif_Bromsprjs;
  --------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Inspecdate(v_Brkey       Inspevnt.Brkey%TYPE,
                                Tablename_In  VARCHAR2,
                                Columnname_In VARCHAR2) RETURN VARCHAR2 IS
    Retval    VARCHAR2(20);
    Sqlstring VARCHAR2(8000);
    Quote     CHAR(1) := Chr(39);
  
  BEGIN
  
    -- create a big sql string which will dynamically include the tablename and column name you have passed.
  
    Sqlstring := 'select to_char( ' || Tablename_In || '.' || Columnname_In ||
                 ' , ' || Quote || 'dd/mm/yyyy' || Quote || ')' ||
                 ' from userinsp , inspevnt , mv_latest_inspection ' ||
                 ' where userinsp.brkey = :br ' ||
                 ' and mv_latest_inspection.brkey = userinsp.brkey ' ||
                 ' and inspevnt.brkey = userinsp.brkey ' ||
                 ' and userinsp.inspkey = mv_latest_inspection.inspkey ' ||
                 ' and inspevnt.inspkey = mv_latest_inspection.inspkey ';
  
    -- execute the dynamic SQL string - supply v_brkey as bind variable :br 
    -- return result into retval
  
    EXECUTE IMMEDIATE Sqlstring
      INTO Retval
      USING v_Brkey; --see :br above
  
    RETURN Retval;
  
  EXCEPTION
    WHEN No_Data_Found THEN
      --- sql did not find any data, so return a NULL
      RETURN NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.
  
  END f_Get_Bif_Inspecdate;
  ------------------------------------------------------------------------------------------------------

  FUNCTION f_Get_Bif_Brdgdata(v_Brkey       Bridge.Brkey%TYPE,
                              Tablename_In  VARCHAR2,
                              Columnname_In VARCHAR2) RETURN VARCHAR2 IS
    Retval    VARCHAR2(2000);
    Sqlstring VARCHAR2(8000);
  
  BEGIN
  
    -- create a big sql string which will dynamically include the tablename and column name you have passed.
  
    Sqlstring := 'select ' || Columnname_In || ' from ' || Tablename_In ||
                 ' where ' || Tablename_In || '.' || 'brkey  = :br ';
  
    -- execute the dynamic SQL string - supply v_brkey as bind variable :br
    -- return result into retval
  
    EXECUTE IMMEDIATE Sqlstring
      INTO Retval
      USING v_Brkey; --see :br above
  
    RETURN Retval;
  
  EXCEPTION
    WHEN No_Data_Found THEN
      --- sql did not find any data, so return a NULL
      RETURN NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.
  
  END f_Get_Bif_Brdgdata;
  ------------------------------------------------------------------------------------------------------------------
  FUNCTION f_Get_Bif_Kta_No(v_Brkey Userbrdg.Brkey%TYPE) RETURN VARCHAR2 IS
    Retval VARCHAR2(30);
  
  BEGIN
  
    SELECT 'KTA No:  ' || Nvl(Kta_No, '0') || '  ' || Kta_Id
      INTO Retval
      FROM Userbrdg
     WHERE Brkey = v_Brkey;
  
    RETURN Retval;
  END f_Get_Bif_Kta_No;
  ---------------------------------------------------------------------------------------------------------------------

END Bif;
/