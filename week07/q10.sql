create table Enrolment(course char(8), sid integer, mark integer);
create table Course(code char(8), lic text, quota integer, numStudes integer default 0);

-- required: no args, returns TRIGGER, must be plpgsql
CREATE FUNCTION updateNumStudes() RETURNS TRIGGER
AS $$
BEGIN
	if TG_OP = 'INSERT' then
        update Course set numStudes = numStudes + 1 where code = new.course;
        return new;
    elsif TG_OP = 'DELETE' then
        update Course set numStudes = numStudes - 1 where code = old.course;
        return old;
    else
        update Course set numStudes = numStudes + 1 where code = new.course;
        update Course set numStudes = numStudes - 1 where code = old.course;
        return new;
    end if;
END;
$$ language plpgsql;

CREATE TRIGGER consNumStudes
AFTER INSERT OR DELETE OR UPDATE
ON Enrolment
FOR EACH ROW
EXECUTE FUNCTION updateNumStudes();

CREATE FUNCTION quotaFunction() returns TRIGGER
as $$
BEGIN
    if (select quota = numStudes from Course where code = new.course) then
        raise exception 'Class is full';
    end if;

    return new;
END;
$$ language plpgsql;

CREATE TRIGGER quotaCheck
BEFORE INSERT OR UPDATE
ON Enrolment
FOR EACH ROW
EXECUTE FUNCTION quotaFunction();