create or replace function unitName(_ouid integer) returns text
as $$
declare
    _orgName    text;
    _orgType    text;
begin
    perform * from OrgUnit where id = _ouid:
    if not found then
        raise exception 'No such unit: %',_ouid;
    end if;

    select 
        U.longname, T.name
    into
        _orgName, _orgType 
    from OrgUnit U
    join OrgUnitType T on (U.utype = T.id)
    where U.id = _ouid;

    if _orgType = 'UNSW' then
        return 'UNSW';
    elsif _orgType = 'Faculty' then
        return _orgName;
    elsif _orgType = 'School' then
        return 'School of ' || _orgName;
    elsif _orgType = 'Department' then
        return 'Department of ' || _orgName;
    elsif _orgType = 'Centre' then
        return 'Centre for ' || _orgName;
    elsif _orgType = 'Institue' then
        return 'Institute of ' || _orgName;
    else
        return null;
    end if;
end;
$$ language plpgsql;