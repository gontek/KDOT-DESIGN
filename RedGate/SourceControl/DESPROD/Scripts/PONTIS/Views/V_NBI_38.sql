CREATE OR REPLACE FORCE VIEW pontis.v_nbi_38 (brkey,oldnavcntrol,newnavcntrol) AS
(select brkey, nvl(navcntrol,-1) as oldnavcntrol,
 nbip.f_check_nbi_38(brkey)as newnavcntrol from bridge)

 ;