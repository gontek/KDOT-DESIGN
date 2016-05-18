CREATE OR REPLACE function pontis.f_get_nbi_64_66(v_brkey userbrdg.brkey%type,
                                           v_adj_h userbrdg.irload_adj_h%type,
                                           v_lfd_h userbrdg.irload_adj_h%type,
                                           v_wsd_h userbrdg.irload_adj_h%type)
                              return number is
    retval number;
    v_fill varchar2(2);
    v_adj number;
    v_lfd number;
    v_wsd number;

  begin

    select v_adj_h,v_lfd_h,v_wsd_h
      into v_adj, v_lfd, v_wsd
      from userbrdg u
     where u.brkey = v_brkey;


    retval := nvl(v_adj,0);

    if retval =  0 then
      retval := nvl(v_adj,0);
    end if;

    if retval = 0 then
       retval := nvl(v_lfd,0);
   end if;

    if retval = 0 then
      retval := v_wsd;
    end if;

    retval := round(retval,2);

    if retval >= 89.8 then
      retval :=  99.9;
      end if;

  select undr_suff_fill into v_fill
    from userbrdg u
    where u.brkey = v_brkey;


    if v_fill = 'Y' then
      retval := 99.9;
      end if;

    return retval;

  end f_get_nbi_64_66;
/