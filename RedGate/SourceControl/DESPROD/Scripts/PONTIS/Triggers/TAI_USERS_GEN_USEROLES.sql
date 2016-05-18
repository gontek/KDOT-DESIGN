CREATE OR REPLACE TRIGGER pontis.tai_users_gen_useroles
  after insert on pontis.users
  for each row




declare
  -- local variables here
BEGIN

     INSERT INTO USEROLES
     SELECT :new.userkey, 
     permission, 
     allowed,
     '' as notes
      FROM useroles WHERE userkey = ksbms_pontis.gs_default_userkey;
    
end tai_users_gen_useroles;
/