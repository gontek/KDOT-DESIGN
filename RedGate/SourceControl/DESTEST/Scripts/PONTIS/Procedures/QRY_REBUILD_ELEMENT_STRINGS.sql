CREATE OR REPLACE procedure pontis.qry_rebuild_element_strings is
begin

/*

drop table bif_element_strings;
create table bif_element_strings (
brkey varchar2(15),
strunitkey varchar2(4),
dkelementstr varchar2(400),
dkdescstr varchar2(400),
dkenvstr  varchar2(400),
dkqtystr  varchar2(400),
dkunitsstr  varchar2(400),
dkpct1str   varchar2(400),
dkqty1str   varchar2(400),
dkpct2str   varchar2(400),
dkqty2str   varchar2(400),
dkpct3str    varchar2(400),
dkqty3str   varchar2(400),
dkpct4str    varchar2(400),
dkqty4str    varchar2(400),
supelementstr varchar2(400),
supdescstr varchar2(400),
supenvstr  varchar2(400),
supqtystr  varchar2(400),
supunitsstr  varchar2(400),
suppct1str   varchar2(400),
supqty1str   varchar2(400),
suppct2str   varchar2(400),
supqty2str   varchar2(400),
suppct3str   varchar2(400),
suppct4str   varchar2(400),
supqty3str   varchar2(400),
supqty4str   varchar2(400),
subelementstr varchar2(400),
subdescstr varchar2(400),
subenvstr  varchar2(400),
subqtystr  varchar2(400),
subunitsstr  varchar2(400),
subpct1str   varchar2(400),
subqty1str   varchar2(400),
subpct2str   varchar2(400),
subqty2str   varchar2(400),
subpct3str   varchar2(400),
subqty3str   varchar2(400),
subpct4str   varchar2(400),
subqty4str   varchar2(400),
culvelementstr varchar2(400),
culvdescstr varchar2(400),
culvenvstr  varchar2(400),
culvqtystr  varchar2(400),
culvunitsstr  varchar2(400),
culvpct1str   varchar2(400),
culvqty1str   varchar2(400),
culvpct2str   varchar2(400),
culvqty2str   varchar2(400),
culvpct3str   varchar2(400),
culvqty3str   varchar2(400),
culvpct4str   varchar2(400),
culvqty4str   varchar2(400),
elem515descstr varchar2(400),
elem515qtystr varchar2(400),
elem515qty1str varchar2(400),
elem515qty2str varchar2(400),
elem515qty3str varchar2(400),
elem515qty4str varchar2(400),
elem515pct1str varchar2(400),
elem515pct2str varchar2(400),
elem515pct3str varchar2(400),
elem515pct4str varchar2(400)
);
*/

delete from bif_element_strings;
commit;

insert into bif_element_strings(brkey, strunitkey)(select s.brkey, strunitkey
 from structure_unit s, bridge b
 where s.brkey = b.brkey and
       b.district <> '9');
 commit;

declare

