CREATE OR REPLACE FORCE VIEW pontis.ds_bridges_changed_by_pontis (brkey,entry_id,old_value,new_value,exchange_rule_id,exchange_status,createdatetime) AS
SELECT   a.BRKEY,
         b.ENTRY_ID,   
         b.OLD_VALUE,   
         b.NEW_VALUE,   
         b.EXCHANGE_RULE_ID,   
         b.EXCHANGE_STATUS,   
         b.CREATEDATETIME  
    FROM BRIDGE a,   
         DS_CHANGE_LOG b,   
         DS_LOOKUP_KEYVALS c  
   WHERE b.ENTRY_ID IN (
						 				SELECT MAX( d.entry_id )
										FROM DS_LOOKUP_KEYVALS d
										GROUP BY d.entry_id, d.keyvalue, d.keyname
										HAVING d.keyname = 'BRKEY'
										AND d.entry_id = ( SELECT MAX( e.ENTRY_ID ) FROM DS_LOOKUP_KEYVALS e
				                  WHERE e.keyvalue = d.keyvalue ) 
								) AND
			( c.entry_id = b.entry_id ) AND
			( c.KEYVALUE = a.BRKEY    ) AND  
         ( c.KEYNAME = 'BRKEY' )

 ;