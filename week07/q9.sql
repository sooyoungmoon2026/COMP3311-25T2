CREATE TABLE Emp(empname text, salary integer, last_date timestamp, last_usr text);

-- required: no args, returns TRIGGER, must be plpgsql
CREATE FUNCTION fillData() RETURNS TRIGGER
AS $$
BEGIN
    if new.empname is NULL then
        raise exception 'empname must be provided';
    end if;

    if new.salary <= 0 then
        raise exception 'salary must be positive';
    end if;

	new.last_date = now();
    new.last_usr = user;

    return new;
END;
$$ language plpgsql;

CREATE TRIGGER autoFillData
BEFORE INSERT OR UPDATE
ON Emp
FOR EACH ROW
EXECUTE FUNCTION fillData();