---create deck element string data
cursor c1 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(elem_key,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as dkelem
                  from (select distinct elem_key ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '1' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
 cursor c2 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(elem_shortname,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as dkelemdesc
                  from (select distinct elem_shortname ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '1' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
                       
 -- BIF not currently using...
 cursor c3 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(envkey,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as dkenvkeys
                  from (select distinct envkey ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '1' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;


 cursor c4 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(lpad(trim(qty)||' '||englishunit,12,' '),'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as dkqtystr
                  from (select distinct qty,
                            englishunit,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '1' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
                       
 -- not currently being used on BIF
cursor c5 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(englishunit,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as dkunitsstr
                  from (select distinct englishunit ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '1' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;


 cursor c6 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct1||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as dkpct1
                  from (select distinct pct1 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '1' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;

--------------

 cursor c6a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty1||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as dkqty1
                  from (select distinct qty1 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '1' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
                     

 cursor c7 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct2||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as dkpct2
                  from (select distinct pct2 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '1' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
  cursor c7a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty2||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as dkqty2
                  from (select distinct qty2 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '1' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;

 cursor c8 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct3||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as dkpct3
                  from (select distinct pct3 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '1' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
                       
 cursor c8a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty3||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as dkqty3
                  from (select distinct qty3 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '1' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;                       

 
  cursor c9 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct4||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as dkpct4
                  from (select distinct pct4 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '1' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
  cursor c9a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty4||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as dkqty4
                  from (select distinct qty4 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '1' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;                       
                       


---create super element strings data

cursor c10 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(elem_key,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as supelem
                  from (select distinct elem_key ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '2')
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
 cursor c11 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(elem_shortname,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as supelemdesc
                  from (select distinct elem_shortname ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '2')
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;

 cursor c12 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(envkey,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as supenvkeys
                  from (select distinct envkey ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '2')
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;

 cursor c13 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(lpad(trim(qty)||' '||englishunit,12,' '),'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as supqtystr
                  from (select distinct qty,
                            englishunit,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '2' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;


cursor c14 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(englishunit,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as supunitsstr
                  from (select distinct englishunit ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '2')
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;


cursor c15 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct1||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as suppct1
                  from (select distinct pct1 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '2' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
 cursor c15a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty1||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as supqty1
                  from (select distinct qty1 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '2' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;                      
 

cursor c16 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct2||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as suppct2
                  from (select distinct pct2 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '2' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
                       
cursor c16a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty2||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as supqty2
                  from (select distinct qty2 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '2' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;                       

 cursor c17 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct3||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as suppct3
                  from (select distinct pct3 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '2' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
 cursor c17a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty3||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as supqty3
                  from (select distinct qty3 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '2' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;                                            


cursor c18 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct4||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as suppct4
                  from (select distinct pct4 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '2' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;

cursor c18a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty4||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as supqty4
                  from (select distinct qty4 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '2' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;

 --create sub element string fields
cursor c19 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(elem_key,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as subelem
                  from (select distinct elem_key ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '3')
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
 cursor c20 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(elem_shortname,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as subelemdesc
                  from (select distinct elem_shortname ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '3')
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;

 cursor c21 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(envkey,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as subenvkeys
                  from (select distinct envkey ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '3')
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;

 cursor c22 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(lpad(trim(qty)||' '||englishunit,12,' '),'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as subqtystr
                  from (select distinct qty,
                            englishunit,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '3' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;

cursor c23 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(englishunit,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as subunitsstr
                  from (select distinct englishunit ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '3')
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;


  cursor c24 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct1||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as subpct1
                  from (select distinct pct1 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '3' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
   cursor c24a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty1||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as subqty1
                  from (select distinct qty1 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '3' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
                      
 cursor c25 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct2||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as subpct2
                  from (select distinct pct2 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '3' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
                       
 cursor c25a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty2||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as subqty2
                  from (select distinct qty2 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '3' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;                       


 cursor c26 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct3||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as subpct3
                  from (select distinct pct3 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '3' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
                       
 cursor c26a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty3||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as subqty3
                  from (select distinct qty3 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '3' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;                       



  cursor c27 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct4||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as subpct4
                  from (select distinct pct4 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '3' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;

  cursor c27a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty4||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as subqty4
                  from (select distinct qty4 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '3' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;


---create culvert element string data

cursor c28 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(elem_key,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as culvelem
                  from (select distinct elem_key ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '4' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
 cursor c29 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(elem_shortname,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as culvelemdesc
                  from (select distinct elem_shortname ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '4' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;

 cursor c30 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(envkey,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as culvenvkeys
                  from (select distinct envkey ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '4' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;

 cursor c31 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(lpad(trim(qty)||' '||englishunit,12,' '),'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as culvqtystr
                  from (select distinct qty,
                            englishunit,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '4' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;


cursor c32 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(englishunit,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as culvunitsstr
                  from (select distinct englishunit ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '4')
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;


 cursor c33 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct1||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as culvpct1
                  from (select distinct pct1 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '4' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
  cursor c33a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty1||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as culvqty1
                  from (select distinct qty1 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '4' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;                      
 

 cursor c34 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct2||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as culvpct2
                  from (select distinct pct2 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '4' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;

 cursor c34a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty2||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as culvqty2
                  from (select distinct qty2 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '4' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
 
                       
 cursor c35 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct3||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as culvpct3
                  from (select distinct pct3 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '4' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;

 cursor c35a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty3||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as culvqty3
                  from (select distinct qty3 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '4' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;


  cursor c36 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct4||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as culvpct4
                  from (select distinct pct4 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '4' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;
  cursor c36a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty4||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as culvqty4
                  from (select distinct qty4 ,
                            brkey,
                            strunitkey,
                            elemtype,
                            count(*) over(partition by brkey,strunitkey,elemtype) cnt,
                            row_number() over(partition by brkey,strunitkey,elemtype order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elemtype = '4' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey
                       and prior elemtype = elemtype;                       
                       
/*
cursor c37 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(elem_shortname,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem515descstr
                  from (select distinct elem_shortname ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements_500 mv where elemtype = '2' and qty is not null  )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey;

cursor c38 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(lpad(trim(qty)||' '||englishunit,12,' '),'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem515qtystr
                  from (select distinct qty ,
                            englishunit,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements_500 mv where elemtype = '2' and qty is not null  )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey;

cursor c39 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(englishunit,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem515unitsstr
                  from (select distinct englishunit ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements_500 mv where elemtype = '2'  )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey;
 

cursor c39 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(elem_shortname,'*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem510descstr
                  from (select distinct elem_shortname ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements_500 mv where elemtype = '1' and qty is not null  )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey;
/*/

cursor c40 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty1||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem515qty1str
                  from (select distinct qty1 ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv   )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey;

cursor c41 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty2||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem515qty2str
                  from (select distinct qty2 ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey;
                        
cursor c42 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty3||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem515qty3str
                  from (select distinct qty3 ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv   )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey; 
 cursor c43 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty4||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem515qty4str
                  from (select distinct qty4 ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv  )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey;
 
 cursor c43a is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct2||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem515pct2str
                  from (select distinct pct2 ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elem_key = '515' and pct2 is not null  )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey;
 cursor c43b is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct3||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem515pct3str
                  from (select distinct pct3 ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elem_key = '515' and pct3 is not null  )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey;
                        
 cursor c43c is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct4||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem515pct4str
                  from (select distinct pct4 ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elem_key = '515' and pct4 is not null  )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey;  
                        
  cursor c43d is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(pct1||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem515pct1str
                  from (select distinct pct1 ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements mv where elem_key = '515' and pct1 is not null  )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey;                                 
                                              

 /*-- made these part of the strings for the deck elements---don't need them separately anymore                    
                        
 cursor c44 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty1||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem510qty1str
                  from (select distinct qty1 ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements_500 mv where elemtype = '1' and qty is not null  )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey;

cursor c45 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty2||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem510qty2str
                  from (select distinct qty2 ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements_500 mv where elemtype = '1' and qty is not null  )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey;
                        
cursor c46 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty3||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem510qty3str
                  from (select distinct qty3 ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements_500 mv where elemtype = '1'  and qty is not null )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey; 
 cursor c47 is
select brkey, strunitkey,
ltrim(substr(replace(sys_connect_by_path(qty4||'____','*'),'*',CHR(13)||CHR(13) ),2 ) )
                 as elem510qty4str
                  from (select distinct qty4 ,
                            brkey,
                            strunitkey,
                             count(*) over(partition by brkey,strunitkey) cnt,
                            row_number() over(partition by brkey,strunitkey order by brkey, strunitkey,elem_key ) seq
                             from mv_bif_data_elements_500 mv where elemtype = '1' and qty is not null )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey
                        and prior strunitkey = strunitkey;                                                   
                                               
*/

----begin updates

result varchar2(200);

begin

---update deck element string data
for c1rec in c1 loop

result := c1rec.dkelem;

update bif_element_strings s
set dkelementstr = result
where s.brkey = c1rec.brkey and
      s.strunitkey = c1rec.strunitkey;

commit;
end loop;

for c2rec in c2 loop

result := c2rec.dkelemdesc;

update bif_element_strings s
set dkdescstr = result
where s.brkey = c2rec.brkey and
s.strunitkey = c2rec.strunitkey;
commit;
end loop;


for c3rec in c3 loop

result := c3rec.dkenvkeys;

update bif_element_strings s
set dkenvstr = result
where s.brkey = c3rec.brkey and
s.strunitkey = c3rec.strunitkey;
commit;
end loop;

for c4rec in c4 loop

result := c4rec.dkqtystr;

update bif_element_strings s
set dkqtystr = result
where s.brkey = c4rec.brkey and
s.strunitkey = c4rec.strunitkey;
commit;
end loop;

for c5rec in c5 loop

result := c5rec.dkunitsstr;

update bif_element_strings s
set dkunitsstr = result
where s.brkey = c5rec.brkey and
s.strunitkey = c5rec.strunitkey;
commit;
end loop;


for c6rec in c6 loop

result := c6rec.dkpct1;

update bif_element_strings s
set dkpct1str = result
where s.brkey = c6rec.brkey and
s.strunitkey = c6rec.strunitkey;
commit;
end loop;

for c6arec in c6a loop

result := c6arec.dkqty1;

update bif_element_strings s
set dkqty1str = result
where s.brkey = c6arec.brkey and
s.strunitkey = c6arec.strunitkey;
commit;
end loop;

for c7rec in c7 loop

result := c7rec.dkpct2;

update bif_element_strings s
set dkpct2str = result
where s.brkey = c7rec.brkey and
s.strunitkey = c7rec.strunitkey;
commit;
end loop;


for c7arec in c7a loop

result := c7arec.dkqty2;

update bif_element_strings s
set dkqty2str = result
where s.brkey = c7arec.brkey and
s.strunitkey = c7arec.strunitkey;
commit;
end loop;


for c8rec in c8 loop

result := c8rec.dkpct3;

update bif_element_strings s
set dkpct3str = result
where s.brkey = c8rec.brkey and
s.strunitkey = c8rec.strunitkey;
commit;
end loop;

for c8arec in c8a loop

result := c8arec.dkqty3;

update bif_element_strings s
set dkqty3str = result
where s.brkey = c8arec.brkey and
s.strunitkey = c8arec.strunitkey;
commit;
end loop;


for c9rec in c9 loop

result := c9rec.dkpct4;

update bif_element_strings s
set dkpct4str = result
where s.brkey = c9rec.brkey and
s.strunitkey = c9rec.strunitkey;
commit;
end loop;

for c9arec in c9a loop

result := c9arec.dkqty4;

update bif_element_strings s
set dkqty4str = result
where s.brkey = c9arec.brkey and
s.strunitkey = c9arec.strunitkey;
commit;
end loop;


---update super element string data
for c10rec in c10 loop

result := c10rec.supelem;

update bif_element_strings s
set supelementstr = result
where s.brkey = c10rec.brkey and
      s.strunitkey = c10rec.strunitkey;

commit;
end loop;

for c11rec in c11 loop

result := c11rec.supelemdesc;

update bif_element_strings s
set supdescstr = result
where s.brkey = c11rec.brkey and
s.strunitkey = c11rec.strunitkey;
commit;
end loop;


for c12rec in c12 loop

result := c12rec.supenvkeys;

update bif_element_strings s
set supenvstr = result
where s.brkey = c12rec.brkey and
s.strunitkey = c12rec.strunitkey;
commit;
end loop;

for c13rec in c13 loop

result := c13rec.supqtystr;

update bif_element_strings s
set supqtystr = result
where s.brkey = c13rec.brkey and
s.strunitkey = c13rec.strunitkey;
commit;
end loop;

for c14rec in c14 loop

result := c14rec.supunitsstr;

update bif_element_strings s
set supunitsstr = result
where s.brkey = c14rec.brkey and
s.strunitkey = c14rec.strunitkey;
commit;
end loop;


for c15rec in c15 loop

result := c15rec.suppct1;

update bif_element_strings s
set suppct1str = result
where s.brkey = c15rec.brkey and
s.strunitkey = c15rec.strunitkey;
commit;
end loop;

for c15arec in c15a loop

result := c15arec.supqty1;

update bif_element_strings s
set supqty1str = result
where s.brkey = c15arec.brkey and
s.strunitkey = c15arec.strunitkey;
commit;
end loop;



for c16rec in c16 loop

result := c16rec.suppct2;

update bif_element_strings s
set suppct2str = result
where s.brkey = c16rec.brkey and
s.strunitkey = c16rec.strunitkey;
commit;
end loop;

for c16arec in c16a loop

result := c16arec.supqty2;

update bif_element_strings s
set supqty2str = result
where s.brkey = c16arec.brkey and
s.strunitkey = c16arec.strunitkey;
commit;
end loop;


for c17rec in c17 loop

result := c17rec.suppct3;

update bif_element_strings s
set suppct3str = result
where s.brkey = c17rec.brkey and
s.strunitkey = c17rec.strunitkey;
commit;
end loop;

for c17arec in c17a loop

result := c17arec.supqty3;

update bif_element_strings s
set supqty3str = result
where s.brkey = c17arec.brkey and
s.strunitkey = c17arec.strunitkey;
commit;
end loop;


for c18rec in c18 loop

result := c18rec.suppct4;

update bif_element_strings s
set suppct4str = result
where s.brkey = c18rec.brkey and
s.strunitkey = c18rec.strunitkey;
commit;
end loop;

for c18arec in c18a loop

result := c18arec.supqty4;

update bif_element_strings s
set supqty4str = result
where s.brkey = c18arec.brkey and
s.strunitkey = c18arec.strunitkey;
commit;
end loop;


--update sub element string data

for c19rec in c19 loop

result := c19rec.subelem;

update bif_element_strings s
set subelementstr = result
where s.brkey = c19rec.brkey and
      s.strunitkey = c19rec.strunitkey;

commit;
end loop;

for c20rec in c20 loop

result := c20rec.subelemdesc;

update bif_element_strings s
set subdescstr = result
where s.brkey = c20rec.brkey and
s.strunitkey = c20rec.strunitkey;
commit;
end loop;


for c21rec in c21 loop

result := c21rec.subenvkeys;

update bif_element_strings s
set subenvstr = result
where s.brkey = c21rec.brkey and
s.strunitkey = c21rec.strunitkey;
commit;
end loop;

for c22rec in c22 loop

result := c22rec.subqtystr;

update bif_element_strings s
set subqtystr = result
where s.brkey = c22rec.brkey and
s.strunitkey = c22rec.strunitkey;
commit;
end loop;

for c23rec in c23 loop

result := c23rec.subunitsstr;

update bif_element_strings s
set subunitsstr = result
where s.brkey = c23rec.brkey and
s.strunitkey = c23rec.strunitkey;
commit;
end loop;


for c24rec in c24 loop

result := c24rec.subpct1;

update bif_element_strings s
set subpct1str = result
where s.brkey = c24rec.brkey and
s.strunitkey = c24rec.strunitkey;
commit;
end loop;

for c24arec in c24a loop

result := c24arec.subqty1;

update bif_element_strings s
set subqty1str = result
where s.brkey = c24arec.brkey and
s.strunitkey = c24arec.strunitkey;
commit;
end loop;



for c25rec in c25 loop

result := c25rec.subpct2;

update bif_element_strings s
set subpct2str = result
where s.brkey = c25rec.brkey and
s.strunitkey = c25rec.strunitkey;
commit;
end loop;

for c25arec in c25a loop

result := c25arec.subqty2;

update bif_element_strings s
set subqty2str = result
where s.brkey = c25arec.brkey and
s.strunitkey = c25arec.strunitkey;
commit;
end loop;

for c26rec in c26 loop

result := c26rec.subpct3;

update bif_element_strings s
set subpct3str = result
where s.brkey = c26rec.brkey and
s.strunitkey = c26rec.strunitkey;
commit;
end loop;

for c26arec in c26a loop

result := c26arec.subqty3;

update bif_element_strings s
set subqty3str = result
where s.brkey = c26arec.brkey and
s.strunitkey = c26arec.strunitkey;
commit;
end loop;


for c27rec in c27 loop

result := c27rec.subpct4;

update bif_element_strings s
set subpct4str = result
where s.brkey = c27rec.brkey and
s.strunitkey = c27rec.strunitkey;
commit;
end loop;

for c27arec in c27a loop

result := c27arec.subqty4;

update bif_element_strings s
set subqty4str = result
where s.brkey = c27arec.brkey and
s.strunitkey = c27arec.strunitkey;
commit;
end loop;


--update culv element string data

for c28rec in c28 loop

result := c28rec.culvelem;

update bif_element_strings s
set culvelementstr = result
where s.brkey = c28rec.brkey and
      s.strunitkey = c28rec.strunitkey;

commit;
end loop;

for c29rec in c29 loop

result := c29rec.culvelemdesc;

update bif_element_strings s
set culvdescstr = result
where s.brkey = c29rec.brkey and
s.strunitkey = c29rec.strunitkey;
commit;
end loop;


for c30rec in c30 loop

result := c30rec.culvenvkeys;

update bif_element_strings s
set culvenvstr = result
where s.brkey = c30rec.brkey and
s.strunitkey = c30rec.strunitkey;
commit;
end loop;

for c31rec in c31 loop

result := c31rec.culvqtystr;

update bif_element_strings s
set culvqtystr = result
where s.brkey = c31rec.brkey and
s.strunitkey = c31rec.strunitkey;
commit;
end loop;

for c32rec in c32 loop

result := c32rec.culvunitsstr;

update bif_element_strings s
set culvunitsstr = result
where s.brkey = c32rec.brkey and
s.strunitkey = c32rec.strunitkey;
commit;
end loop;


for c33rec in c33 loop

result := c33rec.culvpct1;

update bif_element_strings s
set culvpct1str = result
where s.brkey = c33rec.brkey and
s.strunitkey = c33rec.strunitkey;
commit;
end loop;

for c33arec in c33a loop

result := c33arec.culvqty1;

update bif_element_strings s
set culvqty1str = result
where s.brkey = c33arec.brkey and
s.strunitkey = c33arec.strunitkey;
commit;
end loop;

for c34rec in c34 loop

result := c34rec.culvpct2;

update bif_element_strings s
set culvpct2str = result
where s.brkey = c34rec.brkey and
s.strunitkey = c34rec.strunitkey;
commit;
end loop;

for c34arec in c34a loop

result := c34arec.culvqty2;

update bif_element_strings s
set culvqty2str = result
where s.brkey = c34arec.brkey and
s.strunitkey = c34arec.strunitkey;
commit;
end loop;


for c35rec in c35 loop

result := c35rec.culvpct3;

update bif_element_strings s
set culvpct3str = result
where s.brkey = c35rec.brkey and
s.strunitkey = c35rec.strunitkey;
commit;
end loop;

for c35arec in c35a loop

result := c35arec.culvqty3;

update bif_element_strings s
set culvqty3str = result
where s.brkey = c35arec.brkey and
s.strunitkey = c35arec.strunitkey;
commit;
end loop;


for c36rec in c36 loop

result := c36rec.culvpct4;

update bif_element_strings s
set culvpct4str = result
where s.brkey = c36rec.brkey and
s.strunitkey = c36rec.strunitkey;
commit;
end loop;

for c36arec in c36a loop

result := c36arec.culvqty4;

update bif_element_strings s
set culvqty4str = result
where s.brkey = c36arec.brkey and
s.strunitkey = c36arec.strunitkey;
commit;
end loop;

/*
for c37rec in c37 loop
  
result :=c37rec.elem515descstr;

update bif_element_strings s
set elem515descstr = result
where s.brkey = c37rec.brkey and
s.strunitkey = c37rec.strunitkey;
commit;
end loop;

for c38rec in c38 loop
  
result :=c38rec.elem515qtystr;

update bif_element_strings s
set elem515qtystr = result
where s.brkey = c38rec.brkey and
s.strunitkey = c38rec.strunitkey;
commit;
end loop;


for c39rec in c39 loop
  
result :=c39rec.elem510descstr;

update bif_element_strings s
set elem510descstr = result
where s.brkey = c39rec.brkey and
s.strunitkey = c39rec.strunitkey;
commit;
end loop;
*/
for c40rec in c40 loop
  
result :=c40rec.elem515qty1str;

update bif_element_strings s
set elem515qty1str = result
where s.brkey = c40rec.brkey and
s.strunitkey = c40rec.strunitkey;
commit;
end loop;


for c41rec in c41 loop
  
result :=c41rec.elem515qty2str;

update bif_element_strings s
set elem515qty2str = result
where s.brkey = c41rec.brkey and
s.strunitkey = c41rec.strunitkey;
commit;
end loop;

for c42rec in c42 loop
  
result :=c42rec.elem515qty3str;

update bif_element_strings s
set elem515qty3str = result
where s.brkey = c42rec.brkey and
s.strunitkey = c42rec.strunitkey;
commit;
end loop;

for c43rec in c43 loop
  
result :=c43rec.elem515qty4str;

update bif_element_strings s
set elem515qty4str = result
where s.brkey = c43rec.brkey and
s.strunitkey = c43rec.strunitkey;
commit;
end loop;

for c43arec in c43a loop
  
result :=c43arec.elem515pct2str;

update bif_element_strings s
set elem515pct2str = result
where s.brkey = c43arec.brkey and
s.strunitkey = c43arec.strunitkey;
commit;
end loop;

for c43brec in c43b loop
  
result :=c43brec.elem515pct3str;

update bif_element_strings s
set elem515pct3str = result
where s.brkey = c43brec.brkey and
s.strunitkey = c43brec.strunitkey;
commit;
end loop;

for c43crec in c43c loop
  
result :=c43crec.elem515pct4str;

update bif_element_strings s
set elem515pct4str = result
where s.brkey = c43crec.brkey and
s.strunitkey = c43crec.strunitkey;
commit;
end loop;

for c43drec in c43d loop
  
result :=c43drec.elem515pct1str;

update bif_element_strings s
set elem515pct1str = result
where s.brkey = c43drec.brkey and
s.strunitkey = c43drec.strunitkey;
commit;
end loop;


/*

for c44rec in c44 loop
  
result :=c44rec.elem510qty1str;

update bif_element_strings s
set elem510qty1str = result
where s.brkey = c44rec.brkey and
s.strunitkey = c44rec.strunitkey;
commit;
end loop;


for c45rec in c45 loop
  
result :=c45rec.elem510qty2str;

update bif_element_strings s
set elem510qty2str = result
where s.brkey = c45rec.brkey and
s.strunitkey = c45rec.strunitkey;
commit;
end loop;

for c46rec in c46 loop
  
result :=c46rec.elem510qty3str;

update bif_element_strings s
set elem510qty3str = result
where s.brkey = c46rec.brkey and
s.strunitkey = c46rec.strunitkey;
commit;
end loop;

for c47rec in c47 loop
  
result :=c47rec.elem510qty4str;

update bif_element_strings s
set elem510qty4str = result
where s.brkey = c47rec.brkey and
s.strunitkey = c47rec.strunitkey;
commit;
end loop;

*/


end;
end;
/