CREATE OR REPLACE function pontis.f_tab_to_string(p_varchar2_tab in t_varchar2_tab,
                                         p_delimiter    in varchar2 default ',') return varchar2 is
 l_string varchar2(32767);
BEGIN
  For i IN p_varchar2_tab.First .. p_varchar2_tab.LAST LOOP
    IF i != p_varchar2_tab.FIRST THEN
      l_string := l_string || p_delimiter;
      END IF;
      l_string := l_string || p_varchar2_tab(i);
      END LOOP;
      RETURN l_string;
      END f_tab_to_string;
    

 
/