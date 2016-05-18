CREATE OR REPLACE function pontis.f_jurisdiction_value(fieldname_in in varchar2,
                                                tablename_in in varchar2,
                                                columnname_in in varchar2,
                                                sortorder_in varchar2,
                                                grporder_in  varchar2) return number is
retval varchar2(2000);
sqlString varchar2(8000);

begin
  
-- create a big sql string which will dynamically include the items you need from mv_deckdeter_by_juris_sum.

sqlString := 'select ' || fieldname_in || ' from '||
              tablename_in ||
             ' where  col_name   = :co ' ||
             ' and sortorder   = :so ' ||
             ' and grporder     = :gr ';
             
-- execute the synamic SQL string by supplying the appropriate fieldname, columnname, sortorder and grporder
-- as bind variables i.e., :co
-- return result into retval

execute immediate sqlString
into retval
using  columnname_in, sortorder_in, grporder_in;

return retval;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    ---PROBABLY BONKED
    return NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad probably happened, report it.
end f_jurisdiction_value;
/