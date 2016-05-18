CREATE OR REPLACE function pontis.f_meters_to_feet(UNITSIN IN NUMBER) RETURN VARCHAR2 IS
  
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
      retval := '*';
    else
    
      if round(mod(retvalfeet, 12), 0) = 12 then
        retval := trim(to_char(trunc(retvalfeet / 12, 0) + 1) || feetsymbol);
      else
        retval := trim(to_char(trunc(retvalfeet / 12, 0) || feetsymbol));
        --    retval := retval || ' ' || feetsymbol;
      end if;
    
      if round(mod(retvalinches, 12), 0) = 12 then
        retval := lpad(trim(retval || ' 0' || inchessymbol),22);
      else
        retval := lpad(trim(retval || lpad(to_char(round(mod(retvalinches, 12), 0)),2) ||
                  inchessymbol),22);
      end if;
    
    end if;
    RETURN retval;
  
  end f_meters_to_feet;

 
/