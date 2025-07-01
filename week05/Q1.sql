create or replace function sqr(n Numeric) returns Numeric
as $$
begin
    return n * n;
end;
$$ language plpgsql;