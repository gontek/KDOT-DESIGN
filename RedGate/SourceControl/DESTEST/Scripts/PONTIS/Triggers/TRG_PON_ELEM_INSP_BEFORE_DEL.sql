CREATE OR REPLACE TRIGGER pontis.TRG_PON_ELEM_INSP_BEFORE_DEL
                    before delete on pontis.PON_ELEM_INSP
                    begin
                    PON_ELEM_INSP_ARRAY.oldvals := PON_ELEM_INSP_ARRAY.empty;
                    end;
/