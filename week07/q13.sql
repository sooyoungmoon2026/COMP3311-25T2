CREATE FUNCTION mult(state Numeric, value Numeric) returns Numeric
as $$
BEGIN
    if value is not null then
        return state * value;
    end if;

    return state;
END;
$$ language plpgsql;


CREATE AGGREGATE product(Numeric) (
	sfunc = mult,
	stype = Numeric,
	initcond = 1
);

-- S -> state
-- S = sfunc(1, V1)
-- S = sfunc(S, V2)
-- S = sfunc(S, V3)
-- S = sfunc(S, V4)
-- S = sfunc(S, V5)