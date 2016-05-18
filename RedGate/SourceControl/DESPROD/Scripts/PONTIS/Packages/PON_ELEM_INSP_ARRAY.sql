CREATE OR REPLACE package pontis.PON_ELEM_INSP_ARRAY as
                    type ridArray is table of PON_ELEM_INSP%rowtype index by binary_integer;
                    oldvals ridArray;
                    empty ridArray;
                    end;
/