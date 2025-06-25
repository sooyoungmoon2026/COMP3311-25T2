-- PLpgSQL syntax
CREATE OR REPLACE func_name(param1 [type], param2 [type]) RETURNS [type]
AS $$
DECLARE
    -- declare your variables here
BEGIN
    -- programming logic goes here
END;
$$ LANGUAGE plpgsql;


-- An example of a very simple PLpgSQL function that multiplies
-- two variables
CREATE OR REPLACE mult(param1 integer, param2 integer) RETURNS integer
AS $$
DECLARE
    result      integer;
BEGIN
    result = param1 * param2
    return result;
END;
$$ LANGUAGE plpgsql;


-- To go over how to integrate SQL into PLpgSQL functions, consider
-- this database schema
create table Suppliers (
      sid     integer primary key,
      sname   text,
      address text
);

create table Parts (
      pid     integer primary key,
      pname   text,
      colour  text
);

create table Catalog (
      sid     integer references Suppliers(sid),
      pid     integer references Parts(pid),
      cost    real,
      primary key (sid,pid)
);


-- To print all suppliers who supplies all parts of a given colour (returning text)
CREATE OR REPLACE SuppliesAllParts(_colour text) RETURNS text
AS $$
DECLARE
    _sid    text;
    _ret    text := '';
BEGIN
    -- loop through tuples of the sql query
    for _sid in
        select 
            S.sid
        from
            Suppliers S
        where not exists (
            (select P.pid from Parts P where P.colour = _colour)
            except 
            (select C.pid from Catalog C where C.sid = S.sid)
        )
    loop
        _ret := _ret || _sid || e'\n';
    end loop;

    return _ret;
END;
$$ LANGUAGE plpgsql;


-- If we wanted to do the same thing for a function returning setof text
CREATE OR REPLACE SuppliesAllParts(_colour text) RETURNS setof text
AS $$
DECLARE
    _sid     text;
BEGIN
    for _sid in
        select 
            S.sid
        from
            Suppliers S
        where not exists (
            (select P.pid from Parts P where P.colour = _colour)
            except 
            (select C.pid from Catalog C where C.sid = S.sid)
        )
    loop
        return next _sid;
    end loop;

    return;
END;
$$ LANGUAGE plpgsql;


-- PERFORM vs SELECT
CREATE OR REPLACE SuppliesPart(partial_name text) RETURNS text
AS $$
DECLARE
    _pid    integer;
BEGIN
    -- PERFORM: For queries that you want to perform but don't want to store
    perform
        *
    from
        Parts
    where
        pname ILIKE '%'||partial_name||'%' -- Case-insensitive partial string matching (search this up for more details)
    ;
    -- typically you do this for when you want to check valid input.
    -- when you do a perform or select query, it updates a keyword called 'found' which will be true if the query
    -- outputted some tuples and false if no tuples
    if not found then
        return 'No part matches';
    end if;


    -- SELECT: For when you want to store variables. note that below we assume the output of the query will be
    -- a single value, not multiple tuples (multiple matches)
    select
        pid -- which column of data
    into
        _pid -- which variable we're storing into
    from
        Parts
    where
        pname ILIKE '%'||partial_name||'%'
    ;
    if not found then
        return 'No part matches';
    end if;
    -- now we can use _pid as a variable later in the code.

    ...
END;
$$ LANGUAGE plpgsql;