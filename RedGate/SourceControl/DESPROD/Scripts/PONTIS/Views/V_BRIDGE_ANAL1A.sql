CREATE OR REPLACE FORCE VIEW pontis.v_bridge_anal1a (brkey,ykey,totwork,discwork) AS
select v1.brkey,     v1.ykey,     sum(v1.totwork) as totwork,     sum(v1.discwork) as discwork  from v_bridge_anal1 v1 group by v1.brkey, v1.ykey
 ;