CREATE OR REPLACE procedure pontis.qry_upd_clear_strings is
begin

/*
---This is a procedure to update the table bif_clearances strings, used by BIF for the clearances piece.  IMP...make sure the mv_bif_underclearances refresh job includes
---a call to this procedure within it's job screen so that when "mv_bif_underclearances" updates, so does the table "bif_clearances_strings"

drop table bif_clearances_strings;

create table BIF_CLEARANCES_STRINGS
(
  brkey            VARCHAR2(15),
  directionstr     VARCHAR2(2000),
  roadcrossnamestr VARCHAR2(2000),
  vclrstr          VARCHAR2(2000),
  hclrstr          VARCHAR2(2000),
  hclrurtstr       VARCHAR2(2000),
  hclrultstr       VARCHAR2(2000),
  signedstr        VARCHAR2(2000),
  vc_date          Varchar2(2000)
)
*/

delete from bif_clearances_strings;
commit;

insert into bif_clearances_strings(brkey)(select brkey
 from  bridge b
 where b.district <> '9');
 commit;

declare

---create deck element string data
cursor c1 is
select brkey,
ltrim(substr(replace(sys_connect_by_path(direction,'*'),'*',CHR(13) ),2 ) )
                 as direction
                  from (select distinct direction ,
                            brkey,
                            count(*) over(partition by brkey) cnt,
                            row_number() over(partition by brkey order by brkey, on_under,sortorder ) seq
                             from mv_bif_underclearances )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey;
 cursor c2 is
select brkey,
ltrim(substr(replace(sys_connect_by_path(roadcrossname,'*'),'*',CHR(13) ),2 ) )
                 as roadcrossname
                  from (select distinct roadcrossname ,
                            brkey,
                            count(*) over(partition by brkey) cnt,
                            row_number() over(partition by brkey order by brkey, on_under,sortorder ) seq
                             from mv_bif_underclearances )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey;

 cursor c3 is
select brkey,
ltrim(substr(replace(sys_connect_by_path(vclr,'*'),'*',CHR(13) ),2 ) )
                 as vclr
                  from (select distinct vclr ,
                            brkey,
                            count(*) over(partition by brkey) cnt,
                            row_number() over(partition by brkey order by brkey, on_under,sortorder ) seq
                             from mv_bif_underclearances )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey;

 cursor c4 is
select brkey,
ltrim(substr(replace(sys_connect_by_path(hclr,'*'),'*',CHR(13) ),2 ) )
                 as hclr
                  from (select distinct hclr ,
                            brkey,
                            count(*) over(partition by brkey) cnt,
                            row_number() over(partition by brkey order by brkey, on_under,sortorder ) seq
                             from mv_bif_underclearances )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey;

cursor c5 is
select brkey,
ltrim(substr(replace(sys_connect_by_path(hclrurt,'*'),'*',CHR(13) ),2 ) )
                 as hclrurt
                  from (select distinct hclrurt ,
                            brkey,
                            count(*) over(partition by brkey) cnt,
                            row_number() over(partition by brkey order by brkey, on_under,sortorder ) seq
                             from mv_bif_underclearances )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey;
 cursor c6 is
select brkey,
ltrim(substr(replace(sys_connect_by_path(hclrult,'*'),'*',CHR(13) ),2 ) )
                 as hclrult
                  from (select distinct hclrult ,
                            brkey,
                            count(*) over(partition by brkey) cnt,
                            row_number() over(partition by brkey order by brkey, on_under,sortorder ) seq
                             from mv_bif_underclearances )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey;
 cursor c7 is
select brkey,
ltrim(substr(replace(sys_connect_by_path(signed,'*'),'*',CHR(13) ),2 ) )
                 as signed
                  from (select distinct signed ,
                            brkey,
                            count(*) over(partition by brkey) cnt,
                            row_number() over(partition by brkey order by brkey, on_under,sortorder ) seq
                             from mv_bif_underclearances )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey;

cursor c8 is
select brkey,
ltrim(substr(replace(sys_connect_by_path(to_char(vc_date,'mm/dd/yyyy'),'*'),'*',CHR(13) ),2 ) )
                 as vc_date
                  from (select distinct vc_date ,
                            brkey,
                            count(*) over(partition by brkey) cnt,
                            row_number() over(partition by brkey order by brkey, on_under,sortorder ) seq
                             from mv_bif_underclearances 
                             where vc_date > '01/jan/1901' )
                    where seq = cnt
                    start with seq = 1
                   connect by prior seq + 1 = seq
                        and prior brkey = brkey;




----begin updates

result varchar2(2000);

begin

---update underclearances string data fields

for c1rec in c1 loop

result := c1rec.direction;

update bif_clearances_strings s
set directionstr = result
where s.brkey = c1rec.brkey ;
commit;
end loop;

for c2rec in c2 loop

result := c2rec.roadcrossname;

update bif_clearances_strings s
set roadcrossnamestr = result
where s.brkey = c2rec.brkey ;
commit;
end loop;

for c3rec in c3 loop

result := c3rec.vclr;

update bif_clearances_strings s
set vclrstr = result
where s.brkey = c3rec.brkey ;
commit;
end loop;

for c4rec in c4 loop

result := c4rec.hclr;

update bif_clearances_strings s
set hclrstr = result
where s.brkey = c4rec.brkey ;
commit;
end loop;

for c5rec in c5 loop

result := c5rec.hclrurt;

update bif_clearances_strings s
set hclrurtstr = result
where s.brkey = c5rec.brkey ;
commit;
end loop;

for c6rec in c6 loop

result := c6rec.hclrult;

update bif_clearances_strings s
set hclrultstr = result
where s.brkey = c6rec.brkey ;
commit;
end loop;

for c7rec in c7 loop

result := c7rec.signed;

update bif_clearances_strings s
set signedstr = result
where s.brkey = c7rec.brkey ;
commit;
end loop;

for c8rec in c8 loop

result := c8rec.vc_date;

update bif_clearances_strings s
set vc_datestr = result
where s.brkey = c8rec.brkey ;
commit;
end loop;


end;
end;

 
/