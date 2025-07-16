
-- S -> state
-- S = sfunc(1, V1)
-- S = sfunc(S, V2)
-- S = sfunc(S, V3)
-- S = sfunc(S, V4)
-- S = sfunc(S, V5)

CREATE TYPE Pair as (sum Numeric, count int);

CREATE OR REPLACE function update(state Pair, value Numeric) returns Pair
as $$
BEGIN
    if value is not null then
        state.sum := state.sum + value;
        state.count := state.count + 1;
    end if;

    return state;
END;
$$ language plpgsql;

CREATE FUNCTION finalise(p Pair) returns Numeric
as $$
BEGIN
    if p.count = 0 then
        return NULL;
    end if;

    return p.sum / p.count;
END;
$$ language plpgsql;

CREATE AGGREGATE mean(Numeric) (
	-- Required --
	sfunc = update,
	stype = Pair,
	
	-- Optional, but common --
	initcond = '(0,0)',
	finalfunc = finalise
);