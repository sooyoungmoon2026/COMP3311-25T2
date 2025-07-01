create or replace function happyHourPrice(_hotel text, _beer text, _discount real) returns text
as $$
declare
    _price      real;
    _newPrice   real;
begin
    perform * from Bars where name = _hotel;
    if not found then
        return 'There is no hotel called ' || _hotel;
    end if;

    perform * from Beers where name = _beer;
    if not found then
        return 'There is no beer called ' || _beer;
    end if;

    select 
        price
    into
        _price
    from Bars Ba
    join Sells S on (S.bar = Ba.name)
    join Beers Be on (S.beer = Be.name)
    where Ba.name = _hotel and Be.name = _beer;
    if not found then
        return _hotel || ' does not serve ' || _beer;
    end if;

    if _price < _discount then
        return 'Price reduction is too large; '|| _beer ||' only costs '||  to_char(_price,'$9.99');
    end if;

    _newPrice := _price - _discount;

    return 'Happy hour price for '|| _beer ||' at '|| _hotel ||' is ' ||  to_char(_newPrice,'$9.99');
end;
$$ language plpgsql;


-- select
--     price
-- from Bars Ba
-- join Sells S on (S.bar = Ba.name)
-- join Beers Be on (S.beer = Be.name)
-- where Ba.name = 'Lord Nelson' and Be.name = 'Invalid Stout';