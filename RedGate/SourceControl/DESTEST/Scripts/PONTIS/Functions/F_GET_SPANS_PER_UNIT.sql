CREATE OR REPLACE function pontis.f_get_spans_per_unit(v_brkey userstrunit.brkey%type,v_strunitkey userstrunit.strunitkey%type) return number is
  retval number;


begin
  

select (nvl(num_spans_grp_1,0)+nvl(num_spans_grp_2,0)+nvl(num_spans_grp_3,0)+nvl(num_spans_grp_4,0)+nvl(num_spans_grp_5,0)
                +nvl(num_spans_grp_6,0)+nvl(num_spans_grp_7,0)+nvl(num_spans_grp_8,0)+nvl(num_spans_grp_9,0)+nvl(num_spans_grp_10,0)) as totalspans
        into retval        
        from userstrunit u
        where u.brkey = v_brkey and
        u.strunitkey = v_strunitkey;

return retval;



 
end f_get_spans_per_unit;

 
/