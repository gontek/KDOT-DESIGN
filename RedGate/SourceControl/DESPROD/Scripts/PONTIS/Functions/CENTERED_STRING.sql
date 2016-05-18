CREATE OR REPLACE function pontis.centered_string(string_in in varchar2, length_in in integer)
    return varchar2 is

    len_string integer := length(string_in);
    begin
      if len_string is null or length_in <= 0 then
        return null;
        else
          return rpad(' ', (length_in - len_string) / 2 - 1)||LTRIM(RTRIM(string_in));
          End if;
       end ;

 
/