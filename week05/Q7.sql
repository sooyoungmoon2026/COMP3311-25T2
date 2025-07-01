-- Q7
-- create or replace function hotelsIn(_addr text) returns text
-- as $$
-- declare
--     out     text := '';
--     bname   text;
-- begin
--     for bname in
--         select name from Bars where addr = _addr
--     loop
--         out := out || bname || e'\n';
--     end loop;

--     return out;
-- end;
-- $$ language plpgsql;


-- Q8
create or replace function hotelsIn(_addr text) returns text
as $$
declare
    out     text := 'Hotels in ';
    bname   text;
begin
    perform * from Bars where addr = _addr;
    if not found then
        return 'There are no hotels in ' || _addr;
    end if;

    out := out || _addr || ': ';

    for bname in
        select name from Bars where addr = _addr
    loop
        out := out || '  ' || bname;
    end loop;

    return out;
end;
$$ language plpgsql;