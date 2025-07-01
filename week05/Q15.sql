create or replace function unitID(partName text) returns integer
as $$ 
    select id from OrgUnit where longname ILIKE '%'||partName||'%';
$$ language sql;