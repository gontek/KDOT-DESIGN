CREATE OR REPLACE FORCE VIEW pontis.v_structurelog_units (brkey,unit_1,unit_2,unit_3,unit_4,unit_5,unit_6,unit_7,unit_8,unit_9,unit_10,unit_11,unit_12,unit_13,unit_14,unit_15,unit_16,unit_17,unit_18,unit_19,unit_20,unit_21,unit_22,unit_23,unit_24,unit_25,unit_26,unit_27,unit_28,unit_29,unit_30,unit_31,unit_32,unit_33,unit_34,unit_35,unit_36,unit_37,unit_38) AS
select brkey,

CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '1')
    then 'UNIT 1:  '||f_structuretype(b.brkey, '1')||'  '||f_spangroups(b.brkey,'1')
      else ''
        end UNIT_1
,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '2')
    then 'UNIT 2:  '||f_structuretype(b.brkey, '2')||'  '||f_spangroups(b.brkey,'2')
      else ''
        end UNIT_2
,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '3')
    then 'UNIT 3:  '||f_structuretype(b.brkey, '3')||'  '||f_spangroups(b.brkey,'3')
      else ''
        end UNIT_3
,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '4')
    then 'UNIT 4:  '||f_structuretype(b.brkey, '4')||'  '||f_spangroups(b.brkey,'4')
      else ''
        end UNIT_4
,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '5')
    then 'UNIT 5:  '||f_structuretype(b.brkey, '5')||'  '||f_spangroups(b.brkey,'5')
      else ''
        end UNIT_5
,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '6')
    then 'UNIT 6:  '||f_structuretype(b.brkey, '6')||'  '||f_spangroups(b.brkey,'6')
      else ''
        end UNIT_6
,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '7')
    then 'UNIT 7:  '||f_structuretype(b.brkey, '7')||'  '||f_spangroups(b.brkey,'7')
      else ''
        end UNIT_7
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '8')
    then 'UNIT 8:  '||f_structuretype(b.brkey, '8')||'  '||f_spangroups(b.brkey,'8')
      else ''
        end UNIT_8
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '9')
    then 'UNIT 9:  '||f_structuretype(b.brkey, '9')||'  '||f_spangroups(b.brkey,'9')
      else ''
        end UNIT_9
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '10')
    then 'UNIT 10:  '||f_structuretype(b.brkey, '10')||'  '||f_spangroups(b.brkey,'10')
      else ''
        end UNIT_10
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '11')
    then 'UNIT 11:  '||f_structuretype(b.brkey, '11')||'  '||f_spangroups(b.brkey,'11')
      else ''
        end UNIT_11
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '12')
    then 'UNIT 12:  '||f_structuretype(b.brkey, '12')||'  '||f_spangroups(b.brkey,'12')
      else ''
        end UNIT_12
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '13')
    then 'UNIT 13:  '||f_structuretype(b.brkey, '13')||'  '||f_spangroups(b.brkey,'13')
      else ''
        end UNIT_13
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '14')
    then 'UNIT 14:  '||f_structuretype(b.brkey, '14')||'  '||f_spangroups(b.brkey,'14')
      else ''
        end UNIT_14
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '15')
    then 'UNIT 15:  '||f_structuretype(b.brkey, '15')||'  '||f_spangroups(b.brkey,'15')
      else ''
        end UNIT_15
,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '16')
    then 'UNIT 16:  '||f_structuretype(b.brkey, '16')||'  '||f_spangroups(b.brkey,'16')
      else ''
        end UNIT_16
,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '17')
    then 'UNIT 17:  '||f_structuretype(b.brkey, '17')||'  '||f_spangroups(b.brkey,'17')
      else ''
        end UNIT_17
,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '18')
    then 'UNIT 18:  '||f_structuretype(b.brkey, '18')||'  '||f_spangroups(b.brkey,'18')
      else ''
        end UNIT_18
,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '19')
    then 'UNIT 19:  '||f_structuretype(b.brkey, '19')||'  '||f_spangroups(b.brkey,'19')
      else ''
        end UNIT_19
,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '20')
    then 'UNIT 20:  '||f_structuretype(b.brkey, '20')||'  '||f_spangroups(b.brkey,'20')
      else ''
        end UNIT_20
,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '21')
    then 'UNIT 21:  '||f_structuretype(b.brkey, '21')||'  '||f_spangroups(b.brkey,'21')
      else ''
        end UNIT_21
,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '22')
    then 'UNIT 22:  '||f_structuretype(b.brkey, '22')||'  '||f_spangroups(b.brkey,'22')
      else ''
        end UNIT_22
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '23')
    then 'UNIT 23:  '||f_structuretype(b.brkey, '23')||'  '||f_spangroups(b.brkey,'23')
      else ''
        end UNIT_23
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '24')
    then 'UNIT 24:  '||f_structuretype(b.brkey, '24')||'  '||f_spangroups(b.brkey,'24')
      else ''
        end UNIT_24
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '25')
    then 'UNIT 25:  '||f_structuretype(b.brkey, '25')||'  '||f_spangroups(b.brkey,'25')
      else ''
        end UNIT_25
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '26')
    then 'UNIT 26:  '||f_structuretype(b.brkey, '26')||'  '||f_spangroups(b.brkey,'26')
      else ''
        end UNIT_26
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '27')
    then 'UNIT 27:  '||f_structuretype(b.brkey, '27')||'  '||f_spangroups(b.brkey,'27')
      else ''
        end UNIT_27
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '28')
    then 'UNIT 28:  '||f_structuretype(b.brkey, '28')||'  '||f_spangroups(b.brkey,'28')
      else ''
        end UNIT_28
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '29')
    then 'UNIT 29:  '||f_structuretype(b.brkey, '29')||'  '||f_spangroups(b.brkey,'29')
      else ''
        end UNIT_29
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '30')
    then 'UNIT 30:  '||f_structuretype(b.brkey, '30')||'  '||f_spangroups(b.brkey,'30')
      else ''
        end UNIT_30
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '31')
    then 'UNIT 31:  '||f_structuretype(b.brkey, '31')||'  '||f_spangroups(b.brkey,'31')
      else ''
        end UNIT_31
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '32')
    then 'UNIT 32:  '||f_structuretype(b.brkey, '32')||'  '||f_spangroups(b.brkey,'32')
      else ''
        end UNIT_32
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '33')
    then 'UNIT 33:  '||f_structuretype(b.brkey, '33')||'  '||f_spangroups(b.brkey,'33')
      else ''
        end UNIT_33
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '34')
    then 'UNIT 34:  '||f_structuretype(b.brkey, '34')||'  '||f_spangroups(b.brkey,'34')
      else ''
        end UNIT_34
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '35')
    then 'UNIT 35:  '||f_structuretype(b.brkey, '35')||'  '||f_spangroups(b.brkey,'35')
      else ''
        end UNIT_35
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '36')
    then 'UNIT 36:  '||f_structuretype(b.brkey, '36')||'  '||f_spangroups(b.brkey,'36')
      else ''
        end UNIT_36
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '37')
    then 'UNIT 37:  '||f_structuretype(b.brkey, '37')||'  '||f_spangroups(b.brkey,'37')
      else ''
        end UNIT_37
 ,CASE
  when exists (select strunitkey from userstrunit u
    where u.brkey = b.brkey and
    strunitkey = '38')
    then 'UNIT 38:  '||f_structuretype(b.brkey, '38')||'  '||f_spangroups(b.brkey,'38')
      else ''
        end UNIT_38

 from bridge b

 ;