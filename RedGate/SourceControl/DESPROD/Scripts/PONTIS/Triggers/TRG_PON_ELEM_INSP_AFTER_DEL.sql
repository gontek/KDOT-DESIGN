CREATE OR REPLACE TRIGGER pontis.TRG_PON_ELEM_INSP_AFTER_DEL
                    after delete on pontis.PON_ELEM_INSP for each row
                    declare
                    i    number default PON_ELEM_INSP_ARRAY.oldvals.count+1;
                    begin
                    PON_ELEM_INSP_ARRAY.oldvals(i).brkey := :old.brkey;
                    PON_ELEM_INSP_ARRAY.oldvals(i).inspkey := :old.inspkey;
                    end;
/