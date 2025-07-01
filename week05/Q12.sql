-- salary of a specified employee

create or replace function employeeSal(text) returns real
as $$
    select salary from employees where name = $1;
$$ language sql;

create or replace function employeeSal(integer) returns real
as $$
    select salary from employees where id = $1;
$$ language sql;

create or replace function employeeSalPL(empName text) return real
as $$
declare
    _salary     real;
begin
    select salary into _salary from employees where name = empName;
    return _salary;
end;
$$ language plpgsql;

create or replace function employeeSalPL(empId int) return real
as $$
declare
    _salary     real;
begin
    select salary into _salary from employees where id =empId;
    return _salary;
end;
$$ language plpgsql;

-- names of all employees earning more than $sal

create type EmpName as ( name varchar(20) );

create or replace function employeeWithSalary(real) returns setof EmpName
as $$
    select name from employees where salary > $1;
$$ language sql;

create or replace function employeeWithSalaryPL(_minSal real) returns setof EmpName
as $$
declare
    _name   EmpName
begin
    for _name in
        select name from employees where salary > _minSal
    loop
        return next _name;
    end loop;

    return;
end;
$$ language plpgsql;