CREATE OR REPLACE procedure pontis.qry_find_misused_defects is
begin
  
update pon_elem_insp p
set elem_key = '861',
elem_parent_key ='0',
elem_quantity ='1'
where elem_key in '6000';
commit;

update pon_elem_insp
set elem_qtystate1 =1
where elem_key = '861'
and elem_qtystate1 >0 
and elem_qtystate1 < 1;
commit;

update pon_elem_insp
set elem_qtystate2 =1
where elem_key = '861'
and elem_qtystate2 >0
and elem_qtystate2 < 1;
commit;

update pon_elem_insp
set elem_qtystate3 =1
where elem_key = '861'
and elem_qtystate3 >0
and elem_qtystate3 < 1;
commit;

update pon_elem_insp
set elem_qtystate4 =1
where elem_key = '861'
and elem_qtystate4 >0
and elem_qtystate4 < 1;
commit;

-- start of deck cracking fix

update pon_elem_insp p
set elem_key = '858',
elem_parent_key ='0',
elem_quantity ='1'
where elem_key in '1130';
commit;

update pon_elem_insp
set elem_qtystate1 =1
where elem_key = '858'
and elem_qtystate1 >0
and elem_qtystate1 < 1;
commit;

update pon_elem_insp
set elem_qtystate2 =1
where elem_key = '858'
and elem_qtystate2 >0
and elem_qtystate2 < 1;
commit;

update pon_elem_insp
set elem_qtystate3 =1
where elem_key = '858'
and elem_qtystate3 >0
and elem_qtystate3 < 1;
commit;

update pon_elem_insp
set elem_qtystate4 =1
where elem_key = '858'
and elem_qtystate4 >0
and elem_qtystate4 < 1;
commit;


end ;
/