CREATE OR REPLACE function pontis.f_bif_meters_to_feetinches
  (UNITSIN IN NUMBER)  RETURN VARCHAR2 IS
         
   retval varchar2(2000);
   retvalfeet varchar2(2000);
   retvalinches varchar2(2000);
   feetsymbol varchar2(2);
   inchessymbol varchar2(2);
   
  
  begin
    
  retvalfeet := unitsin;
  retvalinches := unitsin;
  feetsymbol := CHR(146);
   inchessymbol := CHR(148);
  
  if ( retvalfeet is null) or
     (retvalfeet <= 0) then
      retval := ' ';
 else
 
   if round(mod(retvalfeet,12),0)= 12  then
     retval := to_char(trunc(retvalfeet/12,0)+1);
     else
       retval := to_char(trunc(retvalfeet/12,0));        
        retval := retval||' '||feetsymbol;
  end if;
    
    if round(mod(retvalinches,12),0)=12 then
      retval := retval||'0'||inchessymbol;
      else
        retval := retval||' '||to_char(round(mod(retvalinches,12),0))||inchessymbol;
       end if; 
       
 end if;
       RETURN retval;
 
 
end f_bif_meters_to_feetinches;

 
/