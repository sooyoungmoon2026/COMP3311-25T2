create or replace function hotelsInSQL(text) returns setof Bars
as $$ 
    select * from Bars where addr = $1;
$$ language sql;

create or replace function hotelsInPL(_addr text) returns setof Bars
as $$ 
declare
    rec     record;
begin
    for rec in
        select * from Bars where addr = _addr
    loop
        return next rec;
    end loop;
end;
$$ language plpgsql;